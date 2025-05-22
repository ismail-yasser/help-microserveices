const mongoose = require('mongoose');

const canvasAuthSchema = new mongoose.Schema({
  userId: {
    type: String,
    required: true,
    unique: true
  },
  accessToken: {
    type: String,
    required: true
  },
  refreshToken: {
    type: String
  },
  tokenExpiry: {
    type: Date
  },
  canvasUserId: {
    type: String
  },
  canvasProfileUrl: String,
  canvasLoginId: String,
  canvasEmail: String,
  lastSynced: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  }
});

// Method to check if token needs refresh
canvasAuthSchema.methods.needsRefresh = function() {
  // If no expiry is set, assume token is valid
  if (!this.tokenExpiry) return false;
  
  // Add a buffer of 5 minutes (300000 ms)
  return new Date(this.tokenExpiry.getTime() - 300000) <= new Date();
};

module.exports = mongoose.model('CanvasAuth', canvasAuthSchema);
