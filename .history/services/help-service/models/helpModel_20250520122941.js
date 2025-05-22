const mongoose = require('mongoose');

const helpSchema = new mongoose.Schema({
  type: String, // 'request' or 'offer'
  subject: String,
  description: String,
  userId: String,
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('Help', helpSchema);
