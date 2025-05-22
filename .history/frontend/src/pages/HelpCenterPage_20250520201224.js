import { useEffect, useState } from 'react';
import { 
  getHelpRequests, 
  createHelpRequest, 
  updateHelpStatus,
  searchHelpRequests,
  addResponse,
  assignHelper,
  uploadAttachment
} from '../services/helpService';
import { useNavigate } from 'react-router-dom';

function HelpCenterPage() {
  const [helpRequests, setHelpRequests] = useState([]);
  const [userProfile, setUserProfile] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [activeTab, setActiveTab] = useState('browse'); // browse, request, offer
  const [searchQuery, setSearchQuery] = useState('');
  const [searchTags, setSearchTags] = useState([]);
  const [selectedCourse, setSelectedCourse] = useState('');
  const [courses, setCourses] = useState([]); 
  
  // Fields for creating a new help request
  const [newRequest, setNewRequest] = useState({
    subject: '',
    description: '',
    courseId: '',
    urgency: 'medium',
    tags: [],
    requiredSkills: [],
    deadline: '',
    estimatedTimeInMinutes: 30,
    visibility: 'public'
  });
  
  // For file uploads
  const [selectedFile, setSelectedFile] = useState(null);
  
  const navigate = useNavigate();

  useEffect(() => {
    const fetchUserData = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          setError('You are not logged in.');
          setLoading(false);
          return;
        }
        
        // In a real implementation, you'd fetch user profile from your API
        setUserProfile({
          id: '123',
          name: 'John Doe',
          role: 'student',
          expertise: ['math', 'programming', 'physics']
        });
        
        // Fetch courses
        // In a real implementation, you'd fetch from your Canvas integration
        setCourses([
          { id: '101', name: 'Introduction to Programming' },
          { id: '102', name: 'Calculus I' },
          { id: '103', name: 'Physics for Engineers' }
        ]);
        
        await fetchHelpRequests(token);
      } catch (err) {
        setError('Failed to load user data.');
      } finally {
        setLoading(false);
      }
    };

    fetchUserData();
  }, []);

  const fetchHelpRequests = async (token, filters = {}) => {
    try {
      setLoading(true);
      let data;
      
      if (searchQuery || searchTags.length > 0 || selectedCourse) {
        data = await searchHelpRequests(token, {
          query: searchQuery,
          tags: searchTags,
          courseId: selectedCourse,
          type: 'request' // Only show requests in browse view
        });
      } else {
        data = await getHelpRequests(token, {
          type: 'request',
          status: 'open'
        });
      }
      
      setHelpRequests(Array.isArray(data) ? data : []);
    } catch (err) {
      setError('Failed to fetch help requests.');
    } finally {
      setLoading(false);
    }
  };

  const handleSearch = async () => {
    const token = localStorage.getItem('token');
    await fetchHelpRequests(token);
  };

  const handleAddTag = (tag) => {
    if (tag && !searchTags.includes(tag)) {
      setSearchTags([...searchTags, tag]);
    }
  };

  const handleRemoveTag = (tag) => {
    setSearchTags(searchTags.filter(t => t !== tag));
  };

  const handleSubmitRequest = async () => {
    try {
      const token = localStorage.getItem('token');
      
      // Validate required fields
      if (!newRequest.subject || !newRequest.description) {
        setError('Subject and description are required.');
        return;
      }
      
      // Create the help request
      const response = await createHelpRequest(token, newRequest);
      
      // If there's a file to upload and the request was created successfully
      if (selectedFile && response.helpRequest && response.helpRequest._id) {
        const formData = new FormData();
        formData.append('file', selectedFile);
        
        await uploadAttachment(token, response.helpRequest._id, {
          fileName: selectedFile.name,
          fileType: getFileType(selectedFile.name),
          fileUrl: 'placeholder' // In a real app, you'd get this from your file upload
        });
      }
      
      // Reset form and fetch updated list
      setNewRequest({
        subject: '',
        description: '',
        courseId: '',
        urgency: 'medium',
        tags: [],
        requiredSkills: [],
        deadline: '',
        estimatedTimeInMinutes: 30,
        visibility: 'public'
      });
      setSelectedFile(null);
      
      // Switch to browse tab and fetch updated requests
      setActiveTab('browse');
      await fetchHelpRequests(token);
      
    } catch (err) {
      setError('Failed to create help request.');
    }
  };

  const handleOfferHelp = async (requestId) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      
      // Navigate to help detail page
      navigate(`/help/${requestId}`);
      
    } catch (err) {
      setError('Failed to offer help.');
    }
  };

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setNewRequest({
      ...newRequest,
      [name]: value
    });
  };

  const handleTagInput = (e) => {
    if (e.key === 'Enter' && e.target.value) {
      if (!newRequest.tags.includes(e.target.value)) {
        setNewRequest({
          ...newRequest,
          tags: [...newRequest.tags, e.target.value]
        });
      }
      e.target.value = '';
    }
  };

  const handleSkillInput = (e) => {
    if (e.key === 'Enter' && e.target.value) {
      if (!newRequest.requiredSkills.includes(e.target.value)) {
        setNewRequest({
          ...newRequest,
          requiredSkills: [...newRequest.requiredSkills, e.target.value]
        });
      }
      e.target.value = '';
    }
  };

  const handleRemoveRequestTag = (tag) => {
    setNewRequest({
      ...newRequest,
      tags: newRequest.tags.filter(t => t !== tag)
    });
  };

  const handleRemoveRequestSkill = (skill) => {
    setNewRequest({
      ...newRequest,
      requiredSkills: newRequest.requiredSkills.filter(s => s !== skill)
    });
  };

  const handleFileChange = (e) => {
    setSelectedFile(e.target.files[0]);
  };

  // Helper function to determine file type
  const getFileType = (fileName) => {
    const ext = fileName.split('.').pop().toLowerCase();
    if (['doc', 'docx', 'txt', 'pdf'].includes(ext)) return 'document';
    if (['jpg', 'jpeg', 'png', 'gif'].includes(ext)) return 'image';
    if (['mp4', 'mov', 'avi'].includes(ext)) return 'video';
    if (['js', 'py', 'java', 'cpp', 'html', 'css', 'php'].includes(ext)) return 'code';
    if (['ppt', 'pptx'].includes(ext)) return 'presentation';
    return 'other';
  };

  if (loading) {
    return <p>Loading...</p>;
  }

  if (error) {
    return <p className="alert alert-danger">{error}</p>;
  }

  return (
    <div className="container mt-5">
      <h1 className="text-center">Help Center</h1>
      
      {/* Tab navigation */}
      <ul className="nav nav-tabs mb-4">
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'browse' ? 'active' : ''}`}
            onClick={() => setActiveTab('browse')}
          >
            Browse Help Requests
          </button>
        </li>
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'request' ? 'active' : ''}`}
            onClick={() => setActiveTab('request')}
          >
            Request Help
          </button>
        </li>
        <li className="nav-item">
          <button 
            className={`nav-link ${activeTab === 'my-requests' ? 'active' : ''}`}
            onClick={() => setActiveTab('my-requests')}
          >
            My Help Activity
          </button>
        </li>
      </ul>
      
      {/* Browse Help Requests Tab */}
      {activeTab === 'browse' && (
        <div>
          <div className="card mb-4">
            <div className="card-header">
              <h5>Search for Help</h5>
            </div>
            <div className="card-body">
              <div className="mb-3">
                <input
                  type="text"
                  className="form-control"
                  placeholder="Search by keyword"
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                />
              </div>
              
              <div className="row mb-3">
                <div className="col-md-6">
                  <label>Course</label>
                  <select 
                    className="form-select"
                    value={selectedCourse}
                    onChange={(e) => setSelectedCourse(e.target.value)}
                  >
                    <option value="">All Courses</option>
                    {courses.map(course => (
                      <option key={course.id} value={course.id}>{course.name}</option>
                    ))}
                  </select>
                </div>
                <div className="col-md-6">
                  <label>Add Tags (press Enter)</label>
                  <input
                    type="text"
                    className="form-control"
                    placeholder="Add a tag"
                    onKeyDown={(e) => {
                      if (e.key === 'Enter') {
                        handleAddTag(e.target.value);
                        e.target.value = '';
                      }
                    }}
                  />
                  <div className="mt-2">
                    {searchTags.map((tag) => (
                      <span key={tag} className="badge bg-info me-1">
                        {tag}
                        <button 
                          type="button" 
                          className="btn-close btn-close-white ms-1" 
                          style={{ fontSize: '0.5rem' }}
                          onClick={() => handleRemoveTag(tag)}
                        ></button>
                      </span>
                    ))}
                  </div>
                </div>
              </div>
              
              <button 
                className="btn btn-primary" 
                onClick={handleSearch}
              >
                Search
              </button>
            </div>
          </div>
          
          <div className="row">
            {helpRequests.length === 0 ? (
              <div className="col-12">
                <p className="text-center">No help requests found.</p>
              </div>
            ) : (
              helpRequests.map((request) => (
                <div key={request._id} className="col-md-6 mb-3">
                  <div className="card h-100">
                    <div className="card-header d-flex justify-content-between align-items-center">
                      <h5 className="mb-0">{request.subject}</h5>
                      <span className={`badge bg-${request.urgency === 'high' ? 'danger' : request.urgency === 'medium' ? 'warning' : 'success'}`}>
                        {request.urgency}
                      </span>
                    </div>
                    <div className="card-body">
                      <p>{request.description.length > 150 ? `${request.description.substring(0, 150)}...` : request.description}</p>
                      <div className="mb-2">
                        {request.tags.map((tag) => (
                          <span key={tag} className="badge bg-secondary me-1">{tag}</span>
                        ))}
                      </div>
                      <div className="mb-2">
                        <small className="text-muted">
                          Required skills: {request.requiredSkills?.join(', ') || 'None specified'}
                        </small>
                      </div>
                      <div className="d-flex justify-content-between align-items-center">
                        <div>
                          <small className="text-muted">Points: {request.pointsAwarded || 10}</small>
                        </div>
                        <button 
                          className="btn btn-outline-primary"
                          onClick={() => handleOfferHelp(request._id)}
                        >
                          Offer Help
                        </button>
                      </div>
                    </div>
                    <div className="card-footer text-muted">
                      {request.deadline ? `Deadline: ${new Date(request.deadline).toLocaleDateString()}` : 'No deadline'}
                      {request.estimatedTimeInMinutes && ` • Estimated: ${request.estimatedTimeInMinutes} min`}
                    </div>
                  </div>
                </div>
              ))
            )}
          </div>
        </div>
      )}
      
      {/* Request Help Tab */}
      {activeTab === 'request' && (
        <div className="card">
          <div className="card-header">
            <h5>Create Help Request</h5>
          </div>
          <div className="card-body">
            <div className="mb-3">
              <label className="form-label">Subject *</label>
              <input
                type="text"
                className="form-control"
                placeholder="Brief title describing your issue"
                name="subject"
                value={newRequest.subject}
                onChange={handleInputChange}
                required
              />
            </div>
            
            <div className="mb-3">
              <label className="form-label">Description *</label>
              <textarea
                className="form-control"
                placeholder="Describe your problem in detail"
                name="description"
                value={newRequest.description}
                onChange={handleInputChange}
                rows="5"
                required
              ></textarea>
            </div>
            
            <div className="row mb-3">
              <div className="col-md-6">
                <label className="form-label">Course</label>
                <select
                  className="form-select"
                  name="courseId"
                  value={newRequest.courseId}
                  onChange={handleInputChange}
                >
                  <option value="">Select Course</option>
                  {courses.map(course => (
                    <option key={course.id} value={course.id}>{course.name}</option>
                  ))}
                </select>
              </div>
              <div className="col-md-6">
                <label className="form-label">Urgency</label>
                <select
                  className="form-select"
                  name="urgency"
                  value={newRequest.urgency}
                  onChange={handleInputChange}
                >
                  <option value="low">Low</option>
                  <option value="medium">Medium</option>
                  <option value="high">High</option>
                </select>
              </div>
            </div>
            
            <div className="row mb-3">
              <div className="col-md-6">
                <label className="form-label">Tags (press Enter to add)</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Add tags related to your request"
                  onKeyDown={handleTagInput}
                />
                <div className="mt-2">
                  {newRequest.tags.map((tag) => (
                    <span key={tag} className="badge bg-secondary me-1">
                      {tag}
                      <button 
                        type="button" 
                        className="btn-close btn-close-white ms-1" 
                        style={{ fontSize: '0.5rem' }}
                        onClick={() => handleRemoveRequestTag(tag)}
                      ></button>
                    </span>
                  ))}
                </div>
              </div>
              <div className="col-md-6">
                <label className="form-label">Required Skills (press Enter to add)</label>
                <input
                  type="text"
                  className="form-control"
                  placeholder="Skills needed to help with this"
                  onKeyDown={handleSkillInput}
                />
                <div className="mt-2">
                  {newRequest.requiredSkills.map((skill) => (
                    <span key={skill} className="badge bg-info me-1">
                      {skill}
                      <button 
                        type="button" 
                        className="btn-close btn-close-white ms-1" 
                        style={{ fontSize: '0.5rem' }}
                        onClick={() => handleRemoveRequestSkill(skill)}
                      ></button>
                    </span>
                  ))}
                </div>
              </div>
            </div>
            
            <div className="row mb-3">
              <div className="col-md-6">
                <label className="form-label">Deadline (optional)</label>
                <input
                  type="date"
                  className="form-control"
                  name="deadline"
                  value={newRequest.deadline}
                  onChange={handleInputChange}
                  min={new Date().toISOString().split('T')[0]}
                />
              </div>
              <div className="col-md-6">
                <label className="form-label">Estimated Time (minutes)</label>
                <input
                  type="number"
                  className="form-control"
                  placeholder="How long will this take to help with?"
                  name="estimatedTimeInMinutes"
                  value={newRequest.estimatedTimeInMinutes}
                  onChange={handleInputChange}
                  min="5"
                  max="240"
                />
              </div>
            </div>
            
            <div className="mb-3">
              <label className="form-label">File Attachment (optional)</label>
              <input
                type="file"
                className="form-control"
                onChange={handleFileChange}
              />
              {selectedFile && (
                <div className="mt-2">
                  <span className="badge bg-primary">
                    {selectedFile.name}
                  </span>
                </div>
              )}
            </div>
            
            <div className="mb-3">
              <label className="form-label">Visibility</label>
              <select
                className="form-select"
                name="visibility"
                value={newRequest.visibility}
                onChange={handleInputChange}
              >
                <option value="public">Public (anyone can see)</option>
                <option value="course">Course Only (only course members)</option>
                <option value="private">Private (only assigned helpers)</option>
              </select>
            </div>
            
            <div className="mb-3">
              <p className="text-info">
                <i className="bi bi-info-circle me-2"></i>
                You'll earn {calculatePoints(newRequest.urgency, newRequest.estimatedTimeInMinutes)} points when someone helps you!
              </p>
            </div>
            
            <button 
              className="btn btn-primary" 
              onClick={handleSubmitRequest}
              disabled={!newRequest.subject || !newRequest.description}
            >
              Submit Help Request
            </button>
          </div>
        </div>
      )}
      
      {/* My Help Activity Tab */}
      {activeTab === 'my-requests' && (
        <div>
          <p>My help activity content will go here...</p>
        </div>
      )}
    </div>
  );
}

// Helper function to calculate points (matches backend logic)
function calculatePoints(urgency, estimatedTimeInMinutes = 30) {
  const basePoints = 10;
  const urgencyMultiplier = {
    'low': 1,
    'medium': 1.5,
    'high': 2
  };
  
  const timeMultiplier = Math.ceil(estimatedTimeInMinutes / 15); // 15-minute blocks
  
  return Math.round(basePoints * (urgencyMultiplier[urgency] || 1) * timeMultiplier);
}

export default HelpCenterPage;

export default HelpCenterPage;
