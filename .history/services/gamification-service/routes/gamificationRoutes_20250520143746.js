const express = require('express');
const router = express.Router();
const gamificationController = require('../controllers/gamificationController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes with JWT middleware
router.use(authMiddleware);

// Log a contribution
router.post('/log', gamificationController.logContribution);

// Fetch leaderboard
router.get('/leaderboard', gamificationController.getLeaderboard);

module.exports = router;
