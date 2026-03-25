const express = require('express');
const router = express.Router();
const { placeOrder, getMyOrders, getOrderById, getMySales, updateOrderStatus } = require('../controllers/orderController');
const { protect } = require('../middleware/auth');

// All order routes require auth
router.use(protect);

router.post('/', placeOrder);
router.get('/', getMyOrders);
router.get('/sales', getMySales);
router.get('/:id', getOrderById);
router.put('/:id/status', updateOrderStatus);

module.exports = router;
