const express = require('express');
const { generateDrills, getDrills, submitDrillCount, getUserDashboard } = require('../controllers/drillController');
const router = express.Router();

router.post('/generate', generateDrills);
router.post('/submit', submitDrillCount);
router.get('/', getDrills);
router.get('/user/:userId/dashboard', getUserDashboard);

module.exports = router;
