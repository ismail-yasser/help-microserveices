const express = require('express');
const router = express.Router();
const canvasController = require('../controllers/canvasController');
const authMiddleware = require('../middleware/authMiddleware');

// Sync routes - require authentication
router.post('/sync/courses', authMiddleware, canvasController.syncCourses);
router.post('/sync/courses/:courseId/assignments', authMiddleware, canvasController.syncAssignments);
router.post('/sync/users/:userId/enrollments', authMiddleware, canvasController.syncEnrollments);
router.post('/sync/courses/:courseId/announcements', authMiddleware, canvasController.syncAnnouncements);

// Get routes - some might be public depending on your requirements
router.get('/courses', canvasController.getCourses);
router.get('/courses/:courseId', canvasController.getCourseWithAssignments);
router.get('/users/:userId/upcoming-assignments', authMiddleware, canvasController.getUpcomingAssignments);

module.exports = router;
