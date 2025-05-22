const mongoose = require('mongoose');

const responseSchema = new mongoose.Schema({
  userId: String,
  content: String,
  attachments: [String],
  helpful: {
    type: Boolean,
    default: false
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const helpSchema = new mongoose.Schema({
  type: String, // 'request' or 'offer'
  subject: String,
  description: String,
  userId: String,
  courseId: String, // Canvas course ID if applicable
  urgency: {
    type: String,
    enum: ['low', 'medium', 'high'],
    default: 'medium'
  },
  status: {
    type: String,
    enum: ['open', 'in-progress', 'resolved', 'closed'],
    default: 'open'
  },
  tags: [String],
  responses: [responseSchema],
  assignedHelpers: [String], // IDs of users helping with this request
  meetingUrl: String, // For virtual help sessions
  meetingScheduled: Date,
  attachments: [String], // URLs to attached resources
  visibility: {
    type: String,
    enum: ['public', 'course', 'private'],
    default: 'public'
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Add index for search
helpSchema.index({ subject: 'text', description: 'text', tags: 'text' });

module.exports = mongoose.model('Help', helpSchema);
