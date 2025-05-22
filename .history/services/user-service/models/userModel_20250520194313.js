const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  name: String,
  email: String,
  password: String,
  // Add Canvas integration fields
  canvasId: String, 
  role: {
    type: String,
    enum: ['student', 'faculty', 'alumni', 'partner'],
    default: 'student'
  },
  department: String,
  expertise: [String], // Areas where this user can provide help
  helpRating: {
    type: Number,
    default: 0
  },
  helpCount: {
    type: Number,
    default: 0
  },
  enrolledCourses: [String],
  availableForHelp: {
    type: Boolean,
    default: false
  }
});

module.exports = mongoose.model('User', userSchema);
