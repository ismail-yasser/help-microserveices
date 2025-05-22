const express = require('express');
const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(express.json());

// Routes
app.get('/', (req, res) => {
  res.send('User Service is running');
});

// Start the server
app.listen(PORT, () => {
  console.log(`User Service is running on port ${PORT}`);
});
