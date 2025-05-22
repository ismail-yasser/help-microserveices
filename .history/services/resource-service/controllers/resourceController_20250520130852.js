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

// Fetch all resources
exports.getAllResources = async (req, res) => {
  try {
    const resources = await Resource.find();
    res.status(200).json(resources);
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
