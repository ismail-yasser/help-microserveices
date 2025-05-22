const Help = require('../models/helpModel');
const axios = require('axios');

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
    await axios.post(`http://localhost:3004/api/gamification/${userId}/points`, {
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
    // Create help request with enhanced details
    const helpRequest = new Help({ 
      ...req.body, 
      type: 'request',
      // Calculate suggested point reward based on urgency and estimated time
      pointsAwarded: calculatePoints(req.body.urgency, req.body.estimatedTimeInMinutes)
    });
    
    // Find potential helpers based on required skills
    const suggestedHelpers = await findPotentialHelpers(req.body.requiredSkills, req.body.tags);
    helpRequest.suggestedHelpers = suggestedHelpers.map(helper => helper._id);
    
    await helpRequest.save();
    
    // Notify suggested helpers (assuming notification service exists)
    suggestedHelpers.forEach(async (helper) => {
      try {
        await axios.post('http://localhost:3002/api/notifications', {
          userId: helper._id,
          type: 'help_request_match',
          message: `Your skills match a new help request: ${req.body.subject}`,
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
    res.status(500).send('Error creating help request');
  }
};

// Save a new help offer
exports.createHelpOffer = async (req, res) => {
  try {
    const helpOffer = new Help({ ...req.body, type: 'offer' });
    await helpOffer.save();
    
    // Find matching help requests
    const matchingRequests = await Help.find({ 
      type: 'request', 
      status: 'open',
      $or: [
        { tags: { $in: req.body.expertise } },
        { requiredSkills: { $in: req.body.expertise } }
      ]
    });
    
    // Notify users with matching requests
    matchingRequests.forEach(async (request) => {
      try {
        await axios.post('http://localhost:3002/api/notifications', {
          userId: request.userId,
          type: 'help_offer_match',
          message: `Someone offered help matching your request: ${request.subject}`,
          linkToResource: `/help/${request._id}`
        });
      } catch (err) {
        console.error('Error sending notification:', err);
      }
    });
    
    res.status(201).json({
      message: 'Help offer created successfully',
      helpOffer,
      matchingRequests: matchingRequests.length
    });
  } catch (error) {
    console.error('Error creating help offer:', error);
    res.status(500).send('Error creating help offer');
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
