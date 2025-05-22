import React, { useEffect, useState } from 'react';
import api from '../services/api';
import { Link } from 'react-router-dom';

function HelpRequestList() {
  const [requests, setRequests] = useState([]);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchRequests = async () => {
      try {
        setLoading(true);
        const response = await api.getAllHelpRequests();
        setRequests(response.data);
        setError('');
      } catch (err) {
        setError('Failed to fetch help requests.');
        console.error(err);
        // If 404 or other specific errors, you might want to guide the user
        if (err.response && err.response.status === 404) {
            setError('Help requests endpoint not found. Make sure the help-service is running.');
        }
      } finally {
        setLoading(false);
      }
    };
    fetchRequests();
  }, []);

  if (loading) return <p>Loading help requests...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;

  return (
    <div>
      <h2>Help Requests & Offers</h2>
      <Link to="/create-help-request">Create New Request</Link> | <Link to="/create-help-offer">Create New Offer</Link>
      {requests.length === 0 ? (
        <p>No help requests or offers found.</p>
      ) : (
        <ul>
          {requests.map((req) => (
            <li key={req._id}>
              <Link to={`/help-requests/${req._id}`}>
                <strong>{req.subject}</strong> ({req.type})
              </Link>
              <p>Status: {req.status} | Urgency: {req.urgency}</p>
              <p>{req.description.substring(0,100)}...</p>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}

export default HelpRequestList;
