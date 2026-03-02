<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View - Login</title>
    <style>
        
        body {
            font-family: 'Poppins', 'Segoe UI', sans-serif;
            margin: 0;
            padding: 0;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            
            background: linear-gradient(rgba(2, 48, 71, 0.8), rgba(2, 48, 71, 0.8)), 
                        url('https://images.unsplash.com/photo-1520250497591-112f2f40a3f4?ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80');
            background-size: cover;
            background-position: center;
        }

        
        .login-card {
            background: white;
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 15px 35px rgba(0,0,0,0.3);
            width: 100%;
            max-width: 400px;
            text-align: center;
        }

        h2 {
            color: #023047;
            margin-bottom: 10px;
            font-size: 26px;
            letter-spacing: 1px;
            text-transform: uppercase;
        }

        .error-msg {
            background: #ffe5e5;
            color: #d9534f;
            padding: 10px;
            border-radius: 5px;
            margin-bottom: 20px;
            font-size: 14px;
            border-left: 5px solid #d9534f;
        }

        
        .form-group {
            text-align: left;
            margin-bottom: 20px;
        }

        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #444;
            font-size: 14px;
        }

        input[type="text"], 
        input[type="password"],
        input[name="username"] {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 6px;
            box-sizing: border-box; 
            font-size: 16px;
            transition: border-color 0.3s;
        }

        input:focus {
            outline: none;
            border-color: #219ebc;
            box-shadow: 0 0 5px rgba(33, 158, 188, 0.3);
        }

        
        button {
            background-color: #023047;
            color: #ffb703; 
            border: none;
            padding: 14px;
            width: 100%;
            border-radius: 6px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            transition: all 0.3s ease;
            text-transform: uppercase;
        }

        button:hover {
            background-color: #219ebc;
            color: white;
            transform: translateY(-2px);
        }

        
        .footer-text {
            margin-top: 20px;
            font-size: 12px;
            color: #888;
        }
    </style>
</head>
<body>

<div class="login-card">
    <h2>Ocean View Resort</h2>
    <p style="color: #666; margin-bottom: 25px;">Welcome Back! Please login.</p>

    <% if (request.getAttribute("error") != null) { %>
        <div class="error-msg">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>

    <form method="post" action="login">
        <div class="form-group">
            <label>Username</label>
            <input name="username" required placeholder="Enter your username">
        </div>

        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" required placeholder="Enter your password">
        </div>

        <button type="submit">Login</button>
    </form>

    <div class="footer-text">
        &copy; 2026 Ocean View Resort & Spa. All rights reserved.
    </div>
</div>

</body>
</html>