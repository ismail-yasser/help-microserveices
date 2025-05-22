import axios from 'axios';

const API_URL = 'http://localhost:3002/api/help';

// Get all help requests with optional filters
export const getHelpRequests = async (token, filters = {}) => {
  let url = API_URL;
  
  // Add query parameters for filters
  if (Object.keys(filters).length > 0) {
    const queryParams = new URLSearchParams();
    
    for (const [key, value] of Object.entries(filters)) {
      if (value !== undefined && value !== null) {
        queryParams.append(key, value);
      }
    }
    
    url += `?${queryParams.toString()}`;
  }
  
  const response = await axios.get(url, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Search for help requests with query, tags, and course
export const searchHelpRequests = async (token, searchParams) => {
  const queryParams = new URLSearchParams();
  
  for (const [key, value] of Object.entries(searchParams)) {
    if (Array.isArray(value)) {
      // Handle array values like tags
      value.forEach(item => queryParams.append(key, item));
    } else if (value !== undefined && value !== null) {
      queryParams.append(key, value);
    }
  }
  
  const response = await axios.get(`${API_URL}/search?${queryParams.toString()}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Get a specific help request by ID
export const getHelpRequestById = async (token, id) => {
  const response = await axios.get(`${API_URL}/${id}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Create a new help request
export const createHelpRequest = async (token, request) => {
  const response = await axios.post(`${API_URL}/request`, request, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Create a new help offer
export const createHelpOffer = async (token, offer) => {
  const response = await axios.post(`${API_URL}/offer`, offer, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Update an existing help request
export const updateHelpRequest = async (token, id, updates) => {
  const response = await axios.put(`${API_URL}/${id}`, updates, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Delete a help request
export const deleteHelpRequest = async (token, id) => {
  const response = await axios.delete(`${API_URL}/${id}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return response.data;
};

// Add a response to a help request
export const addResponse = async (token, helpId, response) => {
  const result = await axios.post(`${API_URL}/${helpId}/responses`, response, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return result.data;
};

// Update the status of a help request
export const updateHelpStatus = async (token, helpId, status) => {
  const result = await axios.put(`${API_URL}/${helpId}/status`, { status }, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return result.data;
};

// Assign a helper to a help request
export const assignHelper = async (token, helpId, helperId) => {
  const result = await axios.post(`${API_URL}/${helpId}/assign`, { helperId }, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return result.data;
};

// Schedule a meeting for a help request
export const scheduleMeeting = async (token, helpId, meetingData) => {
  const result = await axios.post(`${API_URL}/${helpId}/meeting`, meetingData, {
    headers: { Authorization: `Bearer ${token}` },
  });
  
  return result.data;
};

// Rate a help response
export const rateResponse = async (token, helpId, responseId, rating, helpful) => {
  const result = await axios.post(
    `${API_URL}/${helpId}/responses/${responseId}/rate`,
    { rating, helpful },
    { headers: { Authorization: `Bearer ${token}` } }
  );
  
  return result.data;
};

// Upload a file attachment
export const uploadAttachment = async (token, helpId, attachmentData) => {
  const result = await axios.post(
    `${API_URL}/${helpId}/attachments`,
    attachmentData,
    { headers: { Authorization: `Bearer ${token}` } }
  );
  
  return result.data;
};
