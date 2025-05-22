const express = require('express');
const router = express.Router();
const helpController = require('../controllers/helpController');
const authMiddleware = require('../middleware/authMiddleware');
const multer = require('multer');
const path = require('path');
const fs = require('fs');

// Ensure uploads directory exists
const uploadsDir = path.join(__dirname, '../uploads');
if (!fs.existsSync(uploadsDir)){
    fs.mkdirSync(uploadsDir, { recursive: true });
}

// Multer storage configuration
const storage = multer.diskStorage({
  destination: function (req, file, cb) {
    cb(null, uploadsDir); // Save files to the 'uploads' directory
  },
  filename: function (req, file, cb) {
    cb(null, Date.now() + '-' + file.originalname.replace(/\s+/g, '_')); // Use a unique filename
  }
});

const upload = multer({ 
  storage: storage,
  limits: { fileSize: 10 * 1024 * 1024 }, // Limit file size to 10MB
  fileFilter: function (req, file, cb) {
    // Add any specific file type filtering here if needed
    // Example: Allow only images
    // if (!file.mimetype.startsWith('image/')) {
    //   return cb(new Error('Only image files are allowed!'), false);
    // }
    cb(null, true);
  }
});

// Make these routes public for testing purposes
// GET all help requests/offers
router.get('/', helpController.getAllHelp);

// Search help by query, tags, and course
router.get('/search', helpController.searchHelp);

// Find help match (must come before /:id route)
router.get('/match', helpController.findHelpMatch);

// Get specific help request/offer
router.get('/:id', helpController.getHelpById);

// Protect other routes with JWT middleware
router.use(authMiddleware);

// Create help request - now handles file uploads (e.g., up to 5 files)
router.post('/request', upload.array('attachments', 5), helpController.createHelpRequest);

// Create help offer
router.post('/offer', helpController.createHelpOffer);

// Update a help request/offer
router.put('/:id', helpController.updateHelp);

// Delete a help request/offer
router.delete('/:id', helpController.deleteHelp);

// Add a response to a help request
router.post('/:id/responses', helpController.addResponse);

// Update the status of a help request
router.put('/:id/status', helpController.updateStatus);

// Assign a helper to a request
router.post('/:id/assign', helpController.assignHelper);

// Schedule a meeting for a help request
router.post('/:id/meeting', helpController.scheduleMeeting);

// Rate a help response
router.post('/:id/responses/:responseId/rate', helpController.rateResponse);

// Upload a file attachment
router.post('/:id/attachments', helpController.uploadAttachment);

module.exports = router;
