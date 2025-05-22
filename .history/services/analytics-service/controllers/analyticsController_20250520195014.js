const { 
  UserAnalytics, 
  ResourceAnalytics, 
  HelpAnalytics,
  StudyGroupAnalytics,
  PartnershipAnalytics,
  SystemAnalytics
} = require('../models/analyticsModel');

// Record user activity
exports.recordUserActivity = async (req, res) => {
  try {
    const { userId, activity, details } = req.body;
    
    if (!userId || !activity) {
      return res.status(400).json({ message: 'userId and activity are required' });
    }
    
    let userAnalytics = await UserAnalytics.findOne({ userId });
    
    if (!userAnalytics) {
      userAnalytics = new UserAnalytics({ userId });
    }
    
    // Update analytics based on activity type
    userAnalytics.lastActive = new Date();
    
    switch (activity) {
      case 'login':
        userAnalytics.loginCount += 1;
        break;
        
      case 'page_view':
        if (details && details.page) {
          const pageViews = userAnalytics.pageViews || {};
          pageViews[details.page] = (pageViews[details.page] || 0) + 1;
          userAnalytics.pageViews = pageViews;
        }
        break;
        
      case 'resource_view':
        if (details && details.resourceId) {
          if (!userAnalytics.resourcesViewed.includes(details.resourceId)) {
            userAnalytics.resourcesViewed.push(details.resourceId);
          }
          
          // Update resource analytics
          await this.updateResourceAnalytics(details.resourceId, userId, 'view');
        }
        break;
        
      case 'resource_create':
        if (details && details.resourceId) {
          userAnalytics.resourcesCreated.push(details.resourceId);
        }
        break;
        
      case 'help_request_create':
        if (details && details.helpRequestId) {
          userAnalytics.helpRequestsCreated.push(details.helpRequestId);
        }
        break;
        
      case 'help_response_provide':
        if (details && details.helpRequestId) {
          userAnalytics.helpResponsesProvided.push(details.helpRequestId);
          
          // Update help analytics
          await this.updateHelpAnalytics(details.helpRequestId, 'response');
        }
        break;
        
      case 'study_group_join':
        if (details && details.studyGroupId) {
          userAnalytics.studyGroupsJoined.push(details.studyGroupId);
          
          // Update study group analytics
          await this.updateStudyGroupAnalytics(details.studyGroupId, 'member_join');
        }
        break;
        
      case 'partnership_engage':
        if (details && details.partnershipId) {
          userAnalytics.partnershipsEngaged.push(details.partnershipId);
          
          // Update partnership analytics
          await this.updatePartnershipAnalytics(details.partnershipId, 'engage', details);
        }
        break;
    }
    
    userAnalytics.lastUpdated = new Date();
    await userAnalytics.save();
    
    res.status(200).json({ message: 'User activity recorded successfully' });
  } catch (error) {
    console.error('Error recording user activity:', error);
    res.status(500).json({ message: 'Error recording user activity', error: error.message });
  }
};

// Update resource analytics (helper method)
exports.updateResourceAnalytics = async (resourceId, userId, action, details = {}) => {
  try {
    let resourceAnalytics = await ResourceAnalytics.findOne({ resourceId });
    
    if (!resourceAnalytics) {
      resourceAnalytics = new ResourceAnalytics({ resourceId });
    }
    
    switch (action) {
      case 'view':
        resourceAnalytics.viewCount += 1;
        if (!resourceAnalytics.uniqueViewers.includes(userId)) {
          resourceAnalytics.uniqueViewers.push(userId);
        }
        break;
        
      case 'download':
        resourceAnalytics.downloadCount += 1;
        break;
        
      case 'share':
        resourceAnalytics.shareCount += 1;
        break;
        
      case 'rate':
        if (details.rating) {
          const newRatingSum = resourceAnalytics.averageRating * resourceAnalytics.ratingCount + details.rating;
          resourceAnalytics.ratingCount += 1;
          resourceAnalytics.averageRating = newRatingSum / resourceAnalytics.ratingCount;
        }
        break;
        
      case 'course_view':
        if (details.courseId) {
          const courseDistribution = resourceAnalytics.courseDistribution || {};
          courseDistribution[details.courseId] = (courseDistribution[details.courseId] || 0) + 1;
          resourceAnalytics.courseDistribution = courseDistribution;
        }
        break;
    }
    
    resourceAnalytics.lastUpdated = new Date();
    await resourceAnalytics.save();
  } catch (error) {
    console.error('Error updating resource analytics:', error);
    throw error;
  }
};

// Update help analytics (helper method)
exports.updateHelpAnalytics = async (helpRequestId, action, details = {}) => {
  try {
    let helpAnalytics = await HelpAnalytics.findOne({ helpRequestId });
    
    if (!helpAnalytics) {
      helpAnalytics = new HelpAnalytics({ helpRequestId });
    }
    
    switch (action) {
      case 'view':
        helpAnalytics.viewCount += 1;
        break;
        
      case 'response':
        helpAnalytics.responseCount += 1;
        break;
        
      case 'resolve':
        if (details.createdAt) {
          const createdTime = new Date(details.createdAt);
          const resolvedTime = new Date();
          const timeDiffMinutes = (resolvedTime - createdTime) / (1000 * 60);
          helpAnalytics.resolvedTime = timeDiffMinutes;
        }
        helpAnalytics.helpful = details.helpful || true;
        break;
    }
    
    helpAnalytics.lastUpdated = new Date();
    await helpAnalytics.save();
  } catch (error) {
    console.error('Error updating help analytics:', error);
    throw error;
  }
};

// Update study group analytics (helper method)
exports.updateStudyGroupAnalytics = async (studyGroupId, action, details = {}) => {
  try {
    let studyGroupAnalytics = await StudyGroupAnalytics.findOne({ studyGroupId });
    
    if (!studyGroupAnalytics) {
      studyGroupAnalytics = new StudyGroupAnalytics({ studyGroupId });
    }
    
    switch (action) {
      case 'member_join':
        studyGroupAnalytics.memberCount += 1;
        break;
        
      case 'message':
        studyGroupAnalytics.messageCount += 1;
        break;
        
      case 'meeting':
        studyGroupAnalytics.meetingCount += 1;
        if (details.duration) {
          studyGroupAnalytics.totalMeetingDuration += details.duration;
        }
        break;
        
      case 'share_resource':
        studyGroupAnalytics.resourcesShared += 1;
        break;
    }
    
    if (details.courseId) {
      studyGroupAnalytics.courseId = details.courseId;
    }
    
    studyGroupAnalytics.lastUpdated = new Date();
    await studyGroupAnalytics.save();
  } catch (error) {
    console.error('Error updating study group analytics:', error);
    throw error;
  }
};

// Update partnership analytics (helper method)
exports.updatePartnershipAnalytics = async (partnershipId, action, details = {}) => {
  try {
    let partnershipAnalytics = await PartnershipAnalytics.findOne({ partnershipId });
    
    if (!partnershipAnalytics) {
      partnershipAnalytics = new PartnershipAnalytics({ partnershipId });
    }
    
    switch (action) {
      case 'view':
        partnershipAnalytics.viewCount += 1;
        break;
        
      case 'enroll':
        partnershipAnalytics.enrollmentCount += 1;
        break;
        
      case 'project_join':
        partnershipAnalytics.projectParticipationCount += 1;
        break;
        
      case 'opportunity_complete':
        // Opportunity completion rate logic would be more complex in a real scenario
        if (details.completedCount && details.totalCount) {
          partnershipAnalytics.opportunityCompletionRate = 
            (details.completedCount / details.totalCount) * 100;
        }
        break;
        
      case 'engage':
        if (details.department) {
          const deptDistribution = partnershipAnalytics.departmentDistribution || {};
          deptDistribution[details.department] = (deptDistribution[details.department] || 0) + 1;
          partnershipAnalytics.departmentDistribution = deptDistribution;
        }
        break;
    }
    
    partnershipAnalytics.lastUpdated = new Date();
    await partnershipAnalytics.save();
  } catch (error) {
    console.error('Error updating partnership analytics:', error);
    throw error;
  }
};

// Get user analytics
exports.getUserAnalytics = async (req, res) => {
  try {
    const { userId } = req.params;
    
    const userAnalytics = await UserAnalytics.findOne({ userId });
    
    if (!userAnalytics) {
      return res.status(404).json({ message: 'User analytics not found' });
    }
    
    res.status(200).json(userAnalytics);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching user analytics', error: error.message });
  }
};

// Get resource analytics
exports.getResourceAnalytics = async (req, res) => {
  try {
    const { resourceId } = req.params;
    
    const resourceAnalytics = await ResourceAnalytics.findOne({ resourceId });
    
    if (!resourceAnalytics) {
      return res.status(404).json({ message: 'Resource analytics not found' });
    }
    
    res.status(200).json(resourceAnalytics);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching resource analytics', error: error.message });
  }
};

// Get help analytics
exports.getHelpAnalytics = async (req, res) => {
  try {
    const { helpRequestId } = req.params;
    
    const helpAnalytics = await HelpAnalytics.findOne({ helpRequestId });
    
    if (!helpAnalytics) {
      return res.status(404).json({ message: 'Help analytics not found' });
    }
    
    res.status(200).json(helpAnalytics);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching help analytics', error: error.message });
  }
};

// Get system analytics
exports.getSystemAnalytics = async (req, res) => {
  try {
    const { startDate, endDate } = req.query;
    
    let query = {};
    
    if (startDate || endDate) {
      query.date = {};
      
      if (startDate) {
        query.date.$gte = new Date(startDate);
      }
      
      if (endDate) {
        query.date.$lte = new Date(endDate);
      }
    }
    
    const systemAnalytics = await SystemAnalytics.find(query).sort({ date: -1 });
    
    res.status(200).json(systemAnalytics);
  } catch (error) {
    res.status(500).json({ message: 'Error fetching system analytics', error: error.message });
  }
};

// Update system analytics daily (should be called by a scheduler)
exports.updateSystemAnalytics = async (req, res) => {
  try {
    const today = new Date();
    today.setHours(0, 0, 0, 0);
    
    // Count active users (users who logged in today)
    const activeUsers = await UserAnalytics.countDocuments({
      lastActive: { $gte: today }
    });
    
    // Count new users registered today
    const oneDayAgo = new Date(today);
    oneDayAgo.setDate(today.getDate() - 1);
    
    // This would need to interact with the user service in a real implementation
    // This is a placeholder
    const newUsers = 10; // Placeholder value
    
    // Count total help requests
    const totalHelpRequests = await HelpAnalytics.countDocuments();
    
    // Count resolved help requests
    const resolvedHelpRequests = await HelpAnalytics.countDocuments({
      resolved: true
    });
    
    // Count total resources
    const totalResources = await ResourceAnalytics.countDocuments();
    
    // Count total study groups
    const totalStudyGroups = await StudyGroupAnalytics.countDocuments();
    
    // Count total partnerships
    const totalPartnerships = await PartnershipAnalytics.countDocuments();
    
    // Canvas integration usage (placeholder)
    const canvasIntegrationUsage = 50; // Placeholder value
    
    const systemAnalytics = new SystemAnalytics({
      date: today,
      activeUsers,
      newUsers,
      totalHelpRequests,
      resolvedHelpRequests,
      totalResources,
      totalStudyGroups,
      totalPartnerships,
      canvasIntegrationUsage
    });
    
    await systemAnalytics.save();
    
    res.status(200).json({ message: 'System analytics updated successfully', data: systemAnalytics });
  } catch (error) {
    console.error('Error updating system analytics:', error);
    res.status(500).json({ message: 'Error updating system analytics', error: error.message });
  }
};

// Get aggregated analytics for dashboard
exports.getDashboardAnalytics = async (req, res) => {
  try {
    // Get latest system analytics
    const latestSystemAnalytics = await SystemAnalytics.findOne().sort({ date: -1 });
    
    // Get top resources by views
    const topResources = await ResourceAnalytics.find()
      .sort({ viewCount: -1 })
      .limit(5);
    
    // Get help request resolution time averages
    const helpAnalytics = await HelpAnalytics.find({ resolvedTime: { $ne: null } });
    let avgResolutionTime = 0;
    
    if (helpAnalytics.length > 0) {
      const totalResolutionTime = helpAnalytics.reduce((acc, curr) => acc + curr.resolvedTime, 0);
      avgResolutionTime = totalResolutionTime / helpAnalytics.length;
    }
    
    // Get study group activity
    const studyGroupActivity = await StudyGroupAnalytics.find()
      .sort({ messageCount: -1 })
      .limit(5);
    
    // Get top partnerships by engagement
    const topPartnerships = await PartnershipAnalytics.find()
      .sort({ viewCount: -1 })
      .limit(5);
    
    const dashboardData = {
      overview: latestSystemAnalytics || {},
      topResources,
      helpMetrics: {
        avgResolutionTime,
        totalRequests: helpAnalytics.length
      },
      studyGroupActivity,
      topPartnerships
    };
    
    res.status(200).json(dashboardData);
  } catch (error) {
    console.error('Error getting dashboard analytics:', error);
    res.status(500).json({ message: 'Error getting dashboard analytics', error: error.message });
  }
};
