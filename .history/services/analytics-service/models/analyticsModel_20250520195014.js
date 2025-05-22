const mongoose = require('mongoose');

const userAnalyticsSchema = new mongoose.Schema({
  userId: String,
  lastActive: Date,
  loginCount: {
    type: Number,
    default: 0
  },
  pageViews: {
    type: Map,
    of: Number,
    default: {}
  },
  resourcesViewed: [String],
  resourcesCreated: [String],
  helpRequestsCreated: [String],
  helpResponsesProvided: [String],
  studyGroupsJoined: [String],
  partnershipsEngaged: [String],
  lastUpdated: {
    type: Date,
    default: Date.now
  }
});

const resourceAnalyticsSchema = new mongoose.Schema({
  resourceId: String,
  viewCount: {
    type: Number,
    default: 0
  },
  uniqueViewers: [String],
  downloadCount: {
    type: Number,
    default: 0
  },
  shareCount: {
    type: Number,
    default: 0
  },
  averageRating: {
    type: Number,
    default: 0
  },
  ratingCount: {
    type: Number,
    default: 0
  },
  courseDistribution: {
    type: Map,
    of: Number,
    default: {}
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  }
});

const helpAnalyticsSchema = new mongoose.Schema({
  helpRequestId: String,
  viewCount: {
    type: Number,
    default: 0
  },
  responseCount: {
    type: Number,
    default: 0
  },
  averageResponseTime: {
    type: Number, // in minutes
    default: 0
  },
  resolvedTime: {
    type: Number, // in minutes
    default: null
  },
  helpful: {
    type: Boolean,
    default: null
  },
  courseId: String,
  lastUpdated: {
    type: Date,
    default: Date.now
  }
});

const studyGroupAnalyticsSchema = new mongoose.Schema({
  studyGroupId: String,
  memberCount: {
    type: Number,
    default: 0
  },
  messageCount: {
    type: Number,
    default: 0
  },
  meetingCount: {
    type: Number,
    default: 0
  },
  totalMeetingDuration: {
    type: Number, // in minutes
    default: 0
  },
  resourcesShared: {
    type: Number,
    default: 0
  },
  courseId: String,
  lastUpdated: {
    type: Date,
    default: Date.now
  }
});

const partnershipAnalyticsSchema = new mongoose.Schema({
  partnershipId: String,
  viewCount: {
    type: Number,
    default: 0
  },
  enrollmentCount: {
    type: Number,
    default: 0
  },
  projectParticipationCount: {
    type: Number,
    default: 0
  },
  opportunityCompletionRate: {
    type: Number, // percentage
    default: 0
  },
  departmentDistribution: {
    type: Map,
    of: Number,
    default: {}
  },
  lastUpdated: {
    type: Date,
    default: Date.now
  }
});

const systemAnalyticsSchema = new mongoose.Schema({
  date: {
    type: Date,
    default: Date.now
  },
  activeUsers: {
    type: Number,
    default: 0
  },
  newUsers: {
    type: Number,
    default: 0
  },
  totalHelpRequests: {
    type: Number,
    default: 0
  },
  resolvedHelpRequests: {
    type: Number,
    default: 0
  },
  totalResources: {
    type: Number,
    default: 0
  },
  totalStudyGroups: {
    type: Number,
    default: 0
  },
  totalPartnerships: {
    type: Number,
    default: 0
  },
  canvasIntegrationUsage: {
    type: Number,
    default: 0
  }
});

const UserAnalytics = mongoose.model('UserAnalytics', userAnalyticsSchema);
const ResourceAnalytics = mongoose.model('ResourceAnalytics', resourceAnalyticsSchema);
const HelpAnalytics = mongoose.model('HelpAnalytics', helpAnalyticsSchema);
const StudyGroupAnalytics = mongoose.model('StudyGroupAnalytics', studyGroupAnalyticsSchema);
const PartnershipAnalytics = mongoose.model('PartnershipAnalytics', partnershipAnalyticsSchema);
const SystemAnalytics = mongoose.model('SystemAnalytics', systemAnalyticsSchema);

module.exports = {
  UserAnalytics,
  ResourceAnalytics,
  HelpAnalytics,
  StudyGroupAnalytics,
  PartnershipAnalytics,
  SystemAnalytics
};
