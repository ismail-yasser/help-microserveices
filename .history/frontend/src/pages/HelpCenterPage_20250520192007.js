import { useEffect, useState } from 'react';
import { getHelpRequests, createHelpRequest, resolveHelpRequest } from '../services/helpService';

function HelpCenterPage() {
  const [helpRequests, setHelpRequests] = useState([]);
  const [newRequest, setNewRequest] = useState('');
  const [error, setError] = useState('');

  useEffect(() => {
    const fetchHelpRequests = async () => {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      try {
        const data = await getHelpRequests(token);
        setHelpRequests(Array.isArray(data) ? data : []);
      } catch (err) {
        setError('Failed to fetch help requests.');
      }
    };

    fetchHelpRequests();
  }, []);

  const handleAddRequest = async () => {
    if (newRequest.trim() === '') return;
    try {
      const token = localStorage.getItem('token');
      const request = await createHelpRequest(token, { message: newRequest });
      setHelpRequests([...helpRequests, request]);
      setNewRequest('');
    } catch (err) {
      setError('Failed to create help request.');
    }
  };

  const handleResolveRequest = async (id) => {
    try {
      const token = localStorage.getItem('token');
      await resolveHelpRequest(token, id);
      setHelpRequests(helpRequests.filter((request) => request._id !== id));
    } catch (err) {
      setError('Failed to resolve help request.');
    }
  };

  if (error) {
    return <p style={{ color: 'red' }}>{error}</p>;
  }

  return (
    <div className="container mt-5">
      <h1 className="text-center">Help Center</h1>
      <div className="mb-3">
        <input
          type="text"
          className="form-control"
          placeholder="Describe your issue"
          value={newRequest}
          onChange={(e) => setNewRequest(e.target.value)}
        />
        <button className="btn btn-primary mt-2" onClick={handleAddRequest}>
          Submit Request
        </button>
      </div>
      <ul className="list-group">
        {helpRequests.map((request) => (
          <li
            key={request._id}
            className="list-group-item d-flex justify-content-between align-items-center"
          >
            {request.message}
            <button
              className="btn btn-success btn-sm"
              onClick={() => handleResolveRequest(request._id)}
            >
              Resolve
            </button>
          </li>
        ))}
      </ul>
    </div>
  );
}

export default HelpCenterPage;
