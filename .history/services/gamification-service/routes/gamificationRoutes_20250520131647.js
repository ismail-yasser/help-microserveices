const express = require('express');
const router = express.Router();
const gamificationController = require('../controllers/gamificationController');

// Log a contribution
router.post('/log', gamificationController.logContribution);

// Fetch leaderboard
router.get('/leaderboard', gamificationController.getLeaderboard);

module.exports = router;
