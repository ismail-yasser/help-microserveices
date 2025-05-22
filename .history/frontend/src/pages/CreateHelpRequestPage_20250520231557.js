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

function CreateHelpRequestPage() {
  const [title, setTitle] = useState('');
  const [description, setDescription] = useState('');
  const [course, setCourse] = useState('');
  const [tags, setTags] = useState(''); // Assuming tags are comma-separated strings for now
  const [urgency, setUrgency] = useState('medium'); // Default urgency
  const [attachments, setAttachments] = useState([]); // State for files
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const { user } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();

  const handleFileChange = (e) => {
    setAttachments(Array.from(e.target.files)); // Store an array of selected files
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!user) {
      setError("You must be logged in to create a help request.");
      return;
    }

    const formData = new FormData();
    formData.append('title', title);
    formData.append('description', description);
    formData.append('course', course);
    formData.append('tags', tags); // Send as comma-separated string, backend will parse
    formData.append('urgency', urgency);

    if (attachments.length > 0) {
      attachments.forEach(file => {
        formData.append('attachments', file); // Use 'attachments' as the field name (matches multer config)
      });
    }

    try {
      await api.createHelpRequest(formData); // Send formData
      setSuccess('Help request created successfully!');
      // Clear form
      setTitle('');
      setDescription('');
      setCourse('');
      setTags('');
      setUrgency('medium');
      setAttachments([]); // Clear selected files
      if (document.getElementById('attachments-input')) {
        document.getElementById('attachments-input').value = null;
      }
      setTimeout(() => navigate('/requests'), 2000); // Redirect after a short delay
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to create help request.');
      console.error('Create help request error:', err.response || err.message);
    }
  };

  return (
    <Container component="main" maxWidth="md" className="create-help-request-page">
      <Paper elevation={3} sx={{ p: 4, mt: 4 }}>
        <Typography component="h1" variant="h4" align="center" gutterBottom>
          Create New Help Request
        </Typography>
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
        {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
        <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            id="title"
            label="Title / Question Summary"
            name="title"
            autoFocus
            value={title}
            onChange={(e) => setTitle(e.target.value)}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            id="course"
            label="Course (e.g., CS101, MATH203)"
            name="course"
            value={course}
            onChange={(e) => setCourse(e.target.value)}
          />
          <TextField
            margin="normal"
            required
            fullWidth
            name="description"
            label="Detailed Description"
            id="description"
            multiline
            rows={6}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
          />
          <TextField
            margin="normal"
            fullWidth
            id="tags"
            label="Tags (comma-separated, e.g., javascript, arrays, homework)"
            name="tags"
            value={tags}
            onChange={(e) => setTags(e.target.value)}
          />
          <FormControl fullWidth margin="normal" required>
            <InputLabel id="urgency-label">Urgency</InputLabel>
            <Select
              labelId="urgency-label"
              id="urgency"
              value={urgency}
              label="Urgency"
              onChange={(e) => setUrgency(e.target.value)}
            >
              <MenuItem value="low">Low</MenuItem>
              <MenuItem value="medium">Medium</MenuItem>
              <MenuItem value="high">High</MenuItem>
            </Select>
          </FormControl>

          <Typography variant="body2" sx={{ mt: 2, mb: 1 }}>Attach files (optional, max 5 files, 10MB total):</Typography>
          <input 
            type="file" 
            multiple 
            id="attachments-input" // Added id for clearing
            onChange={handleFileChange} 
            accept=".jpg,.jpeg,.png,.gif,.pdf,.doc,.docx,.txt,.zip" // Example file types
            style={{ display: 'block', marginBottom: '16px' }} 
          />
          {attachments.length > 0 && (
            <Box sx={{mb: 2}}>
              <Typography variant="caption">Selected files:</Typography>
              <ul>
                {attachments.map((file, index) => (
                  <li key={index}><Typography variant="caption">{file.name} ({(file.size / 1024).toFixed(2)} KB)</Typography></li>
                ))}
              </ul>
            </Box>
          )}

          <Button
            type="submit"
            fullWidth
            variant="contained"
            sx={{ mt: 3, mb: 2 }}
          >
            Submit Request
          </Button>
        </Box>
      </Paper>
    </Container>
  );
}

export default CreateHelpRequestPage;
