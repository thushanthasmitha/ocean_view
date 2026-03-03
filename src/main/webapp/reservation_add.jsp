<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.dao.RoomDAO" %>
<%@ page import="com.mycompany.ocean_view.model.Room" %>
<%
  if (session.getAttribute("username") == null) { response.sendRedirect("login"); return; }
  List<Room> rooms = new RoomDAO().listActiveRooms();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Reservation | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --secondary-color: #64748b;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-color: #1e293b;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-color);
            margin: 0;
            padding: 20px;
            display: flex;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 600px;
            background: var(--card-bg);
            padding: 40px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 30px;
        }

        h2 {
            margin: 0;
            font-size: 1.5rem;
            color: var(--text-color);
        }

        .back-link {
            text-decoration: none;
            color: var(--secondary-color);
            font-size: 0.9rem;
            display: flex;
            align-items: center;
        }

        .back-link:hover { color: var(--primary-color); }

        .alert {
            padding: 12px;
            border-radius: 6px;
            margin-bottom: 20px;
            font-size: 0.9rem;
        }
        .alert-success { background: #dcfce7; color: #166534; border: 1px solid #bbf7d0; }
        .alert-error { background: #fee2e2; color: #991b1b; border: 1px solid #fecaca; }

        .form-group { margin-bottom: 20px; }

        label {
            display: block;
            font-weight: 600;
            margin-bottom: 8px;
            font-size: 0.85rem;
            text-transform: uppercase;
            letter-spacing: 0.025em;
        }

        input, select {
            width: 100%;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            box-sizing: border-box;
            transition: border-color 0.2s;
        }

        input:focus, select:focus {
            outline: none;
            border-color: var(--primary-color);
            box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
        }

        .grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        button {
            width: 100%;
            background-color: var(--primary-color);
            color: white;
            padding: 14px;
            border: none;
            border-radius: 8px;
            font-size: 1rem;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
            margin-top: 10px;
        }

        button:hover { background-color: #1d4ed8; }

        @media (max-width: 480px) {
            .grid { grid-template-columns: 1fr; }
            .container { padding: 20px; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>Add New Reservation</h2>
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <%-- Messages --%>
    <% if (request.getAttribute("msg") != null) { %>
        <div class="alert alert-success"><%= request.getAttribute("msg") %></div>
    <% } %>
    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <form method="post" action="reservation/add">
        <div class="form-group">
            <label>Reservation Number</label>
            <input type="text" name="reservationNumber" placeholder="RES-1001" required>
        </div>

        <div class="form-group">
            <label>Guest Full Name</label>
            <input type="text" name="fullName" placeholder="guest name" required>
        </div>

        <div class="form-group">
            <label>Address</label>
            <input type="text" name="address" placeholder="123 Street, City" required>
        </div>

        <div class="grid">
            <div class="form-group">
                <label>Contact Number</label>
                <input type="tel" name="contactNumber" placeholder="+94..." required>
            </div>
            <div class="form-group">
                <label>Email (Optional)</label>
                <input type="email" name="email" placeholder="name@example.com">
            </div>
        </div>

        <div class="form-group">
            <label>Room Allocation</label>
            <select name="roomId" required>
                <option value="" disabled selected>Select a room</option>
                <% for (Room r : rooms) { %>
                  <option value="<%= r.getRoomId() %>">
                    Room <%= r.getRoomNumber() %> - <%= r.getRoomType() %>
                  </option>
                <% } %>
            </select>
        </div>

        <div class="grid">
            <div class="form-group">
                <label>Check-in Date</label>
                <input type="date" name="checkIn" required>
            </div>
            <div class="form-group">
                <label>Check-out Date</label>
                <input type="date" name="checkOut" required>
            </div>
        </div>

        <button type="submit">Confirm & Save Reservation</button>
    </form>
</div>

</body>
</html>