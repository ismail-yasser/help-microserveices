const express = require('express');
const router = express.Router();
const resourceController = require('../controllers/resourceController');
const authMiddleware = require('../middleware/authMiddleware');

// Protect all routes with JWT middleware
router.use(authMiddleware);

// Upload a resource
router.post('/', resourceController.uploadResource);

// Fetch all resources with pagination and filtering
router.get('/', resourceController.getResources);

// Fetch a specific resource by ID
router.get('/:id', resourceController.getResourceById);

module.exports = router;
