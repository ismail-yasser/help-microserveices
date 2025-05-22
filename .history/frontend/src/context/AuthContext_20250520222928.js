import React, { createContext, useState, useEffect, useContext } from 'react';
import api from '../services/api';

// Create the context
const AuthContext = createContext(null);

// Export the Provider component
export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      const token = localStorage.getItem('token');
      if (token) {
        try {
          // Ensure the API client has the token for this request
          // This might be handled by an Axios interceptor in api.js already
          const response = await api.getCurrentUser(); // This should use the token from localStorage
          setUser(response.data);
        } catch (error) {
          console.error('Failed to fetch current user:', error);
          localStorage.removeItem('token');
          setUser(null);
        }
      } else {
        setUser(null); // Explicitly set user to null if no token
      }
      setLoading(false);
    };

    fetchUser();
  }, []); // Empty dependency array means this runs once on mount

  // Modified login function to accept token and then fetch user
  const login = async (token) => {
    localStorage.setItem('token', token);
    setLoading(true);
    try {
      const response = await api.getCurrentUser(); // Fetch user details with the new token
      setUser(response.data);
    } catch (error) {
      console.error('Failed to fetch user after login:', error);
      localStorage.removeItem('token'); // Clean up if user fetch fails
      setUser(null);
      throw error; // Re-throw error to be caught by the login page
    } finally {
      setLoading(false);
    }
  };

  // Signup function - can be expanded if direct login after signup is needed from here
  const signup = async (userData) => {
    try {
      // The API call is made in SignupPage.js, this function could be used for other logic
      // or if the API call for signup was to be centralized here.
      // For now, it doesn't need to do much if SignupPage handles token and navigation.
      console.log('Signup function in AuthContext called, but API call is in SignupPage.js');
      // Example: const response = await api.signupUser(userData);
      // return response;
    } catch (error) {
      console.error('Signup failed:', error);
      throw error;
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
    // Optionally, redirect here or let the component do it
  };

  return (
    <AuthContext.Provider value={{ user, setUser, login, signup, logout, loading }}>
      {children}
    </AuthContext.Provider>
  );
};

// Export the hook to use the context
export const useAuth = () => useContext(AuthContext);
