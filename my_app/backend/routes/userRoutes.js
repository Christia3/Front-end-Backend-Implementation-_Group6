const express = require('express');
const router = express.Router();
const { getProfile, updateProfile, updateSettings, changePassword } = require('../controllers/userController');
const { protect } = require('../middleware/auth');
const upload = require('../middleware/upload');

// All routes require auth
router.use(protect);

// GET  /api/users/profile
router.get('/profile', getProfile);

// PUT  /api/users/profile
router.put('/profile', upload.single('profile_image'), updateProfile);

// PUT  /api/users/settings
router.put('/settings', updateSettings);

// PUT  /api/users/change-password
router.put('/change-password', changePassword);

module.exports = router;
