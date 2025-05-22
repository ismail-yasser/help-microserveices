const mongoose = require('mongoose');

const partnershipSchema = new mongoose.Schema({
  name: String,
  organizationType: {
    type: String,
    enum: ['industry', 'academic', 'alumni', 'student-group'],
    default: 'industry'
  },
  description: String,
  contactEmail: String,
  contactName: String,
  website: String,
  logo: String,
  expertiseAreas: [String],
  availableOpportunities: [{
    title: String,
    description: String,
    type: {
      type: String,
      enum: ['mentorship', 'project', 'internship', 'guest-lecture', 'workshop'],
      default: 'mentorship'
    },
    startDate: Date,
    endDate: Date,
    capacity: Number,
    requirements: String,
    enrolledStudents: [String] // User IDs
  }],
  members: [String], // User IDs of organization representatives
  activeProjects: [{
    title: String,
    description: String,
    status: {
      type: String,
      enum: ['planning', 'in-progress', 'completed'],
      default: 'planning'
    },
    participants: [String], // User IDs
    resources: [String], // Resource IDs
    startDate: Date,
    endDate: Date
  }],
  rating: {
    type: Number,
    min: 0,
    max: 5,
    default: 0
  },
  feedbackCount: {
    type: Number,
    default: 0
  },
  verified: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Partnership', partnershipSchema);
