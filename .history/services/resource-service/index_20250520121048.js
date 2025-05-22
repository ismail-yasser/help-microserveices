require('dotenv').config();
const express = require('express');
const mongoose = require('mongoose');
const app = express();
const PORT = process.env.PORT || 3001;

const resourceRoutes = require('./routes/resourceRoutes');

// Connect to MongoDB
mongoose.connect(process.env.MONGO_URI, {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB for Resource Service'))
.catch((err) => console.error('Error connecting to MongoDB:', err));

// Middleware
app.use(express.json());

// Routes
app.use('/api/resources', resourceRoutes);

app.get('/', (req, res) => {
  res.send('Resource Service is running');
});

// Start the server
app.listen(PORT, () => {
  console.log(`Resource Service is running on port ${PORT}`);
});
