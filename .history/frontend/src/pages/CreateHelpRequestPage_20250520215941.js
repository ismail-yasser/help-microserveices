import React, { useState } from 'react';
import api from '../services/api';
import { useNavigate } from 'react-router-dom';

function CreateHelpRequestPage() {
  const [formData, setFormData] = useState({
    subject: '',
    description: '',
    type: 'request', // Default to 'request'
    urgency: 'medium',
    courseId: '', // Optional
    tags: '', // Store as comma-separated string for simplicity, then convert
    requiredSkills: '', // Store as comma-separated string
  });
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    try {
      const payload = {
        ...formData,
        tags: formData.tags.split(',').map(tag => tag.trim()).filter(tag => tag),
        requiredSkills: formData.requiredSkills.split(',').map(skill => skill.trim()).filter(skill => skill),
      };
      await api.createHelpRequest(payload);
      setSuccess('Help request created successfully!');
      // navigate('/help-requests'); // Optionally redirect
      setFormData({
        subject: '',
        description: '',
        type: 'request',
        urgency: 'medium',
        courseId: '',
        tags: '',
        requiredSkills: '',
      });
    } catch (err) {
      setError('Failed to create help request. ' + (err.response?.data?.message || ''));
      console.error(err);
    }
  };

  return (
    <div>
      <h2>Create New Help Request</h2>
      {error && <p style={{ color: 'red' }}>{error}</p>}
      {success && <p style={{ color: 'green' }}>{success}</p>}
      <form onSubmit={handleSubmit}>
        <div>
          <label>Subject:</label>
          <input type="text" name="subject" value={formData.subject} onChange={handleChange} required />
        </div>
        <div>
          <label>Description:</label>
          <textarea name="description" value={formData.description} onChange={handleChange} required />
        </div>
        <div>
          <label>Urgency:</label>
          <select name="urgency" value={formData.urgency} onChange={handleChange}>
            <option value="low">Low</option>
            <option value="medium">Medium</option>
            <option value="high">High</option>
          </select>
        </div>
        <div>
          <label>Course ID (Optional):</label>
          <input type="text" name="courseId" value={formData.courseId} onChange={handleChange} />
        </div>
        <div>
          <label>Tags (comma-separated):</label>
          <input type="text" name="tags" value={formData.tags} onChange={handleChange} />
        </div>
        <div>
          <label>Required Skills (comma-separated):</label>
          <input type="text" name="requiredSkills" value={formData.requiredSkills} onChange={handleChange} />
        </div>
        {/* Add more fields from helpModel.js as needed */}
        <button type="submit">Create Request</button>
      </form>
    </div>
  );
}

export default CreateHelpRequestPage;
