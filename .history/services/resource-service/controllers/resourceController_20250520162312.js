const Resource = require('../models/resourceModel');

// Save a new resource
exports.uploadResource = async (req, res) => {
  try {
    const resource = new Resource(req.body);
    await resource.save();
    res.status(201).send('Resource uploaded successfully');
  } catch (error) {
    res.status(500).send('Error uploading resource');
  }
};

// Fetch all resources with pagination and filtering
exports.getResources = async (req, res) => {
  try {
    const { page = 1, limit = 10, category } = req.query;

    const query = category ? { category: { $regex: category, $options: 'i' } } : {};

    const resources = await Resource.find(query)
      .skip((page - 1) * limit)
      .limit(parseInt(limit));

    const total = await Resource.countDocuments(query);

    res.status(200).json({
      total,
      page: parseInt(page),
      limit: parseInt(limit),
      resources,
    });
  } catch (error) {
    res.status(500).send('Error fetching resources');
  }
};

// Fetch a specific resource by ID
exports.getResourceById = async (req, res) => {
  try {
    const resource = await Resource.findById(req.params.id);
    if (!resource) return res.status(404).send('Resource not found');
    res.status(200).json(resource);
  } catch (error) {
    res.status(500).send('Error fetching resource');
  }
};
