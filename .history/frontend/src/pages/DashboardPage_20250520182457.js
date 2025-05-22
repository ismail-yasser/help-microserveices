import { useEffect, useState } from 'react';
import { getUserProfile } from '../services/userService';

function DashboardPage() {
  const [user, setUser] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchUserProfile = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const data = await getUserProfile(token);
        setUser(data);
      } catch (err) {
        setError('Failed to fetch user profile.');
      }
    };

    fetchUserProfile();
  }, []);

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  if (!user) {
    return <p>Loading...</p>;
  }

  return (
    <div>
      <h1>Welcome, {user.name}</h1>
      <p>Email: {user.email}</p>
    </div>
  );
}

export default DashboardPage;
