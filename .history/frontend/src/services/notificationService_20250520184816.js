import axios from 'axios';

const API_URL = 'http://localhost:3004/api/notifications';

export const getNotifications = async (token) => {
  const response = await axios.get(API_URL, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};
