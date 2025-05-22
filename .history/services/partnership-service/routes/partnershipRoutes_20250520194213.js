const express = require('express');
const router = express.Router();
const partnershipController = require('../controllers/partnershipController');
const authMiddleware = require('../middleware/authMiddleware');

// Get all partnerships
router.get('/', partnershipController.getAllPartnerships);

// Get partnership by ID
router.get('/:id', partnershipController.getPartnershipById);

// Create a new partnership
router.post('/', authMiddleware, partnershipController.createPartnership);

// Update a partnership
router.put('/:id', authMiddleware, partnershipController.updatePartnership);

// Delete a partnership
router.delete('/:id', authMiddleware, partnershipController.deletePartnership);

// Add an opportunity to a partnership
router.post('/:id/opportunities', authMiddleware, partnershipController.addOpportunity);

// Enroll in an opportunity
router.post('/:id/opportunities/:opportunityId/enroll', authMiddleware, partnershipController.enrollInOpportunity);

// Add a project to a partnership
router.post('/:id/projects', authMiddleware, partnershipController.addProject);

// Join a project
router.post('/:id/projects/:projectId/join', authMiddleware, partnershipController.joinProject);

// Add a rating to a partnership
router.post('/:id/rate', authMiddleware, partnershipController.ratePartnership);

module.exports = router;
