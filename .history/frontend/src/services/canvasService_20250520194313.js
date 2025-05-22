import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3006/api';

// Get all Canvas courses
export const getAllCourses = async () => {
  try {
    const response = await axios.get(`${API_URL}/canvas/courses`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get a course with its assignments
export const getCourseWithAssignments = async (courseId) => {
  try {
    const response = await axios.get(`${API_URL}/canvas/courses/${courseId}`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Sync courses from Canvas
export const syncCourses = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/canvas/sync/courses`,
      {},
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Sync assignments for a course
export const syncAssignments = async (courseId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/canvas/sync/courses/${courseId}/assignments`,
      {},
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Sync enrollments for a user
export const syncEnrollments = async (userId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/canvas/sync/users/${userId}/enrollments`,
      {},
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Sync announcements for a course
export const syncAnnouncements = async (courseId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/canvas/sync/courses/${courseId}/announcements`,
      {},
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get upcoming assignments for a user
export const getUpcomingAssignments = async (userId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(
      `${API_URL}/canvas/users/${userId}/upcoming-assignments`,
      {
        headers: {
          'Authorization': `Bearer ${token}`
        }
      }
    );
    return response.data;
  } catch (error) {
    throw error;
  }
};
