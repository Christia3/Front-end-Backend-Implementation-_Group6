const express = require('express');
const router = express.Router();
const { getShops, getShopById, getMyShop, createShop, updateShop } = require('../controllers/shopController');
const { protect } = require('../middleware/auth');
const upload = require('../middleware/upload');

// Public routes
router.get('/', getShops);
router.get('/:id', getShopById);

// Private routes
router.get('/me/my-shop', protect, getMyShop);
router.post('/', protect, upload.single('logo_image'), createShop);
router.put('/:id', protect, upload.single('logo_image'), updateShop);

module.exports = router;
