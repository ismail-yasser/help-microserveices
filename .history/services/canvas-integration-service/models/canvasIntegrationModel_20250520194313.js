const mongoose = require('mongoose');

const courseSchema = new mongoose.Schema({
  canvasCourseId: String,
  courseName: String,
  courseCode: String,
  term: String,
  startDate: Date,
  endDate: Date,
  lastSynced: Date
});

const assignmentSchema = new mongoose.Schema({
  canvasAssignmentId: String,
  title: String,
  description: String,
  dueDate: Date,
  pointsPossible: Number,
  submissionType: String,
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'CanvasCourse'
  }
});

const enrollmentSchema = new mongoose.Schema({
  canvasEnrollmentId: String,
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'CanvasCourse'
  },
  role: {
    type: String,
    enum: ['student', 'teacher', 'ta', 'designer', 'observer'],
    default: 'student'
  },
  lastActivity: Date
});

const announcementSchema = new mongoose.Schema({
  canvasAnnouncementId: String,
  title: String,
  message: String,
  postedAt: Date,
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'CanvasCourse'
  }
});

// Course model
const CanvasCourse = mongoose.model('CanvasCourse', courseSchema);

// Assignment model
const CanvasAssignment = mongoose.model('CanvasAssignment', assignmentSchema);

// Enrollment model
const CanvasEnrollment = mongoose.model('CanvasEnrollment', enrollmentSchema);

// Announcement model
const CanvasAnnouncement = mongoose.model('CanvasAnnouncement', announcementSchema);

module.exports = {
  CanvasCourse,
  CanvasAssignment,
  CanvasEnrollment,
  CanvasAnnouncement
};
