import React, { useEffect, useState } from 'react'; // Removed useContext
import { Link } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext'; // Correctly import useAuth

// Material-UI Components
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemText from '@mui/material/ListItemText';
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import Paper from '@mui/material/Paper'; // For better visual grouping of items
import Divider from '@mui/material/Divider';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';

function HelpRequestListPage() {
  const [requests, setRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const { user } = useAuth(); // Use the useAuth hook

  useEffect(() => {
    const fetchRequests = async () => {
      try {
        setLoading(true);
        // Use the named export for getting all help requests
        const response = await api.getAllHelpRequests(); 
        setRequests(response.data);
        setError('');
      } catch (err) {
        setError(err.response?.data?.message || 'Failed to fetch help requests.');
        console.error('Fetch requests error:', err);
      } finally {
        setLoading(false);
      }
    };

    fetchRequests();
  }, []);

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

  return (
    <Container maxWidth="md" className="help-request-list">
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', my: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom>
          Help Requests
        </Typography>
        <Button variant="contained" color="primary" component={Link} to="/create-request">
          Create New Request
        </Button>
      </Box>

      {requests.length === 0 ? (
        <Typography variant="subtitle1" sx={{ textAlign: 'center', mt: 3 }}>
          No help requests available at the moment.
        </Typography>
      ) : (
        <List component={Paper} elevation={3}>
          {requests.map((request, index) => (
            <React.Fragment key={request._id}>
              <ListItem 
                alignItems="flex-start"
                button
                component={Link} 
                to={`/request/${request._id}`}
              >
                <ListItemText
                  primary={<Typography variant="h6">{request.title}</Typography>}
                  secondary={
                    <>
                      <Typography
                        sx={{ display: 'inline' }}
                        component="span"
                        variant="body2"
                        color="text.primary"
                      >
                        {request.course} - Status: {request.status}
                      </Typography>
                      {` — ${request.description.substring(0, 100)}...`}
                      <br />
                      <Typography variant="caption" color="text.secondary">
                        Requested by: {request.user?.name || 'Unknown User'} on {new Date(request.createdAt).toLocaleDateString()}
                      </Typography>
                    </>
                  }
                />
              </ListItem>
              {index < requests.length - 1 && <Divider component="li" />}
            </React.Fragment>
          ))}
        </List>
      )}
    </Container>
  );
}

export default HelpRequestListPage;
