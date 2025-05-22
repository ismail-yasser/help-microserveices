import axios from 'axios';

const API_URL = process.env.REACT_APP_API_URL || 'http://localhost:3007/api';

// Get all partnerships
export const getAllPartnerships = async () => {
  try {
    const response = await axios.get(`${API_URL}/partnerships`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Get partnership by ID
export const getPartnershipById = async (id) => {
  try {
    const response = await axios.get(`${API_URL}/partnerships/${id}`);
    return response.data;
  } catch (error) {
    throw error;
  }
};

// Create a new partnership
export const createPartnership = async (partnershipData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships`, 
      partnershipData,
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

// Update a partnership
export const updatePartnership = async (id, partnershipData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.put(
      `${API_URL}/partnerships/${id}`, 
      partnershipData,
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

// Delete a partnership
export const deletePartnership = async (id) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.delete(
      `${API_URL}/partnerships/${id}`,
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

// Add an opportunity to a partnership
export const addOpportunity = async (partnershipId, opportunityData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships/${partnershipId}/opportunities`, 
      opportunityData,
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

// Enroll in an opportunity
export const enrollInOpportunity = async (partnershipId, opportunityId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships/${partnershipId}/opportunities/${opportunityId}/enroll`,
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

// Add a project to a partnership
export const addProject = async (partnershipId, projectData) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships/${partnershipId}/projects`, 
      projectData,
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

// Join a project
export const joinProject = async (partnershipId, projectId) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships/${partnershipId}/projects/${projectId}/join`,
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

// Rate a partnership
export const ratePartnership = async (partnershipId, rating) => {
  try {
    const token = localStorage.getItem('token');
    const response = await axios.post(
      `${API_URL}/partnerships/${partnershipId}/rate`,
      { rating },
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
