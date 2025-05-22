// Get a specific help request/offer
exports.getHelpById = async (req, res) => {
  try {
    const helpItem = await Help.findById(req.params.id);
    
    if (!helpItem) {
      return res.status(404).send('Help item not found');
    }
    
    // Get user profile to add requester name
    let requesterName = 'Unknown User';
    try {
      const users = await getUserProfiles();
      const requester = users.find(u => 
        u._id && helpItem.userId && 
        u._id.toString() === helpItem.userId.toString()
      );
      
      if (requester) {
        requesterName = requester.name;
      }
    } catch (err) {
      console.error('Error fetching user profile for help item:', err);
    }
    
    // Convert to object and add requester name
    const helpItemObj = helpItem.toObject ? helpItem.toObject() : helpItem;
    
    res.status(200).json({
      ...helpItemObj,
      requestedBy: requesterName
    });
  } catch (error) {
    console.error('Error fetching help item by ID:', error);
    res.status(500).send('Error fetching help item');
  }
};
