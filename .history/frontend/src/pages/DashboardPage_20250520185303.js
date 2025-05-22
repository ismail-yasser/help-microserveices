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
  const [searchGroup, setSearchGroup] = useState('');
  const [searchNotification, setSearchNotification] = useState('');
  const [searchResource, setSearchResource] = useState('');

  const filteredGroups = studyGroups.filter((group) =>
    group.name.toLowerCase().includes(searchGroup.toLowerCase())
  );

  const filteredNotifications = notifications.filter((notif) =>
    notif.message.toLowerCase().includes(searchNotification.toLowerCase())
  );

  const filteredResources = resources.filter((resource) =>
    resource.title.toLowerCase().includes(searchResource.toLowerCase())
  );

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
    <div className="container mt-5">
      <h1 className="text-center">Dashboard</h1>

      <div className="mt-4">
        <h2>Study Groups</h2>
        <input
          type="text"
          className="form-control mb-3"
          placeholder="Search Study Groups"
          value={searchGroup}
          onChange={(e) => setSearchGroup(e.target.value)}
        />
        <ul className="list-group">
          {filteredGroups.map((group) => (
            <li key={group._id} className="list-group-item">
              {group.name}
            </li>
          ))}
        </ul>
      </div>

      <div className="mt-4">
        <h2>Notifications</h2>
        <input
          type="text"
          className="form-control mb-3"
          placeholder="Search Notifications"
          value={searchNotification}
          onChange={(e) => setSearchNotification(e.target.value)}
        />
        <ul className="list-group">
          {filteredNotifications.map((notif) => (
            <li key={notif._id} className="list-group-item">
              {notif.message}
            </li>
          ))}
        </ul>
      </div>

      <div className="mt-4">
        <h2>Resources</h2>
        <input
          type="text"
          className="form-control mb-3"
          placeholder="Search Resources"
          value={searchResource}
          onChange={(e) => setSearchResource(e.target.value)}
        />
        <ul className="list-group">
          {filteredResources.map((resource) => (
            <li key={resource._id} className="list-group-item">
              {resource.title}
            </li>
          ))}
        </ul>
      </div>
    </div>
  );
}

export default DashboardPage;
