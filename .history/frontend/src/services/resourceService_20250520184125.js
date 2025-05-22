import axios from 'axios';

const API_URL = 'http://localhost:3001/api/resources';

export const getResources = async (token) => {
  const response = await axios.get(API_URL, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};
