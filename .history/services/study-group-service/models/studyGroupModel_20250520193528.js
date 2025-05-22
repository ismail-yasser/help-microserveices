const mongoose = require('mongoose');

const meetingSchema = new mongoose.Schema({
  title: String,
  date: Date,
  duration: Number, // in minutes
  virtualMeetingUrl: String,
  physicalLocation: String,
  agenda: String,
  attendees: [String]
});

const messageSchema = new mongoose.Schema({
  userId: String,
  content: String,
  attachments: [String],
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const studyGroupSchema = new mongoose.Schema({
  name: String,
  description: String,
  courseId: String, // Canvas course ID if applicable
  privacy: {
    type: String,
    enum: ['public', 'private', 'invite-only'],
    default: 'public'
  },
  members: [String],
  admins: [String],
  capacity: {
    type: Number,
    default: 10
  },
  tags: [String],
  relatedResources: [String], // IDs of resources shared in this group
  meetings: [meetingSchema],
  messages: [messageSchema],
  active: {
    type: Boolean,
    default: true
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Add index for search
studyGroupSchema.index({ name: 'text', description: 'text', tags: 'text' });

module.exports = mongoose.model('StudyGroup', studyGroupSchema);
