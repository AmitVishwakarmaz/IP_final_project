<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.ComplaintDAO, model.Complaint" %>
<%
    String role     = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    if (role == null || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Filter params
    String filterCategory = request.getParameter("filterCategory") != null ? request.getParameter("filterCategory") : "";
    String filterStatus   = request.getParameter("filterStatus")   != null ? request.getParameter("filterStatus")   : "";
    String filterPriority = request.getParameter("filterPriority") != null ? request.getParameter("filterPriority") : "";

    ComplaintDAO dao = new ComplaintDAO();
    List<Complaint> list;

    boolean hasFilter = !filterCategory.isEmpty() || !filterStatus.isEmpty() || !filterPriority.isEmpty();

    if (hasFilter) {
        String userFilter = "admin".equals(role) ? "" : username;
        list = dao.getComplaintsByFilter(userFilter, filterCategory, filterStatus, filterPriority);
    } else if ("admin".equals(role)) {
        list = dao.getAllComplaints();
    } else {
        list = dao.getComplaintsByUsername(username);
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= "admin".equals(role) ? "All Complaints" : "My Complaints" %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f1f5f9;
            min-height: 100vh;
            padding: 24px 16px;
        }

        .page-header {
            max-width: 1200px;
            margin: 0 auto 1.2rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 0.8rem;
        }

        .page-title {
            font-size: 1.6rem;
            font-weight: 700;
            color: #1a1a2e;
        }

        .page-title span {
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .header-actions { display: flex; gap: 0.7rem; }

        .btn {
            display: inline-block;
            padding: 0.55rem 1.1rem;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
            border: none;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-primary { background: linear-gradient(135deg,#667eea,#764ba2); color: white; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(102,126,234,0.35); }

        .btn-outline { background: white; color: #374151; border: 1.5px solid #e5e7eb; }
        .btn-outline:hover { border-color: #667eea; color: #667eea; }

        /* Filter bar */
        .filter-card {
            max-width: 1200px;
            margin: 0 auto 1.2rem;
            background: white;
            border-radius: 12px;
            padding: 1.2rem 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
        }

        .filter-form {
            display: flex;
            gap: 0.8rem;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .filter-form .fg {
            display: flex;
            flex-direction: column;
            gap: 0.35rem;
            min-width: 160px;
        }

        .filter-form label {
            font-size: 0.78rem;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .filter-form select {
            padding: 0.6rem 2rem 0.6rem 0.75rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9rem;
            font-family: 'Inter', sans-serif;
            color: #374151;
            background: #fafafa;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3E%3Cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.5rem center;
            background-size: 1.1em;
            cursor: pointer;
            transition: all 0.2s;
        }

        .filter-form select:focus {
            outline: none;
            border-color: #667eea;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.12);
        }

        .btn-filter {
            padding: 0.62rem 1.3rem;
            background: linear-gradient(135deg,#667eea,#764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.2s;
        }

        .btn-filter:hover { transform: translateY(-1px); box-shadow: 0 5px 15px rgba(102,126,234,0.35); }

        .btn-clear {
            padding: 0.62rem 1rem;
            background: #f3f4f6;
            color: #6b7280;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.9rem;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-clear:hover { color: #374151; border-color: #d1d5db; }

        /* Table */
        .table-card {
            max-width: 1200px;
            margin: 0 auto;
            background: white;
            border-radius: 12px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            overflow: hidden;
        }

        .table-info {
            padding: 1rem 1.5rem;
            border-bottom: 1px solid #f3f4f6;
            font-size: 0.88rem;
            color: #6b7280;
        }

        .table-info strong { color: #374151; }

        .table-wrapper { overflow-x: auto; }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            padding: 0.85rem 1.1rem;
            background: #f8fafc;
            color: #6b7280;
            font-size: 0.78rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            text-align: left;
            border-bottom: 1px solid #e5e7eb;
        }

        td {
            padding: 0.9rem 1.1rem;
            color: #374151;
            font-size: 0.93rem;
            border-bottom: 1px solid #f3f4f6;
            vertical-align: middle;
        }

        tr:last-child td { border-bottom: none; }
        tr:hover td { background: #fafafa; }

        /* Badges */
        .badge {
            display: inline-block;
            padding: 0.3rem 0.7rem;
            border-radius: 9999px;
            font-size: 0.78rem;
            font-weight: 600;
            white-space: nowrap;
        }

        .s-pending    { background: #fef3c7; color: #92400e; }
        .s-inprogress { background: #dbeafe; color: #1e40af; }
        .s-resolved   { background: #d1fae5; color: #065f46; }
        .s-rejected   { background: #fee2e2; color: #991b1b; }

        .p-high   { background: #fee2e2; color: #b91c1c; }
        .p-medium { background: #fef3c7; color: #92400e; }
        .p-low    { background: #d1fae5; color: #065f46; }

        .cat-chip {
            display: inline-block;
            padding: 0.25rem 0.65rem;
            border-radius: 6px;
            font-size: 0.8rem;
            font-weight: 500;
            background: #ede9fe;
            color: #5b21b6;
        }

        /* Action buttons */
        .action-btn {
            display: inline-block;
            padding: 0.38rem 0.8rem;
            margin: 0 0.2rem;
            border-radius: 6px;
            text-decoration: none;
            font-size: 0.83rem;
            font-weight: 500;
            transition: all 0.2s;
        }

        .edit-btn   { background: #ede9fe; color: #5b21b6; }
        .edit-btn:hover { background: #ddd6fe; transform: translateY(-1px); }

        .delete-btn { background: #fee2e2; color: #b91c1c; }
        .delete-btn:hover { background: #fecaca; transform: translateY(-1px); }

        .no-records {
            text-align: center;
            padding: 4rem 1rem;
            color: #9ca3af;
        }

        .no-records .icon { font-size: 3rem; margin-bottom: 0.8rem; }
        .no-records p { font-size: 1.05rem; }

        .date-col { color: #9ca3af; font-size: 0.83rem; white-space: nowrap; }

        /* Footer */
        .page-footer {
            max-width: 1200px;
            margin: 1.2rem auto 0;
            display: flex;
            gap: 0.8rem;
        }

        @media (max-width: 640px) {
            th, td { padding: 0.75rem 0.75rem; font-size: 0.85rem; }
        }
    </style>
</head>
<body>

    <div class="page-header">
        <h1 class="page-title">
            <span><%= "admin".equals(role) ? "All Complaints" : "My Complaints" %></span>
        </h1>
        <div class="header-actions">
            <% if (!"admin".equals(role)) { %>
                <a href="addComplaint.jsp" class="btn btn-primary">+ New Complaint</a>
            <% } %>
            <% if ("admin".equals(role)) { %>
                <a href="AnalyticsServlet" class="btn btn-outline">📊 Analytics</a>
            <% } %>
            <a href="dashboard.jsp" class="btn btn-outline">⬅ Dashboard</a>
        </div>
    </div>

    <!-- Filter Bar -->
    <div class="filter-card">
        <form class="filter-form" method="get" action="viewComplaint.jsp">
            <div class="fg">
                <label>Category</label>
                <select name="filterCategory">
                    <option value="">All Categories</option>
                    <% String[] cats = {"General","Infrastructure","Academic","Administrative","IT Support","Hostel","Transport","Other"}; %>
                    <% for (String cat : cats) { %>
                        <option value="<%= cat %>" <%= cat.equals(filterCategory) ? "selected" : "" %>><%= cat %></option>
                    <% } %>
                </select>
            </div>
            <div class="fg">
                <label>Status</label>
                <select name="filterStatus">
                    <option value="">All Statuses</option>
                    <option value="Pending"     <%= "Pending".equals(filterStatus)     ? "selected" : "" %>>Pending</option>
                    <option value="In Progress" <%= "In Progress".equals(filterStatus) ? "selected" : "" %>>In Progress</option>
                    <option value="Resolved"    <%= "Resolved".equals(filterStatus)    ? "selected" : "" %>>Resolved</option>
                    <option value="Rejected"    <%= "Rejected".equals(filterStatus)    ? "selected" : "" %>>Rejected</option>
                </select>
            </div>
            <div class="fg">
                <label>Priority</label>
                <select name="filterPriority">
                    <option value="">All Priorities</option>
                    <option value="High"   <%= "High".equals(filterPriority)   ? "selected" : "" %>>🔴 High</option>
                    <option value="Medium" <%= "Medium".equals(filterPriority) ? "selected" : "" %>>🟡 Medium</option>
                    <option value="Low"    <%= "Low".equals(filterPriority)    ? "selected" : "" %>>🟢 Low</option>
                </select>
            </div>
            <button type="submit" class="btn-filter">🔍 Filter</button>
            <a href="viewComplaint.jsp" class="btn-clear">✕ Clear</a>
        </form>
    </div>

    <!-- Table -->
    <div class="table-card">
        <div class="table-info">
            Showing <strong><%= list.size() %></strong> complaint<%= list.size() != 1 ? "s" : "" %>
            <% if (hasFilter) { %> &nbsp;(filtered)<% } %>
        </div>
        <div class="table-wrapper">
            <table>
                <thead>
                    <tr>
                        <% if ("admin".equals(role)) { %><th>#</th><% } %>
                        <th>Name</th>
                        <th>Category</th>
                        <th>Subject</th>
                        <th>Priority</th>
                        <th>Status</th>
                        <th>Date</th>
                        <% if ("admin".equals(role)) { %><th>Actions</th><% } %>
                    </tr>
                </thead>
                <tbody>
                    <% if (list == null || list.isEmpty()) { %>
                        <tr>
                            <td colspan="<%= "admin".equals(role) ? 8 : 6 %>">
                                <div class="no-records">
                                    <div class="icon">📭</div>
                                    <p>No complaints found.</p>
                                </div>
                            </td>
                        </tr>
                    <% } else { %>
                        <% for (Complaint c : list) { %>
                        <%
                            String st = c.getStatus() != null ? c.getStatus() : "Pending";
                            String stC = "s-pending";
                            if ("Resolved".equals(st))   stC = "s-resolved";
                            else if ("In Progress".equals(st)) stC = "s-inprogress";
                            else if ("Rejected".equals(st))    stC = "s-rejected";

                            String pr = c.getPriority() != null ? c.getPriority() : "Medium";
                            String prC = "p-medium";
                            if ("High".equals(pr)) prC = "p-high";
                            else if ("Low".equals(pr)) prC = "p-low";
                        %>
                        <tr>
                            <% if ("admin".equals(role)) { %><td><%= c.getId() %></td><% } %>
                            <td><strong><%= c.getName() %></strong></td>
                            <td><span class="cat-chip"><%= c.getCategory() != null ? c.getCategory() : "Other" %></span></td>
                            <td><%= c.getSubject() %></td>
                            <td><span class="badge <%= prC %>"><%= pr %></span></td>
                            <td><span class="badge <%= stC %>"><%= st %></span></td>
                            <td class="date-col"><%= c.getCreatedAt() != null ? c.getCreatedAt() : "-" %></td>
                            <% if ("admin".equals(role)) { %>
                            <td>
                                <a href="editComplaint.jsp?id=<%= c.getId() %>" class="action-btn edit-btn">Edit</a>
                                <a href="ComplaintServlet?action=delete&id=<%= c.getId() %>"
                                   class="action-btn delete-btn"
                                   onclick="return confirm('Delete this complaint?');">Delete</a>
                            </td>
                            <% } %>
                        </tr>
                        <% } %>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <div class="page-footer">
        <a href="dashboard.jsp" class="btn btn-outline">← Dashboard</a>
    </div>

</body>
</html>