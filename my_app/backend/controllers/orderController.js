const pool = require('../config/db');

// Generate order number
const generateOrderNumber = () => {
  const date = new Date();
  const year = date.getFullYear();
  const random = Math.floor(Math.random() * 100000).toString().padStart(5, '0');
  return `ORD-${year}-${random}`;
};

// @desc    Place an order (from cart or direct)
// @route   POST /api/orders
// @access  Private
const placeOrder = async (req, res, next) => {
  const client = await pool.connect();
  try {
    const {
      payment_method,
      shipping_name,
      shipping_address,
      shipping_city,
      shipping_zip,
      items, // optional: direct purchase [{ product_id, quantity }]
    } = req.body;

    if (!shipping_name || !shipping_address) {
      return res.status(400).json({ success: false, message: 'Shipping name and address are required.' });
    }

    await client.query('BEGIN');

    // Determine order items — from cart if no items passed
    let orderItems = [];
    if (items && items.length > 0) {
      orderItems = items;
    } else {
      const cartResult = await client.query(
        'SELECT product_id, quantity FROM cart_items WHERE user_id = $1',
        [req.user.id]
      );
      if (cartResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(400).json({ success: false, message: 'Your cart is empty.' });
      }
      orderItems = cartResult.rows;
    }

    // Validate products and calculate totals
    let subtotal = 0;
    const enrichedItems = [];

    for (const item of orderItems) {
      const productResult = await client.query(
        'SELECT id, name, price, currency, stock_quantity, seller_id FROM products WHERE id = $1 AND is_active = true',
        [item.product_id]
      );

      if (productResult.rows.length === 0) {
        await client.query('ROLLBACK');
        return res.status(404).json({ success: false, message: `Product not found: ${item.product_id}` });
      }

      const product = productResult.rows[0];

      if (product.stock_quantity < item.quantity) {
        await client.query('ROLLBACK');
        return res.status(400).json({
          success: false,
          message: `Not enough stock for "${product.name}". Available: ${product.stock_quantity}`,
        });
      }

      const totalPrice = parseFloat(product.price) * item.quantity;
      subtotal += totalPrice;

      enrichedItems.push({
        product_id: product.id,
        seller_id: product.seller_id,
        product_name: product.name,
        quantity: item.quantity,
        unit_price: parseFloat(product.price),
        total_price: totalPrice,
      });
    }

    const shipping_fee = 1000; // 1000 RWF flat shipping
    const tax = parseFloat((subtotal * 0.18).toFixed(2)); // 18% VAT
    const total_amount = subtotal + shipping_fee + tax;

    const estimated_delivery = new Date();
    estimated_delivery.setDate(estimated_delivery.getDate() + 5);

    // Create order
    const orderResult = await client.query(
      `INSERT INTO orders
         (buyer_id, order_number, status, total_amount, subtotal, shipping_fee, tax,
          payment_method, shipping_name, shipping_address, shipping_city, shipping_zip, estimated_delivery)
       VALUES ($1, $2, 'Processing', $3, $4, $5, $6, $7, $8, $9, $10, $11, $12)
       RETURNING *`,
      [
        req.user.id,
        generateOrderNumber(),
        total_amount.toFixed(2),
        subtotal.toFixed(2),
        shipping_fee,
        tax.toFixed(2),
        payment_method || 'Mobile Money',
        shipping_name,
        shipping_address,
        shipping_city || '',
        shipping_zip || '',
        estimated_delivery,
      ]
    );

    const order = orderResult.rows[0];

    // Insert order items and reduce stock
    for (const item of enrichedItems) {
      await client.query(
        `INSERT INTO order_items
           (order_id, product_id, seller_id, product_name, quantity, unit_price, total_price)
         VALUES ($1, $2, $3, $4, $5, $6, $7)`,
        [order.id, item.product_id, item.seller_id, item.product_name, item.quantity, item.unit_price, item.total_price]
      );

      // Reduce stock
      await client.query(
        'UPDATE products SET stock_quantity = stock_quantity - $1, updated_at = NOW() WHERE id = $2',
        [item.quantity, item.product_id]
      );

      // Add credits to seller (10% of sale value as credits)
      const sellerCredits = Math.floor(item.total_price * 0.1);
      await client.query(
        `UPDATE users SET credits = credits + $1 WHERE id = $2`,
        [sellerCredits, item.seller_id]
      );
      await client.query(
        `INSERT INTO credit_transactions (user_id, type, amount, description, reference_id, reference_type)
         VALUES ($1, 'credit', $2, $3, $4, 'order')`,
        [item.seller_id, sellerCredits, `Sale: ${item.product_name}`, order.id]
      );
    }

    // Clear cart after order
    await client.query('DELETE FROM cart_items WHERE user_id = $1', [req.user.id]);

    await client.query('COMMIT');

    res.status(201).json({
      success: true,
      message: 'Order placed successfully!',
      order,
    });
  } catch (err) {
    await client.query('ROLLBACK');
    next(err);
  } finally {
    client.release();
  }
};

// @desc    Get my orders (buyer)
// @route   GET /api/orders
// @access  Private
const getMyOrders = async (req, res, next) => {
  try {
    const { status, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [req.user.id];
    let where = 'WHERE o.buyer_id = $1';
    let idx = 2;

    if (status) {
      where += ` AND o.status = $${idx++}`;
      values.push(status);
    }

    const countResult = await pool.query(`SELECT COUNT(*) FROM orders o ${where}`, values);
    const total = parseInt(countResult.rows[0].count);

    values.push(limit, offset);
    const result = await pool.query(
      `SELECT o.*,
              COUNT(oi.id)::int AS item_count
       FROM orders o
       LEFT JOIN order_items oi ON oi.order_id = o.id
       ${where}
       GROUP BY o.id
       ORDER BY o.created_at DESC
       LIMIT $${idx++} OFFSET $${idx}`,
      values
    );

    res.json({ success: true, total, page: parseInt(page), orders: result.rows });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single order with items
// @route   GET /api/orders/:id
// @access  Private
const getOrderById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const orderResult = await pool.query(
      'SELECT * FROM orders WHERE id = $1 AND buyer_id = $2',
      [id, req.user.id]
    );

    if (orderResult.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Order not found.' });
    }

    const itemsResult = await pool.query(
      `SELECT oi.*, p.category,
              ARRAY_AGG(pi.image_url ORDER BY pi.is_primary DESC) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM order_items oi
       LEFT JOIN products p ON p.id = oi.product_id
       LEFT JOIN product_images pi ON pi.product_id = oi.product_id
       WHERE oi.order_id = $1
       GROUP BY oi.id, p.category`,
      [id]
    );

    res.json({
      success: true,
      order: orderResult.rows[0],
      items: itemsResult.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get orders for seller (sales view)
// @route   GET /api/orders/sales
// @access  Private
const getMySales = async (req, res, next) => {
  try {
    const { status, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [req.user.id];
    let where = 'WHERE oi.seller_id = $1';
    let idx = 2;

    if (status) {
      where += ` AND o.status = $${idx++}`;
      values.push(status);
    }

    const result = await pool.query(
      `SELECT DISTINCT o.id, o.order_number, o.status, o.created_at,
              o.shipping_name, o.total_amount,
              COUNT(oi2.id)::int AS item_count,
              SUM(oi2.total_price) AS my_revenue
       FROM orders o
       JOIN order_items oi ON oi.order_id = o.id ${where.replace('WHERE', 'AND o.id = o.id WHERE')}
       JOIN order_items oi2 ON oi2.order_id = o.id AND oi2.seller_id = $1
       GROUP BY o.id
       ORDER BY o.created_at DESC
       LIMIT $${idx++} OFFSET $${idx}`,
      [...values, limit, offset]
    );

    // Total revenue for the seller
    const revenueResult = await pool.query(
      `SELECT COALESCE(SUM(oi.total_price), 0) AS total_revenue,
              COUNT(DISTINCT o.id) AS total_orders
       FROM order_items oi
       JOIN orders o ON o.id = oi.order_id
       WHERE oi.seller_id = $1`,
      [req.user.id]
    );

    res.json({
      success: true,
      sales: result.rows,
      stats: revenueResult.rows[0],
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update order status (seller or admin)
// @route   PUT /api/orders/:id/status
// @access  Private
const updateOrderStatus = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { status } = req.body;

    const validStatuses = ['Processing', 'Shipped', 'Delivered', 'Cancelled'];
    if (!validStatuses.includes(status)) {
      return res.status(400).json({ success: false, message: `Invalid status. Must be one of: ${validStatuses.join(', ')}` });
    }

    // Check this seller has items in the order
    const check = await pool.query(
      'SELECT o.id FROM orders o JOIN order_items oi ON oi.order_id = o.id WHERE o.id = $1 AND oi.seller_id = $2 LIMIT 1',
      [id, req.user.id]
    );

    if (check.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Order not found or not authorized.' });
    }

    const result = await pool.query(
      'UPDATE orders SET status = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
      [status, id]
    );

    res.json({ success: true, message: `Order status updated to "${status}"`, order: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

module.exports = { placeOrder, getMyOrders, getOrderById, getMySales, updateOrderStatus };
