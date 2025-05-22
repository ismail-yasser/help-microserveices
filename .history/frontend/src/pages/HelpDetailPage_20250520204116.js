import React, { useEffect, useState } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import { 
  getHelpRequestById, 
  addResponse, 
  updateHelpStatus,
  assignHelper,
  scheduleMeeting,
  rateResponse,
  uploadAttachment
} from '../services/helpService';

function HelpDetailPage() {
  const { id } = useParams();
  const navigate = useNavigate();
  const [helpRequest, setHelpRequest] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [response, setResponse] = useState('');
  const [selectedFile, setSelectedFile] = useState(null);
  const [meetingData, setMeetingData] = useState({
    meetingUrl: '',
    meetingScheduled: ''
  });
  
  // Fetch help request data
  useEffect(() => {
    const fetchHelpRequest = async () => {
      try {
        const token = localStorage.getItem('token');
        if (!token) {
          setError('You are not logged in.');
          setLoading(false);
          return;
        }
        
        const data = await getHelpRequestById(token, id);
        setHelpRequest(data);
      } catch (err) {
        setError('Failed to fetch help request details.');
      } finally {
        setLoading(false);
      }
    };
    
    fetchHelpRequest();
  }, [id]);
  
  // Get user data
  const [currentUser, setCurrentUser] = useState(null);
  
  useEffect(() => {
    // In a real implementation, you'd fetch from your API
    setCurrentUser({
      id: '123',
      name: 'John Doe',
      role: 'student'
    });
  }, []);
  
  // Check if current user is the owner of the help request
  const isOwner = helpRequest && currentUser && helpRequest.userId === currentUser.id;
  
  // Check if current user is an assigned helper
  const isHelper = helpRequest && currentUser && 
    helpRequest.assignedHelpers && 
    helpRequest.assignedHelpers.includes(currentUser.id);
  
  // Submit a response
  const handleSubmitResponse = async () => {
    if (!response.trim()) return;
    
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      
      // Create response object
      const responseData = {
        content: response,
        attachments: []
      };
      
      // Add response
      const updatedHelp = await addResponse(token, id, responseData);
      setHelpRequest(updatedHelp);
      setResponse('');
      
      // If there's a file to upload
      if (selectedFile) {
        await uploadAttachment(token, id, {
          fileName: selectedFile.name,
          fileType: getFileType(selectedFile.name),
          fileUrl: 'placeholder' // In a real app, this would be a proper URL
        });
        
        setSelectedFile(null);
        
        // Refresh the help request data to show the attachment
        const refreshedData = await getHelpRequestById(token, id);
        setHelpRequest(refreshedData);
      }
      
    } catch (err) {
      setError('Failed to submit response.');
    }
  };
  
  // Update help request status
  const handleUpdateStatus = async (newStatus) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      
      const updatedHelp = await updateHelpStatus(token, id, newStatus);
      setHelpRequest(updatedHelp);
      
    } catch (err) {
      setError('Failed to update status.');
    }
  };
  
  // Schedule a meeting
  const handleScheduleMeeting = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      
      if (!meetingData.meetingUrl || !meetingData.meetingScheduled) {
        setError('Meeting URL and scheduled time are required.');
        return;
      }
      
      const updatedHelp = await scheduleMeeting(token, id, meetingData);
      setHelpRequest(updatedHelp);
      
    } catch (err) {
      setError('Failed to schedule meeting.');
    }
  };
  
  // Rate a response
  const handleRateResponse = async (responseId, rating, helpful) => {
    try {
      const token = localStorage.getItem('token');
      if (!token) {
        setError('You are not logged in.');
        return;
      }
      
      const updatedHelp = await rateResponse(token, id, responseId, rating, helpful);
      setHelpRequest(updatedHelp);
      
    } catch (err) {
      setError('Failed to rate response.');
    }
  };
  
  // Assign self as helper
  const handleVolunteerToHelp = async () => {
    try {
      const token = localStorage.getItem('token');
      if (!token || !currentUser) {
        setError('You are not logged in.');
        return;
      }
      
      const updatedHelp = await assignHelper(token, id, currentUser.id);
      setHelpRequest(updatedHelp);
      
    } catch (err) {
      setError('Failed to volunteer as helper.');
    }
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
  
  // Handle file selection
  const handleFileChange = (e) => {
    setSelectedFile(e.target.files[0]);
  };
  
  // Meeting data input handling
  const handleMeetingInputChange = (e) => {
    const { name, value } = e.target;
    setMeetingData({
      ...meetingData,
      [name]: value
    });
  };
  
  if (loading) {
    return <div className="container mt-5"><p>Loading...</p></div>;
  }
  
  if (error) {
    return (
      <div className="container mt-5">
        <div className="alert alert-danger" role="alert">
          {error}
        </div>
        <button 
          className="btn btn-primary" 
          onClick={() => navigate('/help')}
        >
          Back to Help Center
        </button>
      </div>
    );
  }
  
  if (!helpRequest) {
    return (
      <div className="container mt-5">
        <div className="alert alert-warning" role="alert">
          Help request not found.
        </div>
        <button 
          className="btn btn-primary" 
          onClick={() => navigate('/help')}
        >
          Back to Help Center
        </button>
      </div>
    );
  }
  
  return (
    <div className="container mt-5">
      <div className="mb-4">
        <button 
          className="btn btn-outline-secondary mb-3" 
          onClick={() => navigate('/help')}
        >
          &larr; Back to Help Center
        </button>
        
        <div className="card">
          <div className="card-header d-flex justify-content-between align-items-center">
            <h3 className="mb-0">{helpRequest.subject}</h3>
            <div>
              <span className={`badge bg-${
                helpRequest.status === 'open' ? 'success' : 
                helpRequest.status === 'in-progress' ? 'warning' :
                helpRequest.status === 'resolved' ? 'info' : 'secondary'
              } me-2`}>
                {helpRequest.status}
              </span>
              <span className={`badge bg-${
                helpRequest.urgency === 'high' ? 'danger' : 
                helpRequest.urgency === 'medium' ? 'warning' : 'success'
              }`}>
                {helpRequest.urgency}
              </span>
            </div>
          </div>
          
          <div className="card-body">
            <div className="mb-4">
              <h5>Description</h5>
              <p>{helpRequest.description}</p>
              
              <div className="mb-3">
                <h6>Tags</h6>
                <div>
                  {helpRequest.tags && helpRequest.tags.map((tag) => (
                    <span key={tag} className="badge bg-secondary me-1">{tag}</span>
                  ))}
                  {(!helpRequest.tags || helpRequest.tags.length === 0) && (
                    <span className="text-muted">No tags</span>
                  )}
                </div>
              </div>
              
              <div className="mb-3">
                <h6>Required Skills</h6>
                <div>
                  {helpRequest.requiredSkills && helpRequest.requiredSkills.map((skill) => (
                    <span key={skill} className="badge bg-info me-1">{skill}</span>
                  ))}
                  {(!helpRequest.requiredSkills || helpRequest.requiredSkills.length === 0) && (
                    <span className="text-muted">No specific skills required</span>
                  )}
                </div>
              </div>
              
              <div className="mb-3">
                <h6>Attachments</h6>
                <div>
                  {helpRequest.attachments && helpRequest.attachments.map((attachment, index) => (
                    <div key={index} className="badge bg-light text-dark me-2 p-2">
                      <i className={`bi bi-${
                        attachment.fileType === 'document' ? 'file-text' :
                        attachment.fileType === 'image' ? 'file-image' :
                        attachment.fileType === 'video' ? 'file-play' :
                        attachment.fileType === 'code' ? 'file-code' :
                        attachment.fileType === 'presentation' ? 'file-slides' :
                        'file'
                      } me-1`}></i>
                      {attachment.fileName}
                    </div>
                  ))}
                  {(!helpRequest.attachments || helpRequest.attachments.length === 0) && (
                    <span className="text-muted">No attachments</span>
                  )}
                </div>
              </div>
              
              <div className="row mb-3">
                <div className="col-md-6">
                  <h6>Points</h6>
                  <p>{helpRequest.pointsAwarded} points available for helping</p>
                </div>
                <div className="col-md-6">
                  <h6>Deadline</h6>
                  <p>
                    {helpRequest.deadline ? 
                      new Date(helpRequest.deadline).toLocaleDateString() : 
                      'No specific deadline'
                    }
                  </p>
                </div>
              </div>
              
              {/* Meeting Information (if scheduled) */}
              {helpRequest.meetingScheduled && (
                <div className="alert alert-info">
                  <h6>Scheduled Meeting</h6>
                  <p>
                    <strong>Date:</strong> {new Date(helpRequest.meetingScheduled).toLocaleString()}
                    <br />
                    <strong>Meeting Link:</strong> <a href={helpRequest.meetingUrl} target="_blank" rel="noreferrer">{helpRequest.meetingUrl}</a>
                  </p>
                </div>
              )}
            </div>
            
            {/* Action Buttons */}
            <div className="mb-4">
              {/* For the request owner */}
              {isOwner && (
                <div className="d-flex gap-2 mb-3">
                  {helpRequest.status !== 'resolved' && helpRequest.status !== 'closed' && (
                    <button 
                      className="btn btn-success"
                      onClick={() => handleUpdateStatus('resolved')}
                    >
                      Mark as Resolved
                    </button>
                  )}
                  {helpRequest.status !== 'closed' && (
                    <button 
                      className="btn btn-secondary"
                      onClick={() => handleUpdateStatus('closed')}
                    >
                      Close Request
                    </button>
                  )}
                </div>
              )}
              
              {/* For potential helpers */}
              {!isOwner && !isHelper && helpRequest.status === 'open' && (
                <button 
                  className="btn btn-primary mb-3"
                  onClick={handleVolunteerToHelp}
                >
                  Volunteer to Help
                </button>
              )}
              
              {/* For assigned helpers */}
              {isHelper && helpRequest.status === 'in-progress' && (
                <div className="d-flex gap-2 mb-3">
                  <button 
                    className="btn btn-outline-success"
                    onClick={() => handleUpdateStatus('resolved')}
                  >
                    Suggest as Resolved
                  </button>
                </div>
              )}
              
              {/* Schedule a meeting (for both owner and helpers) */}
              {(isOwner || isHelper) && helpRequest.status !== 'resolved' && helpRequest.status !== 'closed' && (
                <div className="card mb-3">
                  <div className="card-header">
                    <h6 className="mb-0">Schedule a Meeting</h6>
                  </div>
                  <div className="card-body">
                    <div className="row g-3">
                      <div className="col-md-6">
                        <label className="form-label">Meeting URL</label>
                        <input
                          type="text"
                          className="form-control"
                          placeholder="https://zoom.us/j/123456789"
                          name="meetingUrl"
                          value={meetingData.meetingUrl}
                          onChange={handleMeetingInputChange}
                        />
                      </div>
                      <div className="col-md-6">
                        <label className="form-label">Meeting Date & Time</label>
                        <input
                          type="datetime-local"
                          className="form-control"
                          name="meetingScheduled"
                          value={meetingData.meetingScheduled}
                          onChange={handleMeetingInputChange}
                          min={new Date().toISOString().slice(0, 16)}
                        />
                      </div>
                    </div>
                    <button 
                      className="btn btn-primary mt-3"
                      onClick={handleScheduleMeeting}
                      disabled={!meetingData.meetingUrl || !meetingData.meetingScheduled}
                    >
                      Schedule Meeting
                    </button>
                  </div>
                </div>
              )}
            </div>
            
            {/* Responses Section */}
            <div className="mb-4">
              <h5>Responses ({helpRequest.responses ? helpRequest.responses.length : 0})</h5>
              
              {helpRequest.responses && helpRequest.responses.length > 0 ? (
                <div className="list-group">
                  {helpRequest.responses.map((resp, index) => (
                    <div key={index} className="list-group-item">
                      <div className="d-flex justify-content-between align-items-start mb-2">
                        <strong>Response from User {resp.userId}</strong>
                        <small className="text-muted">
                          {new Date(resp.createdAt).toLocaleString()}
                        </small>
                      </div>
                      <p>{resp.content}</p>
                      
                      {/* Attachments */}
                      {resp.attachments && resp.attachments.length > 0 && (
                        <div className="mb-2">
                          <small className="text-muted">Attachments:</small>
                          <div className="mt-1">
                            {resp.attachments.map((attachment, idx) => (
                              <div key={idx} className="badge bg-light text-dark me-2 p-2">
                                <i className={`bi bi-${
                                  attachment.fileType === 'document' ? 'file-text' :
                                  attachment.fileType === 'image' ? 'file-image' :
                                  attachment.fileType === 'video' ? 'file-play' :
                                  attachment.fileType === 'code' ? 'file-code' :
                                  attachment.fileType === 'presentation' ? 'file-slides' :
                                  'file'
                                } me-1`}></i>
                                {attachment.fileName}
                              </div>
                            ))}
                          </div>
                        </div>
                      )}
                      
                      {/* Rating for request owner */}
                      {isOwner && !resp.rating && (
                        <div className="mt-2">
                          <div className="d-flex align-items-center gap-2">
                            <small className="text-muted">Rate this response:</small>
                            {[1, 2, 3, 4, 5].map((rating) => (
                              <button 
                                key={rating}
                                className="btn btn-sm btn-outline-warning"
                                onClick={() => handleRateResponse(resp._id, rating, true)}
                              >
                                {rating} ★
                              </button>
                            ))}
                            
                            <button 
                              className="btn btn-sm btn-outline-success ms-2"
                              onClick={() => handleRateResponse(resp._id, 4, true)}
                            >
                              Helpful
                            </button>
                            <button 
                              className="btn btn-sm btn-outline-danger"
                              onClick={() => handleRateResponse(resp._id, 1, false)}
                            >
                              Not Helpful
                            </button>
                          </div>
                        </div>
                      )}
                      
                      {/* Show rating if it exists */}
                      {resp.rating > 0 && (
                        <div className="mt-2">
                          <small className={`badge ${resp.helpful ? 'bg-success' : 'bg-danger'}`}>
                            {resp.helpful ? 'Marked as Helpful' : 'Not Helpful'} • 
                            {' '}Rating: {resp.rating} / 5
                          </small>
                        </div>
                      )}
                    </div>
                  ))}
                </div>
              ) : (
                <p className="text-muted">No responses yet.</p>
              )}
            </div>
            
            {/* Add Response Form */}
            {helpRequest.status !== 'resolved' && helpRequest.status !== 'closed' && (
              <div className="card">
                <div className="card-header">
                  <h5 className="mb-0">Add Your Response</h5>
                </div>
                <div className="card-body">
                  <div className="mb-3">
                    <textarea
                      className="form-control"
                      placeholder="Type your response here..."
                      value={response}
                      onChange={(e) => setResponse(e.target.value)}
                      rows="4"
                    ></textarea>
                  </div>
                  <div className="mb-3">
                    <label className="form-label">Attach File (Optional)</label>
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
                  <button 
                    className="btn btn-primary"
                    onClick={handleSubmitResponse}
                    disabled={!response.trim()}
                  >
                    Submit Response
                  </button>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
}

export default HelpDetailPage;
