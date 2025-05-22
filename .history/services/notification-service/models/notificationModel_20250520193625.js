const mongoose = require('mongoose');

const notificationSchema = new mongoose.Schema({
  userId: String,
  message: String,
  type: {
    type: String,
    enum: ['help_request', 'study_group', 'resource', 'achievement', 'mention', 'system', 'canvas'],
    default: 'system'
  },
  sourceId: String, // ID of the object that generated this notification
  sourceType: String, // Type of object that generated this notification
  priority: {
    type: String,
    enum: ['low', 'normal', 'high', 'urgent'],
    default: 'normal'
  },
  read: {
    type: Boolean,
    default: false
  },
  clicked: {
    type: Boolean,
    default: false
  },
  actionUrl: String, // URL to direct user when they click the notification
  expiresAt: Date, // When this notification should be auto-removed
  createdAt: {
    type: Date,
    default: Date.now
  }
});

// Index for efficient querying
notificationSchema.index({ userId: 1, read: 1, type: 1 });

module.exports = mongoose.model('Notification', notificationSchema);
