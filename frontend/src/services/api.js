import axios from 'axios';

// Use environment variables provided by Kubernetes ConfigMap for internal communication
// These environment variables will be set by the 'frontend-config' ConfigMap
const API_URL_USER = process.env.REACT_APP_USER_SERVICE_URL; 
const API_URL_HELP = process.env.REACT_APP_HELP_SERVICE_URL;

// Fallback for local development if these are not set (e.g., when running 'npm start' locally)
// You might still want a conditional for local, but it won't affect the K8s deployment
// Example:
// const API_URL_USER = process.env.REACT_APP_USER_SERVICE_URL || 'http://localhost:3000/api/users';
// const API_URL_HELP = process.env.REACT_APP_HELP_SERVICE_URL || 'http://localhost:3002/api/help';

// Function to get the auth token from localStorage
const getAuthToken = () => {
  return localStorage.getItem('token');
};

// Axios instance for user service
const userApi = axios.create({
  baseURL: API_URL_USER,
});

// Axios instance for help service
const helpApi = axios.create({
  baseURL: API_URL_HELP,
});

// Add a request interceptor to include the token in headers
const addAuthInterceptor = (apiInstance) => {
  apiInstance.interceptors.request.use(
    (config) => {
      const token = getAuthToken();
      if (token) {
        config.headers['Authorization'] = `Bearer ${token}`;
      }
      return config;
    },
    (error) => {
      return Promise.reject(error);
    }
  );
};

addAuthInterceptor(userApi);
addAuthInterceptor(helpApi);

// User Service API calls
export const loginUser = (credentials) => userApi.post('/login', credentials);
export const signupUser = (userData) => userApi.post('/signup', userData); // Changed from /register to /signup
export const getCurrentUser = () => userApi.get('/me'); // Assuming an endpoint to get current user

// Help Service API calls
export const getAllHelpRequests = () => helpApi.get('/');
export const createHelpRequest = (requestData) => {
  // requestData is expected to be FormData if files are included
  return helpApi.post('/request', requestData /* Axios handles FormData Content-Type */);
};
export const createHelpOffer = (offerData) => {
  // offerData should contain { requestId, description, userId }
  return helpApi.post('/offer', offerData);
};
export const acceptHelpOffer = (requestId, offerId) => {
  return helpApi.put(`/request/${requestId}/offer/${offerId}/accept`);
};
export const getHelpRequestById = (id) => {
  // Add client-side validation to prevent making API calls with undefined IDs
  if (!id || id === 'undefined') {
    return Promise.reject(new Error('Invalid help request ID'));
  }
  return helpApi.get(`/${id}`);
};
export const updateHelpRequest = (id, data) => helpApi.put(`/${id}`, data);
export const deleteHelpRequest = (id) => helpApi.delete(`/${id}`);
export const searchHelpRequests = (params) => helpApi.get('/search', { params });

export default {
  loginUser,
  signupUser,
  getCurrentUser,
  getAllHelpRequests,
  createHelpRequest,
  createHelpOffer,
  acceptHelpOffer,
  getHelpRequestById,
  updateHelpRequest,
  deleteHelpRequest,
  searchHelpRequests
};