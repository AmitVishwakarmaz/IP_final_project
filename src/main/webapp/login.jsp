<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login</title>
    
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

        .login-container {
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

        input[type="text"]:focus,
        input[type="password"]:focus {
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
        .signup-link {
    		color: #4f46e5;
    		text-decoration: none;
    		font-weight: 500;
    		transition: color 0.2s ease;
		}

		.signup-link:hover {
    		color: #4338ca;
    		text-decoration: underline;
		}

        .submit-btn:active {
            transform: translateY(0);
        }

        .error-message {
            color: #dc2626;
            font-size: 0.9rem;
            text-align: center;
            margin-top: 1.2rem;
            background: #fef2f2;
            padding: 0.8rem;
            border-radius: 6px;
            border: 1px solid #fecaca;
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 2rem 1.5rem;
            }
            h2 {
                font-size: 1.5rem;
            }
        }
    </style>
</head>
<body>

    <div class="login-container">
        <h2>Login</h2>

        <form action="LoginServlet" method="post">
            <div class="form-group">
                <label for="username">Username</label>
                <input 
                    type="text" 
                    id="username" 
                    name="username" 
                    required 
                    autocomplete="username"
                    placeholder="Enter your username"
                >
            </div>

            <div class="form-group">
                <label for="password">Password</label>
                <input 
                    type="password" 
                    id="password" 
                    name="password" 
                    required 
                    autocomplete="current-password"
                    placeholder="••••••••"
                >
            </div>

            <button type="submit" class="submit-btn">Sign In</button>
            <br>
            
        </form>

        <% if(request.getAttribute("error") != null) { %>
            <div class="error-message">
                <%= request.getAttribute("error") %>
            </div>
        <% } %>
        <!-- ... your existing form code ... -->

        <div style="text-align: center; margin-top: 1.8rem; color: #4b5563; font-size: 0.95rem;">
            Don't have an account?
            <a href="signup.jsp" 
               style="color: #4f46e5; text-decoration: none; font-weight: 500; transition: color 0.2s ease;">
                Sign Up
            </a>
        </div>
    </div>
    
        
</body>
</html>