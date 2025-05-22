const express = require('express');
const router = express.Router();

// Placeholder routes
router.post('/', (req, res) => {
  res.send('Study group created');
});

router.get('/', (req, res) => {
  res.send('Study groups fetched');
});

router.post('/:id/join', (req, res) => {
  res.send(`Joined study group with ID: ${req.params.id}`);
});

module.exports = router;
