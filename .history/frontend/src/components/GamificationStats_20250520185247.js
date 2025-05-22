import React, { useEffect, useState } from 'react';
import gamificationService from '../services/gamificationService';

const GamificationStats = () => {
  const [stats, setStats] = useState({ points: 0, badges: [] });

  useEffect(() => {
    gamificationService.getStats().then(setStats);
  }, []);

  return (
    <div>
      <h2>Gamification Stats</h2>
      <p>Points: {stats.points}</p>
      <ul>
        {stats.badges.map((badge, index) => (
          <li key={index}>{badge}</li>
        ))}
      </ul>
    </div>
  );
};

export default GamificationStats;
