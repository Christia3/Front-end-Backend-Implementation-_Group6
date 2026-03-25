const pool = require('../config/db');

// @desc    Get all shops (with search & category filter)
// @route   GET /api/shops
// @access  Public
const getShops = async (req, res, next) => {
  try {
    const { search, category, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [];
    let idx = 1;
    let where = 'WHERE s.is_active = true';

    if (category && category !== 'All') {
      where += ` AND s.category = $${idx++}`;
      values.push(category);
    }

    if (search) {
      where += ` AND (s.name ILIKE $${idx} OR s.location ILIKE $${idx})`;
      values.push(`%${search}%`);
      idx++;
    }

    const countResult = await pool.query(`SELECT COUNT(*) FROM shops s ${where}`, values);
    const total = parseInt(countResult.rows[0].count);

    values.push(limit, offset);
    const result = await pool.query(
      `SELECT s.id, s.name, s.description, s.category, s.location, s.rating,
              s.total_reviews, s.logo_image, s.is_active,
              COUNT(p.id)::int AS product_count,
              u.full_name AS owner_name
       FROM shops s
       LEFT JOIN products p ON p.shop_id = s.id AND p.is_active = true
       LEFT JOIN users u ON u.id = s.owner_id
       ${where}
       GROUP BY s.id, u.full_name
       ORDER BY s.rating DESC
       LIMIT $${idx++} OFFSET $${idx}`,
      values
    );

    res.json({
      success: true,
      total,
      page: parseInt(page),
      shops: result.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get single shop with products
// @route   GET /api/shops/:id
// @access  Public
const getShopById = async (req, res, next) => {
  try {
    const { id } = req.params;

    const shopResult = await pool.query(
      `SELECT s.*, u.full_name AS owner_name, u.email AS owner_email
       FROM shops s
       LEFT JOIN users u ON u.id = s.owner_id
       WHERE s.id = $1`,
      [id]
    );

    if (shopResult.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Shop not found.' });
    }

    const productsResult = await pool.query(
      `SELECT p.*, ARRAY_AGG(pi.image_url) FILTER (WHERE pi.image_url IS NOT NULL) AS images
       FROM products p
       LEFT JOIN product_images pi ON pi.product_id = p.id
       WHERE p.shop_id = $1 AND p.is_active = true
       GROUP BY p.id
       ORDER BY p.created_at DESC`,
      [id]
    );

    res.json({
      success: true,
      shop: shopResult.rows[0],
      products: productsResult.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get current user's shop
// @route   GET /api/shops/my-shop
// @access  Private
const getMyShop = async (req, res, next) => {
  try {
    const result = await pool.query('SELECT * FROM shops WHERE owner_id = $1', [req.user.id]);

    if (result.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'You have not created a shop yet.' });
    }

    res.json({ success: true, shop: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Create shop
// @route   POST /api/shops
// @access  Private
const createShop = async (req, res, next) => {
  try {
    const { name, description, address, phone, email, category, location } = req.body;

    if (!name) {
      return res.status(400).json({ success: false, message: 'Shop name is required.' });
    }

    // One shop per user (optional rule — remove if multiple shops allowed)
    const existing = await pool.query('SELECT id FROM shops WHERE owner_id = $1', [req.user.id]);
    if (existing.rows.length > 0) {
      return res.status(400).json({ success: false, message: 'You already have a shop. Use update instead.' });
    }

    const logo_image = req.file ? `/uploads/${req.file.filename}` : null;

    const result = await pool.query(
      `INSERT INTO shops (owner_id, name, description, address, phone, email, category, location, logo_image)
       VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9)
       RETURNING *`,
      [req.user.id, name, description, address, phone, email, category, location, logo_image]
    );

    res.status(201).json({ success: true, message: 'Shop created successfully!', shop: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Update shop
// @route   PUT /api/shops/:id
// @access  Private
const updateShop = async (req, res, next) => {
  try {
    const { id } = req.params;

    const shopCheck = await pool.query('SELECT id, owner_id FROM shops WHERE id = $1', [id]);
    if (shopCheck.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Shop not found.' });
    }
    if (shopCheck.rows[0].owner_id !== req.user.id) {
      return res.status(403).json({ success: false, message: 'Not authorized to update this shop.' });
    }

    const { name, description, address, phone, email, category, location, is_active } = req.body;
    const logo_image = req.file ? `/uploads/${req.file.filename}` : undefined;

    const fields = [];
    const values = [];
    let idx = 1;

    if (name) { fields.push(`name = $${idx++}`); values.push(name); }
    if (description !== undefined) { fields.push(`description = $${idx++}`); values.push(description); }
    if (address !== undefined) { fields.push(`address = $${idx++}`); values.push(address); }
    if (phone !== undefined) { fields.push(`phone = $${idx++}`); values.push(phone); }
    if (email !== undefined) { fields.push(`email = $${idx++}`); values.push(email); }
    if (category) { fields.push(`category = $${idx++}`); values.push(category); }
    if (location !== undefined) { fields.push(`location = $${idx++}`); values.push(location); }
    if (is_active !== undefined) { fields.push(`is_active = $${idx++}`); values.push(is_active); }
    if (logo_image) { fields.push(`logo_image = $${idx++}`); values.push(logo_image); }
    fields.push('updated_at = NOW()');

    values.push(id);

    const result = await pool.query(
      `UPDATE shops SET ${fields.join(', ')} WHERE id = $${idx} RETURNING *`,
      values
    );

    res.json({ success: true, message: 'Shop updated successfully!', shop: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

module.exports = { getShops, getShopById, getMyShop, createShop, updateShop };
