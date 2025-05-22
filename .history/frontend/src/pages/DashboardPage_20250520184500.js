import { useEffect, useState } from 'react';
import { getUserProfile } from '../services/userService';
import { getStudyGroups } from '../services/studyGroupService';
import { getNotifications } from '../services/notificationService';
import { getResources } from '../services/resourceService';

function DashboardPage() {
  const [user, setUser] = useState(null);
  const [studyGroups, setStudyGroups] = useState([]);
  const [notifications, setNotifications] = useState([]);
  const [resources, setResources] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchData = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const [userData, groups, notifs, res] = await Promise.all([
          getUserProfile(token),
          getStudyGroups(token),
          getNotifications(token),
          getResources(token),
        ]);
        setUser(userData);
        console.log('Study Groups:', groups); // Log the response
        setStudyGroups(Array.isArray(groups.groups) ? groups.groups : []); // Access the 'groups' property
        setNotifications(Array.isArray(notifs) ? notifs : []);
        setResources(Array.isArray(res) ? res : []);
      } catch (err) {
        setError('Failed to fetch data.');
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
    <div>
      <h1>Welcome, {user.name}</h1>
      <p>Email: {user.email}</p>

      <h2>Study Groups</h2>
      <ul>
        {studyGroups.map((group) => (
          <li key={group._id}>{group.name}</li>
        ))}
      </ul>

      <h2>Notifications</h2>
      <ul>
        {notifications.map((notif) => (
          <li key={notif._id}>{notif.message}</li>
        ))}
      </ul>

      <h2>Resources</h2>
      <ul>
        {resources.map((resource) => (
          <li key={resource._id}>{resource.title}</li>
        ))}
      </ul>
    </div>
  );
}

export default DashboardPage;
