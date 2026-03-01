<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.dao.RoomDAO" %>
<%@ page import="com.mycompany.ocean_view.model.Room" %>
<%
  if (session.getAttribute("username") == null) { response.sendRedirect("login"); return; }
  List<Room> rooms = new RoomDAO().listActiveRooms();
%>
<!DOCTYPE html>
<html>
<head><title>Add Reservation</title></head>
<body>
<h2>Add New Reservation</h2>
<a href="dashboard.jsp">← Back</a>

<% if (request.getAttribute("msg") != null) { %>
<p style="color:green;"><%= request.getAttribute("msg") %></p>
<% } %>
<% if (request.getAttribute("error") != null) { %>
<p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

<form method="post" action="reservation/add">
  Reservation Number:<br><input name="reservationNumber" required><br><br>

  Guest Full Name:<br><input name="fullName" required><br><br>
  Address:<br><input name="address" required><br><br>
  Contact Number:<br><input name="contactNumber" required><br><br>
  Email (optional):<br><input name="email"><br><br>

  Room:<br>
  <select name="roomId" required>
    <% for (Room r : rooms) { %>
      <option value="<%= r.getRoomId() %>">
        <%= r.getRoomNumber() %> - <%= r.getRoomType() %>
      </option>
    <% } %>
  </select><br><br>

  Check-in (YYYY-MM-DD):<br><input name="checkIn" required><br><br>
  Check-out (YYYY-MM-DD):<br><input name="checkOut" required><br><br>

  <button type="submit">Save Reservation</button>
</form>
</body>
</html>