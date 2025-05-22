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
// import IconButton from '@mui/material/IconButton';
// import MenuIcon from '@mui/icons-material/Menu'; // Example Icon, commented out as not used for now
import Container from '@mui/material/Container';

function ProtectedRoute({ children }) {
  const { user, loading } = useAuth(); // Use the useAuth hook
  if (loading) return <Typography sx={{ textAlign: 'center', mt: 4 }}>Loading user session...</Typography>; // Or a spinner component
  return user ? children : <Navigate to="/login" replace />;
}

function Navigation() {
  const { user, logout } = useAuth(); // Use the useAuth hook
  const navigate = useNavigate();

  const handleLogout = () => {
    logout();
    navigate('/login');
  };

  return (
    <AppBar position="static">
      <Toolbar>
        {/* <IconButton
          size="large"
          edge="start"
          color="inherit"
          aria-label="menu"
          sx={{ mr: 2 }}
        >
          <MenuIcon />
        </IconButton> */}
        <Typography variant="h6" component="div" sx={{ flexGrow: 1 }}>
          <Link to={user ? "/" : "/login"} style={{ textDecoration: 'none', color: 'inherit' }}>
            Help Platform
          </Link>
        </Typography>
        {user ? (
          <Box sx={{ display: 'flex', alignItems: 'center' }}>
            <Button color="inherit" component={Link} to="/requests">View Requests</Button>
            <Button color="inherit" component={Link} to="/create-request">Create Request</Button>
            <Typography sx={{ mx: 2 }}>Welcome, {user.name || 'User'}!</Typography>
            <Button color="inherit" onClick={handleLogout}>Logout</Button>
          </Box>
        ) : (
          <Box>
            <Button color="inherit" component={Link} to="/login">Login</Button>
            <Button color="inherit" component={Link} to="/signup">Sign Up</Button>
          </Box>
        )}
      </Toolbar>
    </AppBar>
  );
}

function App() {
  return (
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
  );
}

export default App;
