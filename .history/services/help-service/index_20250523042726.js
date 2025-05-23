require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3002;

const helpRoutes = require('./routes/helpRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('Connected to MongoDB for Help Service'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.get('/', (req, res) => {
  const dbStatus = mongoose.connection.readyState === 1 ? 'Connected to MongoDB' : 'Not connected to MongoDB';
  res.send(`Help Service is running. Database status: ${dbStatus}`);
});

// Health check endpoint
app.get('/health', (req, res) => {
  res.status(200).json({ status: 'UP', message: 'Help Service is healthy' });
});

// Readiness check endpoint
app.get('/ready', (req, res) => {
  // Check MongoDB connection
  if (mongoose.connection.readyState === 1) {
    res.status(200).json({ status: 'READY', message: 'Help Service is ready' });
  } else {
    res.status(503).json({ status: 'NOT READY', message: 'Database connection not ready' });
  }
});

// Use help routes
app.use('/api/help', helpRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`Help Service is running on port ${PORT}`);
});
