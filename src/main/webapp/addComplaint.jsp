<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Complaint</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
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
            max-width: 560px;
            border-radius: 16px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2);
            padding: 2.5rem 2.2rem;
            animation: slideUp 0.5s ease-out;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .card-header {
            text-align: center;
            margin-bottom: 2rem;
        }

        .card-header .icon {
            width: 56px; height: 56px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 14px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 1.6rem;
            margin-bottom: 0.8rem;
        }

        h2 {
            color: #1a1a2e;
            font-size: 1.6rem;
            font-weight: 700;
        }

        .subtitle {
            color: #6b7280;
            font-size: 0.9rem;
            margin-top: 0.3rem;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1rem;
        }

        .form-group {
            margin-bottom: 1.4rem;
        }

        label {
            display: block;
            margin-bottom: 0.45rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.88rem;
            letter-spacing: 0.02em;
        }

        .required-star { color: #ef4444; }

        input[type="text"],
        input[type="email"],
        textarea,
        select {
            width: 100%;
            padding: 0.72rem 1rem;
            border: 1.5px solid #e5e7eb;
            border-radius: 8px;
            font-size: 0.95rem;
            font-family: 'Inter', sans-serif;
            color: #1f2937;
            background: #fafafa;
            transition: all 0.2s ease;
            appearance: none;
        }

        textarea { min-height: 100px; resize: vertical; }

        select {
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' fill='none' viewBox='0 0 20 20'%3E%3Cpath stroke='%236b7280' stroke-linecap='round' stroke-linejoin='round' stroke-width='1.5' d='M6 8l4 4 4-4'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 0.75rem center;
            background-size: 1.2em;
            padding-right: 2.5rem;
        }

        input:focus, textarea:focus, select:focus {
            outline: none;
            border-color: #667eea;
            background: white;
            box-shadow: 0 0 0 3px rgba(102,126,234,0.15);
        }

        /* Priority colour hints */
        select[name="priority"] option[value="High"]   { color: #dc2626; }
        select[name="priority"] option[value="Medium"] { color: #d97706; }
        select[name="priority"] option[value="Low"]    { color: #16a34a; }

        .submit-btn {
            width: 100%;
            padding: 0.9rem;
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: white;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            font-family: 'Inter', sans-serif;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 0.5rem;
            letter-spacing: 0.02em;
        }

        .submit-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 10px 25px rgba(102,126,234,0.4);
        }

        .submit-btn:active { transform: translateY(0); }

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
            .form-row { grid-template-columns: 1fr; }
            .card { padding: 2rem 1.4rem; }
        }
    </style>
</head>
<body>
    <div class="card">
        <div class="card-header">
            <div class="icon">📝</div>
            <h2>File a Complaint</h2>
            <p class="subtitle">Fill in the details below and we'll address it promptly.</p>
        </div>

        <form action="ComplaintServlet" method="post">

            <div class="form-row">
                <div class="form-group">
                    <label for="name">Full Name <span class="required-star">*</span></label>
                    <input type="text" id="name" name="name" required
                           placeholder="Your full name" autocomplete="name">
                </div>
                <div class="form-group">
                    <label for="email">Email Address <span class="required-star">*</span></label>
                    <input type="email" id="email" name="email" required
                           placeholder="you@example.com" autocomplete="email">
                </div>
            </div>

            <div class="form-group">
                <label for="subject">Subject <span class="required-star">*</span></label>
                <input type="text" id="subject" name="subject" required
                       placeholder="Brief title of your complaint">
            </div>

            <div class="form-row">
                <div class="form-group">
                    <label for="category">Category <span class="required-star">*</span></label>
                    <select id="category" name="category" required>
                        <option value="" disabled selected>Select category</option>
                        <option value="General">General</option>
                        <option value="Infrastructure">Infrastructure</option>
                        <option value="Academic">Academic</option>
                        <option value="Administrative">Administrative</option>
                        <option value="IT Support">IT Support</option>
                        <option value="Hostel">Hostel</option>
                        <option value="Transport">Transport</option>
                        <option value="Other">Other</option>
                    </select>
                </div>
                <div class="form-group">
                    <label for="priority">Priority <span class="required-star">*</span></label>
                    <select id="priority" name="priority" required>
                        <option value="" disabled selected>Select priority</option>
                        <option value="Low">🟢 Low</option>
                        <option value="Medium" selected>🟡 Medium</option>
                        <option value="High">🔴 High</option>
                    </select>
                </div>
            </div>

            <div class="form-group">
                <label for="description">Description <span class="required-star">*</span></label>
                <textarea id="description" name="description" required
                          placeholder="Please describe your issue in detail..."></textarea>
            </div>

            <button type="submit" class="submit-btn">🚀 Submit Complaint</button>
        </form>

        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>
</body>
</html>