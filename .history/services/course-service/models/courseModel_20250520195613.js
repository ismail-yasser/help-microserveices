const mongoose = require('mongoose');

// Course schema
const courseSchema = new mongoose.Schema({
  courseName: {
    type: String,
    required: true
  },
  courseCode: {
    type: String,
    required: true
  },
  description: String,
  department: String,
  term: String,
  year: Number,
  semester: {
    type: String,
    enum: ['Fall', 'Spring', 'Summer', 'Winter']
  },
  startDate: Date,
  endDate: Date,
  instructorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  enrolledStudents: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  assistants: [{
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }],
  syllabus: String,
  isActive: {
    type: Boolean,
    default: true
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  }
}, { timestamps: true });

// Assignment schema
const assignmentSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  description: String,
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  dueDate: Date,
  pointsPossible: Number,
  submissionType: {
    type: String,
    enum: ['online', 'file', 'text', 'url', 'media', 'none']
  },
  instructions: String,
  allowedFileTypes: [String],
  isGroupAssignment: {
    type: Boolean,
    default: false
  },
  visible: {
    type: Boolean,
    default: true
  },
  published: {
    type: Boolean,
    default: false
  },
  createdBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  }
}, { timestamps: true });

// Enrollment schema
const enrollmentSchema = new mongoose.Schema({
  userId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  role: {
    type: String,
    enum: ['student', 'teacher', 'teaching_assistant'],
    default: 'student'
  },
  enrollmentDate: {
    type: Date,
    default: Date.now
  },
  isActive: {
    type: Boolean,
    default: true
  }
}, { timestamps: true });

// Announcement schema
const announcementSchema = new mongoose.Schema({
  title: {
    type: String,
    required: true
  },
  content: {
    type: String,
    required: true
  },
  courseId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Course',
    required: true
  },
  authorId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  publishedDate: {
    type: Date,
    default: Date.now
  },
  attachment: String,
  isDeleted: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

// Submission schema
const submissionSchema = new mongoose.Schema({
  assignmentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'Assignment',
    required: true
  },
  studentId: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User',
    required: true
  },
  submissionDate: {
    type: Date,
    default: Date.now
  },
  content: String,
  fileUrl: String,
  comment: String,
  grade: Number,
  feedback: String,
  gradedBy: {
    type: mongoose.Schema.Types.ObjectId,
    ref: 'User'
  },
  gradedDate: Date,
  isLate: {
    type: Boolean,
    default: false
  }
}, { timestamps: true });

const Course = mongoose.model('Course', courseSchema);
const Assignment = mongoose.model('Assignment', assignmentSchema);
const Enrollment = mongoose.model('Enrollment', enrollmentSchema);
const Announcement = mongoose.model('Announcement', announcementSchema);
const Submission = mongoose.model('Submission', submissionSchema);

module.exports = {
  Course,
  Assignment,
  Enrollment,
  Announcement,
  Submission
};
