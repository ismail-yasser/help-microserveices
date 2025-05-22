const Help = require('../models/helpModel');

// Save a new help request
exports.createHelpRequest = async (req, res) => {
  try {
    const helpRequest = new Help({ ...req.body, type: 'request' });
    await helpRequest.save();
    res.status(201).send('Help request created successfully');
  } catch (error) {
    res.status(500).send('Error creating help request');
  }
};

// Save a new help offer
exports.createHelpOffer = async (req, res) => {
  try {
    const helpOffer = new Help({ ...req.body, type: 'offer' });
    await helpOffer.save();
    res.status(201).send('Help offer created successfully');
  } catch (error) {
    res.status(500).send('Error creating help offer');
  }
};

// Find help matches
exports.findHelpMatch = async (req, res) => {
  try {
    const matches = await Help.find({ type: 'offer', subject: req.query.subject });
    res.status(200).json(matches);
  } catch (error) {
    res.status(500).send('Error finding help matches');
  }
};
