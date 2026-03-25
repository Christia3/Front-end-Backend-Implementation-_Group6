const pool = require('../config/db');
const bcrypt = require('bcryptjs');
const { validationResult } = require('express-validator');

// @desc    Get user profile
// @route   GET /api/users/profile
// @access  Private
const getProfile = async (req, res, next) => {
  try {
    const result = await pool.query(
      `SELECT id, full_name, email, phone, address, bio, profile_image,
              language, currency, notifications_enabled, dark_mode, credits, created_at
       FROM users WHERE id = $1`,
      [req.user.id]
    );

    // Get user stats
    const statsResult = await pool.query(
      `SELECT
         (SELECT COUNT(*) FROM orders WHERE buyer_id = $1) AS total_orders,
         (SELECT COUNT(*) FROM reviews WHERE reviewer_id = $1) AS total_reviews,
         (SELECT COALESCE(SUM(amount), 0) FROM credit_transactions WHERE user_id = $1 AND type = 'credit') AS total_earned,
         (SELECT COALESCE(SUM(amount), 0) FROM credit_transactions WHERE user_id = $1 AND type = 'debit') AS total_spent`,
      [req.user.id]
    );

    res.json({
      success: true,
      user: result.rows[0],
      stats: statsResult.rows[0],
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Update user profile
// @route   PUT /api/users/profile
// @access  Private
const updateProfile = async (req, res, next) => {
  try {
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ success: false, errors: errors.array() });
    }

    const { full_name, phone, address, bio } = req.body;
    const profile_image = req.file ? `/uploads/${req.file.filename}` : undefined;

    const fields = [];
    const values = [];
    let idx = 1;

    if (full_name) { fields.push(`full_name = $${idx++}`); values.push(full_name); }
    if (phone !== undefined) { fields.push(`phone = $${idx++}`); values.push(phone); }
    if (address !== undefined) { fields.push(`address = $${idx++}`); values.push(address); }
    if (bio !== undefined) { fields.push(`bio = $${idx++}`); values.push(bio); }
    if (profile_image) { fields.push(`profile_image = $${idx++}`); values.push(profile_image); }
    fields.push(`updated_at = NOW()`);

    if (fields.length === 1) {
      return res.status(400).json({ success: false, message: 'No fields to update.' });
    }

    values.push(req.user.id);

    const result = await pool.query(
      `UPDATE users SET ${fields.join(', ')} WHERE id = $${idx}
       RETURNING id, full_name, email, phone, address, bio, profile_image, credits`,
      values
    );

    res.json({ success: true, message: 'Profile updated successfully!', user: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Update user settings (language, currency, notifications, dark mode)
// @route   PUT /api/users/settings
// @access  Private
const updateSettings = async (req, res, next) => {
  try {
    const { language, currency, notifications_enabled, dark_mode } = req.body;

    const fields = [];
    const values = [];
    let idx = 1;

    if (language) { fields.push(`language = $${idx++}`); values.push(language); }
    if (currency) { fields.push(`currency = $${idx++}`); values.push(currency); }
    if (notifications_enabled !== undefined) { fields.push(`notifications_enabled = $${idx++}`); values.push(notifications_enabled); }
    if (dark_mode !== undefined) { fields.push(`dark_mode = $${idx++}`); values.push(dark_mode); }
    fields.push('updated_at = NOW()');

    if (fields.length === 1) {
      return res.status(400).json({ success: false, message: 'No settings to update.' });
    }

    values.push(req.user.id);

    const result = await pool.query(
      `UPDATE users SET ${fields.join(', ')} WHERE id = $${idx}
       RETURNING id, language, currency, notifications_enabled, dark_mode`,
      values
    );

    res.json({ success: true, message: 'Settings updated!', settings: result.rows[0] });
  } catch (err) {
    next(err);
  }
};

// @desc    Change password
// @route   PUT /api/users/change-password
// @access  Private
const changePassword = async (req, res, next) => {
  try {
    const { current_password, new_password } = req.body;

    if (!current_password || !new_password) {
      return res.status(400).json({ success: false, message: 'Both current and new passwords are required.' });
    }

    if (new_password.length < 6) {
      return res.status(400).json({ success: false, message: 'New password must be at least 6 characters.' });
    }

    const result = await pool.query('SELECT password FROM users WHERE id = $1', [req.user.id]);
    const isMatch = await bcrypt.compare(current_password, result.rows[0].password);

    if (!isMatch) {
      return res.status(401).json({ success: false, message: 'Current password is incorrect.' });
    }

    const salt = await bcrypt.genSalt(10);
    const hashed = await bcrypt.hash(new_password, salt);

    await pool.query('UPDATE users SET password = $1, updated_at = NOW() WHERE id = $2', [hashed, req.user.id]);

    res.json({ success: true, message: 'Password changed successfully!' });
  } catch (err) {
    next(err);
  }
};

module.exports = { getProfile, updateProfile, updateSettings, changePassword };
