import React from 'react';
import NotificationCenter from '../components/NotificationCenter';
import StudyGroupSection from '../components/StudyGroupSection';
import GamificationStats from '../components/GamificationStats';

const DashboardPage = () => {
  return (
    <div>
      <h1>Dashboard</h1>
      <NotificationCenter />
      <StudyGroupSection />
      <GamificationStats />
    </div>
  );
};

export default DashboardPage;
