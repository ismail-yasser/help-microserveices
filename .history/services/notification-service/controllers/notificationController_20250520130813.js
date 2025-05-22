const Notification = require('../models/notificationModel');

// Create a new notification
exports.createNotification = async (req, res) => {
  try {
    const notification = new Notification(req.body);
    await notification.save();
    res.status(201).send('Notification created successfully');
  } catch (error) {
    res.status(500).send('Error creating notification');
  }
};

// Fetch notifications for a user
exports.getNotifications = async (req, res) => {
  try {
    const notifications = await Notification.find({ userId: req.query.userId });
    res.status(200).json(notifications);
  } catch (error) {
    res.status(500).send('Error fetching notifications');
  }
};
