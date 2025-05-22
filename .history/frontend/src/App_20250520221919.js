import React, { useContext } from 'react';
import {
  BrowserRouter as Router,
  Routes,
  Route,
  Link,
  Navigate,
  useNavigate
} from 'react-router-dom';
import { AuthContext, AuthProvider } from './context/AuthContext';
import LoginPage from './pages/LoginPage';
import SignupPage from './pages/SignupPage';
import HelpRequestListPage from './pages/HelpRequestListPage';
import HelpRequestDetailPage from './pages/HelpRequestDetailPage';
import CreateHelpRequestPage from './pages/CreateHelpRequestPage';
import CreateHelpOfferPage from './pages/CreateHelpOfferPage';
import './App.css'; // General App styles

// Material-UI Components
import AppBar from '@mui/material/AppBar';
import Box from '@mui/material/Box';
import Toolbar from '@mui/material/Toolbar';
import Typography from '@mui/material/Typography';
import Button from '@mui/material/Button';
import IconButton from '@mui/material/IconButton';
import MenuIcon from '@mui/icons-material/Menu'; // Example Icon
import Container from '@mui/material/Container';

function ProtectedRoute({ children }) {
  const { user, loading } = useContext(AuthContext);
  if (loading) return <p>Loading...</p>; // Or a spinner
  return user ? children : <Navigate to="/login" />;
}

function Navigation() {
  const { user, logout } = useContext(AuthContext);
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
          <Link to="/" style={{ textDecoration: 'none', color: 'inherit' }}>Help Platform</Link>
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
      <Container maxWidth="lg" sx={{ mt: 4, mb: 4 }}> {/* Added Material-UI Container for better layout */}
        <Routes>
          <Route path="/login" element={<LoginPage />} />
          <Route path="/signup" element={<SignupPage />} />
          <Route path="/requests" element={<ProtectedRoute><HelpRequestListPage /></ProtectedRoute>} />
          <Route path="/request/:id" element={<ProtectedRoute><HelpRequestDetailPage /></ProtectedRoute>} />
          <Route path="/create-request" element={<ProtectedRoute><CreateHelpRequestPage /></ProtectedRoute>} />
          <Route path="/request/:id/create-offer" element={<ProtectedRoute><CreateHelpOfferPage /></ProtectedRoute>} />
          <Route path="/" element={<ProtectedRoute><HelpRequestListPage /></ProtectedRoute>} />
        </Routes>
      </Container>
    </Router>
  );
}

// It's good practice to wrap App with providers at the top level, usually in index.js
// However, if App is the root component passed to ReactDOM.render, ensure AuthProvider wraps it.
// For this example, assuming App is used as is, and AuthProvider is in index.js or a higher component.

export default App; // Ensure App is exported if AuthProvider is in index.js

// If you want to keep AuthProvider here for simplicity in this file, you can do:
// const AppWrapper = () => (
//   <AuthProvider>
//     <App />
//   </AuthProvider>
// );
// export default AppWrapper;
