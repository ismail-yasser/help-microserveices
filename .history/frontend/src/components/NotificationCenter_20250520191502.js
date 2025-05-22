import { useEffect, useState } from 'react';
import { getNotifications } from '../services/notificationService';

function NotificationCenter() {
  const [notifications, setNotifications] = useState([]);
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchNotifications = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const data = await getNotifications(token);
        setNotifications(Array.isArray(data) ? data : []);
      } catch (err) {
        setError('Failed to fetch notifications.');
      }
    };

    fetchNotifications();
  }, []);

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  return (
    <ul className="list-group">
      {notifications.map((notif) => (
        <li key={notif._id} className="list-group-item">
          {notif.message}
        </li>
      ))}
    </ul>
  );
}

export default NotificationCenter;