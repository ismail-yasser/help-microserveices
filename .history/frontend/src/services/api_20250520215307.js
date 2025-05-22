import axios from 'axios';

const API_URL_USER = 'http://localhost:3000/api/users'; // Assuming user-service runs on port 3000
const API_URL_HELP = 'http://localhost:3002/api/help'; // Assuming help-service runs on port 3002

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
export const signupUser = (userData) => userApi.post('/register', userData);
export const getCurrentUser = () => userApi.get('/me'); // Assuming an endpoint to get current user

// Help Service API calls
export const getAllHelpRequests = () => helpApi.get('/');
export const createHelpRequest = (requestData) => helpApi.post('/request', requestData);
export const getHelpRequestById = (id) => helpApi.get(`/${id}`);
export const updateHelpRequest = (id, data) => helpApi.put(`/${id}`, data);
export const deleteHelpRequest = (id) => helpApi.delete(`/${id}`);
export const searchHelpRequests = (params) => helpApi.get('/search', { params });


export default {
  loginUser,
  signupUser,
  getCurrentUser,
  getAllHelpRequests,
  createHelpRequest,
  getHelpRequestById,
  updateHelpRequest,
  deleteHelpRequest,
  searchHelpRequests
};
