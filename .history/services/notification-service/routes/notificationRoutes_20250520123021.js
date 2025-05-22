const express = require('express');
const router = express.Router();

// Placeholder routes
router.post('/', (req, res) => {
  res.send('Notification created');
});

router.get('/', (req, res) => {
  res.send('Notifications fetched');
});

module.exports = router;
