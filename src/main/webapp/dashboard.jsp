<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role     = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");

    if (role == null || username == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard – Complaint Portal</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 24px;
        }

        .card {
            background: white;
            width: 100%;
            max-width: 460px;
            border-radius: 20px;
            box-shadow: 0 25px 60px rgba(0,0,0,0.25);
            overflow: hidden;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-top {
            background: linear-gradient(135deg, #667eea, #764ba2);
            padding: 2.2rem 2rem;
            text-align: center;
            color: white;
        }

        .avatar {
            width: 68px; height: 68px;
            border-radius: 50%;
            background: rgba(255,255,255,0.2);
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 2rem;
            margin: 0 auto 1rem;
            border: 3px solid rgba(255,255,255,0.4);
        }

        .welcome-text {
            font-size: 1.5rem;
            font-weight: 700;
            margin-bottom: 0.3rem;
        }

        .welcome-text .uname { opacity: 0.9 }

        .role-badge {
            display: inline-block;
            padding: 0.3rem 0.9rem;
            background: rgba(255,255,255,0.2);
            border-radius: 9999px;
            font-size: 0.82rem;
            font-weight: 500;
            letter-spacing: 0.04em;
            backdrop-filter: blur(4px);
        }

        .card-body {
            padding: 2rem;
        }

        .section-label {
            font-size: 0.75rem;
            font-weight: 600;
            color: #9ca3af;
            text-transform: uppercase;
            letter-spacing: 0.08em;
            margin-bottom: 0.9rem;
        }

        .btn-group {
            display: flex;
            flex-direction: column;
            gap: 0.75rem;
            margin-bottom: 1.8rem;
        }

        .btn {
            display: flex;
            align-items: center;
            gap: 0.75rem;
            padding: 0.95rem 1.2rem;
            border-radius: 12px;
            text-decoration: none;
            font-size: 0.97rem;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            border: none;
            cursor: pointer;
            transition: all 0.22s ease;
        }

        .btn-icon {
            width: 36px; height: 36px;
            border-radius: 9px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.1rem;
            flex-shrink: 0;
        }

        .btn-primary {
            background: linear-gradient(135deg,#667eea,#764ba2);
            color: white;
        }

        .btn-primary .btn-icon { background: rgba(255,255,255,0.2); }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102,126,234,0.4);
        }

        .btn-secondary {
            background: #f8fafc;
            color: #374151;
            border: 1.5px solid #e5e7eb;
        }

        .btn-secondary .btn-icon { background: #ede9fe; }

        .btn-secondary:hover {
            border-color: #667eea;
            background: #faf5ff;
            color: #5b21b6;
            transform: translateY(-1px);
        }

        .btn-analytics {
            background: #faf5ff;
            color: #5b21b6;
            border: 1.5px solid #ddd6fe;
        }

        .btn-analytics .btn-icon { background: #ddd6fe; }

        .btn-analytics:hover {
            background: #ede9fe;
            border-color: #c4b5fd;
            transform: translateY(-1px);
        }

        .btn-logout {
            background: #fff1f2;
            color: #be123c;
            border: 1.5px solid #fecdd3;
        }

        .btn-logout .btn-icon { background: #fecdd3; }

        .btn-logout:hover {
            background: #fee2e2;
            border-color: #fca5a5;
            transform: translateY(-1px);
        }

        .divider {
            border: none;
            border-top: 1px solid #f3f4f6;
            margin: 1.5rem 0;
        }

        @media (max-width: 460px) {
            .card-top { padding: 1.8rem 1.5rem; }
            .card-body { padding: 1.5rem; }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-top">
            <div class="avatar">
                <%= "admin".equals(role) ? "👑" : "👤" %>
            </div>
            <div class="welcome-text">
                Welcome, <span class="uname"><%= username %></span>
            </div>
            <span class="role-badge">
                <%= "admin".equals(role) ? "Administrator" : "User Account" %>
            </span>
        </div>

        <div class="card-body">

            <% if ("admin".equals(role)) { %>

                <div class="section-label">Administration</div>
                <div class="btn-group">
                    <a href="viewComplaint.jsp" class="btn btn-primary">
                        <span class="btn-icon">📋</span>
                        View All Complaints
                    </a>
                    <a href="AnalyticsServlet" class="btn btn-analytics">
                        <span class="btn-icon">📊</span>
                        Analytics Dashboard
                    </a>
                </div>

            <% } else { %>

                <div class="section-label">Quick Actions</div>
                <div class="btn-group">
                    <a href="addComplaint.jsp" class="btn btn-primary">
                        <span class="btn-icon">✍️</span>
                        Register New Complaint
                    </a>
                    <a href="viewComplaint.jsp" class="btn btn-secondary">
                        <span class="btn-icon">📋</span>
                        My Complaints
                    </a>
                </div>

            <% } %>

            <hr class="divider">

            <div class="btn-group" style="margin-bottom:0;">
                <a href="LogoutServlet" class="btn btn-logout">
                    <span class="btn-icon">🚪</span>
                    Logout
                </a>
            </div>
        </div>
    </div>
</body>
</html>