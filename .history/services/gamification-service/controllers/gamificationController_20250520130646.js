const Gamification = require('../models/gamificationModel');

// Log a contribution to the database
exports.logContribution = async (req, res) => {
  try {
    const { userId, points } = req.body;
    const contribution = await Gamification.findOneAndUpdate(
      { userId },
      { $inc: { points } },
      { new: true, upsert: true }
    );
    res.status(201).json({ message: 'Contribution logged successfully', contribution });
  } catch (error) {
    res.status(500).json({ error: 'Failed to log contribution' });
  }
};

// Fetch the leaderboard from the database
exports.getLeaderboard = async (req, res) => {
  try {
    const leaderboard = await Gamification.find().sort({ points: -1 }).limit(10);
    res.status(200).json(leaderboard);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch leaderboard' });
  }
};
