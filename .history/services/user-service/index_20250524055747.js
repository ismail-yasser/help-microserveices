require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const os = require('os'); // Import the 'os' module
const app = express();
const PORT = process.env.PORT || 3000;

// Remember MongoDB Atlas connection
const dbConnection = process.env.MONGO_URI;

const userRoutes = require('./routes/userRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('Connected to MongoDB'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.get('/', (req, res) => {
  res.status(200).json({
    message: 'User Service is running',
    hostname: os.hostname()
  });
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP', message: 'User Service is healthy', hostname: os.hostname() });
});

// Readiness check endpoint
app.get('/ready', (req, res) => {
  // Check MongoDB connection
  if (mongoose.connection.readyState === 1) {
    res.status(200).json({ status: 'READY', message: 'User Service is ready', hostname: os.hostname() });
  } else {
    res.status(503).json({ status: 'NOT READY', message: 'Database connection not ready', hostname: os.hostname() });
  }
});

// Use user routes
app.use('/api/users', userRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`User Service is running on port ${PORT}`);
});
