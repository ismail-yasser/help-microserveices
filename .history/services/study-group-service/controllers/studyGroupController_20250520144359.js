const axios = require('axios');
const StudyGroup = require('../models/studyGroupModel');

// Create a new study group
exports.createStudyGroup = async (req, res) => {
  try {
    const group = new StudyGroup(req.body);
    await group.save();
    res.status(201).send('Study group created successfully');
  } catch (error) {
    res.status(500).send('Error creating study group');
  }
};

// Fetch all study groups
exports.getStudyGroups = async (req, res) => {
  try {
    const groups = await StudyGroup.find();
    res.status(200).json(groups);
  } catch (error) {
    res.status(500).send('Error fetching study groups');
  }
};

// Notify notification-service when a user joins a study group
async function notifyUserJoinedGroup(userId, groupName) {
  try {
    await axios.post('http://localhost:3004/api/notifications', {
      userId,
      message: `You have successfully joined the study group: ${groupName}`,
    });
  } catch (error) {
    console.error('Error notifying notification-service:', error.message);
  }
}

// Add a member to a study group
exports.joinStudyGroup = async (req, res) => {
  try {
    // Validate request body
    if (!req.body.userId) {
      return res.status(400).send('userId is required');
    }

    const group = await StudyGroup.findById(req.params.id);
    if (!group) {
      return res.status(404).send('Study group not found');
    }

    group.members.push(req.body.userId);
    await group.save();

    // Notify the user via notification-service
    await notifyUserJoinedGroup(req.body.userId, group.name);

    res.status(200).send('Joined study group successfully');
  } catch (error) {
    console.error('Error joining study group:', error);
    res.status(500).send('Error joining study group');
  }
};
