import React from 'react'; // Removed useContext as useAuth will be used
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  Navigate,
  useNavigate
} from 'react-router-dom';
import { useAuth } from './context/AuthContext'; // Correctly import useAuth
import LoginPage from './pages/LoginPage';
import SignupPage from './pages/SignupPage';
import HelpRequestListPage from './pages/HelpRequestListPage';
import HelpRequestDetailPage from './pages/HelpRequestDetailPage';
import CreateHelpRequestPage from './pages/CreateHelpRequestPage';
import CreateHelpOfferPage from './pages/CreateHelpOfferPage';
import './App.css'; // General App styles
import { ThemeProvider } from '@mui/material/styles';
import CssBaseline from '@mui/material/CssBaseline';
import theme from './theme';

// Material-UI Components
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu';
import Container from '@mui/material/Container';
import Avatar from '@mui/material/Avatar';
import Drawer from '@mui/material/Drawer';
import List from '@mui/material/List';
import ListItem from '@mui/material/ListItem';
import ListItemIcon from '@mui/material/ListItemIcon';
import ListItemText from '@mui/material/ListItemText';
import ListItemAvatar from '@mui/material/ListItemAvatar';
import Divider from '@mui/material/Divider';
import LogoutIcon from '@mui/icons-material/Logout';
import ListIcon from '@mui/icons-material/List';
import AddIcon from '@mui/icons-material/Add';

function ProtectedRoute({ children }) {
  const { user, loading } = useAuth(); // Use the useAuth hook
  if (loading) return <Typography sx={{ textAlign: 'center', mt: 4 }}>Loading user session...</Typography>; // Or a spinner component
  return user ? children : <Navigate to="/login" replace />;
}

function Navigation() {
  const { user, logout } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();
  const [drawerOpen, setDrawerOpen] = React.useState(false);

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  const toggleDrawer = (open) => (event) => {
    if (event.type === 'keydown' && (event.key === 'Tab' || event.key === 'Shift')) {
      return;
    }
    setDrawerOpen(open);
  };

  return (
    <AppBar position="static" className="fade-in">
      <Toolbar>
        {user && (
          <IconButton
            size="large"
            edge="start"
            color="inherit"
            aria-label="menu"
            sx={{ mr: 2, display: { xs: 'block', md: 'none' } }}
            onClick={toggleDrawer(true)}
            className="slide-in-left"
          >
            <MenuIcon />
          </IconButton>
        )}
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          <Link to={user ? "/" : "/login"} style={{ textDecoration: 'none', color: 'inherit' }} className="fade-in">
            AIU Learning Hub
          </Link>
        </Typography>
        {user ? (
          <Box sx={{ display: { xs: 'none', md: 'flex' }, alignItems: 'center' }} className="slide-in-right">
            <Button color="inherit" component={Link} to="/requests" className="animated-card">Browse Requests</Button>
            <Button color="inherit" component={Link} to="/create-request" className="animated-card">Ask for Help</Button>
            <Button 
              color="inherit" 
              sx={{ ml: 1, display: 'flex', alignItems: 'center' }}
              className="avatar-with-badge"
            >
              <Avatar 
                sx={{ width: 28, height: 28, mr: 1, bgcolor: 'secondary.main' }}
                className="avatar-small"
              >
                {user.name ? user.name.charAt(0).toUpperCase() : 'U'}
              </Avatar>
              <span className="status-badge status-online"></span>
              {user.name || 'User'}
            </Button>
            <Button 
              color="inherit" 
              onClick={handleLogout}
              startIcon={<LogoutIcon />}
              sx={{ ml: 1 }}
              className="animated-card"
            >
              Logout
            </Button>
          </Box>
        ) : (
          <Box className="slide-in-right">
            <Button color="inherit" component={Link} to="/login" className="outline-button">Login</Button>
            <Button 
              component={Link} 
              to="/signup"
              sx={{ ml: 1 }}
              className="secondary-gradient-button"
            >
              Sign Up
            </Button>
          </Box>
        )}
      </Toolbar>
      
      {/* Mobile Drawer */}
      {user && (
        <Drawer
          anchor="left"
          open={drawerOpen}
          onClose={toggleDrawer(false)}
        >
          <Box
            sx={{ width: 250 }}
            role="presentation"
            onClick={toggleDrawer(false)}
            onKeyDown={toggleDrawer(false)}
            className="slide-in-left"
          >
            <List>
              <ListItem sx={{ py: 2, px: 3, bgcolor: 'primary.main', color: 'white' }}>
                <ListItemAvatar>
                  <Avatar sx={{ bgcolor: 'secondary.main' }} className="animated-card">
                    {user.name ? user.name.charAt(0).toUpperCase() : 'U'}
                  </Avatar>
                </ListItemAvatar>
                <ListItemText 
                  primary={<Typography variant="subtitle1">{user.name || 'User'}</Typography>}
                />
              </ListItem>
              <Divider />
              <ListItem button component={Link} to="/requests" className="animated-card">
                <ListItemIcon>
                  <ListIcon className="text-primary" />
                </ListItemIcon>
                <ListItemText primary="Browse Requests" />
              </ListItem>
              <ListItem button component={Link} to="/create-request" className="animated-card">
                <ListItemIcon>
                  <AddIcon className="text-primary" />
                </ListItemIcon>
                <ListItemText primary="Ask for Help" />
              </ListItem>
              <Divider />
              <ListItem button onClick={handleLogout} className="animated-card">
                <ListItemIcon>
                  <LogoutIcon color="error" />
                </ListItemIcon>
                <ListItemText primary="Logout" />
              </ListItem>
            </List>
          </Box>
        </Drawer>
      )}
    </AppBar>
  );
}

function App() {
  return (
    <ThemeProvider theme={theme}>
      <CssBaseline />
      <Router>
        <Navigation />
        <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}>
          <Routes>
            <Route path="/login" element={<LoginPage />} />
            <Route path="/signup" element={<SignupPage />} />
            <Route 
              path="/requests" 
              element={<ProtectedRoute><HelpRequestListPage /></ProtectedRoute>} 
            />
            <Route 
              path="/request/:id" 
              element={<ProtectedRoute><HelpRequestDetailPage /></ProtectedRoute>} 
            />
            <Route 
              path="/create-request" 
              element={<ProtectedRoute><CreateHelpRequestPage /></ProtectedRoute>} 
            />
            <Route 
              path="/request/:id/create-offer" // This route might be handled by a dialog within HelpRequestDetailPage
              element={<ProtectedRoute><CreateHelpOfferPage /></ProtectedRoute>} 
            />
            <Route 
              path="/" 
              element={<ProtectedRoute><HelpRequestListPage /></ProtectedRoute>} 
            />
          </Routes>
        </Container>
      </Router>
    </ThemeProvider>
  );
}

export default App;
