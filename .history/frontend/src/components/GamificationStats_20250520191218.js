import { useEffect, useState } from 'react';

function GamificationStats() {
  const [stats, setStats] = useState({ points: 0, badges: [] });
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchStats = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        // Simulate fetching stats from the gamification service
        const data = { points: 120, badges: ['Beginner', 'Explorer'] };
        setStats(data);
      } catch (err) {
        setError('Failed to fetch gamification stats.');
      }
    };

    fetchStats();
  }, []);

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  return (
    <div>
      <h3>Points: {stats.points}</h3>
      <h4>Badges:</h4>
      <ul className="list-group">
        {stats.badges.map((badge, index) => (
          <li key={index} className="list-group-item">
            {badge}
          </li>
        ))}
      </ul>
    </div>
  );
}

export default GamificationStats;