const express = require('express');
const router = express.Router();

// Placeholder routes
router.post('/resources', (req, res) => {
  res.send('Upload a new resource');
});

router.get('/resources', (req, res) => {
  res.send('Fetch all resources');
});

router.get('/resources/:id', (req, res) => {
  res.send(`Fetch resource with ID: ${req.params.id}`);
});

module.exports = router;
