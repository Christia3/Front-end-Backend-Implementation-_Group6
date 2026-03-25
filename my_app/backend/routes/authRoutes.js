const express = require('express');
const router = express.Router();
const { body } = require('express-validator');
const { register, login, forgotPassword, getMe } = require('../controllers/authController');
const { protect } = require('../middleware/auth');

// POST /api/auth/register
router.post(
  '/register',
  [
    body('full_name').trim().notEmpty().withMessage('Full name is required'),
    body('email').isEmail().withMessage('Valid email is required').normalizeEmail(),
    body('password').isLength({ min: 6 }).withMessage('Password must be at least 6 characters'),
  ],
  register
);

// POST /api/auth/login
router.post(
  '/login',
  [
    body('email').isEmail().withMessage('Valid email is required').normalizeEmail(),
    body('password').notEmpty().withMessage('Password is required'),
  ],
  login
);

// POST /api/auth/forgot-password
router.post('/forgot-password', forgotPassword);

// GET /api/auth/me
router.get('/me', protect, getMe);

module.exports = router;
