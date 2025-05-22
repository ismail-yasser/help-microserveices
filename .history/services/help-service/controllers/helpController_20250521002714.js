const Help = require('../models/helpModel');
const axios = require('axios');
const fs = require('fs').promises;

// Get all user profiles from user service
const getUserProfiles = async () => {
  try {
    const response = await axios.get('http://localhost:3000/api/users/profiles');
    return response.data;
  } catch (error) {
    console.error('Error fetching user profiles:', error);
    return [];
  }
};

// Award points to a user through gamification service
const awardPoints = async (userId, points, action) => {
  try {
    await axios.post(`http://localhost:3003/api/gamification/${userId}/points`, {
      points,
      action
    });
    return true;
  } catch (error) {
    console.error('Error awarding points:', error);
    return false;
  }
};

// Save a new help request
exports.createHelpRequest = async (req, res) => {
  try {
    const { title, description, course, tags, urgency, estimatedTimeInMinutes, requiredSkills } = req.body;
    const userId = req.user.id; // Assuming authMiddleware adds user to req

    let fileAttachments = [];
    if (req.files && req.files.length > 0) {
      fileAttachments = req.files.map(file => {
        let fileType = 'other'; // Default fileType
        if (file.mimetype.startsWith('image/')) {
          fileType = 'image';
        } else if (file.mimetype === 'application/pdf') {
          fileType = 'pdf';
        } else if (file.mimetype.startsWith('video/')) {
          fileType = 'video';
        } else if (file.mimetype.startsWith('text/') || file.mimetype.includes('javascript') || file.mimetype.includes('python')) {
          fileType = 'code'; // Basic check for code files
        } else if (file.mimetype.includes('document') || file.mimetype.includes('word') || file.mimetype.includes('presentation') || file.mimetype.includes('powerpoint')) {
          fileType = 'document'; // Broader category for office documents
        }

        return {
          fileName: file.filename, // Corrected to match schema: fileName
          fileUrl: file.path,     // Using path as fileUrl for now (server path)
          mimetype: file.mimetype, // Storing original mimetype can be useful
          size: file.size,
          fileType: fileType       // Set derived fileType
        };
      });
    }

    const helpRequest = new Help({
      userId,
      title,
      description,
      course,
      // Ensure subject is populated if your model requires it and it's different from title
      subject: title, // Assuming subject is the same as title for now
      tags: Array.isArray(tags) ? tags : (tags ? tags.split(',').map(tag => tag.trim()) : []),
      urgency,
      estimatedTimeInMinutes,
      requiredSkills: Array.isArray(requiredSkills) ? requiredSkills : (requiredSkills ? requiredSkills.split(',').map(skill => skill.trim()) : []),
      attachments: fileAttachments, // Corrected field name to 'attachments' as per helpModel
      type: 'request',
      pointsAwarded: calculatePoints(urgency, estimatedTimeInMinutes)
    });

    // Find potential helpers based on required skills
    const suggestedHelpers = await findPotentialHelpers(helpRequest.requiredSkills, helpRequest.tags);
    helpRequest.suggestedHelpers = suggestedHelpers.map(helper => helper._id);

    await helpRequest.save();

    // Notify suggested helpers
    suggestedHelpers.forEach(async (helper) => {
      try {
        await axios.post('http://localhost:3004/api/notifications', {
          userId: helper._id,
          type: 'help_request_match',
          message: `Your skills match a new help request: ${title}`,
          linkToResource: `/help/${helpRequest._id}`
        });
      } catch (err) {
        console.error('Error sending notification:', err);
      }
    });

    res.status(201).json({
      message: 'Help request created successfully',
      helpRequest
    });
  } catch (error) {
    console.error('Error creating help request:', error);
    res.status(500).json({ message: 'Error creating help request', error: error.message });
  }
};

// Save a new help offer (this is a simplified version, adjust as needed)
// This function is for creating an offer on an *existing* help request.
exports.createHelpOffer = async (req, res) => {
  try {
    const { requestId, description, userId } = req.body; // userId is the ID of the user making the offer
    const helpRequest = await Help.findById(requestId);

    if (!helpRequest) {
      return res.status(404).json({ message: 'Help request not found' });
    }

    if (helpRequest.userId.toString() === userId) {
        return res.status(400).json({ message: 'You cannot offer help on your own request.'});
    }

    const newOffer = {
      userId: userId, // User making the offer
      description: description,
      // status will default to 'pending' as per schema
    };

    helpRequest.offers.push(newOffer);
    await helpRequest.save();

    // Notify the help requester
    try {
      await axios.post('http://localhost:3004/api/notifications', {
        userId: helpRequest.userId, // Notify the user who created the request
        type: 'new_help_offer',
        message: `You have a new offer for your help request: ${helpRequest.title}`,
        linkToResource: `/request/${requestId}` // Link to the help request detail page
      });
    } catch (err) {
      console.error('Error sending new offer notification:', err);
    }

    res.status(201).json({ message: 'Help offer submitted successfully', offer: newOffer });

  } catch (error) {
    console.error('Error creating help offer:', error);
    res.status(500).json({ message: 'Error creating help offer', error: error.message });
  }
};

// Accept a help offer
exports.acceptHelpOffer = async (req, res) => {
  try {
    const { requestId, offerId } = req.params;
    const helpRequest = await Help.findById(requestId);

    if (!helpRequest) {
      return res.status(404).json({ message: 'Help request not found' });
    }

    // Ensure the person accepting is the owner of the help request
    if (helpRequest.userId.toString() !== req.user.id) {
      return res.status(403).json({ message: 'Unauthorized to accept offers for this request' });
    }

    const offer = helpRequest.offers.id(offerId);
    if (!offer) {
      return res.status(404).json({ message: 'Offer not found' });
    }

    if (offer.status !== 'pending') {
      return res.status(400).json({ message: 'Offer is not pending and cannot be accepted' });
    }

    // Accept this offer
    offer.status = 'accepted';
    helpRequest.status = 'in-progress'; // Update request status
    helpRequest.assignedHelpers.push(offer.userId); // Add offerer to assigned helpers

    // Reject other pending offers for this request (optional, but good practice)
    helpRequest.offers.forEach(o => {
      if (o._id.toString() !== offerId && o.status === 'pending') {
        o.status = 'rejected';
      }
    });

    await helpRequest.save();

    // Notify the offerer that their offer was accepted
    try {
      await axios.post('http://localhost:3004/api/notifications', {
        userId: offer.userId,
        type: 'offer_accepted',
        message: `Your help offer for "${helpRequest.title}" has been accepted!`,
        linkToResource: `/request/${requestId}`
      });
    } catch (err) {
      console.error('Error sending offer accepted notification:', err);
    }
    
    // Award points to the helper who got accepted (initial points for acceptance)
    // More points can be awarded upon resolution
    await awardPoints(offer.userId, 10, 'offer_accepted'); // Example: 10 points for offer acceptance


    res.status(200).json({ message: 'Offer accepted successfully', helpRequest });

  } catch (error) {
    console.error('Error accepting help offer:', error);
    res.status(500).json({ message: 'Error accepting help offer', error: error.message });
  }
};

// Find help matches based on skills and course
exports.findHelpMatch = async (req, res) => {
  try {
    const { subject, requiredSkills = [], courseId, tags = [] } = req.query;
    
    // Build query
    const query = { type: 'offer', status: 'open' };
    
    if (subject) {
      query.$text = { $search: subject };
    }
    
    if (courseId) {
      query.courseId = courseId;
    }
    
    if (requiredSkills.length > 0) {
      query.expertise = { $in: Array.isArray(requiredSkills) ? requiredSkills : [requiredSkills] };
    }
    
    if (tags.length > 0) {
      query.tags = { $in: Array.isArray(tags) ? tags : [tags] };
    }
    
    const matches = await Help.find(query).sort({ createdAt: -1 });
    res.status(200).json(matches);
  } catch (error) {
    console.error('Error finding help matches:', error);
    res.status(500).send('Error finding help matches');
  }
};

// Function to calculate points based on urgency and time
function calculatePoints(urgency, estimatedTimeInMinutes = 30) {
  const basePoints = 10;
  const urgencyMultiplier = {
    'low': 1,
    'medium': 1.5,
    'high': 2
  };
  
  const timeMultiplier = Math.ceil(estimatedTimeInMinutes / 15); // 15-minute blocks
  
  return Math.round(basePoints * (urgencyMultiplier[urgency] || 1) * timeMultiplier);
}

// Find potential helpers based on skills
async function findPotentialHelpers(requiredSkills = [], tags = []) {
  try {
    // Get user profiles from user service
    const users = await getUserProfiles();
    
    // Filter users with matching skills
    return users.filter(user => {
      if (!user.expertise || !Array.isArray(user.expertise)) {
        return false;
      }
      
      // Check if user has at least one required skill or relevant tag
      const hasRequiredSkill = requiredSkills.some(skill => 
        user.expertise.includes(skill)
      );
      
      const hasRelevantTag = tags.some(tag => 
        user.expertise.includes(tag)
      );
      
      return hasRequiredSkill || hasRelevantTag;
    }).slice(0, 5); // Limit to 5 potential helpers
  } catch (error) {
    console.error('Error finding potential helpers:', error);
    return [];
  }
};

// Get all help requests/offers
exports.getAllHelp = async (req, res) => {
  try {
    const { type, status } = req.query;
    const query = {};
    
    if (type) {
      query.type = type;
    }
    
    if (status) {
      query.status = status;
    }
    
    const helpItems = await Help.find(query).sort({ createdAt: -1 });
    
    // Get user profiles to add names
    let users = [];
    try {
      const response = await getUserProfiles();
      users = response || [];
    } catch (err) {
      console.error('Error fetching user profiles for help items:', err);
    }
    
    // Add requester name to each help item
    const enrichedHelpItems = helpItems.map(item => {
      const itemObj = item.toObject ? item.toObject() : item;
      const user = users.find(u => 
        u._id && itemObj.userId && 
        u._id.toString() === itemObj.userId.toString()
      );
      
      return {
        ...itemObj,
        requestedBy: user ? user.name : 'Unknown User'
      };
    });
    
    res.status(200).json(enrichedHelpItems);
  } catch (error) {
    console.error('Error getting help items:', error);
    res.status(500).send('Error getting help items');
  }
};

// Search help by query, tags, and course
exports.searchHelp = async (req, res) => {
  try {
    const { query, tags, courseId, type } = req.query;
    const searchQuery = {};
    
    if (query) {
      searchQuery.$text = { $search: query };
    }
    
    if (tags && Array.isArray(tags)) {
      searchQuery.tags = { $in: tags };
    } else if (tags) {
      searchQuery.tags = tags;
    }
    
    if (courseId) {
      searchQuery.courseId = courseId;
    }
    
    if (type) {
      searchQuery.type = type;
    }
    
    const helpItems = await Help.find(searchQuery).sort({ createdAt: -1 });
    res.status(200).json(helpItems);
  } catch (error) {
    console.error('Error searching help items:', error);
    res.status(500).send('Error searching help items');
  }
};

// Get a specific help request/offer
exports.getHelpById = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id); // Removed .populate() calls
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Get user profile to add requester name
    let requesterName = 'Unknown User';
    try {
      const users = await getUserProfiles();
      const requester = users.find(u => 
        u._id && helpItem.userId && 
        u._id.toString() === helpItem.userId.toString()
      );
      
      if (requester) {
        requesterName = requester.name;
      }
    } catch (err) {
      console.error('Error fetching user profile for help item:', err);
    }
    
    // Convert to object and add requester name
    const helpItemObj = helpItem.toObject ? helpItem.toObject() : helpItem;
    
    res.status(200).json({
      ...helpItemObj,
      requestedBy: requesterName
    });
  } catch (error) {
    console.error('Error fetching help item by ID:', error); // Log the actual error
    res.status(500).send('Error fetching help item');
  }
};

// Update a help request/offer
exports.updateHelp = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Verify ownership or admin status
    if (helpItem.userId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).send('Unauthorized to update this help item');
    }
    
    // Update help item
    const updatedHelpItem = await Help.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true }
    );
    
    res.status(200).json(updatedHelpItem);
  } catch (error) {
    console.error('Error updating help item:', error);
    res.status(500).send('Error updating help item');
  }
};

// Delete a help request/offer
exports.deleteHelp = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id);
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }

    // Verify ownership or admin status
    if (helpItem.userId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).send('Unauthorized to delete this help item');
    }

    // Delete associated files from the server if they exist
    if (helpItem.fileAttachments && helpItem.fileAttachments.length > 0) {
      for (const attachment of helpItem.fileAttachments) {
        try {
          await fs.unlink(attachment.path); // attachment.path should be the absolute path or resolvable
          console.log(`Deleted file: ${attachment.path}`);
        } catch (fileError) {
          console.error(`Error deleting file ${attachment.path}:`, fileError);
        }
      }
    }

    await Help.findByIdAndDelete(req.params.id);
    res.status(200).json({ message: 'Help item deleted successfully' });
  } catch (error) {
    console.error('Error deleting help item:', error);
    res.status(500).send('Error deleting help item');
  }
};

// Add a response to a help request
exports.addResponse = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Create response object
    const response = {
      userId: req.user.id,
      content: req.body.content,
      attachments: req.body.attachments || [],
      createdAt: Date.now()
    };
    
    // Add response to the help item
    helpItem.responses.push(response);
    
    // Update status to in-progress if it's the first response
    if (helpItem.status === 'open' && helpItem.responses.length === 1) {
      helpItem.status = 'in-progress';
    }
    
    await helpItem.save();
    
    // Notify help requester
    try {
      await axios.post('http://localhost:3004/api/notifications', {
        userId: helpItem.userId,
        type: 'help_response',
        message: `You received a response to your help request: ${helpItem.subject}`,
        linkToResource: `/help/${helpItem._id}`
      });
    } catch (err) {
      console.error('Error sending notification:', err);
    }
    
    res.status(200).json(helpItem);
  } catch (error) {
    console.error('Error adding response:', error);
    res.status(500).send('Error adding response');
  }
};

// Update the status of a help request
exports.updateStatus = async (req, res) => {
  try {
    const { status } = req.body;
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Verify ownership or helper status
    const isOwner = helpItem.userId === req.user.id;
    const isHelper = helpItem.assignedHelpers.includes(req.user.id);
    
    if (!isOwner && !isHelper && req.user.role !== 'admin') {
      return res.status(403).send('Unauthorized to update status');
    }
    
    // If we're marking it as resolved, award points to helpers
    if (status === 'resolved' && helpItem.status !== 'resolved') {
      for (const helperId of helpItem.assignedHelpers) {
        await awardPoints(helperId, helpItem.pointsAwarded, 'provided_help');
        
        // Notify helper about points
        try {
          await axios.post('http://localhost:3004/api/notifications', {
            userId: helperId,
            type: 'points_awarded',
            message: `You earned ${helpItem.pointsAwarded} points for helping with: ${helpItem.subject}`,
            linkToResource: `/help/${helpItem._id}`
          });
        } catch (err) {
          console.error('Error sending notification:', err);
        }
      }
    }
    
    // Update status
    helpItem.status = status;
    await helpItem.save();
    
    res.status(200).json(helpItem);
  } catch (error) {
    console.error('Error updating status:', error);
    res.status(500).send('Error updating status');
  }
};

// Assign a helper to a request
exports.assignHelper = async (req, res) => {
  try {
    const { helperId } = req.body;
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Only allow request owner to assign helpers
    if (helpItem.userId !== req.user.id && req.user.role !== 'admin') {
      return res.status(403).send('Unauthorized to assign helpers');
    }
    
    // Check if helper is already assigned
    if (helpItem.assignedHelpers.includes(helperId)) {
      return res.status(400).send('Helper already assigned');
    }
    
    // Add helper to assigned helpers
    helpItem.assignedHelpers.push(helperId);
    
    // Update status to in-progress if it's open
    if (helpItem.status === 'open') {
      helpItem.status = 'in-progress';
    }
    
    await helpItem.save();
    
    // Notify assigned helper
    try {
      await axios.post('http://localhost:3004/api/notifications', {
        userId: helperId,
        type: 'assigned_to_help',
        message: `You've been assigned to help with: ${helpItem.subject}`,
        linkToResource: `/help/${helpItem._id}`
      });
    } catch (err) {
      console.error('Error sending notification:', err);
    }
    
    res.status(200).json(helpItem);
  } catch (error) {
    console.error('Error assigning helper:', error);
    res.status(500).send('Error assigning helper');
  }
};

// Schedule a meeting for a help request
exports.scheduleMeeting = async (req, res) => {
  try {
    const { meetingUrl, meetingScheduled } = req.body;
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Only allow request owner or assigned helpers to schedule meetings
    const isOwner = helpItem.userId === req.user.id;
    const isHelper = helpItem.assignedHelpers.includes(req.user.id);
    
    if (!isOwner && !isHelper && req.user.role !== 'admin') {
      return res.status(403).send('Unauthorized to schedule meetings');
    }
    
    // Update meeting details
    helpItem.meetingUrl = meetingUrl;
    helpItem.meetingScheduled = meetingScheduled;
    await helpItem.save();
    
    // Notify all participants
    const participantIds = [helpItem.userId, ...helpItem.assignedHelpers];
    
    for (const participantId of participantIds) {
      if (participantId !== req.user.id) {
        try {
          await axios.post('http://localhost:3004/api/notifications', {
            userId: participantId,
            type: 'meeting_scheduled',
            message: `A meeting has been scheduled for help request: ${helpItem.subject}`,
            linkToResource: `/help/${helpItem._id}`
          });
        } catch (err) {
          console.error('Error sending notification:', err);
        }
      }
    }
    
    res.status(200).json(helpItem);
  } catch (error) {
    console.error('Error scheduling meeting:', error);
    res.status(500).send('Error scheduling meeting');
  }
};

// Rate a help response
exports.rateResponse = async (req, res) => {
  try {
    const { rating, helpful } = req.body;
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Only allow request owner to rate responses
    if (helpItem.userId !== req.user.id) {
      return res.status(403).send('Unauthorized to rate responses');
    }
    
    // Find the response
    const responseIndex = helpItem.responses.findIndex(
      response => response._id.toString() === req.params.responseId
    );
    
    if (responseIndex === -1) {
      return res.status(404).send('Response not found');
    }
    
    // Update rating and helpful status
    helpItem.responses[responseIndex].rating = rating;
    helpItem.responses[responseIndex].helpful = helpful;
    
    await helpItem.save();
    
    // Update user's help rating in user service
    const response = helpItem.responses[responseIndex];
    
    try {
      await axios.post(`http://localhost:3000/api/users/${response.userId}/update-help-rating`, {
        rating,
        helpful
      });
    } catch (err) {
      console.error('Error updating user help rating:', err);
    }
    
    // Award bonus points for highly rated responses
    if (rating >= 4) {
      const bonusPoints = Math.round(helpItem.pointsAwarded * 0.2); // 20% bonus
      await awardPoints(response.userId, bonusPoints, 'high_quality_help');
      
      // Notify helper about bonus points
      try {
        await axios.post('http://localhost:3004/api/notifications', {
          userId: response.userId,
          type: 'bonus_points',
          message: `You earned ${bonusPoints} bonus points for your high-quality help!`,
          linkToResource: `/help/${helpItem._id}`
        });
      } catch (err) {
        console.error('Error sending notification:', err);
      }
    }
    
    res.status(200).json(helpItem);
  } catch (error) {
    console.error('Error rating response:', error);
    res.status(500).send('Error rating response');
  }
};

// Upload a file attachment
exports.uploadAttachment = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Only allow owner or assigned helpers to add attachments
    const isOwner = helpItem.userId === req.user.id;
    const isHelper = helpItem.assignedHelpers.includes(req.user.id);
    
    if (!isOwner && !isHelper) {
      return res.status(403).send('Unauthorized to add attachments');
    }
    
    // In a real implementation, you'd upload the file to a storage service
    // and get a URL back. Here we'll just simulate that.
    const attachment = {
      fileName: req.body.fileName,
      fileType: req.body.fileType,
      fileUrl: req.body.fileUrl || `https://example.com/files/${Date.now()}-${req.body.fileName}`,
      uploadedAt: Date.now()
    };
    
    // Add attachment to help item
    helpItem.attachments.push(attachment);
    await helpItem.save();
    
    res.status(200).json({
      message: 'Attachment added successfully',
      attachment
    });
  } catch (error) {
    console.error('Error adding attachment:', error);
    res.status(500).send('Error adding attachment');
  }
};
