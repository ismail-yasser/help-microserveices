import { useEffect, useState } from 'react';
import { getUserProfile } from '../services/userService';
import NotificationCenter from '../components/NotificationCenter';
import StudyGroupSection from '../components/StudyGroupSection';
import GamificationStats from '../components/GamificationStats';

function DashboardPage() {
  const [user, setUser] = useState(null);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const userData = await getUserProfile(token);
        setUser(userData);
      } catch (err) {
        setError('Failed to fetch user data.');
      }
    };

    fetchData();
  }, []);

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  if (!user) {
    return <p>Loading...</p>;
  }

  return (
    <div className="container mt-5">
      <h1 className="text-center">Dashboard</h1>

      <div className="mt-4">
        <h2>Notifications</h2>
        <NotificationCenter />
      </div>

      <div className="mt-4">
        <h2>Study Groups</h2>
        <StudyGroupSection />
      </div>

      <div className="mt-4">
        <h2>Gamification Stats</h2>
        <GamificationStats />
      </div>
    </div>
  );
}

export default DashboardPage;
