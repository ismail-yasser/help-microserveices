const Help = require('../models/helpModel');

// Save a new help request to the database
exports.createHelpRequest = async (req, res) => {
  try {
    const { subject, description, userId } = req.body;
    const newRequest = new Help({ type: 'request', subject, description, userId });
    await newRequest.save();
    res.status(201).json({ message: 'Help request created successfully', request: newRequest });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create help request' });
  }
};

// Save a new help offer to the database
exports.createHelpOffer = async (req, res) => {
  try {
    const { subject, description, userId } = req.body;
    const newOffer = new Help({ type: 'offer', subject, description, userId });
    await newOffer.save();
    res.status(201).json({ message: 'Help offer created successfully', offer: newOffer });
  } catch (error) {
    res.status(500).json({ error: 'Failed to create help offer' });
  }
};

// Find matches for help requests and offers
exports.findHelpMatch = async (req, res) => {
  try {
    const { subject } = req.query;
    if (!subject) {
      return res.status(400).json({ error: 'Subject is required to find matches' });
    }
    const matches = await Help.find({ subject });
    res.status(200).json(matches);
  } catch (error) {
    res.status(500).json({ error: 'Failed to find help matches' });
  }
};
