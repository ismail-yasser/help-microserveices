const mongoose = require('mongoose');

const fileAttachmentSchema = new mongoose.Schema({
  fileName: String,
  fileType: {
    type: String,
    enum: ['document', 'image', 'video', 'code', 'pdf', 'presentation', 'other'],
    default: 'other'
  },
  fileUrl: String,
  uploadedAt: {
    type: Date,
    default: Date.now
  }
});

const responseSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  content: String,
  attachments: [fileAttachmentSchema],
  helpful: {
    type: Boolean,
    default: false
  },
  rating: {
    type: Number,
    min: 1,
    max: 5,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const offerSchema = new mongoose.Schema({
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  description: String,
  status: {
    type: String,
    enum: ['pending', 'accepted', 'rejected'],
    default: 'pending'
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
  userId: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  courseId: String, // Generic course ID
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
  requiredSkills: [String], // Skills needed to help with this request
  deadline: Date, // When help is needed by
  estimatedTimeInMinutes: {
    type: Number,
    default: 30
  },
  responses: [responseSchema],
  offers: [offerSchema], // Added offers array
  assignedHelpers: [String], // IDs of users helping with this request
  suggestedHelpers: [String], // IDs of users recommended by the system
  meetingUrl: String, // For virtual help sessions
  meetingScheduled: Date,
  attachments: [fileAttachmentSchema], // Structured file attachments
  visibility: {
    type: String,
    enum: ['public', 'course', 'private'],
    default: 'public'
  },
  pointsAwarded: {
    type: Number,
    default: 0
  },
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Add index for search
helpSchema.index({ subject: 'text', description: 'text', tags: 'text' });

module.exports = mongoose.model('Help', helpSchema);
