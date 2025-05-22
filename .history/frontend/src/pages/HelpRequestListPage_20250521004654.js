import React, { useEffect, useState } from 'react';
import { Link } from 'react-router-dom';
import api from '../services/api';
import { useAuth } from '../context/AuthContext';

// Material-UI Components
import Typography from '@mui/material/Typography';
import Container from '@mui/material/Container';
import Button from '@mui/material/Button';
import Box from '@mui/material/Box';
import Paper from '@mui/material/Paper';
import CircularProgress from '@mui/material/CircularProgress';
import Alert from '@mui/material/Alert';
import Grid from '@mui/material/Grid';
import Card from '@mui/material/Card';
import CardContent from '@mui/material/CardContent';
import CardActions from '@mui/material/CardActions';
import Chip from '@mui/material/Chip';
import TextField from '@mui/material/TextField';
import MenuItem from '@mui/material/MenuItem';
import FormControl from '@mui/material/FormControl';
import InputLabel from '@mui/material/InputLabel';
import Select from '@mui/material/Select';
import IconButton from '@mui/material/IconButton';
import SearchIcon from '@mui/icons-material/Search';
import FilterListIcon from '@mui/icons-material/FilterList';
import Tooltip from '@mui/material/Tooltip';
import Collapse from '@mui/material/Collapse';
import SchoolIcon from '@mui/icons-material/School';
import AddIcon from '@mui/icons-material/Add';

function HelpRequestListPage() {
  const [requests, setRequests] = useState([]);
  const [filteredRequests, setFilteredRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [showFilters, setShowFilters] = useState(false);
  
  // Get auth context but only keep what we need
  // eslint-disable-next-line no-unused-vars
  const { user } = useAuth();

  useEffect(() => {
    const fetchRequests = async () => {
      try {
        setLoading(true);
        // Use the named export for getting all help requests
        const response = await api.getAllHelpRequests(); 
        setRequests(response.data);
        setFilteredRequests(response.data);
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

  useEffect(() => {
    // Filter requests based on search term and status filter
    let result = requests;
    
    if (searchTerm) {
      result = result.filter(
        request =>
          request.title.toLowerCase().includes(searchTerm.toLowerCase()) ||
          request.description.toLowerCase().includes(searchTerm.toLowerCase()) ||
          (request.course && request.course.toLowerCase().includes(searchTerm.toLowerCase()))
      );
    }
    
    if (statusFilter !== 'all') {
      result = result.filter(request => request.status === statusFilter);
    }
    
    setFilteredRequests(result);
  }, [requests, searchTerm, statusFilter]);

  const handleSearchChange = (event) => {
    setSearchTerm(event.target.value);
  };

  const handleStatusFilterChange = (event) => {
    setStatusFilter(event.target.value);
  };

  const toggleFilters = () => {
    setShowFilters(!showFilters);
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

  return (
    <Container maxWidth="md" className="help-request-list">
      <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', my: 4 }}>
        <Typography variant="h4" component="h1" gutterBottom className="page-header">
          Help Requests
        </Typography>
        <Button 
          component={Link} 
          to="/create-request"
          startIcon={<AddIcon />}
          className="gradient-button"
        >
          Create New Request
        </Button>
      </Box>

      {/* Search and Filters */}
      <Paper sx={{ p: 2, mb: 3 }} elevation={2} className="filter-container slide-in-up">
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', flex: 1 }}>
            <TextField
              label="Search requests"
              variant="outlined"
              size="small"
              fullWidth
              value={searchTerm}
              onChange={handleSearchChange}
              className="custom-input"
              InputProps={{
                endAdornment: (
                  <IconButton size="small">
                    <SearchIcon />
                  </IconButton>
                ),
              }}
            />
          </Box>
          <Tooltip title="Toggle filters">
            <IconButton onClick={toggleFilters} color="primary" className="animated-card">
              <FilterListIcon />
            </IconButton>
          </Tooltip>
        </Box>
        
        <Collapse in={showFilters}>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth variant="outlined" size="small" className="custom-form-control">
                <InputLabel>Status</InputLabel>
                <Select
                  value={statusFilter}
                  onChange={handleStatusFilterChange}
                  label="Status"
                >
                  <MenuItem value="all">All Statuses</MenuItem>
                  <MenuItem value="open">Open</MenuItem>
                  <MenuItem value="in-progress">In Progress</MenuItem>
                  <MenuItem value="closed">Closed</MenuItem>
                </Select>
              </FormControl>
            </Grid>
          </Grid>
        </Collapse>
      </Paper>

      {filteredRequests.length === 0 ? (
        <Paper sx={{ p: 4, textAlign: 'center' }} className="fade-in">
          <Typography variant="subtitle1" sx={{ mb: 2 }}>
            No help requests available with the current filters.
          </Typography>
          {searchTerm || statusFilter !== 'all' ? (
            <Button 
              onClick={() => { setSearchTerm(''); setStatusFilter('all'); }}
              className="outline-button"
            >
              Clear Filters
            </Button>
          ) : null}
        </Paper>
      ) : (
        <Grid container spacing={3} className="stagger-animation">
          {filteredRequests.map((request, index) => (
            <Grid item xs={12} key={request._id} style={{"--animation-order": index}} className="request-card-container">
              <Card className="help-request-card">
                <CardContent className="card-content">
                  <Typography variant="h6" component="h2" gutterBottom>
                    {request.title}
                  </Typography>
                  <Box sx={{ display: 'flex', alignItems: 'center', mb: 1 }}>
                    {request.course && (
                      <Chip 
                        icon={<SchoolIcon />} 
                        label={request.course} 
                        size="small" 
                        sx={{ mr: 1 }}
                      />
                    )}
                    <Chip 
                      label={request.status} 
                      size="small"
                      color={
                        request.status === 'open' ? 'primary' : 
                        request.status === 'in-progress' ? 'secondary' : 
                        'default'
                      }
                    />
                  </Box>
                  <Typography variant="body2" color="text.secondary" sx={{ mb: 2 }}>
                    {request.description.substring(0, 150)}
                    {request.description.length > 150 ? '...' : ''}
                  </Typography>
                  <Typography variant="caption" color="text.secondary" display="block">
                    Requested by: {request.requestedBy || request.user?.name || 'Unknown User'} 
                    <br />
                    {new Date(request.createdAt).toLocaleDateString()} at {new Date(request.createdAt).toLocaleTimeString()}
                  </Typography>
                </CardContent>
                <CardActions>
                  <Button 
                    size="small" 
                    color="primary" 
                    component={Link} 
                    to={`/request/${request._id}`}
                  >
                    View Details
                  </Button>
                </CardActions>
              </Card>
            </Grid>
          ))}
        </Grid>
      )}
    </Container>
  );
}

export default HelpRequestListPage;
