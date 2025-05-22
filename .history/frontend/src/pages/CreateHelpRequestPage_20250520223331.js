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
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const { user } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!user) {
      setError("You must be logged in to create a help request.");
      return;
    }

    const helpRequestData = {
      title,
      description,
      course,
      tags: tags.split(',').map(tag => tag.trim()).filter(tag => tag !== ''), // Convert string to array
      urgency,
      // userId will be added by the backend via authMiddleware
    };

    try {
      await api.post('/help-requests', helpRequestData);
      setSuccess('Help request created successfully!');
      // Clear form
      setTitle('');
      setDescription('');
      setCourse('');
      setTags('');
      setUrgency('medium');
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
          {/* File input can be added here later - requires more complex handling */}
          {/* <Typography variant="body2" sx={{ mt: 1, mb: 1 }}>Attach files (optional):</Typography>
          <input type="file" multiple /> */}
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
