// Placeholder for user-related routes
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');

// Signup route
router.post('/signup', userController.signup);

// Login route
router.post('/login', userController.login);

// Get user profile route
router.get('/profile/:id', userController.getUserProfile);

// Example of a protected route
router.get('/profile', authMiddleware, (req, res) => {
  res.send(`Welcome, user with ID: ${req.user.id}`);
});

module.exports = router;
