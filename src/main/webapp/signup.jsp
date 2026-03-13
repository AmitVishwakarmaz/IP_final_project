<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Create Account</title>

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f5f6f8;
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }

        .signup-container {
            background: white;
            width: 100%;
            max-width: 420px;
            padding: 2.5rem 2rem;
            border-radius: 12px;
            box-shadow: 0 10px 25px rgba(0, 0, 0, 0.08);
            animation: fadeInUp 0.6s ease-out;
        }

        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(25px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        h2 {
            text-align: center;
            margin-bottom: 2rem;
            color: #1f2937;
            font-weight: 600;
            font-size: 1.75rem;
        }

        .form-group {
            margin-bottom: 1.5rem;
        }

        label {
            display: block;
            margin-bottom: 0.5rem;
            color: #374151;
            font-weight: 500;
            font-size: 0.95rem;
        }

        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 0.75rem 1rem;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 1rem;
            transition: all 0.2s ease;
        }

        input:focus {
            outline: none;
            border-color: #6366f1;
            box-shadow: 0 0 0 3px rgba(99, 102, 241, 0.12);
        }

        .submit-btn {
            width: 100%;
            padding: 0.9rem;
            background: #4f46e5;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 1.05rem;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.25s ease;
            margin-top: 1rem;
        }

        .submit-btn:hover {
            background: #4338ca;
            transform: translateY(-1px);
            box-shadow: 0 6px 15px rgba(79, 70, 229, 0.2);
        }

        .error-message {
            background: #fee2e2;
            color: #b91c1c;
            padding: 10px;
            border-radius: 6px;
            margin-bottom: 15px;
            font-size: 0.9rem;
            text-align: center;
        }

        .login-link {
            display: block;
            text-align: center;
            margin-top: 1.8rem;
            color: #4b5563;
            font-size: 0.95rem;
        }

        .login-link a {
            color: #4f46e5;
            text-decoration: none;
            font-weight: 500;
        }

        .login-link a:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>

    <div class="signup-container">
        <h2>Create Account</h2>


        <%
            if(request.getAttribute("error") != null){
        %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <%
            }
        %>

        <form action="<%=request.getContextPath()%>/SignupServlet" method="post">
            <div class="form-group">
                <label>Username</label>
                <input 
                    type="text" 
                    name="username" 
                    required 
                    autocomplete="username"
                    placeholder="Choose a username"
                >
            </div>

            <div class="form-group">
                <label>Password</label>
                <input 
                    type="password" 
                    name="password" 
                    required 
                    autocomplete="new-password"
                    placeholder="••••••••"
                >
            </div>

            <button type="submit" class="submit-btn">Register</button>
        </form>

        <div class="login-link">
            Already have an account? <a href="login.jsp">Login here</a>
        </div>
    </div>

</body>
</html>
