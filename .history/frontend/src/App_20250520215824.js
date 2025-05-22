import React from 'react';
import { BrowserRouter as Router, Routes, Route, Link, Navigate } from 'react-router-dom';
import { AuthProvider, useAuth } from './context/AuthContext';
import LoginPage from './pages/LoginPage';
import SignupPage from './pages/SignupPage';
import HelpRequestList from './pages/HelpRequestListPage';
import CreateHelpRequestPage from './pages/CreateHelpRequestPage';
import HelpRequestDetailPage from './pages/HelpRequestDetailPage';
import CreateHelpOfferPage from './pages/CreateHelpOfferPage';

function App() {
  const { user, logout, loading } = useAuth();

  if (loading) {
    return <div>Loading...</div>; // Or a proper spinner component
  }

  return (
    <Router>
      <nav>
        <ul>
          <li><Link to="/">Home</Link></li>
          {user ? (
            <>
              <li><Link to="/help-requests">View Help Requests</Link></li>
              <li><Link to="/create-help-request">Create Help Request</Link></li>
              <li><Link to="/create-help-offer">Create Help Offer</Link></li>
              <li><button onClick={logout}>Logout</button></li>
              {/* Display user info if available */}
              {user && user.name && <li>Logged in as: {user.name}</li>}
            </>
          ) : (
            <>
              <li><Link to="/login">Login</Link></li>
              <li><Link to="/signup">Sign Up</Link></li>
            </>
          )}
        </ul>
      </nav>
      <Routes>
        <Route path="/login" element={<LoginPage />} />
        <Route path="/signup" element={<SignupPage />} />
        
        {/* Protected Routes */}
        <Route 
          path="/help-requests" 
          element={user ? <HelpRequestList /> : <Navigate to="/login" />}
        />
        <Route 
          path="/help-requests/:id" 
          element={user ? <HelpRequestDetailPage /> : <Navigate to="/login" />}
        />
        <Route 
          path="/create-help-request" 
          element={user ? <CreateHelpRequestPage /> : <Navigate to="/login" />}
        />
        <Route 
          path="/create-help-offer" 
          element={user ? <CreateHelpOfferPage /> : <Navigate to="/login" />}
        />
        <Route 
          path="/" 
          element={user ? <Navigate to="/help-requests" /> : <Navigate to="/login" />}
        />
      </Routes>
    </Router>
  );
}

// Wrap App with AuthProvider so useAuth can be used within App
const AppWrapper = () => (
  <AuthProvider>
    <App />
  </AuthProvider>
);

export default AppWrapper;
