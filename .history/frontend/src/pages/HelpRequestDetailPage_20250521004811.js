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
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardActions from '@mui/material/CardActions';
import Grid from '@mui/material/Grid';
import Avatar from '@mui/material/Avatar';
import SchoolIcon from '@mui/icons-material/School';
import PriorityHighIcon from '@mui/icons-material/PriorityHigh';
import AccessTimeIcon from '@mui/icons-material/AccessTime';
import PersonIcon from '@mui/icons-material/Person';
import ArrowBackIcon from '@mui/icons-material/ArrowBack';
import CheckCircleIcon from '@mui/icons-material/CheckCircle';

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
        <CircularProgress className="pulse" />
      </Box>
    );
  }

  if (error) {
    return <Alert severity="error" sx={{ mt: 2 }} className="slide-in-up">{error}</Alert>;
  }

  if (!request) {
    return <Typography sx={{ textAlign: 'center', mt: 3 }} className="fade-in">Help request not found.</Typography>;
  }

  return (
    <Container maxWidth="lg" className="help-request-detail fade-in">
      <Box sx={{ display: 'flex', alignItems: 'center', mt: 3, mb: 3 }}>
        <Button 
          startIcon={<ArrowBackIcon />} 
          onClick={() => navigate('/requests')}
          sx={{ mr: 2 }}
          className="outline-button"
        >
          Back to Requests
        </Button>
        <Typography variant="h4" component="h1" className="page-header">
          Help Request Details
        </Typography>
      </Box>

      <Grid container spacing={4} className="stagger-animation">
        {/* Request Details Card */}
        <Grid item xs={12} md={8}>
          <Card elevation={3} className="help-request-card slide-in-left">
            <CardContent className="card-content">
              <Typography variant="h5" component="h2" gutterBottom>
                {request.title}
              </Typography>
              
              <Box sx={{ display: 'flex', alignItems: 'center', mb: 2 }}>
                <Avatar sx={{ mr: 1, bgcolor: 'primary.main' }} className="avatar-small">
                  <PersonIcon />
                </Avatar>
                <Typography variant="subtitle1">
                  {request.requestedBy || request.user?.name || 'Unknown User'}
                </Typography>
              </Box>
              
              <Stack direction="row" spacing={1} sx={{ mb: 3, flexWrap: 'wrap', gap: 1 }} className="tag-cloud">
                <Chip 
                  icon={<SchoolIcon />} 
                  label={`Course: ${request.course}`} 
                  className="request-badge badge-primary"
                />
                <Chip 
                  icon={<CheckCircleIcon />}
                  label={`Status: ${request.status}`} 
                  className={`request-badge ${
                    request.status === 'open' ? 'badge-success' : 
                    request.status === 'in-progress' ? 'badge-warning' : 
                    'badge-secondary'
                  }`}
                />
                <Chip 
                  icon={<PriorityHighIcon />}
                  label={`Urgency: ${request.urgency}`} 
                  className="request-badge badge-warning"
                />
                <Chip 
                  icon={<AccessTimeIcon />}
                  label={`Posted: ${new Date(request.createdAt).toLocaleDateString()}`} 
                  className="request-badge badge-info"
                />
              </Stack>
              
              <Typography variant="h6" gutterBottom>Description</Typography>
              <Typography variant="body1" paragraph sx={{ whiteSpace: 'pre-wrap' }}>
                {request.description}
              </Typography>
              
              {request.additionalInfo && (
                <>
                  <Typography variant="h6" gutterBottom>Additional Information</Typography>
                  <Typography variant="body1" paragraph sx={{ whiteSpace: 'pre-wrap' }}>
                    {request.additionalInfo}
                  </Typography>
                </>
              )}
              
              {request.status === 'open' && user && request.user?._id !== user.id && (
                <Button 
                  onClick={handleOpenOfferDialog}
                  sx={{ mt: 2 }}
                  className="gradient-button"
                >
                  Offer Help
                </Button>
              )}
            </CardContent>
          </Card>
        </Grid>

        {/* Help Offers Card */}
        <Grid item xs={12} md={4}>
          <Card elevation={3} className="help-request-card slide-in-right">
            <CardContent>
              <Typography variant="h6" gutterBottom className="card-header">
                Help Offers ({request.offers ? request.offers.length : 0})
              </Typography>
              
              {!request.offers || request.offers.length === 0 ? (
                <Typography variant="body2" color="text.secondary" className="p-3 text-center">
                  No offers yet. Be the first to help!
                </Typography>
              ) : (
                <List sx={{ width: '100%', bgcolor: 'background.paper' }} className="stagger-animation">
                  {request.offers.map((offer, index) => (
                    <React.Fragment key={offer._id}>
                      <ListItem alignItems="flex-start" className="comment">
                        <ListItemText
                          primary={
                            <Box sx={{ display: 'flex', alignItems: 'center' }} className="comment-header">
                              <Avatar sx={{ width: 24, height: 24, mr: 1, bgcolor: 'secondary.main' }} className="avatar-small">
                                {offer.user?.name ? offer.user.name.charAt(0).toUpperCase() : 'U'}
                              </Avatar>
                              <Typography variant="subtitle2" className="comment-author">
                                {offer.user?.name || 'Unknown Helper'}
                              </Typography>
                              <Typography variant="caption" color="text.secondary" className="comment-time">
                                {new Date(offer.createdAt).toLocaleDateString()}
                              </Typography>
                            </Box>
                          }
                          secondary={
                            <>
                              <Typography
                                variant="body2"
                                color="text.primary"
                                sx={{ mt: 1, mb: 1, whiteSpace: 'pre-wrap' }}
                                className="comment-content"
                              >
                                {offer.description}
                              </Typography>
                              {user && request.user?._id === user.id && request.status === 'open' && (
                                <Button 
                                  size="small" 
                                  onClick={() => handleAcceptOffer(offer._id)}
                                  sx={{ mt: 1 }}
                                  className="outline-button"
                                >
                                  Accept Offer
                                </Button>
                              )}
                            </>
                          }
                        />
                      </ListItem>
                      {index < request.offers.length - 1 && <Divider variant="inset" component="li" />}
                    </React.Fragment>
                  ))}
                </List>
              )}
            </CardContent>
          </Card>
        </Grid>
      </Grid>

      {/* Dialog for creating an offer */}
      <Dialog open={openOfferDialog} onClose={handleCloseOfferDialog}>
        <DialogTitle>Offer to Help</DialogTitle>
        <DialogContent>
          <DialogContentText>
            Describe how you can help with this request. Be specific about your knowledge and availability.
          </DialogContentText>
          <TextField
            autoFocus
            margin="dense"
            id="description"
            label="Your Offer"
            type="text"
            fullWidth
            multiline
            rows={4}
            variant="outlined"
            value={offerDescription}
            onChange={(e) => setOfferDescription(e.target.value)}
            error={!!offerError}
            helperText={offerError}
            className="custom-input custom-textarea"
          />
        </DialogContent>
        <DialogActions>
          <Button onClick={handleCloseOfferDialog} className="outline-button">Cancel</Button>
          <Button onClick={handleOfferSubmit} className="gradient-button">
            Submit Offer
          </Button>
        </DialogActions>
      </Dialog>
    </Container>
  );
}

export default HelpRequestDetailPage;
