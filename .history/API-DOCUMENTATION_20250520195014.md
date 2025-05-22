# AIU Educational Collaboration Platform API Documentation

This document provides an overview of the APIs available in the AIU Educational Collaboration Platform, which integrates with Canvas to provide enhanced collaboration features.

## Authentication

All authenticated endpoints require a JWT token sent in the `Authorization` header:

```
Authorization: Bearer <token>
```

## User Service (Port 3000)

### Endpoints

- `POST /api/users/register` - Register a new user
- `POST /api/users/login` - Login and get JWT token
- `GET /api/users/profile` - Get current user profile (authenticated)
- `PUT /api/users/profile` - Update user profile (authenticated)
- `GET /api/users/:id` - Get user by ID
- `PUT /api/users/canvas-integration` - Link Canvas account to user profile (authenticated)

## Resource Service (Port 3001)

### Endpoints

- `GET /api/resources` - Get all resources
- `GET /api/resources/search` - Search resources by query, tags, and course
- `GET /api/resources/:id` - Get resource by ID
- `POST /api/resources` - Create a new resource (authenticated)
- `PUT /api/resources/:id` - Update a resource (authenticated)
- `DELETE /api/resources/:id` - Delete a resource (authenticated)
- `POST /api/resources/:id/upvote` - Upvote a resource (authenticated)
- `POST /api/resources/:id/useful` - Mark a resource as useful (authenticated)
- `POST /api/resources/:id/comments` - Add a comment to a resource (authenticated)
- `DELETE /api/resources/:id/comments/:commentId` - Delete a comment (authenticated)

## Help Service (Port 3003)

### Endpoints

- `GET /api/help` - Get all help requests/offers
- `GET /api/help/search` - Search help by query, tags, and course
- `GET /api/help/:id` - Get help request/offer by ID
- `POST /api/help` - Create a new help request/offer (authenticated)
- `PUT /api/help/:id` - Update a help request/offer (authenticated)
- `DELETE /api/help/:id` - Delete a help request/offer (authenticated)
- `POST /api/help/:id/responses` - Add a response to a help request (authenticated)
- `PUT /api/help/:id/status` - Update the status of a help request (authenticated)
- `POST /api/help/:id/assign` - Assign a helper to a request (authenticated)
- `POST /api/help/:id/meeting` - Schedule a meeting for a help request (authenticated)

## Study Group Service (Port 3005)

### Endpoints

- `GET /api/study-groups` - Get all study groups
- `GET /api/study-groups/search` - Search study groups by query, tags, and course
- `GET /api/study-groups/:id` - Get study group by ID
- `POST /api/study-groups` - Create a new study group (authenticated)
- `PUT /api/study-groups/:id` - Update a study group (authenticated)
- `DELETE /api/study-groups/:id` - Delete a study group (authenticated)
- `POST /api/study-groups/:id/join` - Join a study group (authenticated)
- `POST /api/study-groups/:id/leave` - Leave a study group (authenticated)
- `POST /api/study-groups/:id/meetings` - Create a meeting (authenticated)
- `POST /api/study-groups/:id/messages` - Send a message to the group (authenticated)

## Gamification Service (Port 3004)

### Endpoints

- `GET /api/gamification/:userId` - Get a user's gamification data
- `POST /api/gamification/:userId/points` - Award points to a user (internal only)
- `POST /api/gamification/:userId/badges` - Award a badge to a user (internal only)
- `GET /api/gamification/leaderboard` - Get the points leaderboard
- `GET /api/gamification/achievements/:userId` - Get a user's achievements

## Notification Service (Port 3002)

### Endpoints

- `GET /api/notifications` - Get all notifications for the current user (authenticated)
- `PUT /api/notifications/:id/read` - Mark a notification as read (authenticated)
- `DELETE /api/notifications/:id` - Delete a notification (authenticated)
- `POST /api/notifications/subscribe` - Subscribe to push notifications (authenticated)

## Canvas Integration Service (Port 3006)

### Endpoints

- `GET /api/canvas/courses` - Get all Canvas courses
- `GET /api/canvas/courses/:courseId` - Get a course with its assignments
- `POST /api/canvas/sync/courses` - Sync courses from Canvas (authenticated)
- `POST /api/canvas/sync/courses/:courseId/assignments` - Sync assignments (authenticated)
- `POST /api/canvas/sync/users/:userId/enrollments` - Sync enrollments (authenticated)
- `POST /api/canvas/sync/courses/:courseId/announcements` - Sync announcements (authenticated)
- `GET /api/canvas/users/:userId/upcoming-assignments` - Get upcoming assignments (authenticated)

## Partnership Service (Port 3007)

### Endpoints

- `GET /api/partnerships` - Get all partnerships
- `GET /api/partnerships/search` - Search partnerships by query, type, and expertise
- `GET /api/partnerships/:id` - Get partnership by ID
- `POST /api/partnerships` - Create a new partnership (authenticated)
- `PUT /api/partnerships/:id` - Update a partnership (authenticated)
- `DELETE /api/partnerships/:id` - Delete a partnership (authenticated)
- `POST /api/partnerships/:id/opportunities` - Add an opportunity (authenticated)
- `POST /api/partnerships/:id/opportunities/:opportunityId/enroll` - Enroll in an opportunity (authenticated)
- `POST /api/partnerships/:id/projects` - Add a project (authenticated)
- `POST /api/partnerships/:id/projects/:projectId/join` - Join a project (authenticated)
- `POST /api/partnerships/:id/rate` - Rate a partnership (authenticated)
- `POST /api/partnerships/:id/members` - Add a member (authenticated)
- `DELETE /api/partnerships/:id/members/:memberId` - Remove a member (authenticated)

## Data Models

### User

```json
{
  "_id": "string",
  "name": "string",
  "email": "string",
  "password": "string (hashed)",
  "canvasId": "string",
  "role": "student | faculty | alumni | partner",
  "department": "string",
  "expertise": ["string"],
  "helpRating": "number",
  "helpCount": "number",
  "enrolledCourses": ["string"],
  "availableForHelp": "boolean"
}
```

### Resource

```json
{
  "_id": "string",
  "title": "string",
  "description": "string",
  "url": "string",
  "fileType": "document | image | video | link | audio | code | other",
  "category": "string",
  "courseId": "string",
  "createdBy": "string",
  "difficultyLevel": "beginner | intermediate | advanced",
  "tags": ["string"],
  "upvotes": "number",
  "usefulCount": "number",
  "comments": [{
    "userId": "string",
    "content": "string",
    "createdAt": "date"
  }],
  "verifiedBy": ["string"],
  "relatedResources": ["string"],
  "createdAt": "date"
}
```

### Help Request

```json
{
  "_id": "string",
  "type": "request | offer",
  "subject": "string",
  "description": "string",
  "userId": "string",
  "courseId": "string",
  "urgency": "low | medium | high",
  "status": "open | in-progress | resolved | closed",
  "tags": ["string"],
  "responses": [{
    "userId": "string",
    "content": "string",
    "attachments": ["string"],
    "helpful": "boolean",
    "createdAt": "date"
  }],
  "assignedHelpers": ["string"],
  "meetingUrl": "string",
  "meetingScheduled": "date",
  "attachments": ["string"],
  "visibility": "public | course | private",
  "createdAt": "date"
}
```

### Study Group

```json
{
  "_id": "string",
  "name": "string",
  "description": "string",
  "courseId": "string",
  "privacy": "public | private | invite-only",
  "members": ["string"],
  "admins": ["string"],
  "capacity": "number",
  "tags": ["string"],
  "relatedResources": ["string"],
  "meetings": [{
    "title": "string",
    "date": "date",
    "duration": "number",
    "virtualMeetingUrl": "string",
    "physicalLocation": "string",
    "agenda": "string",
    "attendees": ["string"]
  }],
  "messages": [{
    "userId": "string",
    "content": "string",
    "attachments": ["string"],
    "createdAt": "date"
  }],
  "active": "boolean",
  "createdAt": "date"
}
```

### Partnership

```json
{
  "_id": "string",
  "name": "string",
  "organizationType": "industry | academic | alumni | student-group",
  "description": "string",
  "contactEmail": "string",
  "contactName": "string",
  "website": "string",
  "logo": "string",
  "expertiseAreas": ["string"],
  "availableOpportunities": [{
    "title": "string",
    "description": "string",
    "type": "mentorship | project | internship | guest-lecture | workshop",
    "startDate": "date",
    "endDate": "date",
    "capacity": "number",
    "requirements": "string",
    "enrolledStudents": ["string"]
  }],
  "members": ["string"],
  "activeProjects": [{
    "title": "string",
    "description": "string",
    "status": "planning | in-progress | completed",
    "participants": ["string"],
    "resources": ["string"],
    "startDate": "date",
    "endDate": "date"
  }],
  "rating": "number",
  "feedbackCount": "number",
  "verified": "boolean",
  "createdAt": "date"
}
```
