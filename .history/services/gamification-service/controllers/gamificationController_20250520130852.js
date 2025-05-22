const Gamification = require('../models/gamificationModel');

// Log a contribution
exports.logContribution = async (req, res) => {
  try {
    const log = new Gamification(req.body);
    await log.save();
    res.status(201).send('Contribution logged successfully');
  } catch (error) {
    res.status(500).send('Error logging contribution');
  }
};

// Fetch leaderboard
exports.getLeaderboard = async (req, res) => {
  try {
    const leaderboard = await Gamification.find().sort({ points: -1 }).limit(10);
    res.status(200).json(leaderboard);
  } catch (error) {
    res.status(500).send('Error fetching leaderboard');
  }
};
