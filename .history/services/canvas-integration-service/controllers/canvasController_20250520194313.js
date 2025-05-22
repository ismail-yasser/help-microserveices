const { 
  CanvasCourse, 
  CanvasAssignment, 
  CanvasEnrollment,
  CanvasAnnouncement 
} = require('../models/canvasIntegrationModel');
const axios = require('axios');

// Canvas API configuration
const canvasBaseUrl = process.env.CANVAS_API_URL;
const canvasApiToken = process.env.CANVAS_API_TOKEN;

const canvasApi = axios.create({
  baseURL: canvasBaseUrl,
  headers: {
    'Authorization': `Bearer ${canvasApiToken}`
  }
});

// Sync courses from Canvas
exports.syncCourses = async (req, res) => {
  try {
    // Get courses from Canvas API
    const response = await canvasApi.get('/courses');
    const canvasCourses = response.data;
    
    // Update or create courses in our database
    for (const course of canvasCourses) {
      await CanvasCourse.findOneAndUpdate(
        { canvasCourseId: course.id },
        {
          canvasCourseId: course.id,
          courseName: course.name,
          courseCode: course.course_code,
          term: course.term?.name,
          startDate: course.start_at,
          endDate: course.end_at,
          lastSynced: new Date()
        },
        { upsert: true, new: true }
      );
    }
    
    res.status(200).json({ message: 'Courses synced successfully', count: canvasCourses.length });
  } catch (error) {
    console.error('Error syncing courses:', error);
    res.status(500).json({ message: 'Error syncing courses', error: error.message });
  }
};

// Sync assignments for a specific course
exports.syncAssignments = async (req, res) => {
  try {
    const { courseId } = req.params;
    
    // Get course from our database
    const course = await CanvasCourse.findById(courseId);
    
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }
    
    // Get assignments from Canvas API
    const response = await canvasApi.get(`/courses/${course.canvasCourseId}/assignments`);
    const canvasAssignments = response.data;
    
    // Update or create assignments in our database
    for (const assignment of canvasAssignments) {
      await CanvasAssignment.findOneAndUpdate(
        { canvasAssignmentId: assignment.id },
        {
          canvasAssignmentId: assignment.id,
          title: assignment.name,
          description: assignment.description,
          dueDate: assignment.due_at,
          pointsPossible: assignment.points_possible,
          submissionType: assignment.submission_types[0],
          courseId: course._id
        },
        { upsert: true, new: true }
      );
    }
    
    res.status(200).json({ 
      message: 'Assignments synced successfully', 
      count: canvasAssignments.length 
    });
  } catch (error) {
    console.error('Error syncing assignments:', error);
    res.status(500).json({ message: 'Error syncing assignments', error: error.message });
  }
};

// Get all courses
exports.getCourses = async (req, res) => {
  try {
    const courses = await CanvasCourse.find();
    res.status(200).json(courses);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching courses', error: error.message });
  }
};

// Get a single course with assignments
exports.getCourseWithAssignments = async (req, res) => {
  try {
    const course = await CanvasCourse.findById(req.params.courseId);
    
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }
    
    const assignments = await CanvasAssignment.find({ courseId: course._id });
    
    res.status(200).json({
      course,
      assignments
    });
  } catch (error) {
    res.status(500).json({ message: 'Error fetching course', error: error.message });
  }
};

// Sync user enrollments
exports.syncEnrollments = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Get user's Canvas ID from our user service
    // This would typically involve a service-to-service call
    const userResponse = await axios.get(`${process.env.USER_SERVICE_URL}/api/users/${userId}`);
    const user = userResponse.data;
    
    if (!user.canvasId) {
      return res.status(400).json({ message: 'User does not have a Canvas ID' });
    }
    
    // Get enrollments from Canvas API
    const response = await canvasApi.get(`/users/${user.canvasId}/enrollments`);
    const canvasEnrollments = response.data;
    
    const enrollments = [];
    
    // Update or create enrollments in our database
    for (const enrollment of canvasEnrollments) {
      // Find the course in our database
      const course = await CanvasCourse.findOne({ 
        canvasCourseId: enrollment.course_id 
      });
      
      if (course) {
        const updatedEnrollment = await CanvasEnrollment.findOneAndUpdate(
          { canvasEnrollmentId: enrollment.id },
          {
            canvasEnrollmentId: enrollment.id,
            userId,
            courseId: course._id,
            role: enrollment.type.toLowerCase(),
            lastActivity: new Date()
          },
          { upsert: true, new: true }
        );
        
        enrollments.push(updatedEnrollment);
      }
    }
    
    res.status(200).json({ 
      message: 'Enrollments synced successfully', 
      count: enrollments.length,
      enrollments 
    });
  } catch (error) {
    console.error('Error syncing enrollments:', error);
    res.status(500).json({ message: 'Error syncing enrollments', error: error.message });
  }
};

// Sync announcements for a course
exports.syncAnnouncements = async (req, res) => {
  try {
    const { courseId } = req.params;
    
    // Get course from our database
    const course = await CanvasCourse.findById(courseId);
    
    if (!course) {
      return res.status(404).json({ message: 'Course not found' });
    }
    
    // Get announcements from Canvas API
    const response = await canvasApi.get(
      `/courses/${course.canvasCourseId}/discussion_topics?only_announcements=true`
    );
    const canvasAnnouncements = response.data;
    
    // Update or create announcements in our database
    for (const announcement of canvasAnnouncements) {
      await CanvasAnnouncement.findOneAndUpdate(
        { canvasAnnouncementId: announcement.id },
        {
          canvasAnnouncementId: announcement.id,
          title: announcement.title,
          message: announcement.message,
          postedAt: announcement.posted_at,
          courseId: course._id
        },
        { upsert: true, new: true }
      );
    }
    
    res.status(200).json({ 
      message: 'Announcements synced successfully', 
      count: canvasAnnouncements.length 
    });
  } catch (error) {
    console.error('Error syncing announcements:', error);
    res.status(500).json({ message: 'Error syncing announcements', error: error.message });
  }
};

// Get upcoming assignments for a user
exports.getUpcomingAssignments = async (req, res) => {
  try {
    const { userId } = req.params;
    
    // Get user's enrollments
    const enrollments = await CanvasEnrollment.find({ userId });
    
    // Get course IDs from enrollments
    const courseIds = enrollments.map(enrollment => enrollment.courseId);
    
    // Get assignments for these courses with due dates in the future
    const assignments = await CanvasAssignment.find({
      courseId: { $in: courseIds },
      dueDate: { $gte: new Date() }
    }).populate('courseId');
    
    res.status(200).json(assignments);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching upcoming assignments', error: error.message });
  }
};
