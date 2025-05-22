const mongoose = require('mongoose');

const badgeSchema = new mongoose.Schema({
  name: String,
  description: String,
  iconUrl: String,
  criteria: String, // What the user did to earn this
  dateEarned: {
    type: Date,
    default: Date.now
  },
  category: {
    type: String,
    enum: ['helper', 'contributor', 'collaborator', 'expert', 'learner'],
    default: 'contributor'
  }
});

const achievementSchema = new mongoose.Schema({
  name: String,
  description: String,
  completedDate: Date,
  progress: {
    type: Number,
    min: 0,
    max: 100,
    default: 0
  }
});

const gamificationSchema = new mongoose.Schema({
  userId: String,
  points: {
    type: Number,
    default: 0
  },
  level: {
    type: Number,
    default: 1
  },
  badges: [badgeSchema],
  achievements: [achievementSchema],
  helpScore: {
    type: Number,
    default: 0
  },
  contributionScore: {
    type: Number,
    default: 0
  },
  collaborationScore: {
    type: Number,
    default: 0
  },
  streakDays: {
    type: Number,
    default: 0
  },
  lastActive: Date,
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Gamification', gamificationSchema);
