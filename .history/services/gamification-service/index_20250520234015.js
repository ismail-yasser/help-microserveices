require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const cors = require('cors');
const app = express();
const PORT = process.env.PORT || 3003;

const gamificationRoutes = require('./routes/gamificationRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI)
.then(() => console.log('Connected to MongoDB for Gamification Service'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());
app.use(cors());

// Routes
app.get('/', (req, res) => {
  res.send('Gamification Service is running');
});

// Use gamification routes
app.use('/api/gamification', gamificationRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`Gamification Service is running on port ${PORT}`);
});
