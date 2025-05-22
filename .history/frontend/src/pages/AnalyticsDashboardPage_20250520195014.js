import React, { useState, useEffect } from 'react';
import { getDashboardAnalytics, getUserAnalytics } from '../services/analyticsService';

const AnalyticsDashboardPage = () => {
  const [dashboardData, setDashboardData] = useState(null);
  const [userAnalytics, setUserAnalytics] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);
  
  const userId = localStorage.getItem('userId');

  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        
        // Fetch dashboard analytics
        const dashboardResult = await getDashboardAnalytics();
        setDashboardData(dashboardResult);
        
        // Fetch user's personal analytics
        if (userId) {
          const userResult = await getUserAnalytics(userId);
          setUserAnalytics(userResult);
        }
        
        setLoading(false);
      } catch (err) {
        setError('Error fetching analytics data: ' + err.message);
        setLoading(false);
      }
    };
    
    fetchData();
  }, [userId]);

  if (loading) {
    return <div className="loading">Loading analytics data...</div>;
  }

  if (error) {
    return <div className="error-message">{error}</div>;
  }

  return (
    <div className="analytics-dashboard">
      <h1>Analytics Dashboard</h1>
      
      {dashboardData && (
        <div className="dashboard-container">
          <div className="row">
            <div className="col-md-3">
              <div className="analytics-card">
                <h3>Active Users</h3>
                <div className="analytics-value">{dashboardData.overview.activeUsers || 0}</div>
              </div>
            </div>
            
            <div className="col-md-3">
              <div className="analytics-card">
                <h3>Resources</h3>
                <div className="analytics-value">{dashboardData.overview.totalResources || 0}</div>
              </div>
            </div>
            
            <div className="col-md-3">
              <div className="analytics-card">
                <h3>Help Requests</h3>
                <div className="analytics-value">{dashboardData.overview.totalHelpRequests || 0}</div>
              </div>
            </div>
            
            <div className="col-md-3">
              <div className="analytics-card">
                <h3>Partnerships</h3>
                <div className="analytics-value">{dashboardData.overview.totalPartnerships || 0}</div>
              </div>
            </div>
          </div>
          
          <div className="row mt-4">
            <div className="col-md-6">
              <div className="analytics-panel">
                <h3>Top Resources</h3>
                {dashboardData.topResources && dashboardData.topResources.length > 0 ? (
                  <ul className="list-group">
                    {dashboardData.topResources.map(resource => (
                      <li key={resource.resourceId} className="list-group-item d-flex justify-content-between align-items-center">
                        Resource {resource.resourceId}
                        <span className="badge bg-primary rounded-pill">{resource.viewCount} views</span>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>No resource data available</p>
                )}
              </div>
            </div>
            
            <div className="col-md-6">
              <div className="analytics-panel">
                <h3>Help Metrics</h3>
                <div className="metrics-container">
                  <div className="metric">
                    <p className="metric-label">Average Resolution Time</p>
                    <p className="metric-value">
                      {dashboardData.helpMetrics.avgResolutionTime 
                        ? `${Math.round(dashboardData.helpMetrics.avgResolutionTime)} minutes` 
                        : 'N/A'}
                    </p>
                  </div>
                  
                  <div className="metric">
                    <p className="metric-label">Total Help Requests</p>
                    <p className="metric-value">
                      {dashboardData.helpMetrics.totalRequests || 0}
                    </p>
                  </div>
                  
                  <div className="metric">
                    <p className="metric-label">Resolution Rate</p>
                    <p className="metric-value">
                      {dashboardData.overview.resolvedHelpRequests && dashboardData.overview.totalHelpRequests
                        ? `${Math.round((dashboardData.overview.resolvedHelpRequests / dashboardData.overview.totalHelpRequests) * 100)}%`
                        : 'N/A'}
                    </p>
                  </div>
                </div>
              </div>
            </div>
          </div>
          
          <div className="row mt-4">
            <div className="col-md-6">
              <div className="analytics-panel">
                <h3>Study Group Activity</h3>
                {dashboardData.studyGroupActivity && dashboardData.studyGroupActivity.length > 0 ? (
                  <ul className="list-group">
                    {dashboardData.studyGroupActivity.map(group => (
                      <li key={group.studyGroupId} className="list-group-item">
                        <div>Group {group.studyGroupId}</div>
                        <div className="small">
                          <span className="me-2">{group.memberCount} members</span>
                          <span className="me-2">{group.messageCount} messages</span>
                          <span>{group.meetingCount} meetings</span>
                        </div>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>No study group data available</p>
                )}
              </div>
            </div>
            
            <div className="col-md-6">
              <div className="analytics-panel">
                <h3>Partnership Engagement</h3>
                {dashboardData.topPartnerships && dashboardData.topPartnerships.length > 0 ? (
                  <ul className="list-group">
                    {dashboardData.topPartnerships.map(partnership => (
                      <li key={partnership.partnershipId} className="list-group-item d-flex justify-content-between align-items-center">
                        Partnership {partnership.partnershipId}
                        <span className="badge bg-info rounded-pill">{partnership.viewCount} views</span>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>No partnership data available</p>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
      
      {userAnalytics && (
        <div className="user-analytics mt-5">
          <h2>Your Activity</h2>
          
          <div className="row">
            <div className="col-md-4">
              <div className="analytics-panel">
                <h4>Resource Activity</h4>
                <p><strong>Viewed:</strong> {userAnalytics.resourcesViewed.length}</p>
                <p><strong>Created:</strong> {userAnalytics.resourcesCreated.length}</p>
              </div>
            </div>
            
            <div className="col-md-4">
              <div className="analytics-panel">
                <h4>Help Activity</h4>
                <p><strong>Requests Created:</strong> {userAnalytics.helpRequestsCreated.length}</p>
                <p><strong>Responses Provided:</strong> {userAnalytics.helpResponsesProvided.length}</p>
              </div>
            </div>
            
            <div className="col-md-4">
              <div className="analytics-panel">
                <h4>Collaboration</h4>
                <p><strong>Study Groups:</strong> {userAnalytics.studyGroupsJoined.length}</p>
                <p><strong>Partnerships:</strong> {userAnalytics.partnershipsEngaged.length}</p>
              </div>
            </div>
          </div>
          
          <div className="row mt-3">
            <div className="col-md-12">
              <div className="analytics-panel">
                <h4>Page Views</h4>
                {userAnalytics.pageViews && Object.keys(userAnalytics.pageViews).length > 0 ? (
                  <ul className="list-group">
                    {Object.entries(userAnalytics.pageViews).map(([page, count]) => (
                      <li key={page} className="list-group-item d-flex justify-content-between align-items-center">
                        {page}
                        <span className="badge bg-secondary rounded-pill">{count} views</span>
                      </li>
                    ))}
                  </ul>
                ) : (
                  <p>No page view data available</p>
                )}
              </div>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default AnalyticsDashboardPage;
