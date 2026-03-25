const pool = require('../config/db');

// @desc    Get all products (public, with filters)
// @route   GET /api/products
// @access  Public
const getProducts = async (req, res, next) => {
  try {
    const { search, category, shop_id, min_price, max_price, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [];
    let idx = 1;
    let where = 'WHERE p.is_active = true';

    if (category) { where += ` AND p.category = $${idx++}`; values.push(category); }
    if (shop_id) { where += ` AND p.shop_id = $${idx++}`; values.push(shop_id); }
    if (min_price) { where += ` AND p.price >= $${idx++}`; values.push(min_price); }
    if (max_price) { where += ` AND p.price <= $${idx++}`; values.push(max_price); }
    if (search) {
      where += ` AND (p.name ILIKE $${idx} OR p.description ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await pool.query(`SELECT COUNT(*) FROM products p ${where}`, values);
    const total = parseInt(countResult.rows[0].count);

    values.push(limit, offset);
    const result = await pool.query(
      `SELECT p.id, p.name, p.description, p.price, p.currency, p.category,
              p.stock_quantity, p.unit, p.is_expense,
              s.name AS shop_name, s.location AS shop_location, s.rating AS shop_rating,
              u.full_name AS seller_name,
              ARRAY_AGG(pi.image_url ORDER BY pi.is_primary DESC) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM products p
       LEFT JOIN shops s ON s.id = p.shop_id
       LEFT JOIN users u ON u.id = p.seller_id
       LEFT JOIN product_images pi ON pi.product_id = p.id
       ${where}
       GROUP BY p.id, s.name, s.location, s.rating, u.full_name
       ORDER BY p.created_at DESC
       LIMIT $${idx++} OFFSET $${idx}`,
      values
    );

    res.json({ success: true, total, page: parseInt(page), products: result.rows });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single product
// @route   GET /api/products/:id
// @access  Public
const getProductById = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT p.*, s.name AS shop_name, s.location AS shop_location,
              s.rating AS shop_rating, s.id AS shop_id,
              u.full_name AS seller_name,
              ARRAY_AGG(pi.image_url ORDER BY pi.is_primary DESC) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM products p
       LEFT JOIN shops s ON s.id = p.shop_id
       LEFT JOIN users u ON u.id = p.seller_id
       LEFT JOIN product_images pi ON pi.product_id = p.id
       WHERE p.id = $1
       GROUP BY p.id, s.name, s.location, s.rating, s.id, u.full_name`,
      [req.params.id]
    );

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }

    res.json({ success: true, product: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Get my products (seller view)
// @route   GET /api/products/my-products
// @access  Private
const getMyProducts = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT p.*, s.name AS shop_name,
              ARRAY_AGG(pi.image_url ORDER BY pi.is_primary DESC) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM products p
       LEFT JOIN shops s ON s.id = p.shop_id
       LEFT JOIN product_images pi ON pi.product_id = p.id
       WHERE p.seller_id = $1
       GROUP BY p.id, s.name
       ORDER BY p.created_at DESC`,
      [req.user.id]
    );

    res.json({ success: true, products: result.rows });
  } catch (err) {
    next(err);
  }
};

// @desc    Create product
// @route   POST /api/products
// @access  Private
const createProduct = async (req, res, next) => {
  try {
    const { name, description, price, currency, category, stock_quantity, unit, is_expense } = req.body;

    if (!name || !price) {
      return res.status(400).json({ success: false, message: 'Name and price are required.' });
    }

    // Get seller's shop
    const shopResult = await pool.query('SELECT id FROM shops WHERE owner_id = $1 AND is_active = true', [req.user.id]);
    if (shopResult.rows.length === 0) {
      return res.status(400).json({ success: false, message: 'You need to create a shop before adding products.' });
    }

    const shop_id = shopResult.rows[0].id;

    const result = await pool.query(
      `INSERT INTO products (shop_id, seller_id, name, description, price, currency, category, stock_quantity, unit, is_expense)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)
       RETURNING *`,
      [shop_id, req.user.id, name, description, parseFloat(price), currency || 'RWF',
       category, parseInt(stock_quantity) || 0, unit, is_expense === 'true' || is_expense === true]
    );

    const product = result.rows[0];

    // Save uploaded images
    if (req.files && req.files.length > 0) {
      for (let i = 0; i < req.files.length; i++) {
        await pool.query(
          'INSERT INTO product_images (product_id, image_url, is_primary) VALUES ($1, $2, $3)',
          [product.id, `/uploads/${req.files[i].filename}`, i === 0]
        );
      }
    }

    res.status(201).json({ success: true, message: 'Product added successfully!', product });
  } catch (err) {
    next(err);
  }
};

// @desc    Update product
// @route   PUT /api/products/:id
// @access  Private
const updateProduct = async (req, res, next) => {
  try {
    const { id } = req.params;

    const check = await pool.query('SELECT id, seller_id FROM products WHERE id = $1', [id]);
    if (check.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }
    if (check.rows[0].seller_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to edit this product.' });
    }

    const { name, description, price, currency, category, stock_quantity, unit, is_expense, is_active } = req.body;

    const fields = [];
    const values = [];
    let idx = 1;

    if (name) { fields.push(`name = $${idx++}`); values.push(name); }
    if (description !== undefined) { fields.push(`description = $${idx++}`); values.push(description); }
    if (price !== undefined) { fields.push(`price = $${idx++}`); values.push(parseFloat(price)); }
    if (currency) { fields.push(`currency = $${idx++}`); values.push(currency); }
    if (category) { fields.push(`category = $${idx++}`); values.push(category); }
    if (stock_quantity !== undefined) { fields.push(`stock_quantity = $${idx++}`); values.push(parseInt(stock_quantity)); }
    if (unit !== undefined) { fields.push(`unit = $${idx++}`); values.push(unit); }
    if (is_expense !== undefined) { fields.push(`is_expense = $${idx++}`); values.push(is_expense); }
    if (is_active !== undefined) { fields.push(`is_active = $${idx++}`); values.push(is_active); }
    fields.push('updated_at = NOW()');

    values.push(id);
    const result = await pool.query(
      `UPDATE products SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );

    res.json({ success: true, message: 'Product updated!', product: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Delete product
// @route   DELETE /api/products/:id
// @access  Private
const deleteProduct = async (req, res, next) => {
  try {
    const { id } = req.params;

    const check = await pool.query('SELECT seller_id FROM products WHERE id = $1', [id]);
    if (check.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Product not found.' });
    }
    if (check.rows[0].seller_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to delete this product.' });
    }

    await pool.query('DELETE FROM products WHERE id = $1', [id]);

    res.json({ success: true, message: 'Product deleted successfully.' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getProducts, getProductById, getMyProducts, createProduct, updateProduct, deleteProduct };
