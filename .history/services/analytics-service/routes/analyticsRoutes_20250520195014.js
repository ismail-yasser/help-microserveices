const express = require('express');
const router = express.Router();
const analyticsController = require('../controllers/analyticsController');
const authMiddleware = require('../middleware/authMiddleware');

// Record user activity (can be called from client or other services)
router.post('/record', analyticsController.recordUserActivity);

// Get analytics for a specific user (requires authentication)
router.get('/users/:userId', authMiddleware, analyticsController.getUserAnalytics);

// Get analytics for a specific resource
router.get('/resources/:resourceId', analyticsController.getResourceAnalytics);

// Get analytics for a specific help request
router.get('/help/:helpRequestId', analyticsController.getHelpAnalytics);

// Get system analytics (admin only in a real implementation)
router.get('/system', authMiddleware, analyticsController.getSystemAnalytics);

// Update system analytics (should be protected and called by a scheduler)
router.post('/system/update', authMiddleware, analyticsController.updateSystemAnalytics);

// Get dashboard analytics summary
router.get('/dashboard', authMiddleware, analyticsController.getDashboardAnalytics);

module.exports = router;
