const mongoose = require('mongoose');

const commentSchema = new mongoose.Schema({
  userId: String,
  content: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

const resourceSchema = new mongoose.Schema({
  title: String,
  description: String,
  url: String,
  fileType: {
    type: String,
    enum: ['document', 'image', 'video', 'link', 'audio', 'code', 'other'],
    default: 'document'
  },
  category: String,
  courseId: String, // Canvas course ID for integration
  createdBy: String, // User ID
  difficultyLevel: {
    type: String,
    enum: ['beginner', 'intermediate', 'advanced'],
    default: 'intermediate'
  },
  tags: [String], // For searchability
  upvotes: {
    type: Number,
    default: 0
  },
  usefulCount: {
    type: Number,
    default: 0
  },
  comments: [commentSchema],
  verifiedBy: [String], // IDs of users who verified this content
  relatedResources: [String], // IDs of related resources
  createdAt: {
    type: Date,
    default: Date.now,
  },
});

// Add index for search
resourceSchema.index({ title: 'text', description: 'text', tags: 'text' });

module.exports = mongoose.model('Resource', resourceSchema);
