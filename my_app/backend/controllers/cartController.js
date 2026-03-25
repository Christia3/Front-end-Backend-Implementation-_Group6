const pool = require('../config/db');

// @desc    Get cart items
// @route   GET /api/cart
// @access  Private
const getCart = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT ci.id, ci.quantity, ci.product_id,
              p.name, p.price, p.currency, p.stock_quantity, p.unit,
              s.name AS shop_name,
              ARRAY_AGG(pi.image_url ORDER BY pi.is_primary DESC) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM cart_items ci
       JOIN products p ON p.id = ci.product_id
       LEFT JOIN shops s ON s.id = p.shop_id
       LEFT JOIN product_images pi ON pi.product_id = p.id
       WHERE ci.user_id = $1
       GROUP BY ci.id, p.id, s.name
       ORDER BY ci.created_at DESC`,
      [req.user.id]
    );

    const total = result.rows.reduce((sum, item) => sum + (parseFloat(item.price) * item.quantity), 0);

    res.json({ success: true, cart: result.rows, total: total.toFixed(2) });
  } catch (err) {
    next(err);
  }
};

// @desc    Add item to cart
// @route   POST /api/cart
// @access  Private
const addToCart = async (req, res, next) => {
  try {
    const { product_id, quantity = 1 } = req.body;

    if (!product_id) {
      return res.status(400).json({ success: false, message: 'Product ID is required.' });
    }

    // Check product exists and has stock
    const productResult = await pool.query(
      'SELECT id, stock_quantity, name FROM products WHERE id = $1 AND is_active = true',
      [product_id]
    );

    if (productResult.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }

    const product = productResult.rows[0];
    if (product.stock_quantity < quantity) {
      return res.status(400).json({ success: false, message: `Only ${product.stock_quantity} units available.` });
    }

    // Upsert cart item
    const result = await pool.query(
      `INSERT INTO cart_items (user_id, product_id, quantity)
       VALUES ($1, $2, $3)
       ON CONFLICT (user_id, product_id)
       DO UPDATE SET quantity = cart_items.quantity + $3, updated_at = NOW()
       RETURNING *`,
      [req.user.id, product_id, quantity]
    );

    res.status(201).json({ success: true, message: `${product.name} added to cart!`, cartItem: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Update cart item quantity
// @route   PUT /api/cart/:id
// @access  Private
const updateCartItem = async (req, res, next) => {
  try {
    const { id } = req.params;
    const { quantity } = req.body;

    if (!quantity || quantity < 1) {
      return res.status(400).json({ success: false, message: 'Quantity must be at least 1.' });
    }

    const check = await pool.query('SELECT user_id, product_id FROM cart_items WHERE id = $1', [id]);
    if (check.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Cart item not found.' });
    }
    if (check.rows[0].user_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized.' });
    }

    const result = await pool.query(
      'UPDATE cart_items SET quantity = $1, updated_at = NOW() WHERE id = $2 RETURNING *',
      [quantity, id]
    );

    res.json({ success: true, message: 'Cart updated!', cartItem: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Remove item from cart
// @route   DELETE /api/cart/:id
// @access  Private
const removeFromCart = async (req, res, next) => {
  try {
    const { id } = req.params;

    const check = await pool.query('SELECT user_id FROM cart_items WHERE id = $1', [id]);
    if (check.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Cart item not found.' });
    }
    if (check.rows[0].user_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized.' });
    }

    await pool.query('DELETE FROM cart_items WHERE id = $1', [id]);

    res.json({ success: true, message: 'Item removed from cart.' });
  } catch (err) {
    next(err);
  }
};

// @desc    Clear entire cart
// @route   DELETE /api/cart
// @access  Private
const clearCart = async (req, res, next) => {
  try {
    await pool.query('DELETE FROM cart_items WHERE user_id = $1', [req.user.id]);
    res.json({ success: true, message: 'Cart cleared.' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getCart, addToCart, updateCartItem, removeFromCart, clearCart };
