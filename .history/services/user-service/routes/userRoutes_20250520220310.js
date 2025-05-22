// Placeholder for user-related routes
const express = require('express');
const router = express.Router();
const userController = require('../controllers/userController');
const authMiddleware = require('../middleware/authMiddleware');
const validationMiddleware = require('../middleware/validationMiddleware');

// Signup route with validation
router.post(
  '/signup',
  validationMiddleware.validateSignup,
  validationMiddleware.handleValidationErrors,
  userController.signup
);

// Login route with validation
router.post(
  '/login',
  validationMiddleware.validateLogin,
  validationMiddleware.handleValidationErrors,
  userController.login
);

// Get current user (me) - Protected
router.get('/me', authMiddleware, userController.getCurrentUser);

// Get user profile route with validation
router.get(
  '/profile/:id',
  validationMiddleware.validateUserProfile,
  validationMiddleware.handleValidationErrors,
  userController.getUserProfile
);

// Example of a protected route
router.get('/profile', authMiddleware, (req, res) => {
  res.send(`Welcome, user with ID: ${req.user.id}`);
});

module.exports = router;
