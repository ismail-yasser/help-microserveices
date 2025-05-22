require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3005;

const studyGroupRoutes = require('./routes/studyGroupRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('Connected to MongoDB for Study Group Service'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.get('/', (req, res) => {
  res.send('Study Group Service is running');
});

// Use study group routes
app.use('/api/groups', studyGroupRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`Study Group Service is running on port ${PORT}`);
});
