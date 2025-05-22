import axios from 'axios';

const API_URL = 'http://localhost:3005/api/groups';

export const getStudyGroups = async (token) => {
  const response = await axios.get(API_URL, {
    headers: { Authorization: `Bearer ${token}` },
  });
  return response.data;
};
