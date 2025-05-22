import { useEffect, useState } from 'react';
import { getUserProfile } from '../services/userService';
// import NotificationCenter from '../components/NotificationCenter'; // Removed
// import StudyGroupSection from '../components/StudyGroupSection'; // Removed
// import GamificationStats from '../components/GamificationStats'; // Removed

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
        {/* <NotificationCenter /> */}{/* Removed */}
        <p>Notification feature coming soon.</p>
      </div>

      <div className="mt-4">
        <h2>Study Groups</h2>
        {/* <StudyGroupSection /> */}{/* Removed */}
        <p>Study group feature coming soon.</p>
      </div>

      <div className="mt-4">
        <h2>Gamification Stats</h2>
        {/* <GamificationStats /> */}{/* Removed */}
        <p>Gamification statistics coming soon.</p>
      </div>
    </div>
  );
}

export default DashboardPage;
