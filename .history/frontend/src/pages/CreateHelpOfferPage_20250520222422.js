import React, { useState, useContext } from 'react';
import { useParams, useNavigate } from 'react-router-dom';
import api from '../services/api';
import { AuthContext } from '../context/AuthContext';

// Material-UI Components
import Button from '@mui/material/Button';
import TextField from '@mui/material/TextField';
import Box from '@mui/material/Box';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Alert from '@mui/material/Alert';
import Paper from '@mui/material/Paper';

// This page might be redundant if offer creation is handled within HelpRequestDetailPage using a dialog.
// However, if a dedicated page is preferred:

function CreateHelpOfferPage() {
  const { id: requestId } = useParams(); // ID of the help request
  const [description, setDescription] = useState('');
  const [error, setError] = useState('');
  const [success, setSuccess] = useState('');
  const { user } = useContext(AuthContext);
  const navigate = useNavigate();

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setSuccess('');

    if (!user) {
      setError("You must be logged in to make an offer.");
      return;
    }
    if (!description.trim()) {
      setError("Offer description cannot be empty.");
      return;
    }

    try {
      await api.post(`/help-requests/${requestId}/offers`, { description });
      setSuccess('Help offer submitted successfully!');
      setDescription('');
      setTimeout(() => navigate(`/request/${requestId}`), 2000); // Redirect back to the request detail page
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to submit help offer.');
      console.error('Create help offer error:', err.response || err.message);
    }
  };

  return (
    <Container component="main" maxWidth="md" className="create-help-offer-page">
      <Paper elevation={3} sx={{ p: 4, mt: 4 }}>
        <Typography component="h1" variant="h4" align="center" gutterBottom>
          Make a Help Offer
        </Typography>
        <Typography variant="subtitle1" align="center" sx={{mb: 2}}>
          For request ID: {requestId}
        </Typography>
        {error && <Alert severity="error" sx={{ mb: 2 }}>{error}</Alert>}
        {success && <Alert severity="success" sx={{ mb: 2 }}>{success}</Alert>}
        <Box component="form" onSubmit={handleSubmit} noValidate sx={{ mt: 1 }}>
          <TextField
            margin="normal"
            required
            fullWidth
            name="description"
            label="Your Offer Description"
            id="description"
            multiline
            rows={6}
            value={description}
            onChange={(e) => setDescription(e.target.value)}
            autoFocus
          />
          <Button
            type="submit"
            fullWidth
            variant="contained"
            color="secondary" // Differentiate from primary action buttons
            sx={{ mt: 3, mb: 2 }}
          >
            Submit Offer
          </Button>
        </Box>
      </Paper>
    </Container>
  );
}

export default CreateHelpOfferPage;
