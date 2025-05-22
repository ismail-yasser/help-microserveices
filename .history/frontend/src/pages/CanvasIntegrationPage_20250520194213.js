import React, { useState, useEffect } from 'react';
import { 
  getAllCourses, 
  getCourseWithAssignments, 
  syncCourses,
  syncAssignments,
  syncAnnouncements,
  getUpcomingAssignments
} from '../services/canvasService';

const CanvasIntegrationPage = () => {
  const [courses, setCourses] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState(null);
  const [assignments, setAssignments] = useState([]);
  const [upcomingAssignments, setUpcomingAssignments] = useState([]);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [syncStatus, setSyncStatus] = useState('');
  
  const userId = localStorage.getItem('userId');

  useEffect(() => {
    fetchCourses();
    if (userId) {
      fetchUpcomingAssignments(userId);
    }
  }, [userId]);

  const fetchCourses = async () => {
    try {
      setLoading(true);
      const data = await getAllCourses();
      setCourses(data);
      setLoading(false);
    } catch (err) {
      setError('Error fetching courses: ' + err.message);
      setLoading(false);
    }
  };

  const fetchUpcomingAssignments = async (userId) => {
    try {
      setLoading(true);
      const data = await getUpcomingAssignments(userId);
      setUpcomingAssignments(data);
      setLoading(false);
    } catch (err) {
      setError('Error fetching upcoming assignments: ' + err.message);
      setLoading(false);
    }
  };

  const handleSelectCourse = async (courseId) => {
    try {
      setLoading(true);
      const data = await getCourseWithAssignments(courseId);
      setSelectedCourse(data.course);
      setAssignments(data.assignments);
      setLoading(false);
    } catch (err) {
      setError('Error fetching course details: ' + err.message);
      setLoading(false);
    }
  };

  const handleSyncCourses = async () => {
    try {
      setLoading(true);
      setSyncStatus('Syncing courses from Canvas...');
      const result = await syncCourses();
      await fetchCourses(); // Refresh the courses list
      setSyncStatus(`Successfully synced ${result.count} courses`);
      setLoading(false);
      
      // Clear the status after 3 seconds
      setTimeout(() => {
        setSyncStatus('');
      }, 3000);
    } catch (err) {
      setError('Error syncing courses: ' + err.message);
      setSyncStatus('');
      setLoading(false);
    }
  };

  const handleSyncAssignments = async (courseId) => {
    if (!courseId) return;
    
    try {
      setLoading(true);
      setSyncStatus('Syncing assignments...');
      const result = await syncAssignments(courseId);
      
      // If we have a selected course, refresh its assignments
      if (selectedCourse && selectedCourse._id === courseId) {
        const data = await getCourseWithAssignments(courseId);
        setAssignments(data.assignments);
      }
      
      setSyncStatus(`Successfully synced ${result.count} assignments`);
      setLoading(false);
      
      // Clear the status after 3 seconds
      setTimeout(() => {
        setSyncStatus('');
      }, 3000);
    } catch (err) {
      setError('Error syncing assignments: ' + err.message);
      setSyncStatus('');
      setLoading(false);
    }
  };

  const handleSyncAnnouncements = async (courseId) => {
    if (!courseId) return;
    
    try {
      setLoading(true);
      setSyncStatus('Syncing announcements...');
      const result = await syncAnnouncements(courseId);
      setSyncStatus(`Successfully synced ${result.count} announcements`);
      setLoading(false);
      
      // Clear the status after 3 seconds
      setTimeout(() => {
        setSyncStatus('');
      }, 3000);
    } catch (err) {
      setError('Error syncing announcements: ' + err.message);
      setSyncStatus('');
      setLoading(false);
    }
  };

  return (
    <div className="canvas-integration-page">
      <h1>Canvas Integration</h1>
      
      {error && <div className="alert alert-danger">{error}</div>}
      {syncStatus && <div className="alert alert-info">{syncStatus}</div>}
      
      <div className="canvas-controls">
        <button 
          onClick={handleSyncCourses}
          className="btn btn-primary"
          disabled={loading}
        >
          {loading ? 'Processing...' : 'Sync Courses from Canvas'}
        </button>
      </div>
      
      <div className="upcoming-assignments">
        <h2>Your Upcoming Assignments</h2>
        {loading && <div>Loading upcoming assignments...</div>}
        
        {upcomingAssignments.length === 0 && !loading ? (
          <div>No upcoming assignments found.</div>
        ) : (
          <div className="assignments-list">
            {upcomingAssignments.map(assignment => (
              <div key={assignment._id} className="assignment-card">
                <h4>{assignment.title}</h4>
                <p>
                  <strong>Course:</strong> {assignment.courseId.courseName}
                </p>
                <p>
                  <strong>Due:</strong> {new Date(assignment.dueDate).toLocaleString()}
                </p>
                <p>
                  <strong>Points:</strong> {assignment.pointsPossible}
                </p>
              </div>
            ))}
          </div>
        )}
      </div>
      
      <div className="canvas-content">
        <div className="courses-list">
          <h2>Your Canvas Courses</h2>
          {loading && !syncStatus && <div>Loading courses...</div>}
          
          {courses.length === 0 && !loading ? (
            <div>No Canvas courses found. Click "Sync Courses" to import them.</div>
          ) : (
            <ul className="list-group">
              {courses.map(course => (
                <li 
                  key={course._id}
                  className={`list-group-item ${selectedCourse?._id === course._id ? 'active' : ''}`}
                  onClick={() => handleSelectCourse(course._id)}
                >
                  <h4>{course.courseName}</h4>
                  <div className="course-code">{course.courseCode}</div>
                  <div className="course-term">{course.term}</div>
                  <div className="course-dates">
                    {course.startDate && new Date(course.startDate).toLocaleDateString()} - 
                    {course.endDate && new Date(course.endDate).toLocaleDateString()}
                  </div>
                </li>
              ))}
            </ul>
          )}
        </div>
        
        {selectedCourse && (
          <div className="course-details">
            <div className="course-header">
              <h2>{selectedCourse.courseName}</h2>
              <div className="course-actions">
                <button 
                  onClick={() => handleSyncAssignments(selectedCourse._id)}
                  className="btn btn-outline-primary btn-sm"
                  disabled={loading}
                >
                  Sync Assignments
                </button>
                <button 
                  onClick={() => handleSyncAnnouncements(selectedCourse._id)}
                  className="btn btn-outline-primary btn-sm"
                  disabled={loading}
                >
                  Sync Announcements
                </button>
              </div>
            </div>
            
            <div className="course-info">
              <p><strong>Course Code:</strong> {selectedCourse.courseCode}</p>
              <p><strong>Term:</strong> {selectedCourse.term}</p>
              <p>
                <strong>Dates:</strong> {selectedCourse.startDate && new Date(selectedCourse.startDate).toLocaleDateString()} - 
                {selectedCourse.endDate && new Date(selectedCourse.endDate).toLocaleDateString()}
              </p>
              <p><strong>Last Synced:</strong> {selectedCourse.lastSynced && new Date(selectedCourse.lastSynced).toLocaleString()}</p>
            </div>
            
            <div className="course-assignments">
              <h3>Assignments</h3>
              
              {assignments.length === 0 ? (
                <div>No assignments found. Click "Sync Assignments" to import them.</div>
              ) : (
                <div className="assignments-list">
                  {assignments.map(assignment => (
                    <div key={assignment._id} className="assignment-card">
                      <h4>{assignment.title}</h4>
                      {assignment.description && (
                        <div 
                          className="assignment-description"
                          dangerouslySetInnerHTML={{ __html: assignment.description }}
                        />
                      )}
                      <div className="assignment-details">
                        <p>
                          <strong>Due:</strong> {assignment.dueDate && new Date(assignment.dueDate).toLocaleString()}
                        </p>
                        <p>
                          <strong>Points:</strong> {assignment.pointsPossible}
                        </p>
                        <p>
                          <strong>Submission Type:</strong> {assignment.submissionType}
                        </p>
                      </div>
                    </div>
                  ))}
                </div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default CanvasIntegrationPage;
