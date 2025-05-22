const express = require('express');
const router = express.Router();
const helpController = require('../controllers/helpController');

// Create help request
router.post('/request', helpController.createHelpRequest);

// Create help offer
router.post('/offer', helpController.createHelpOffer);

// Find help match
router.get('/match', helpController.findHelpMatch);

module.exports = router;
