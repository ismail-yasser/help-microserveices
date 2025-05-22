import axios from 'axios';

const API_URL = 'http://localhost:3003/api/help';

export const getHelpRequests = async (token) => {
  const response = await axios.get(API_URL, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};

export const createHelpRequest = async (token, request) => {
  const response = await axios.post(API_URL, request, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};

export const resolveHelpRequest = async (token, id) => {
  const response = await axios.delete(`${API_URL}/${id}`, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};
