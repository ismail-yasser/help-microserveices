import React, { useState, useEffect } from 'react';
import api from '../services/api';
import { useParams, useNavigate } from 'react-router-dom';

function HelpRequestDetailPage() {
  const [request, setRequest] = useState(null);
  const [error, setError] = useState('');
  const [loading, setLoading] = useState(true);
  const { id } = useParams();
  const navigate = useNavigate();

  // States for editing (optional, can be expanded)
  const [isEditing, setIsEditing] = useState(false);
  const [editFormData, setEditFormData] = useState({});

  useEffect(() => {
    const fetchRequest = async () => {
      try {
        setLoading(true);
        const response = await api.getHelpRequestById(id);
        setRequest(response.data);
        setEditFormData(response.data); // Initialize form data for editing
        setError('');
      } catch (err) {
        setError('Failed to fetch help request details.');
        console.error(err);
      } finally {
        setLoading(false);
      }
    };
    if (id) {
      fetchRequest();
    }
  }, [id]);

  const handleDelete = async () => {
    if (window.confirm('Are you sure you want to delete this request?')) {
      try {
        await api.deleteHelpRequest(id);
        navigate('/help-requests');
      } catch (err) {
        setError('Failed to delete help request.');
        console.error(err);
      }
    }
  };

  const handleEditChange = (e) => {
    const { name, value } = e.target;
    setEditFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleEditSubmit = async (e) => {
    e.preventDefault();
    try {
      const updatedRequest = await api.updateHelpRequest(id, editFormData);
      setRequest(updatedRequest.data);
      setIsEditing(false);
      setError('');
    } catch (err) {
      setError('Failed to update help request.');
      console.error(err);
    }
  };

  if (loading) return <p>Loading details...</p>;
  if (error) return <p style={{ color: 'red' }}>{error}</p>;
  if (!request) return <p>Help request not found.</p>;

  return (
    <div>
      {isEditing ? (
        <form onSubmit={handleEditSubmit}>
          <h2>Edit Help {request.type === 'request' ? 'Request' : 'Offer'}</h2>
          <div>
            <label>Subject:</label>
            <input type="text" name="subject" value={editFormData.subject || ''} onChange={handleEditChange} required />
          </div>
          <div>
            <label>Description:</label>
            <textarea name="description" value={editFormData.description || ''} onChange={handleEditChange} required />
          </div>
          <div>
            <label>Urgency:</label>
            <select name="urgency" value={editFormData.urgency || 'medium'} onChange={handleEditChange}>
              <option value="low">Low</option>
              <option value="medium">Medium</option>
              <option value="high">High</option>
            </select>
          </div>
          <div>
            <label>Status:</label>
            <select name="status" value={editFormData.status || 'open'} onChange={handleEditChange}>
              <option value="open">Open</option>
              <option value="in-progress">In Progress</option>
              <option value="resolved">Resolved</option>
              <option value="closed">Closed</option>
            </select>
          </div>
          {/* Add other editable fields as needed based on your helpModel.js */}
          <button type="submit">Save Changes</button>
          <button type="button" onClick={() => setIsEditing(false)}>Cancel</button>
        </form>
      ) : (
        <>
          <h2>{request.subject} ({request.type})</h2>
          <p><strong>Description:</strong> {request.description}</p>
          <p><strong>Status:</strong> {request.status}</p>
          <p><strong>Urgency:</strong> {request.urgency}</p>
          <p><strong>User ID:</strong> {request.userId}</p>
          {request.courseId && <p><strong>Course ID:</strong> {request.courseId}</p>}
          {/* Display other fields from helpModel.js */}
          {/* e.g., tags, requiredSkills, deadline, etc. */}
          <button onClick={() => setIsEditing(true)}>Edit</button>
          <button onClick={handleDelete} style={{ marginLeft: '10px' }}>Delete</button>
        </>
      )}
    </div>
  );
}

export default HelpRequestDetailPage;
