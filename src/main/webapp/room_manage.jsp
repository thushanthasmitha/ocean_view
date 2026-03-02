<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.dao.RoomDAO" %>
<%@ page import="com.mycompany.ocean_view.model.Room" %>

<%
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login");
        return;
    }

    String role = (String) session.getAttribute("role");
    if (role == null || !(role.equals("ADMIN") || role.equals("MANAGER"))) {
        out.println("<div style='text-align:center; padding:50px; font-family:sans-serif;'>");
        out.println("<h2 style='color:#dc2626;'>Access Denied</h2>");
        out.println("<p>You do not have permission to manage rooms.</p>");
        out.println("<a href='dashboard.jsp' style='color:#2563eb;'>Back to Dashboard</a></div>");
        return;
    }

    String msg = null;
    String err = null;

    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String roomNumber = request.getParameter("roomNumber");
        String roomType   = request.getParameter("roomType");
        String status     = request.getParameter("status");

        try {
            if (roomNumber == null || roomNumber.trim().isEmpty()) throw new IllegalArgumentException("Room number is required.");
            if (roomType == null || roomType.trim().isEmpty()) throw new IllegalArgumentException("Room type is required.");
            if (status == null || status.trim().isEmpty()) throw new IllegalArgumentException("Status is required.");

            new RoomDAO().insertRoom(roomNumber.trim(), roomType.trim(), status.trim());
            msg = "Room added successfully!";
        } catch (Exception e) {
            err = "Error: " + e.getMessage();
        }
    }

    List<Room> rooms = new ArrayList<>();
    try {
        rooms = new RoomDAO().findAll();
    } catch (Exception e) {
        err = (err == null ? "" : err + "<br/>") + "Load error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Manage Rooms | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --bg: #f8fafc;
            --card: #ffffff;
            --text: #1e293b;
            --border: #e2e8f0;
            --success: #166534;
            --error: #991b1b;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 30px;
        }

        .container { max-width: 1000px; margin: 0 auto; }

        .header-section {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 25px;
        }

        h2, h3 { margin: 0; font-weight: 700; }
        .back-link { text-decoration: none; color: #64748b; font-size: 0.9rem; }
        .back-link:hover { color: var(--primary); }

        /* Form and Table Layout */
        .grid-layout {
            display: grid;
            grid-template-columns: 320px 1fr;
            gap: 30px;
            align-items: start;
        }

        .card {
            background: var(--card);
            padding: 24px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border);
        }

        .alert {
            padding: 12px;
            border-radius: 8px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
        .alert-success { background: #dcfce7; color: var(--success); border: 1px solid #bbf7d0; }
        .alert-error { background: #fee2e2; color: var(--error); border: 1px solid #fecaca; }

        .form-group { margin-bottom: 15px; }
        label { display: block; font-size: 0.8rem; font-weight: 600; margin-bottom: 6px; text-transform: uppercase; color: #64748b; }
        
        input, select {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border);
            border-radius: 6px;
            font-size: 0.95rem;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }
        input:focus, select:focus { outline: none; border-color: var(--primary); }

        button {
            width: 100%;
            background: var(--primary);
            color: white;
            border: none;
            padding: 12px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            margin-top: 10px;
        }
        button:hover { background: #1d4ed8; }

        /* Table Styling */
        .table-container { overflow-x: auto; }
        table {
            width: 100%;
            border-collapse: collapse;
            background: var(--card);
        }
        th {
            background: #f1f5f9;
            text-align: left;
            padding: 12px 15px;
            font-size: 0.85rem;
            font-weight: 600;
            text-transform: uppercase;
            border-bottom: 2px solid var(--border);
        }
        td { padding: 12px 15px; border-bottom: 1px solid var(--border); font-size: 0.95rem; }
        
        .status-pill {
            padding: 4px 10px;
            border-radius: 20px;
            font-size: 0.75rem;
            font-weight: 700;
        }
        .status-ACTIVE { background: #dcfce7; color: #166534; }
        .status-MAINTENANCE { background: #fef9c3; color: #854d0e; }
        .status-INACTIVE { background: #f1f5f9; color: #475569; }

        @media (max-width: 850px) {
            .grid-layout { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header-section">
        <h2>Manage Rooms</h2>
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <% if (msg != null) { %> <div class="alert alert-success"><%= msg %></div> <% } %>
    <% if (err != null) { %> <div class="alert alert-error"><%= err %></div> <% } %>

    <div class="grid-layout">
        <div class="card">
            <h3 style="margin-bottom: 20px; font-size: 1.1rem;">Add New Room</h3>
            <form method="post" action="room_manage.jsp">
                <div class="form-group">
                    <label>Room Number</label>
                    <input type="text" name="roomNumber" placeholder="e.g. 101" required />
                </div>

                <div class="form-group">
                    <label>Room Type</label>
                    <select name="roomType" required>
                        <option value="">-- Select --</option>
                        <option value="STANDARD">STANDARD</option>
                        <option value="DELUXE">DELUXE</option>
                        <option value="SUITE">SUITE</option>
                    </select>
                </div>

                <div class="form-group">
                    <label>Status</label>
                    <select name="status" required>
                        <option value="">-- Select --</option>
                        <option value="ACTIVE">ACTIVE</option>
                        <option value="MAINTENANCE">MAINTENANCE</option>
                        <option value="INACTIVE">INACTIVE</option>
                    </select>
                </div>

                <button type="submit">Create Room</button>
            </form>
        </div>

        <div class="card table-container">
            <h3 style="margin-bottom: 20px; font-size: 1.1rem;">Current Room Inventory</h3>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Room No</th>
                        <th>Type</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (rooms == null || rooms.isEmpty()) { %>
                        <tr><td colspan="4" style="text-align:center; color:#94a3b8;">No rooms found in the system.</td></tr>
                    <% } else {
                        for (Room r : rooms) { %>
                        <tr>
                            <td style="color:#64748b; font-weight: 500;"><%= r.getRoomId() %></td>
                            <td style="font-weight: 600;"><%= r.getRoomNumber() %></td>
                            <td><%= r.getRoomType() %></td>
                            <td>
                                <span class="status-pill status-<%= r.getStatus() %>">
                                    <%= r.getStatus() %>
                                </span>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>
</div>

</body>
</html>