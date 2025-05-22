import React, { useEffect, useState, useCallback } from 'react'; // Removed useContext
import { useParams, useNavigate } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext'; // Correctly import useAuth

// Material-UI Components
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Box from '@mui/material/Box';
import Paper from '@mui/material/Paper';
import Button from '@mui/material/Button';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import Divider from '@mui/material/Divider';
import Chip from '@mui/material/Chip';
import Stack from '@mui/material/Stack';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';
import TextField from '@mui/material/TextField';
import Dialog from '@mui/material/Dialog';
import DialogActions from '@mui/material/DialogActions';
import DialogContent from '@mui/material/DialogContent';
import DialogContentText from '@mui/material/DialogContentText';
import DialogTitle from '@mui/material/DialogTitle';

function HelpRequestDetailPage() {
  const { id } = useParams();
  const [request, setRequest] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const { user } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();

  // For creating a new offer
  const [offerDescription, setOfferDescription] = useState('');
  const [offerError, setOfferError] = useState('');
  const [openOfferDialog, setOpenOfferDialog] = useState(false);

  // Function to handle accepting an offer
  const handleAcceptOffer = async (offerId) => {
    try {
      await api.acceptHelpOffer(id, offerId); // Assuming 'id' is requestId
      fetchRequestDetails(); // Refresh to show updated status
    } catch (err) {
      console.error('Error accepting offer:', err);
      setError(err.response?.data?.message || 'Failed to accept offer.');
    }
  };

  const fetchRequestDetails = useCallback(async () => {
    try {
      setLoading(true);
      const response = await api.getHelpRequestById(id);
      setRequest(response.data);
      setError('');
    } catch (err) {
      setError(err.response?.data?.message || 'Failed to fetch help request details.');
      console.error('Fetch request detail error:', err);
    } finally {
      setLoading(false);
    }
  }, [id]);

  useEffect(() => {
    fetchRequestDetails();
  }, [fetchRequestDetails]);

  const handleOpenOfferDialog = () => {
    setOpenOfferDialog(true);
  };

  const handleCloseOfferDialog = () => {
    setOpenOfferDialog(false);
    setOfferDescription('');
    setOfferError('');
  };

  const handleOfferSubmit = async () => {
    if (!offerDescription.trim()) {
      setOfferError('Offer description cannot be empty.');
      return;
    }
    setOfferError('');
    try {
      await api.createHelpOffer({ requestId: id, description: offerDescription, userId: user.id });
      fetchRequestDetails();
      handleCloseOfferDialog();
    } catch (err) {
      setOfferError(err.response?.data?.message || 'Failed to submit offer.');
      console.error('Submit offer error:', err);
    }
  };

  if (loading) {
    return (
      <Box sx={{ display: 'flex', justifyContent: 'center', alignItems: 'center', height: '50vh' }}>
        <CircularProgress />
      </Box>
    );
  }

  if (error) {
    return <Alert severity="error" sx={{ mt: 2 }}>{error}</Alert>;
  }

  if (!request) {
    return <Typography sx={{ textAlign: 'center', mt: 3 }}>Help request not found.</Typography>;
  }

  return (
    <Container maxWidth="lg" className="help-request-detail">
      <Paper elevation={3} sx={{ p: { xs: 2, md: 4 }, mt: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          {request.title}
        </Typography>
        <Stack direction="row" spacing={1} sx={{ mb: 2, flexWrap: 'wrap' }}>
          <Chip label={`Course: ${request.course}`} color="primary" variant="outlined" />
          <Chip label={`Status: ${request.status}`} color={request.status === 'open' ? 'success' : 'default'} />
          <Chip label={`Urgency: ${request.urgency}`} color="warning" variant="outlined" />
        </Stack>
        
        <Typography variant="body1" paragraph sx={{ whiteSpace: 'pre-wrap' }}>
          <strong>Description:</strong><br />
          {request.description}
        </Typography>

        {request.tags && request.tags.length > 0 && (
          <Box sx={{ mb: 2 }}>
            <strong>Tags:</strong>
            <Stack direction="row" spacing={1} sx={{ mt: 1, flexWrap: 'wrap' }}>
              {request.tags.map((tag) => (
                <Chip key={tag} label={tag} size="small" />
              ))}
            </Stack>
          </Box>
        )}

        <Typography variant="body2" color="text.secondary" sx={{ mb: 1 }}>
          Requested by: {request.requestedBy || request.user?.name || 'Unknown User'} on {new Date(request.createdAt).toLocaleString()}
        </Typography>

        {request.fileAttachments && request.fileAttachments.length > 0 && (
            <Box sx={{ my: 3 }}>
                <Typography variant="h6" gutterBottom component="div">File Attachments:</Typography>
                <List dense>
                    {request.fileAttachments.map((file, index) => (
                        <ListItem key={index} disablePadding>
                            <ListItemText 
                                primary={file.filename || `Attachment ${index + 1}`}
                                secondary={`Type: ${file.mimetype}, Size: ${(file.size / 1024).toFixed(2)} KB`}
                            />
                        </ListItem>
                    ))}
                </List>
            </Box>
        )}

        <Divider sx={{ my: 3 }} />

        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
            <Typography variant="h5" component="h2" gutterBottom>
            Help Offers ({request.offers ? request.offers.length : 0})
            </Typography>
            {user && request.userId !== user.id && request.status === 'open' && (
                <Button variant="contained" color="secondary" onClick={handleOpenOfferDialog}>
                    Offer Help
                </Button>
            )}
        </Box>

        {request.offers && request.offers.length > 0 ? (
          <List>
            {request.offers.map((offer) => (
              <Paper elevation={1} sx={{ p: 2, mb: 2, backgroundColor: '#f9f9f9' }} key={offer._id}>
                  <ListItemText 
                      primary={<Typography variant="subtitle1"><strong>Offer by:</strong> {offer.user?.name || 'Anonymous Helper' /* TODO: Fetch offer user details */}</Typography>}
                      secondary={
                          <>
                              <Typography variant="body2" sx={{ whiteSpace: 'pre-wrap', my:1 }}>{offer.description}</Typography>
                              <Typography variant="caption" color="text.secondary">Offered on: {new Date(offer.createdAt).toLocaleString()} | Status: {offer.status}</Typography>
                          </>
                      }
                  />
                  {user && request.userId === user.id && offer.status === 'pending' && (
                    <Button 
                        variant="outlined" 
                        size="small" 
                        onClick={() => handleAcceptOffer(offer._id)} 
                        sx={{ mt: 1 }}
                    >
                        Accept Offer
                    </Button>
                  )}
              </Paper>
            ))}
          </List>
        ) : (
          <Typography sx={{ textAlign: 'center', my: 3 }}>No offers yet for this request.</Typography>
        )}
      </Paper>

      <Dialog open={openOfferDialog} onClose={handleCloseOfferDialog} fullWidth maxWidth="sm">
        <DialogTitle>Make a Help Offer</DialogTitle>
        <DialogContent>
          <DialogContentText sx={{mb:2}}>
            Please provide a description of how you can help with this request.
          </DialogContentText>
          {offerError && <Alert severity="error" sx={{ mb: 2 }}>{offerError}</Alert>}
          <TextField
            autoFocus
            margin="dense"
            id="offerDescription"
            label="Offer Description"
            type="text"
            fullWidth
            multiline
            rows={4}
            variant="outlined"
            value={offerDescription}
            onChange={(e) => setOfferDescription(e.target.value)}
            error={!!offerError}
          />
        </DialogContent>
        <DialogActions sx={{p: '16px 24px'}}>
          <Button onClick={handleCloseOfferDialog}>Cancel</Button>
          <Button onClick={handleOfferSubmit} variant="contained">Submit Offer</Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
}

export default HelpRequestDetailPage;
