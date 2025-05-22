const Resource = require('../models/resourceModel');

// Save a new resource to the database
exports.uploadResource = async (req, res) => {
  try {
    const { title, description, url, category } = req.body;
    const newResource = new Resource({ title, description, url, category });
    await newResource.save();
    res.status(201).json({ message: 'Resource uploaded successfully', resource: newResource });
  } catch (error) {
    res.status(500).json({ error: 'Failed to upload resource' });
  }
};

// Fetch all resources from the database
exports.getAllResources = async (req, res) => {
  try {
    const resources = await Resource.find();
    res.status(200).json(resources);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch resources' });
  }
};

// Fetch a specific resource by ID
exports.getResourceById = async (req, res) => {
  try {
    const resource = await Resource.findById(req.params.id);
    if (!resource) {
      return res.status(404).json({ error: 'Resource not found' });
    }
    res.status(200).json(resource);
  } catch (error) {
    res.status(500).json({ error: 'Failed to fetch resource' });
  }
};
