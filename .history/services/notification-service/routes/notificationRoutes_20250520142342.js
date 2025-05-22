const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes with JWT middleware
router.use(authMiddleware);

// Create notification
router.post('/', notificationController.createNotification);

// Fetch notifications
router.get('/', notificationController.getNotifications);

module.exports = router;
