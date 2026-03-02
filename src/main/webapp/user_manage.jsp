<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.model.User" %>

<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  Object roleObj = session.getAttribute("role");
  if (roleObj == null || !"ADMIN".equals(String.valueOf(roleObj))) {
    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
    return;
  }

  String ctx = request.getContextPath();
  List<User> users = (List<User>) request.getAttribute("users");
  if (users == null) users = new ArrayList<>();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Users | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --bg: #f8fafc;
            --card: #ffffff;
            --text: #1e293b;
            --border: #e2e8f0;
            --success: #166534;
            --danger: #dc2626;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 30px;
        }

        .container { max-width: 1100px; margin: 0 auto; }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h2, h3 { margin: 0; font-weight: 700; }
        .back-link { text-decoration: none; color: #64748b; font-size: 0.9rem; }
        .back-link:hover { color: var(--primary); }

        .card {
            background: var(--card);
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border);
            margin-bottom: 30px;
        }

        /* Form Styling */
        .inline-form {
            display: flex;
            gap: 15px;
            flex-wrap: wrap;
            align-items: flex-end;
        }

        .form-group { flex: 1; min-width: 150px; }
        label { display: block; font-size: 0.75rem; font-weight: 700; margin-bottom: 6px; text-transform: uppercase; color: #64748b; }

        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 0.9rem;
            box-sizing: border-box;
        }

        .btn {
            padding: 10px 16px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            border: none;
            font-size: 0.85rem;
            transition: opacity 0.2s;
        }
        .btn:hover { opacity: 0.9; }
        .btn-primary { background: var(--primary); color: white; }
        .btn-outline { background: transparent; border: 1px solid var(--border); color: var(--text); }
        .btn-danger { background: #fee2e2; color: var(--danger); }
        .btn-success { background: #dcfce7; color: var(--success); }

        /* Table Styling */
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
        }
        th {
            background: #f1f5f9;
            text-align: left;
            padding: 12px 15px;
            font-size: 0.8rem;
            text-transform: uppercase;
            border-bottom: 2px solid var(--border);
        }
        td { padding: 12px 15px; border-bottom: 1px solid var(--border); font-size: 0.9rem; vertical-align: middle; }

        .badge {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .badge-active { background: #dcfce7; color: #166534; }
        .badge-inactive { background: #f1f5f9; color: #64748b; }

        .row-actions { display: flex; gap: 10px; align-items: center; }
        .mini-form { display: flex; gap: 5px; align-items: center; }
        .pw-input { width: 120px !important; padding: 6px 10px; font-size: 0.8rem; }
    </style>
</head>
<body>

<div class="container">
    <div class="header-section">
        <h2>User Management</h2>
        <a href="<%= ctx %>/dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <div class="card">
        <h3 style="font-size: 1rem; margin-bottom: 15px;">Create New User Account</h3>
        <form method="post" action="<%= ctx %>/users/manage" class="inline-form">
            <input type="hidden" name="action" value="create"/>
            
            <div class="form-group">
                <label>Username</label>
                <input type="text" name="username" placeholder="Enter username" required/>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password" name="password" placeholder="Enter password" required/>
            </div>

            <div class="form-group">
                <label>Role</label>
                <select name="role">
                    <option value="ADMIN">ADMIN</option>
                    <option value="MANAGER">MANAGER</option>
                    <option value="RECEPTIONIST">RECEPTIONIST</option>
                </select>
            </div>

            <div class="form-group">
                <label>Initial Status</label>
                <select name="active">
                    <option value="1">Active</option>
                    <option value="0">Inactive</option>
                </select>
            </div>

            <button type="submit" class="btn btn-primary" style="height: 41px;">Create Account</button>
        </form>
    </div>

    <div class="card" style="padding: 0; overflow: hidden;">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User Information</th>
                    <th>Role & Permission</th>
                    <th>Status</th>
                    <th style="text-align: center;">Quick Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                  for (User u : users) {
                %>
                <tr>
                    <td style="color: #94a3b8; width: 40px;"><%= u.getUserId() %></td>
                    <td><strong style="font-size: 0.95rem;"><%= u.getUsername() %></strong></td>
                    <td>
                        <form method="post" action="<%= ctx %>/users/manage" class="mini-form">
                            <input type="hidden" name="action" value="updateRole"/>
                            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                            <select name="role" style="padding: 5px; font-size: 0.8rem; width: auto;">
                                <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>ADMIN</option>
                                <option value="MANAGER" <%= "MANAGER".equals(u.getRole()) ? "selected" : "" %>>MANAGER</option>
                                <option value="RECEPTIONIST" <%= "RECEPTIONIST".equals(u.getRole()) ? "selected" : "" %>>RECEPTIONIST</option>
                            </select>
                            <button type="submit" class="btn btn-outline" style="padding: 5px 10px;">Save</button>
                        </form>
                    </td>
                    <td>
                        <span class="badge <%= u.isActive() ? "badge-active" : "badge-inactive" %>">
                            <%= u.isActive() ? "Active" : "Inactive" %>
                        </span>
                    </td>
                    <td>
                        <div class="row-actions" style="justify-content: center;">
                            <form method="post" action="<%= ctx %>/users/manage">
                                <input type="hidden" name="action" value="toggleActive"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <input type="hidden" name="active" value="<%= u.isActive() ? "0" : "1" %>"/>
                                <button type="submit" class="btn <%= u.isActive() ? "btn-danger" : "btn-success" %>" style="width: 100px;">
                                    <%= u.isActive() ? "Deactivate" : "Activate" %>
                                </button>
                            </form>

                            <form method="post" action="<%= ctx %>/users/manage" class="mini-form">
                                <input type="hidden" name="action" value="resetPassword"/>
                                <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
                                <input type="password" name="newPassword" class="pw-input" placeholder="New Password" required/>
                                <button type="submit" class="btn btn-primary" style="padding: 6px 12px;">Reset</button>
                            </form>
                        </div>
                    </td>
                </tr>
                <% } %>
                <% if(users.isEmpty()) { %>
                <tr><td colspan="5" style="text-align: center; padding: 30px; color: #94a3b8;">No users found in the system.</td></tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>

</body>
</html>