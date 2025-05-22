const {
  Course,
  Assignment,
  Enrollment,
  Announcement,
  Submission
} = require('../models/courseModel');

// Course Controllers
exports.getAllCourses = async (req, res) => {
  try {
    const courses = await Course.find()
      .populate('instructorId', 'name email');
    res.status(200).json(courses);
  } catch (error) {
    console.error('Error fetching courses:', error);
    res.status(500).json({ error: 'Error fetching courses' });
  }
};

exports.getCourseById = async (req, res) => {
  try {
    const course = await Course.findById(req.params.id)
      .populate('instructorId', 'name email')
      .populate('enrolledStudents', 'name email')
      .populate('assistants', 'name email');
    
    if (!course) {
      return res.status(404).json({ error: 'Course not found' });
    }
    
    res.status(200).json(course);
  } catch (error) {
    console.error('Error fetching course:', error);
    res.status(500).json({ error: 'Error fetching course' });
  }
};

exports.createCourse = async (req, res) => {
  try {
    const course = new Course({
      ...req.body,
      instructorId: req.user.id // From auth middleware
    });
    
    const savedCourse = await course.save();
    
    // Create enrollment for instructor
    await Enrollment.create({
      userId: req.user.id,
      courseId: savedCourse._id,
      role: 'teacher'
    });
    
    res.status(201).json(savedCourse);
  } catch (error) {
    console.error('Error creating course:', error);
    res.status(500).json({ error: 'Error creating course' });
  }
};

exports.updateCourse = async (req, res) => {
  try {
    // Only instructors can update their courses
    const course = await Course.findOne({
      _id: req.params.id,
      instructorId: req.user.id
    });
    
    if (!course) {
      return res.status(404).json({ error: 'Course not found or you do not have permission' });
    }
    
    const updatedCourse = await Course.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );
    
    res.status(200).json(updatedCourse);
  } catch (error) {
    console.error('Error updating course:', error);
    res.status(500).json({ error: 'Error updating course' });
  }
};

exports.deleteCourse = async (req, res) => {
  try {
    // Only instructors can delete their courses
    const course = await Course.findOne({
      _id: req.params.id,
      instructorId: req.user.id
    });
    
    if (!course) {
      return res.status(404).json({ error: 'Course not found or you do not have permission' });
    }
    
    await Course.findByIdAndDelete(req.params.id);
    
    // Delete related data
    await Assignment.deleteMany({ courseId: req.params.id });
    await Announcement.deleteMany({ courseId: req.params.id });
    await Enrollment.deleteMany({ courseId: req.params.id });
    
    res.status(200).json({ message: 'Course and related data deleted successfully' });
  } catch (error) {
    console.error('Error deleting course:', error);
    res.status(500).json({ error: 'Error deleting course' });
  }
};

// Assignment Controllers
exports.getCourseAssignments = async (req, res) => {
  try {
    const assignments = await Assignment.find({ courseId: req.params.courseId });
    res.status(200).json(assignments);
  } catch (error) {
    console.error('Error fetching assignments:', error);
    res.status(500).json({ error: 'Error fetching assignments' });
  }
};

exports.createAssignment = async (req, res) => {
  try {
    // Check if user is instructor or TA for this course
    const enrollment = await Enrollment.findOne({
      courseId: req.params.courseId,
      userId: req.user.id,
      role: { $in: ['teacher', 'teaching_assistant'] }
    });
    
    if (!enrollment) {
      return res.status(403).json({ error: 'You do not have permission to create assignments' });
    }
    
    const assignment = new Assignment({
      ...req.body,
      courseId: req.params.courseId,
      createdBy: req.user.id
    });
    
    const savedAssignment = await assignment.save();
    res.status(201).json(savedAssignment);
  } catch (error) {
    console.error('Error creating assignment:', error);
    res.status(500).json({ error: 'Error creating assignment' });
  }
};

// Enrollment Controllers
exports.enrollStudent = async (req, res) => {
  try {
    // Check if the user is already enrolled
    const existingEnrollment = await Enrollment.findOne({
      courseId: req.params.courseId,
      userId: req.body.userId
    });
    
    if (existingEnrollment) {
      return res.status(400).json({ error: 'User is already enrolled in this course' });
    }
    
    // Create new enrollment
    const enrollment = new Enrollment({
      courseId: req.params.courseId,
      userId: req.body.userId,
      role: req.body.role || 'student'
    });
    
    const savedEnrollment = await enrollment.save();
    
    // Add student to the course's enrolledStudents array
    if (enrollment.role === 'student') {
      await Course.findByIdAndUpdate(
        req.params.courseId,
        { $addToSet: { enrolledStudents: req.body.userId } }
      );
    } else if (enrollment.role === 'teaching_assistant') {
      await Course.findByIdAndUpdate(
        req.params.courseId,
        { $addToSet: { assistants: req.body.userId } }
      );
    }
    
    res.status(201).json(savedEnrollment);
  } catch (error) {
    console.error('Error enrolling student:', error);
    res.status(500).json({ error: 'Error enrolling student' });
  }
};

// Announcement Controllers
exports.getCourseAnnouncements = async (req, res) => {
  try {
    const announcements = await Announcement.find({ 
      courseId: req.params.courseId,
      isDeleted: false
    })
      .populate('authorId', 'name');
    res.status(200).json(announcements);
  } catch (error) {
    console.error('Error fetching announcements:', error);
    res.status(500).json({ error: 'Error fetching announcements' });
  }
};

exports.createAnnouncement = async (req, res) => {
  try {
    // Check if user is instructor or TA for this course
    const enrollment = await Enrollment.findOne({
      courseId: req.params.courseId,
      userId: req.user.id,
      role: { $in: ['teacher', 'teaching_assistant'] }
    });
    
    if (!enrollment) {
      return res.status(403).json({ error: 'You do not have permission to create announcements' });
    }
    
    const announcement = new Announcement({
      ...req.body,
      courseId: req.params.courseId,
      authorId: req.user.id
    });
    
    const savedAnnouncement = await announcement.save();
    res.status(201).json(savedAnnouncement);
  } catch (error) {
    console.error('Error creating announcement:', error);
    res.status(500).json({ error: 'Error creating announcement' });
  }
};

exports.getUserCourses = async (req, res) => {
  try {
    const enrollments = await Enrollment.find({
      userId: req.params.userId,
      isActive: true
    });
    
    const courseIds = enrollments.map(enrollment => enrollment.courseId);
    
    const courses = await Course.find({
      _id: { $in: courseIds },
      isActive: true
    }).populate('instructorId', 'name email');
    
    res.status(200).json(courses);
  } catch (error) {
    console.error('Error fetching user courses:', error);
    res.status(500).json({ error: 'Error fetching user courses' });
  }
};

exports.getUpcomingAssignments = async (req, res) => {
  try {
    // Get user's course enrollments
    const enrollments = await Enrollment.find({
      userId: req.params.userId,
      isActive: true
    });
    
    const courseIds = enrollments.map(enrollment => enrollment.courseId);
    
    // Find assignments for these courses with due dates in the future
    const upcomingAssignments = await Assignment.find({
      courseId: { $in: courseIds },
      dueDate: { $gte: new Date() },
      published: true
    }).populate('courseId', 'courseName');
    
    res.status(200).json(upcomingAssignments);
  } catch (error) {
    console.error('Error fetching upcoming assignments:', error);
    res.status(500).json({ error: 'Error fetching upcoming assignments' });
  }
};
