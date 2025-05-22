const express = require('express');
const router = express.Router();

// Placeholder routes
router.post('/', (req, res) => {
  res.send('Upload a new resource');
});

router.get('/', (req, res) => {
  res.send('Fetch all resources');
});

router.get('/:id', (req, res) => {
  res.send(`Fetch resource with ID: ${req.params.id}`);
});

module.exports = router;
