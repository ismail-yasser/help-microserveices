require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = process.env.PORT || 3002;

const helpRoutes = require('./routes/helpRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB for Help Service'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.send('Help Service is running');
});

// Use help routes
app.use('/api/help', helpRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`Help Service is running on port ${PORT}`);
});
