const mongoose = require('mongoose');

const gamificationSchema = new mongoose.Schema({
  userId: String,
  points: Number,
  badges: [String],
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Gamification', gamificationSchema);
