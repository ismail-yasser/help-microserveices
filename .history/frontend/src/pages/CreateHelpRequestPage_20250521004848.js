import React, { useState } from 'react'; // Removed useContext
import { useNavigate } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext'; // Correctly import useAuth

// Material-UI Components
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Alert from '@mui/material/Alert';
import Paper from '@mui/material/Paper';
import Select from '@mui/material/Select';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import Grid from '@mui/material/Grid';
import Chip from '@mui/material/Chip';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardActions from '@mui/material/CardActions';
import Divider from '@mui/material/Divider';
import CloudUploadIcon from '@mui/icons-material/CloudUpload';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import SaveIcon from '@mui/icons-material/Save';
import FormHelperText from '@mui/material/FormHelperText';
import CircularProgress from '@mui/material/CircularProgress';
import Tooltip from '@mui/material/Tooltip';
import IconButton from '@mui/material/IconButton';
import DeleteIcon from '@mui/icons-material/Delete';

function CreateHelpRequestPage() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [course, setCourse] = useState('');
  const [tagInput, setTagInput] = useState('');
  const [tagList, setTagList] = useState([]);
  const [urgency, setUrgency] = useState('medium'); // Default urgency
  const [attachments, setAttachments] = useState([]); // State for files
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const [isSubmitting, setIsSubmitting] = useState(false);
  const { user } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();

  const handleFileChange = (e) => {
    setAttachments(Array.from(e.target.files)); // Store an array of selected files
  };

  const handleTagInputChange = (e) => {
    setTagInput(e.target.value);
  };

  const handleTagInputKeyDown = (e) => {
    if (e.key === 'Enter' && tagInput.trim()) {
      e.preventDefault();
      addTag(tagInput.trim());
    }
  };

  const addTag = (tag) => {
    if (tag && !tagList.includes(tag)) {
      setTagList([...tagList, tag]);
    }
    setTagInput('');
  };

  const handleDeleteTag = (tagToDelete) => {
    setTagList(tagList.filter(tag => tag !== tagToDelete));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');
    setIsSubmitting(true);

    if (!user) {
      setError("You must be logged in to create a help request.");
      setIsSubmitting(false);
      return;
    }

    // Validation
    if (!title.trim()) {
      setError("Title is required");
      setIsSubmitting(false);
      return;
    }
    
    if (!description.trim()) {
      setError("Description is required");
      setIsSubmitting(false);
      return;
    }
    
    if (!course.trim()) {
      setError("Course is required");
      setIsSubmitting(false);
      return;
    }

    const formData = new FormData();
    formData.append('title', title);
    formData.append('description', description);
    formData.append('course', course);
    formData.append('tags', tagList.join(',')); // Join the tagList array into a comma-separated string
    formData.append('urgency', urgency);

    // Add each file to formData
    attachments.forEach((file, index) => {
      formData.append(`attachment${index}`, file);
    });

    try {
      const response = await api.createHelpRequest(formData);
      setSuccess('Help request created successfully!');
      
      // Reset form
      setTitle('');
      setDescription('');
      setCourse('');
      setTagInput('');
      setTagList([]);
      setUrgency('medium');
      setAttachments([]);
      
      // Navigate to the new request page after a brief delay
      setTimeout(() => {
        navigate(`/request/${response.data._id}`);
      }, 1500);
    } catch (err) {
      console.error('Create request error:', err);
      setError(err.response?.data?.message || 'Failed to create help request.');
    } finally {
      setIsSubmitting(false);
    }
  };

  return (
    <Container maxWidth="md" className="create-help-request fade-in">
      <Box sx={{ mt: 4, mb: 4 }}>
        <Button 
          startIcon={<ArrowBackIcon />} 
          onClick={() => navigate('/requests')}
          sx={{ mb: 3 }}
          className="outline-button"
        >
          Back to Requests
        </Button>
        
        <Typography variant="h4" component="h1" gutterBottom className="page-header">
          Create Help Request
        </Typography>

        {error && <Alert severity="error" sx={{ mb: 2 }} className="slide-in-up">{error}</Alert>}
        {success && <Alert severity="success" sx={{ mb: 2 }} className="slide-in-up">{success}</Alert>}
        
        <Card elevation={3} className="animated-card">
          <CardContent>
            <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
              <Grid container spacing={3}>
                {/* Title */}
                <Grid item xs={12}>
                  <div className="custom-form-control">
                    <TextField
                      required
                      fullWidth
                      id="title"
                      label="Title"
                      name="title"
                      value={title}
                      onChange={(e) => setTitle(e.target.value)}
                      placeholder="E.g., Need help with Calculus homework"
                      variant="outlined"
                      className="custom-input"
                    />
                    <FormHelperText className="form-helper-text">Be specific and concise</FormHelperText>
                  </div>
                </Grid>
                
                {/* Course */}
                <Grid item xs={12} sm={6}>
                  <div className="custom-form-control">
                    <TextField
                      required
                      fullWidth
                      id="course"
                      label="Course"
                      name="course"
                      value={course}
                      onChange={(e) => setCourse(e.target.value)}
                      placeholder="E.g., Math 101"
                      variant="outlined"
                      className="custom-input"
                    />
                  </div>
                </Grid>
                
                {/* Urgency */}
                <Grid item xs={12} sm={6}>
                  <div className="custom-form-control">
                    <FormControl fullWidth required>
                      <InputLabel id="urgency-label">Urgency</InputLabel>
                      <Select
                        labelId="urgency-label"
                        id="urgency"
                        value={urgency}
                        label="Urgency"
                        onChange={(e) => setUrgency(e.target.value)}
                        className="custom-input"
                      >
                        <MenuItem value="low">Low</MenuItem>
                        <MenuItem value="medium">Medium</MenuItem>
                        <MenuItem value="high">High</MenuItem>
                      </Select>
                    </FormControl>
                  </div>
                </Grid>
                      onChange={(e) => setUrgency(e.target.value)}
                    >
                      <MenuItem value="low">Low</MenuItem>
                      <MenuItem value="medium">Medium</MenuItem>
                      <MenuItem value="high">High</MenuItem>
                    </Select>
                  </FormControl>
                </Grid>
                
                {/* Description */}
                <Grid item xs={12}>
                  <TextField
                    required
                    fullWidth
                    id="description"
                    label="Description"
                    name="description"
                    value={description}
                    onChange={(e) => setDescription(e.target.value)}
                    placeholder="Describe your problem in detail..."
                    multiline
                    rows={5}
                    variant="outlined"
                  />
                </Grid>
                
                {/* Tags */}
                <Grid item xs={12}>
                  <TextField
                    fullWidth
                    id="tags"
                    label="Tags"
                    name="tags"
                    value={tagInput}
                    onChange={handleTagInputChange}
                    onKeyDown={handleTagInputKeyDown}
                    placeholder="Add tags and press Enter (e.g., calculus, homework)"
                    variant="outlined"
                    helperText="Press Enter to add a tag"
                  />
                  {tagList.length > 0 && (
                    <Box sx={{ display: 'flex', flexWrap: 'wrap', gap: 0.5, mt: 1 }}>
                      {tagList.map((tag) => (
                        <Chip
                          key={tag}
                          label={tag}
                          onDelete={() => handleDeleteTag(tag)}
                          color="primary"
                          variant="outlined"
                          size="small"
                        />
                      ))}
                    </Box>
                  )}
                </Grid>
                
                {/* File Upload */}
                <Grid item xs={12}>
                  <Box sx={{ border: '1px dashed #ccc', p: 3, borderRadius: 1, textAlign: 'center' }}>
                    <input
                      type="file"
                      multiple
                      onChange={handleFileChange}
                      style={{ display: 'none' }}
                      id="file-upload"
                    />
                    <label htmlFor="file-upload">
                      <Button
                        variant="outlined"
                        component="span"
                        startIcon={<CloudUploadIcon />}
                      >
                        Upload Attachments
                      </Button>
                    </label>
                    <FormHelperText>Upload any relevant documents or images</FormHelperText>
                    
                    {attachments.length > 0 && (
                      <Box sx={{ mt: 2 }}>
                        <Typography variant="subtitle2" gutterBottom>
                          Selected Files ({attachments.length}):
                        </Typography>
                        <Paper variant="outlined" sx={{ p: 1 }}>
                          {attachments.map((file, index) => (
                            <Box 
                              key={index} 
                              sx={{ 
                                display: 'flex', 
                                justifyContent: 'space-between', 
                                alignItems: 'center',
                                mb: 0.5
                              }}
                            >
                              <Typography variant="body2" noWrap sx={{ maxWidth: '80%' }}>
                                {file.name} ({(file.size / 1024).toFixed(1)} KB)
                              </Typography>
                              <Tooltip title="Remove file">
                                <IconButton 
                                  size="small" 
                                  onClick={() => setAttachments(attachments.filter((_, i) => i !== index))}
                                >
                                  <DeleteIcon fontSize="small" />
                                </IconButton>
                              </Tooltip>
                            </Box>
                          ))}
                        </Paper>
                      </Box>
                    )}
                  </Box>
                </Grid>
              </Grid>
            </Box>
          </CardContent>
          <Divider />
          <CardActions sx={{ justifyContent: 'flex-end', p: 2 }}>
            <Button 
              variant="outlined" 
              onClick={() => navigate('/requests')}
              sx={{ mr: 1 }}
            >
              Cancel
            </Button>
            <Button 
              type="submit"
              variant="contained" 
              color="primary"
              onClick={handleSubmit}
              disabled={isSubmitting}
              startIcon={isSubmitting ? <CircularProgress size={20} /> : <SaveIcon />}
            >
              {isSubmitting ? 'Submitting...' : 'Create Request'}
            </Button>
          </CardActions>
        </Card>
      </Box>
    </Container>
  );
}

export default CreateHelpRequestPage;
