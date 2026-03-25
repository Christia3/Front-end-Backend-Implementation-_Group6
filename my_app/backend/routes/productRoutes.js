const express = require('express');
const router = express.Router();
const {
  getProducts,
  getProductById,
  getMyProducts,
  createProduct,
  updateProduct,
  deleteProduct,
} = require('../controllers/productController');
const { protect } = require('../middleware/auth');
const upload = require('../middleware/upload');

// Public routes
router.get('/', getProducts);
router.get('/:id', getProductById);

// Private routes
router.get('/me/my-products', protect, getMyProducts);
router.post('/', protect, upload.array('images', 4), createProduct);
router.put('/:id', protect, upload.array('images', 4), updateProduct);
router.delete('/:id', protect, deleteProduct);

module.exports = router;
