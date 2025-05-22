const express = require('express');
const router = express.Router();
const notificationController = require('../controllers/notificationController');

// Create notification
router.post('/', notificationController.createNotification);

// Fetch notifications
router.get('/', notificationController.getNotifications);

module.exports = router;
