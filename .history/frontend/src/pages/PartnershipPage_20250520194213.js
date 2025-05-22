import React, { useState, useEffect } from 'react';
import { 
  getAllPartnerships, 
  getPartnershipById, 
  createPartnership,
  addOpportunity,
  enrollInOpportunity
} from '../services/partnershipService';

const PartnershipPage = () => {
  const [partnerships, setPartnerships] = useState([]);
  const [selectedPartnership, setSelectedPartnership] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);
  const [showCreateForm, setShowCreateForm] = useState(false);
  const [showOpportunityForm, setShowOpportunityForm] = useState(false);
  
  // Form states
  const [formData, setFormData] = useState({
    name: '',
    organizationType: 'industry',
    description: '',
    contactEmail: '',
    contactName: '',
    website: '',
    expertiseAreas: ''
  });
  
  const [opportunityData, setOpportunityData] = useState({
    title: '',
    description: '',
    type: 'mentorship',
    startDate: '',
    endDate: '',
    capacity: 5,
    requirements: ''
  });

  useEffect(() => {
    fetchPartnerships();
  }, []);

  const fetchPartnerships = async () => {
    try {
      setLoading(true);
      const data = await getAllPartnerships();
      setPartnerships(data);
      setLoading(false);
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  };

  const handleSelectPartnership = async (id) => {
    try {
      setLoading(true);
      const data = await getPartnershipById(id);
      setSelectedPartnership(data);
      setLoading(false);
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  };

  const handleCreateSubmit = async (e) => {
    e.preventDefault();
    try {
      setLoading(true);
      // Convert expertise areas string to array
      const partnershipData = {
        ...formData,
        expertiseAreas: formData.expertiseAreas.split(',').map(area => area.trim())
      };
      
      const newPartnership = await createPartnership(partnershipData);
      setPartnerships([...partnerships, newPartnership]);
      setShowCreateForm(false);
      setFormData({
        name: '',
        organizationType: 'industry',
        description: '',
        contactEmail: '',
        contactName: '',
        website: '',
        expertiseAreas: ''
      });
      setLoading(false);
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  };

  const handleOpportunitySubmit = async (e) => {
    e.preventDefault();
    if (!selectedPartnership) return;
    
    try {
      setLoading(true);
      const newOpportunity = await addOpportunity(
        selectedPartnership._id, 
        opportunityData
      );
      setSelectedPartnership(newOpportunity);
      setShowOpportunityForm(false);
      setOpportunityData({
        title: '',
        description: '',
        type: 'mentorship',
        startDate: '',
        endDate: '',
        capacity: 5,
        requirements: ''
      });
      setLoading(false);
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  };

  const handleEnroll = async (opportunityId) => {
    if (!selectedPartnership) return;
    
    try {
      setLoading(true);
      const updatedPartnership = await enrollInOpportunity(
        selectedPartnership._id, 
        opportunityId
      );
      setSelectedPartnership(updatedPartnership);
      setLoading(false);
    } catch (err) {
      setError(err.message);
      setLoading(false);
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData({ ...formData, [name]: value });
  };

  const handleOpportunityChange = (e) => {
    const { name, value } = e.target;
    setOpportunityData({ ...opportunityData, [name]: value });
  };

  return (
    <div className="partnership-page">
      <h1>Partnerships</h1>
      
      {error && <div className="error-message">{error}</div>}
      
      <div className="partnership-controls">
        <button 
          onClick={() => setShowCreateForm(!showCreateForm)}
          className="btn btn-primary"
        >
          {showCreateForm ? 'Cancel' : 'Create New Partnership'}
        </button>
      </div>
      
      {showCreateForm && (
        <div className="partnership-form">
          <h2>Create Partnership</h2>
          <form onSubmit={handleCreateSubmit}>
            <div className="form-group">
              <label>Name</label>
              <input
                type="text"
                name="name"
                value={formData.name}
                onChange={handleInputChange}
                required
                className="form-control"
              />
            </div>
            
            <div className="form-group">
              <label>Organization Type</label>
              <select
                name="organizationType"
                value={formData.organizationType}
                onChange={handleInputChange}
                className="form-control"
              >
                <option value="industry">Industry</option>
                <option value="academic">Academic</option>
                <option value="alumni">Alumni</option>
                <option value="student-group">Student Group</option>
              </select>
            </div>
            
            <div className="form-group">
              <label>Description</label>
              <textarea
                name="description"
                value={formData.description}
                onChange={handleInputChange}
                required
                className="form-control"
              />
            </div>
            
            <div className="form-group">
              <label>Contact Name</label>
              <input
                type="text"
                name="contactName"
                value={formData.contactName}
                onChange={handleInputChange}
                required
                className="form-control"
              />
            </div>
            
            <div className="form-group">
              <label>Contact Email</label>
              <input
                type="email"
                name="contactEmail"
                value={formData.contactEmail}
                onChange={handleInputChange}
                required
                className="form-control"
              />
            </div>
            
            <div className="form-group">
              <label>Website</label>
              <input
                type="url"
                name="website"
                value={formData.website}
                onChange={handleInputChange}
                className="form-control"
              />
            </div>
            
            <div className="form-group">
              <label>Expertise Areas (comma-separated)</label>
              <input
                type="text"
                name="expertiseAreas"
                value={formData.expertiseAreas}
                onChange={handleInputChange}
                className="form-control"
              />
            </div>
            
            <button 
              type="submit" 
              className="btn btn-success"
              disabled={loading}
            >
              {loading ? 'Creating...' : 'Create Partnership'}
            </button>
          </form>
        </div>
      )}
      
      <div className="partnerships-container">
        <div className="partnerships-list">
          <h2>Available Partnerships</h2>
          {loading && !showCreateForm && <div>Loading partnerships...</div>}
          
          {partnerships.length === 0 && !loading ? (
            <div>No partnerships available yet.</div>
          ) : (
            <ul className="list-group">
              {partnerships.map(partnership => (
                <li 
                  key={partnership._id}
                  className={`list-group-item ${selectedPartnership?._id === partnership._id ? 'active' : ''}`}
                  onClick={() => handleSelectPartnership(partnership._id)}
                >
                  <h4>{partnership.name}</h4>
                  <div className="partnership-type">{partnership.organizationType}</div>
                  {partnership.verified && <span className="badge bg-success">Verified</span>}
                  <div className="rating">
                    Rating: {partnership.rating} ({partnership.feedbackCount} reviews)
                  </div>
                </li>
              ))}
            </ul>
          )}
        </div>
        
        {selectedPartnership && (
          <div className="partnership-details">
            <h2>{selectedPartnership.name}</h2>
            <div className="partnership-info">
              <p><strong>Type:</strong> {selectedPartnership.organizationType}</p>
              <p><strong>Description:</strong> {selectedPartnership.description}</p>
              <p><strong>Contact:</strong> {selectedPartnership.contactName} ({selectedPartnership.contactEmail})</p>
              <p><strong>Website:</strong> <a href={selectedPartnership.website} target="_blank" rel="noopener noreferrer">{selectedPartnership.website}</a></p>
              <p><strong>Expertise Areas:</strong> {selectedPartnership.expertiseAreas.join(', ')}</p>
              
              <div className="partnership-ratings">
                <h4>Rating: {selectedPartnership.rating}/5</h4>
                <p>{selectedPartnership.feedbackCount} reviews</p>
                {/* Rating UI would go here */}
              </div>
            </div>
            
            <div className="opportunities-section">
              <div className="section-header">
                <h3>Opportunities</h3>
                <button 
                  onClick={() => setShowOpportunityForm(!showOpportunityForm)}
                  className="btn btn-sm btn-primary"
                >
                  {showOpportunityForm ? 'Cancel' : 'Add Opportunity'}
                </button>
              </div>
              
              {showOpportunityForm && (
                <div className="opportunity-form">
                  <h4>Add New Opportunity</h4>
                  <form onSubmit={handleOpportunitySubmit}>
                    <div className="form-group">
                      <label>Title</label>
                      <input
                        type="text"
                        name="title"
                        value={opportunityData.title}
                        onChange={handleOpportunityChange}
                        required
                        className="form-control"
                      />
                    </div>
                    
                    <div className="form-group">
                      <label>Type</label>
                      <select
                        name="type"
                        value={opportunityData.type}
                        onChange={handleOpportunityChange}
                        className="form-control"
                      >
                        <option value="mentorship">Mentorship</option>
                        <option value="project">Project</option>
                        <option value="internship">Internship</option>
                        <option value="guest-lecture">Guest Lecture</option>
                        <option value="workshop">Workshop</option>
                      </select>
                    </div>
                    
                    <div className="form-group">
                      <label>Description</label>
                      <textarea
                        name="description"
                        value={opportunityData.description}
                        onChange={handleOpportunityChange}
                        required
                        className="form-control"
                      />
                    </div>
                    
                    <div className="form-group">
                      <label>Start Date</label>
                      <input
                        type="date"
                        name="startDate"
                        value={opportunityData.startDate}
                        onChange={handleOpportunityChange}
                        className="form-control"
                      />
                    </div>
                    
                    <div className="form-group">
                      <label>End Date</label>
                      <input
                        type="date"
                        name="endDate"
                        value={opportunityData.endDate}
                        onChange={handleOpportunityChange}
                        className="form-control"
                      />
                    </div>
                    
                    <div className="form-group">
                      <label>Capacity</label>
                      <input
                        type="number"
                        name="capacity"
                        value={opportunityData.capacity}
                        onChange={handleOpportunityChange}
                        min="1"
                        className="form-control"
                      />
                    </div>
                    
                    <div className="form-group">
                      <label>Requirements</label>
                      <textarea
                        name="requirements"
                        value={opportunityData.requirements}
                        onChange={handleOpportunityChange}
                        className="form-control"
                      />
                    </div>
                    
                    <button 
                      type="submit" 
                      className="btn btn-success"
                      disabled={loading}
                    >
                      {loading ? 'Adding...' : 'Add Opportunity'}
                    </button>
                  </form>
                </div>
              )}
              
              {selectedPartnership.availableOpportunities?.length > 0 ? (
                <div className="opportunities-list">
                  {selectedPartnership.availableOpportunities.map(opportunity => (
                    <div key={opportunity._id} className="opportunity-card">
                      <h4>{opportunity.title}</h4>
                      <div className="opportunity-type">{opportunity.type}</div>
                      <p>{opportunity.description}</p>
                      
                      <div className="opportunity-details">
                        <div>
                          <strong>Dates:</strong> {new Date(opportunity.startDate).toLocaleDateString()} - 
                          {opportunity.endDate ? new Date(opportunity.endDate).toLocaleDateString() : 'Ongoing'}
                        </div>
                        <div>
                          <strong>Capacity:</strong> {opportunity.enrolledStudents?.length || 0}/{opportunity.capacity}
                        </div>
                      </div>
                      
                      {opportunity.requirements && (
                        <div className="requirements">
                          <strong>Requirements:</strong> {opportunity.requirements}
                        </div>
                      )}
                      
                      <button 
                        onClick={() => handleEnroll(opportunity._id)}
                        className="btn btn-primary btn-sm"
                        disabled={
                          loading || 
                          (opportunity.enrolledStudents?.length >= opportunity.capacity) ||
                          (opportunity.enrolledStudents?.includes(localStorage.getItem('userId')))
                        }
                      >
                        {loading ? 'Processing...' : 'Enroll'}
                      </button>
                    </div>
                  ))}
                </div>
              ) : (
                <div>No opportunities available from this partnership yet.</div>
              )}
            </div>
            
            <div className="projects-section">
              <h3>Active Projects</h3>
              
              {selectedPartnership.activeProjects?.length > 0 ? (
                <div className="projects-list">
                  {selectedPartnership.activeProjects.map(project => (
                    <div key={project._id} className="project-card">
                      <h4>{project.title}</h4>
                      <div className="project-status">{project.status}</div>
                      <p>{project.description}</p>
                      
                      <div className="project-details">
                        <div>
                          <strong>Dates:</strong> {new Date(project.startDate).toLocaleDateString()} - 
                          {project.endDate ? new Date(project.endDate).toLocaleDateString() : 'Ongoing'}
                        </div>
                        <div>
                          <strong>Participants:</strong> {project.participants?.length || 0}
                        </div>
                      </div>
                      
                      {/* Join project button would go here */}
                    </div>
                  ))}
                </div>
              ) : (
                <div>No active projects from this partnership yet.</div>
              )}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default PartnershipPage;
