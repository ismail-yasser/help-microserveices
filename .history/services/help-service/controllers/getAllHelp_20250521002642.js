// Get all help requests/offers
exports.getAllHelp = async (req, res) => {
  try {
    const { type, status } = req.query;
    const query = {};
    
    if (type) {
      query.type = type;
    }
    
    if (status) {
      query.status = status;
    }
    
    const helpItems = await Help.find(query).sort({ createdAt: -1 });
    
    // Get user profiles to add names
    let users = [];
    try {
      const response = await getUserProfiles();
      users = response || [];
    } catch (err) {
      console.error('Error fetching user profiles for help items:', err);
    }
    
    // Add requester name to each help item
    const enrichedHelpItems = helpItems.map(item => {
      const itemObj = item.toObject ? item.toObject() : item;
      const user = users.find(u => 
        u._id && itemObj.userId && 
        u._id.toString() === itemObj.userId.toString()
      );
      
      return {
        ...itemObj,
        requestedBy: user ? user.name : 'Unknown User'
      };
    });
    
    res.status(200).json(enrichedHelpItems);
  } catch (error) {
    console.error('Error getting help items:', error);
    res.status(500).send('Error getting help items');
  }
};
