const mongoose = require('mongoose');

const studyGroupSchema = new mongoose.Schema({
  name: String,
  description: String,
  members: [String],
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

module.exports = mongoose.model('StudyGroup', studyGroupSchema);
