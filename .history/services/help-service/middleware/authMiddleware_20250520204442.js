const jwt = require('jsonwebtoken');

// Middleware to validate JWT token
module.exports = (req, res, next) => {
  // For development/testing purposes only - remove in production
  if (process.env.NODE_ENV === 'development' || process.env.BYPASS_AUTH === 'true') {
    req.user = { id: 'test-user-id', role: 'student' };
    return next();
  }

  const authHeader = req.header('Authorization');
  if (!authHeader) {
    return res.status(401).send('Access denied. No token provided.');
  }

  // Extract token if format is "Bearer <token>"
  const token = authHeader.startsWith('Bearer ') ? authHeader.split(' ')[1] : authHeader;

  try {
    const decoded = jwt.verify(token, process.env.JWT_SECRET || 'your-secret-key');
    req.user = decoded;
    next();
  } catch (error) {
    res.status(400).send('Invalid token');
  }
};
