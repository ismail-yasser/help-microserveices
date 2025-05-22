import React, { useState } from 'react';
import api from '../services/api';
import { useNavigate } from 'react-router-dom';

function CreateHelpOfferPage() {
  const [formData, setFormData] = useState({
    subject: '',
    description: '',
    type: 'offer', // Default to 'offer'
    courseId: '', // Optional
    tags: '', // Store as comma-separated string for simplicity, then convert
    // Add skills you are offering if applicable, similar to requiredSkills for requests
    offeredSkills: '', 
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
        // Convert offeredSkills if you add it to the form
        // offeredSkills: formData.offeredSkills.split(',').map(skill => skill.trim()).filter(skill => skill),
      };
      await api.createHelpOffer(payload); // Using the new API function
      setSuccess('Help offer created successfully!');
      // navigate('/help-requests'); // Optionally redirect
      setFormData({
        subject: '',
        description: '',
        type: 'offer',
        courseId: '',
        tags: '',
        offeredSkills: '',
      });
    } catch (err) {
      setError('Failed to create help offer. ' + (err.response?.data?.message || ''));
      console.error(err);
    }
  };

  return (
    <div>
      <h2>Create New Help Offer</h2>
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
          <label>Course ID (Optional):</label>
          <input type="text" name="courseId" value={formData.courseId} onChange={handleChange} />
        </div>
        <div>
          <label>Tags (comma-separated):</label>
          <input type="text" name="tags" value={formData.tags} onChange={handleChange} />
        </div>
        {/* Add more fields from helpModel.js as relevant for 'offer' type */}
        {/* For example, skills you are offering */}
        {/* <div>
          <label>Skills Offered (comma-separated):</label>
          <input type="text" name="offeredSkills" value={formData.offeredSkills} onChange={handleChange} />
        </div> */}
        <button type="submit">Create Offer</button>
      </form>
    </div>
  );
}

export default CreateHelpOfferPage;
