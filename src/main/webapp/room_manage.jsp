<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.dao.RoomDAO" %>
<%@ page import="com.mycompany.ocean_view.model.Room" %>

<%
    // Login check
    if (session.getAttribute("username") == null) {
        response.sendRedirect("login");
        return;
    }

    // Optional: Only ADMIN/MANAGER can manage rooms
    String role = (String) session.getAttribute("role");
    if (role == null || !(role.equals("ADMIN") || role.equals("MANAGER"))) {
        out.println("<h3>Access Denied</h3>");
        out.println("<p>You do not have permission to manage rooms.</p>");
        out.println("<a href='dashboard.jsp'>Back</a>");
        return;
    }

    String msg = null;
    String err = null;

    // Handle form submit (POST -> same JSP)
    if ("POST".equalsIgnoreCase(request.getMethod())) {
        String roomNumber = request.getParameter("roomNumber");
        String roomType   = request.getParameter("roomType");
        String status     = request.getParameter("status");

        try {
            if (roomNumber == null || roomNumber.trim().isEmpty()) {
                throw new IllegalArgumentException("Room number is required.");
            }
            if (roomType == null || roomType.trim().isEmpty()) {
                throw new IllegalArgumentException("Room type is required.");
            }
            if (status == null || status.trim().isEmpty()) {
                throw new IllegalArgumentException("Status is required.");
            }

            RoomDAO dao = new RoomDAO();
            dao.insertRoom(roomNumber.trim(), roomType.trim(), status.trim());

            msg = "Room added successfully!";
        } catch (Exception e) {
            err = "Error: " + e.getMessage();
        }
    }

    // Load rooms list
    List<Room> rooms = new ArrayList<>();
    try {
        RoomDAO dao = new RoomDAO();
        rooms = dao.findAll();
    } catch (Exception e) {
        err = (err == null ? "" : err + "<br/>") + "Load error: " + e.getMessage();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>Manage Rooms</title>
    <style>
        body { font-family: Arial; margin: 20px; }
        .box { border: 1px solid #ccc; padding: 15px; border-radius: 8px; width: 420px; }
        input, select { width: 100%; padding: 8px; margin-top: 6px; margin-bottom: 12px; }
        button { padding: 10px 14px; cursor: pointer; }
        table { border-collapse: collapse; width: 100%; margin-top: 18px; }
        th, td { border: 1px solid #ddd; padding: 10px; text-align: left; }
        th { background: #f3f3f3; }
        .msg { color: green; margin: 10px 0; }
        .err { color: red; margin: 10px 0; }
    </style>
</head>
<body>

<h2>Manage Rooms</h2>
<a href="dashboard.jsp">← Back to Dashboard</a>

<% if (msg != null) { %>
    <div class="msg"><%= msg %></div>
<% } %>

<% if (err != null) { %>
    <div class="err"><%= err %></div>
<% } %>

<div class="box">
    <form method="post" action="room_manage.jsp">
        <label>Room Number</label>
        <input type="text" name="roomNumber" placeholder="e.g. 101" required />

        <label>Room Type</label>
        <select name="roomType" required>
            <option value="">-- Select --</option>
            <option value="STANDARD">STANDARD</option>
            <option value="DELUXE">DELUXE</option>
            <option value="SUITE">SUITE</option>
        </select>

        <label>Status</label>
        <select name="status" required>
            <option value="">-- Select --</option>
            <option value="ACTIVE">ACTIVE</option>
            <option value="MAINTENANCE">MAINTENANCE</option>
            <option value="INACTIVE">INACTIVE</option>
        </select>

        <button type="submit">Add Room</button>
    </form>
</div>

<h3>Room List</h3>
<table>
    <tr>
        <th>ID</th>
        <th>Room Number</th>
        <th>Room Type</th>
        <th>Status</th>
    </tr>
    <%
        if (rooms == null || rooms.isEmpty()) {
    %>
        <tr><td colspan="4">No rooms found.</td></tr>
    <%
        } else {
            for (Room r : rooms) {
    %>
        <tr>
            <td><%= r.getRoomId() %></td>
            <td><%= r.getRoomNumber() %></td>
            <td><%= r.getRoomType() %></td>
            <td><%= r.getStatus() %></td>
        </tr>
    <%
            }
        }
    %>
</table>

</body>
</html>