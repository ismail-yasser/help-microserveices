const express = require('express');
const router = express.Router();
const resourceController = require('../controllers/resourceController');

// Upload a resource
router.post('/', resourceController.uploadResource);

// Fetch all resources
router.get('/', resourceController.getAllResources);

// Fetch a specific resource by ID
router.get('/:id', resourceController.getResourceById);

module.exports = router;
