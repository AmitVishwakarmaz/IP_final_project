<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="dao.ComplaintDAO, model.Complaint" %>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    String idParam = request.getParameter("id");
    if (idParam == null || idParam.trim().isEmpty()) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    int id;
    try {
        id = Integer.parseInt(idParam);
    } catch (NumberFormatException e) {
        response.sendRedirect("dashboard.jsp");
        return;
    }

    ComplaintDAO dao = new ComplaintDAO();
    Complaint c = dao.getComplaintById(id);
    if (c == null) {
        response.sendRedirect("dashboard.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Complaint #<%= c.getId() %></title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            padding: 30px 20px;
            display: flex;
            justify-content: center;
        }

        .card {
            background: white;
            width: 100%;
            max-width: 660px;
            height: fit-content;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            background: linear-gradient(135deg, #667eea, #764ba2);
            padding: 1.6rem 2rem;
            color: white;
        }

        .card-header h2 {
            font-size: 1.4rem;
            font-weight: 700;
        }

        .card-header .meta {
            font-size: 0.85rem;
            opacity: 0.85;
            margin-top: 0.3rem;
        }

        .card-body { padding: 2rem; }

        .detail-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
            margin-bottom: 1.2rem;
        }

        .detail-item { margin-bottom: 0; }
        .detail-item.full { grid-column: 1 / -1; }

        .detail-label {
            display: block;
            font-size: 0.78rem;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.06em;
            margin-bottom: 0.35rem;
        }

        .detail-value {
            color: #1f2937;
            font-size: 0.97rem;
            line-height: 1.55;
            padding: 0.65rem 0.9rem;
            background: #f9fafb;
            border-radius: 8px;
            border: 1px solid #e5e7eb;
            white-space: pre-wrap;
            word-wrap: break-word;
        }

        /* Status badges */
        .badge {
            display: inline-block;
            padding: 0.35rem 0.85rem;
            border-radius: 9999px;
            font-size: 0.82rem;
            font-weight: 600;
        }
        .badge-pending    { background: #fef3c7; color: #92400e; }
        .badge-inprogress { background: #dbeafe; color: #1e40af; }
        .badge-resolved   { background: #d1fae5; color: #065f46; }
        .badge-rejected   { background: #fee2e2; color: #991b1b; }

        /* Priority badges */
        .badge-high   { background: #fee2e2; color: #b91c1c; }
        .badge-medium { background: #fef3c7; color: #92400e; }
        .badge-low    { background: #d1fae5; color: #065f46; }

        /* Category chip */
        .chip {
            display: inline-block;
            padding: 0.3rem 0.75rem;
            border-radius: 6px;
            font-size: 0.85rem;
            font-weight: 500;
            background: #ede9fe;
            color: #5b21b6;
        }

        /* Admin form */
        .admin-form {
            border-top: 1px solid #e5e7eb;
            margin-top: 1.5rem;
            padding-top: 1.5rem;
        }

        .admin-form h3 {
            font-size: 1rem;
            font-weight: 600;
            color: #374151;
            margin-bottom: 1rem;
        }

        select, input[type="text"] {
            width: 100%;
            padding: 0.7rem 0.9rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            color: #1f2937;
            background: #fafafa;
            appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3E%3Cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.2em;
            padding-right: 2.5rem;
            transition: all 0.2s;
        }

        select:focus { outline: none; border-color: #667eea; box-shadow: 0 0 0 3px rgba(102,126,234,0.15); }

        .fields-row { display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; }

        .field-group label {
            display: block;
            font-size: 0.82rem;
            font-weight: 600;
            color: #6b7280;
            text-transform: uppercase;
            letter-spacing: 0.04em;
            margin-bottom: 0.4rem;
        }

        .submit-btn {
            width: 100%;
            padding: 0.85rem;
            margin-top: 1.2rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102,126,234,0.35);
        }

        .back-link {
            display: block;
            text-align: center;
            margin-top: 1.5rem;
            color: #6b7280;
            text-decoration: none;
            font-size: 0.9rem;
            transition: color 0.2s;
        }

        .back-link:hover { color: #667eea; }

        @media (max-width: 500px) {
            .detail-grid, .fields-row { grid-template-columns: 1fr; }
            .card-body { padding: 1.4rem; }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <h2>Complaint #<%= c.getId() %></h2>
            <div class="meta">Filed on: <%= c.getCreatedAt() != null ? c.getCreatedAt() : "N/A" %></div>
        </div>

        <div class="card-body">
            <div class="detail-grid">
                <div class="detail-item">
                    <span class="detail-label">Name</span>
                    <div class="detail-value"><%= c.getName() %></div>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Email</span>
                    <div class="detail-value"><%= c.getEmail() %></div>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Category</span>
                    <div class="detail-value">
                        <span class="chip"><%= c.getCategory() != null ? c.getCategory() : "Other" %></span>
                    </div>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Priority</span>
                    <div class="detail-value">
                        <%
                            String pri = c.getPriority() != null ? c.getPriority() : "Medium";
                            String priClass = pri.equals("High") ? "badge-high"
                                           : pri.equals("Low")  ? "badge-low"
                                           : "badge-medium";
                        %>
                        <span class="badge <%= priClass %>"><%= pri %></span>
                    </div>
                </div>
                <div class="detail-item full">
                    <span class="detail-label">Subject</span>
                    <div class="detail-value"><%= c.getSubject() %></div>
                </div>
                <div class="detail-item full">
                    <span class="detail-label">Description</span>
                    <div class="detail-value"><%= c.getDescription() %></div>
                </div>
                <div class="detail-item">
                    <span class="detail-label">Current Status</span>
                    <div class="detail-value">
                        <%
                            String st = c.getStatus();
                            String stClass = "badge-pending";
                            if ("Resolved".equals(st))   stClass = "badge-resolved";
                            else if ("In Progress".equals(st)) stClass = "badge-inprogress";
                            else if ("Rejected".equals(st))    stClass = "badge-rejected";
                        %>
                        <span class="badge <%= stClass %>"><%= st %></span>
                    </div>
                </div>
                <% if ("admin".equals(role)) { %>
                <div class="detail-item">
                    <span class="detail-label">Filed By</span>
                    <div class="detail-value"><%= c.getUsername() %></div>
                </div>
                <% } %>
            </div>

            <% if ("admin".equals(role)) { %>
            <div class="admin-form">
                <h3>⚙️ Update Complaint</h3>
                <form action="ComplaintServlet" method="post">
                    <input type="hidden" name="action"      value="update">
                    <input type="hidden" name="id"          value="<%= c.getId() %>">
                    <input type="hidden" name="name"        value="<%= c.getName() %>">
                    <input type="hidden" name="email"       value="<%= c.getEmail() %>">
                    <input type="hidden" name="subject"     value="<%= c.getSubject() %>">
                    <input type="hidden" name="description" value="<%= c.getDescription() %>">

                    <div class="fields-row">
                        <div class="field-group">
                            <label>Category</label>
                            <select name="category">
                                <% String[] cats = {"General","Infrastructure","Academic","Administrative","IT Support","Hostel","Transport","Other"}; %>
                                <% for (String cat : cats) { %>
                                    <option value="<%= cat %>" <%= cat.equals(c.getCategory()) ? "selected" : "" %>><%= cat %></option>
                                <% } %>
                            </select>
                        </div>
                        <div class="field-group">
                            <label>Priority</label>
                            <select name="priority">
                                <option value="Low"    <%= "Low".equals(c.getPriority())    ? "selected" : "" %>>🟢 Low</option>
                                <option value="Medium" <%= "Medium".equals(c.getPriority()) ? "selected" : "" %>>🟡 Medium</option>
                                <option value="High"   <%= "High".equals(c.getPriority())   ? "selected" : "" %>>🔴 High</option>
                            </select>
                        </div>
                        <div class="field-group">
                            <label>Status</label>
                            <select name="status">
                                <option value="Pending"     <%= "Pending".equals(c.getStatus())     ? "selected" : "" %>>Pending</option>
                                <option value="In Progress" <%= "In Progress".equals(c.getStatus()) ? "selected" : "" %>>In Progress</option>
                                <option value="Resolved"    <%= "Resolved".equals(c.getStatus())    ? "selected" : "" %>>Resolved</option>
                                <option value="Rejected"    <%= "Rejected".equals(c.getStatus())    ? "selected" : "" %>>Rejected</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="submit-btn">💾 Save Changes</button>
                </form>
            </div>
            <% } %>

            <a href="viewComplaint.jsp" class="back-link">← Back to Complaints</a>
        </div>
    </div>
</body>
</html>