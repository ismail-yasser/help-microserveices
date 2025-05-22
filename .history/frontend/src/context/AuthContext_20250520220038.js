import React, { createContext, useState, useEffect, useContext } from 'react';
import api from '../services/api'; // Corrected path

const AuthContext = createContext(null);

export const AuthProvider = ({ children }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    const token = localStorage.getItem('token');
    if (token) {
      // You might want to verify the token with the backend here
      // For now, we'll assume if a token exists, the user might be logged in.
      // Fetch user data if token exists
      api.getCurrentUser().then(response => {
        setUser(response.data);
      }).catch(() => {
        // Token might be invalid or expired
        localStorage.removeItem('token');
        setUser(null);
      }).finally(() => {
        setLoading(false);
      });
    } else {
      setLoading(false);
    }
  }, []);

  const login = async (credentials) => {
    try {
      const response = await api.loginUser(credentials);
      localStorage.setItem('token', response.data.token);
      // Fetch user data after login
      const userResponse = await api.getCurrentUser();
      setUser(userResponse.data);
      return response;
    } catch (error) {
      console.error('Login failed:', error);
      throw error;
    }
  };

  const signup = async (userData) => {
    try {
      const response = await api.signupUser(userData);
      // Optionally log in the user directly after signup
      // localStorage.setItem('token', response.data.token);
      // setUser(response.data.user); // Assuming signup returns user and token
      return response;
    } catch (error) {
      console.error('Signup failed:', error);
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
    </AuthContext.Provider>
  );
};

export const useAuth = () => useContext(AuthContext);
