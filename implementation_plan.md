# Enhance Complaint Filing System – Implementation Plan

## Background

The project is a Java EE MVC web application (`tcet_IP` MySQL DB) with:
- **Models**: [Complaint](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/model/Complaint.java#3-50), [User](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/model/User.java#3-30)
- **DAOs**: [ComplaintDAO](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#8-148), `UserDAO`
- **Servlets**: [ComplaintServlet](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/servlet/ComplaintServlet.java#11-92), `LoginServlet`, `LogoutServlet`, `SignupServlet`
- **JSP views**: [addComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/addComplaint.jsp), [editComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/editComplaint.jsp), [viewComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/viewComplaint.jsp), [dashboard.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/dashboard.jsp), [login.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/login.jsp), [signup.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/signup.jsp)

The user has already run the ALTER TABLE, so the DB has `category VARCHAR(50)`, `priority VARCHAR(20)`, and `created_at TIMESTAMP`.

## Proposed Changes

---

### Database

#### [MODIFY] tcet_IP.complaint table
The ALTER is already applied by the user. Additional analytics-supporting queries are included in the SQL file below.

---

### Java Model

#### [MODIFY] [Complaint.java](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/model/Complaint.java)
- Add fields: `category`, `priority`, `createdAt` (String)
- Add constructor overload accepting all fields
- Add getters/setters for all 3 new fields

---

### Java DAO

#### [MODIFY] [ComplaintDAO.java](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java)
- [saveComplaint()](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#10-31) – include `category`, `priority` in INSERT (created_at uses DB DEFAULT)
- [getAllComplaints()](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#32-56), [getComplaintsByUsername()](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#57-86), [getComplaintById()](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#88-113) – read `category`, `priority`, `created_at`
- [updateComplaint()](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/dao/ComplaintDAO.java#114-133) – include `category`, `priority` in UPDATE
- **New methods**:
  - `getCountByCategory()` → `Map<String,Integer>`
  - `getCountByStatus()` → `Map<String,Integer>`
  - `getCountByPriority()` → `Map<String,Integer>`
  - `getMonthlyTrend()` → `Map<String,Integer>` (last 6 months)
  - `getComplaintsByFilter(username, category, status, priority)` – for user-side filtering

---

### Java Servlet

#### [MODIFY] [ComplaintServlet.java](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/servlet/ComplaintServlet.java)
- Read `category` and `priority` from POST params in both save and update branches

#### [NEW] [AnalyticsServlet.java](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/java/servlet/AnalyticsServlet.java)
- Admin-only servlet mapped to `/AnalyticsServlet`
- Calls all 4 analytics DAO methods, sets results as request attributes, forwards to `analytics.jsp`

---

### JSP Views

#### [MODIFY] [addComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/addComplaint.jsp)
- Add `<select name="category">` with 8 categories: General, Infrastructure, Academic, Administrative, IT Support, Hostel, Transport, Other
- Add `<select name="priority">` with Low / Medium / High

#### [MODIFY] [editComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/editComplaint.jsp)
- Display category, priority, created_at as read-only detail items
- Admin form: add hidden inputs for category/priority so they're preserved in update; allow changing status (Pending / In Progress / Resolved / Rejected)

#### [MODIFY] [viewComplaint.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/viewComplaint.jsp)
- Add Category, Priority, Date columns to table
- Add filter bar (Category dropdown, Status dropdown, Priority dropdown) with a Search button that re-submits page via GET
- Color-coded priority badges (Low=green, Medium=amber, High=red)
- Color-coded status badges for "In Progress" and "Rejected" in addition to existing

#### [MODIFY] [dashboard.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/dashboard.jsp)
- Admin: add "Analytics Dashboard" button linking to `AnalyticsServlet`
- Improved layout styling to handle extra buttons

#### [NEW] [analytics.jsp](file:///d:/Tcet/IP_Tcet/SEM_4/IP_final/src/main/webapp/analytics.jsp)
- Admin-only view
- Summary stat cards: Total, Pending, Resolved, In Progress
- Bar chart: Complaints by Category (Chart.js via CDN)
- Doughnut chart: Complaints by Status
- Bar chart: Complaints by Priority
- Line chart: Monthly trend (last 6 months)
- All chart data injected server-side from AnalyticsServlet request attributes

---

## Verification Plan

### Manual Verification
1. **Deploy** the project in Eclipse/Tomcat as usual (run on server)
2. **Login as user** → click "Register New Complaint" → verify Category and Priority dropdowns appear → submit → verify complaint is listed in "My Complaints" with category/priority columns
3. **Login as admin** → click "View All Complaints" → verify filter bar works (filter by category, status, priority) → click Edit on a complaint → verify status can be updated to "In Progress" or "Rejected"
4. **Login as admin** → click "Analytics Dashboard" → verify charts render for all 4 charts with correct data labels
