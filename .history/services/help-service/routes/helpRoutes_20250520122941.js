const express = require('express');
const router = express.Router();

// Placeholder routes
router.post('/request', (req, res) => {
  res.send('Help request created');
});

router.post('/offer', (req, res) => {
  res.send('Help offer created');
});

router.get('/match', (req, res) => {
  res.send('Help match found');
});

module.exports = router;
