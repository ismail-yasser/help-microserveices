import axios from 'axios';

const API_URL = process.env.REACT_APP_ANALYTICS_URL || 'http://localhost:3008/api/analytics';

// Record user activity
export const recordUserActivity = async (userId, activity, details = {}) => {
  try {
    const response = await axios.post(`${API_URL}/record`, {
      userId,
      activity,
      details
    });
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get user analytics
export const getUserAnalytics = async (userId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(
      `${API_URL}/users/${userId}`,
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

// Get resource analytics
export const getResourceAnalytics = async (resourceId) => {
  try {
    const response = await axios.get(`${API_URL}/resources/${resourceId}`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get help request analytics
export const getHelpAnalytics = async (helpRequestId) => {
  try {
    const response = await axios.get(`${API_URL}/help/${helpRequestId}`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get system analytics (admin only)
export const getSystemAnalytics = async (startDate, endDate) => {
  try {
    const token = localStorage.getItem('token');
    let url = `${API_URL}/system`;
    
    if (startDate || endDate) {
      const params = new URLSearchParams();
      if (startDate) params.append('startDate', startDate);
      if (endDate) params.append('endDate', endDate);
      url += `?${params.toString()}`;
    }
    
    const response = await axios.get(
      url,
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

// Get dashboard analytics
export const getDashboardAnalytics = async () => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.get(
      `${API_URL}/dashboard`,
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
