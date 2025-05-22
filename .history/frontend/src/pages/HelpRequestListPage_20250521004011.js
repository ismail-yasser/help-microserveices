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
import BookIcon from '@mui/icons-material/Book';

function HelpRequestListPage() {
  const [requests, setRequests] = useState([]);
  const [filteredRequests, setFilteredRequests] = useState([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState('');
  const [searchTerm, setSearchTerm] = useState('');
  const [statusFilter, setStatusFilter] = useState('all');
  const [showFilters, setShowFilters] = useState(false);
  const { user } = useAuth(); // Use the useAuth hook

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
        <Button 
          variant="contained" 
          color="primary" 
          component={Link} 
          to="/create-request"
          startIcon={<AddIcon />}
        >
          Create New Request
        </Button>
      </Box>

      {/* Search and Filters */}
      <Paper sx={{ p: 2, mb: 3 }} elevation={2}>
        <Box sx={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', mb: 2 }}>
          <Box sx={{ display: 'flex', alignItems: 'center', flex: 1 }}>
            <TextField
              label="Search requests"
              variant="outlined"
              size="small"
              fullWidth
              value={searchTerm}
              onChange={handleSearchChange}
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
            <IconButton onClick={toggleFilters} color="primary">
              <FilterListIcon />
            </IconButton>
          </Tooltip>
        </Box>
        
        <Collapse in={showFilters}>
          <Grid container spacing={2}>
            <Grid item xs={12} sm={6}>
              <FormControl fullWidth variant="outlined" size="small">
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
        <Paper sx={{ p: 4, textAlign: 'center' }}>
          <Typography variant="subtitle1" sx={{ mb: 2 }}>
            No help requests available with the current filters.
          </Typography>
          {searchTerm || statusFilter !== 'all' ? (
            <Button 
              variant="outlined" 
              onClick={() => { setSearchTerm(''); setStatusFilter('all'); }}
            >
              Clear Filters
            </Button>
          ) : null}
        </Paper>
      ) : (
        <Grid container spacing={3}>
          {filteredRequests.map((request) => (
            <Grid item xs={12} key={request._id}>
              <Card 
                sx={{ 
                  transition: 'all 0.3s ease', 
                  '&:hover': {
                    boxShadow: '0 8px 24px rgba(0,0,0,0.12)', 
                    transform: 'translateY(-4px)'
                  } 
                }}
              >
                <CardContent>
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
