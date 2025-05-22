// Placeholder for user-related routes
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');

// Signup route
router.post('/signup', userController.signup);

// Login route
router.post('/login', userController.login);

// Get user profile route
router.get('/profile/:id', userController.getUserProfile);

// Example route
router.get('/profile', (req, res) => {
  res.send('User profile endpoint');
});

module.exports = router;
