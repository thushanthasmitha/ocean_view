<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }
  String role = (String) session.getAttribute("role");
  String username = (String) session.getAttribute("username");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Ocean View - Dashboard</title>
    <style>
        :root {
            --primary-dark: #023047;
            --secondary-blue: #219ebc;
            --accent-gold: #ffb703;
            --light-bg: #f8f9fa;
            --text-main: #333;
            --sidebar-width: 260px;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            display: flex;
            background-color: var(--light-bg);
            color: var(--text-main);
        }

        /* Sidebar Styling */
        .sidebar {
            width: var(--sidebar-width);
            height: 100vh;
            background-color: var(--primary-dark);
            color: white;
            position: fixed;
            display: flex;
            flex-direction: column;
            box-shadow: 2px 0 10px rgba(0,0,0,0.1);
        }

        .sidebar-header {
            padding: 30px 20px;
            text-align: center;
            border-bottom: 1px solid rgba(255,255,255,0.1);
        }

        .sidebar-header h2 {
            margin: 0;
            font-size: 20px;
            letter-spacing: 1px;
            color: var(--accent-gold);
        }

        .nav-list {
            list-style: none;
            padding: 20px 0;
            margin: 0;
            flex-grow: 1;
        }

        .nav-list li a {
            display: block;
            padding: 15px 25px;
            color: #cbd5e0;
            text-decoration: none;
            transition: all 0.3s;
            font-size: 15px;
            border-left: 4px solid transparent;
        }

        .nav-list li a:hover {
            background-color: rgba(255,255,255,0.05);
            color: white;
            border-left: 4px solid var(--accent-gold);
        }

        .logout-link {
            border-top: 1px solid rgba(255,255,255,0.1);
            color: #ff6b6b !important;
        }

        /* Main Content Styling */
        .main-content {
            margin-left: var(--sidebar-width);
            width: calc(100% - var(--sidebar-width));
            padding: 40px;
        }

        .header-bar {
            background: white;
            padding: 20px 30px;
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.05);
            margin-bottom: 30px;
        }

        .user-info h3 { margin: 0; color: var(--primary-dark); }
        .role-badge {
            background: var(--secondary-blue);
            color: white;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            text-transform: uppercase;
            font-weight: bold;
        }

        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 20px;
        }

        .card {
            background: white;
            padding: 25px;
            border-radius: 10px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.02);
            border-bottom: 4px solid var(--secondary-blue);
        }

        .card h4 { margin: 0 0 10px 0; color: #777; font-size: 14px; }
        .card p { margin: 0; font-size: 18px; font-weight: bold; color: var(--primary-dark); }

    </style>
</head>
<body>

    <nav class="sidebar">
        <div class="sidebar-header">
            <h2>OCEAN VIEW</h2>
        </div>
        <ul class="nav-list">
            <li><a href="reservation_add.jsp">Add Reservation</a></li>
            <li><a href="reservation_view.jsp">View Reservations</a></li>
            <li><a href="bill.jsp">Billing System</a></li>

            <% if ("ADMIN".equals(role) || "MANAGER".equals(role)) { %>
                <li><a href="room_manage.jsp">Manage Rooms</a></li>
            <% } %>

            <% if ("ADMIN".equals(role)) { %>
                <li><a href="user_manage.jsp">User Management</a></li>
            <% } %>

            <li><a href="help.jsp">Support & Help</a></li>
            <li><a href="logout" class="logout-link">Sign Out</a></li>
        </ul>
    </nav>

    <div class="main-content">
        <header class="header-bar">
            <div class="user-info">
                <h3>Welcome back, <%= username %>!</h3>
            </div>
            <span class="role-badge"><%= role %></span>
        </header>

        <section class="stats-grid">
            <div class="card">
                <h4>Status</h4>
                <p>System Online</p>
            </div>
            <div class="card">
                <h4>Current Session</h4>
                <p>Authenticated as <%= role %></p>
            </div>
            <div class="card">
                <h4>Quick Action</h4>
                <p>Review Recent Bookings</p>
            </div>
        </section>

        </div>

</body>
</html>