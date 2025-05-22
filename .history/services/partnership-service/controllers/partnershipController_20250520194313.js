const Partnership = require('../models/partnershipModel');

// Get all partnerships
exports.getAllPartnerships = async (req, res) => {
  try {
    const partnerships = await Partnership.find();
    res.status(200).json(partnerships);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching partnerships', error: error.message });
  }
};

// Get partnership by ID
exports.getPartnershipById = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    res.status(200).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching partnership', error: error.message });
  }
};

// Create a new partnership
exports.createPartnership = async (req, res) => {
  try {
    const newPartnership = new Partnership({
      ...req.body,
      members: [req.user.id] // Add the creator as the first member
    });
    const savedPartnership = await newPartnership.save();
    res.status(201).json(savedPartnership);
  } catch (error) {
    res.status(500).json({ message: 'Error creating partnership', error: error.message });
  }
};

// Update a partnership
exports.updatePartnership = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    // Check if user is a member of the partnership
    if (!partnership.members.includes(req.user.id)) {
      return res.status(403).json({ message: 'Not authorized to update this partnership' });
    }
    
    const updatedPartnership = await Partnership.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    
    res.status(200).json(updatedPartnership);
  } catch (error) {
    res.status(500).json({ message: 'Error updating partnership', error: error.message });
  }
};

// Delete a partnership
exports.deletePartnership = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    // Check if user is a member of the partnership
    if (!partnership.members.includes(req.user.id)) {
      return res.status(403).json({ message: 'Not authorized to delete this partnership' });
    }
    
    await Partnership.findByIdAndDelete(req.params.id);
    
    res.status(200).json({ message: 'Partnership deleted successfully' });
  } catch (error) {
    res.status(500).json({ message: 'Error deleting partnership', error: error.message });
  }
};

// Add an opportunity to a partnership
exports.addOpportunity = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    // Check if user is a member of the partnership
    if (!partnership.members.includes(req.user.id)) {
      return res.status(403).json({ message: 'Not authorized to add opportunities to this partnership' });
    }
    
    partnership.availableOpportunities.push(req.body);
    await partnership.save();
    
    res.status(201).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error adding opportunity', error: error.message });
  }
};

// Enroll in an opportunity
exports.enrollInOpportunity = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    const opportunity = partnership.availableOpportunities.id(req.params.opportunityId);
    
    if (!opportunity) {
      return res.status(404).json({ message: 'Opportunity not found' });
    }
    
    // Check if user is already enrolled
    if (opportunity.enrolledStudents.includes(req.user.id)) {
      return res.status(400).json({ message: 'Already enrolled in this opportunity' });
    }
    
    // Check if opportunity is at capacity
    if (opportunity.enrolledStudents.length >= opportunity.capacity) {
      return res.status(400).json({ message: 'Opportunity is at capacity' });
    }
    
    opportunity.enrolledStudents.push(req.user.id);
    await partnership.save();
    
    res.status(200).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error enrolling in opportunity', error: error.message });
  }
};

// Add a project to a partnership
exports.addProject = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    // Check if user is a member of the partnership
    if (!partnership.members.includes(req.user.id)) {
      return res.status(403).json({ message: 'Not authorized to add projects to this partnership' });
    }
    
    const project = {
      ...req.body,
      participants: [req.user.id] // Add the creator as the first participant
    };
    
    partnership.activeProjects.push(project);
    await partnership.save();
    
    res.status(201).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error adding project', error: error.message });
  }
};

// Join a project
exports.joinProject = async (req, res) => {
  try {
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    const project = partnership.activeProjects.id(req.params.projectId);
    
    if (!project) {
      return res.status(404).json({ message: 'Project not found' });
    }
    
    // Check if user is already a participant
    if (project.participants.includes(req.user.id)) {
      return res.status(400).json({ message: 'Already a participant in this project' });
    }
    
    project.participants.push(req.user.id);
    await partnership.save();
    
    res.status(200).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error joining project', error: error.message });
  }
};

// Rate a partnership
exports.ratePartnership = async (req, res) => {
  try {
    const { rating } = req.body;
    
    if (rating < 1 || rating > 5) {
      return res.status(400).json({ message: 'Rating must be between 1 and 5' });
    }
    
    const partnership = await Partnership.findById(req.params.id);
    
    if (!partnership) {
      return res.status(404).json({ message: 'Partnership not found' });
    }
    
    // Calculate new average rating
    const newRatingSum = partnership.rating * partnership.feedbackCount + rating;
    const newFeedbackCount = partnership.feedbackCount + 1;
    const newAverageRating = newRatingSum / newFeedbackCount;
    
    partnership.rating = newAverageRating;
    partnership.feedbackCount = newFeedbackCount;
    
    await partnership.save();
    
    res.status(200).json(partnership);
  } catch (error) {
    res.status(500).json({ message: 'Error rating partnership', error: error.message });
  }
};
