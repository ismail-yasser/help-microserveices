const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

const userRoutes = require('./routes/userRoutes');

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.send('User Service is running');
});

// Use user routes
app.use('/api/users', userRoutes);

// Start the server
app.listen(PORT, () => {
  console.log(`User Service is running on port ${PORT}`);
});
