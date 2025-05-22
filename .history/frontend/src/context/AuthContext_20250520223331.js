import React, { createContext, useState, useEffect, useContext } from 'react';
import api from '../services/api';

// Create the context
const AuthContext = createContext(null); // Default value can be null

// Export the Provider component
export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const fetchUser = async () => {
      const token = localStorage.getItem('token');
      if (token) {
        try {
          const response = await api.getCurrentUser();
          setUser(response.data);
        } catch (error) {
          console.error('Failed to fetch current user:', error);
          localStorage.removeItem('token');
          setUser(null);
        }
      } else {
        setUser(null);
      }
      setLoading(false);
    };

    fetchUser();
  }, []);

  const login = async (token) => {
    localStorage.setItem('token', token);
    setLoading(true);
    try {
      const response = await api.getCurrentUser();
      setUser(response.data);
    } catch (error) {
      console.error('Failed to fetch user after login:', error);
      localStorage.removeItem('token');
      setUser(null);
      throw error;
    } finally {
      setLoading(false);
    }
  };

  const signup = async (userData) => {
    // This function is less critical now as SignupPage.js handles the API call and then calls login().
    // It can be kept for future use or removed if deemed unnecessary.
    try {
      console.log('AuthContext signup function called. API call is primarily in SignupPage.js.');
      // Example: const response = await api.signupUser(userData);
      // return response;
    } catch (error) {
      console.error('Signup context function error:', error);
      throw error;
    }
  };

  const logout = () => {
    localStorage.removeItem('token');
    setUser(null);
  };

  return (
    <AuthContext.Provider value={{ user, setUser, login, signup, logout, loading }}>
      {children}
    </AuthContext.Provider> // Corrected closing tag
  );
};

// Export the hook to use the context
export const useAuth = () => {
  const context = useContext(AuthContext);
  // Removed the check for context === undefined because createContext(null) is valid.
  // The error message indicates context IS null, meaning Provider is likely missing above.
  // If context is null, it means useAuth is used outside of AuthProvider.
  // The calling component should handle the possibility of context values being null initially if loading is true.
  return context;
};
