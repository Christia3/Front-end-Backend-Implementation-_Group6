const express = require('express');
const router = express.Router();
const { getCreditSummary, getTransactions, transferCredits, redeemCredits } = require('../controllers/creditController');
const { protect } = require('../middleware/auth');

router.use(protect);

router.get('/', getCreditSummary);
router.get('/transactions', getTransactions);
router.post('/transfer', transferCredits);
router.post('/redeem', redeemCredits);

module.exports = router;
