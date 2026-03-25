const pool = require('../config/db');

// @desc    Get credit balance and transactions
// @route   GET /api/credits
// @access  Private
const getCreditSummary = async (req, res, next) => {
  try {
    // Get current balance
    const userResult = await pool.query('SELECT credits FROM users WHERE id = $1', [req.user.id]);
    const balance = userResult.rows[0].credits;

    // Get stats
    const statsResult = await pool.query(
      `SELECT
         COALESCE(SUM(CASE WHEN type = 'credit' THEN amount ELSE 0 END), 0) AS total_earned,
         COALESCE(SUM(CASE WHEN type = 'debit' THEN amount ELSE 0 END), 0) AS total_spent
       FROM credit_transactions WHERE user_id = $1`,
      [req.user.id]
    );

    // Get recent transactions
    const { page = 1, limit = 20 } = {};
    const transactionsResult = await pool.query(
      `SELECT * FROM credit_transactions WHERE user_id = $1 ORDER BY created_at DESC LIMIT 20`,
      [req.user.id]
    );

    res.json({
      success: true,
      balance,
      stats: statsResult.rows[0],
      transactions: transactionsResult.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Get all transactions (paginated)
// @route   GET /api/credits/transactions
// @access  Private
const getTransactions = async (req, res, next) => {
  try {
    const { type, page = 1, limit = 20 } = req.query;
    const offset = (page - 1) * limit;
    const values = [req.user.id];
    let where = 'WHERE user_id = $1';
    let idx = 2;

    if (type === 'credit' || type === 'debit') {
      where += ` AND type = $${idx++}`;
      values.push(type);
    }

    const countResult = await pool.query(
      `SELECT COUNT(*) FROM credit_transactions ${where}`, values
    );

    values.push(limit, offset);
    const result = await pool.query(
      `SELECT * FROM credit_transactions ${where} ORDER BY created_at DESC LIMIT $${idx++} OFFSET $${idx}`,
      values
    );

    res.json({
      success: true,
      total: parseInt(countResult.rows[0].count),
      page: parseInt(page),
      transactions: result.rows,
    });
  } catch (err) {
    next(err);
  }
};

// @desc    Transfer credits to another user
// @route   POST /api/credits/transfer
// @access  Private
const transferCredits = async (req, res, next) => {
  const client = await pool.connect();
  try {
    const { recipient_email, amount, description } = req.body;

    if (!recipient_email || !amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Recipient email and a positive amount are required.' });
    }

    // Get recipient
    const recipientResult = await client.query(
      'SELECT id, full_name, email FROM users WHERE email = $1',
      [recipient_email.toLowerCase()]
    );
    if (recipientResult.rows.length === 0) {
      return res.status(404).json({ success: false, message: 'Recipient not found.' });
    }

    const recipient = recipientResult.rows[0];

    if (recipient.id === req.user.id) {
      return res.status(400).json({ success: false, message: 'You cannot transfer credits to yourself.' });
    }

    // Check sender balance
    const senderResult = await client.query('SELECT credits FROM users WHERE id = $1', [req.user.id]);
    const senderCredits = senderResult.rows[0].credits;

    if (senderCredits < amount) {
      return res.status(400).json({ success: false, message: `Insufficient credits. You have ${senderCredits} credits.` });
    }

    await client.query('BEGIN');

    // Deduct from sender
    await client.query('UPDATE users SET credits = credits - $1 WHERE id = $2', [amount, req.user.id]);
    await client.query(
      `INSERT INTO credit_transactions (user_id, type, amount, description, reference_id, reference_type)
       VALUES ($1, 'debit', $2, $3, $4, 'transfer')`,
      [req.user.id, amount, description || `Transfer to ${recipient.full_name}`, recipient.id]
    );

    // Add to recipient
    await client.query('UPDATE users SET credits = credits + $1 WHERE id = $2', [amount, recipient.id]);
    await client.query(
      `INSERT INTO credit_transactions (user_id, type, amount, description, reference_id, reference_type)
       VALUES ($1, 'credit', $2, $3, $4, 'transfer')`,
      [recipient.id, amount, description || `Transfer from ${req.user.full_name}`, req.user.id]
    );

    await client.query('COMMIT');

    res.json({
      success: true,
      message: `Successfully transferred ${amount} credits to ${recipient.full_name}.`,
    });
  } catch (err) {
    await client.query('ROLLBACK');
    next(err);
  } finally {
    client.release();
  }
};

// @desc    Redeem credits (placeholder for reward system)
// @route   POST /api/credits/redeem
// @access  Private
const redeemCredits = async (req, res, next) => {
  try {
    const { amount, reward_type } = req.body;

    if (!amount || amount <= 0) {
      return res.status(400).json({ success: false, message: 'Valid amount required.' });
    }

    const userResult = await pool.query('SELECT credits FROM users WHERE id = $1', [req.user.id]);
    if (userResult.rows[0].credits < amount) {
      return res.status(400).json({ success: false, message: 'Insufficient credits.' });
    }

    await pool.query('UPDATE users SET credits = credits - $1 WHERE id = $2', [amount, req.user.id]);
    await pool.query(
      `INSERT INTO credit_transactions (user_id, type, amount, description, reference_type)
       VALUES ($1, 'debit', $2, $3, 'redemption')`,
      [req.user.id, amount, `Redeemed for ${reward_type || 'reward'}`]
    );

    res.json({ success: true, message: `${amount} credits redeemed successfully!` });
  } catch (err) {
    next(err);
  }
};

module.exports = { getCreditSummary, getTransactions, transferCredits, redeemCredits };
