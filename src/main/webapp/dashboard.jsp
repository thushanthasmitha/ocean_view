<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }

  String role = (String) session.getAttribute("role");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard</title>
</head>
<body>

<h2>Welcome, <%= session.getAttribute("username") %>!</h2>
<p>Role: <%= role %></p>

<ul>

  <!-- All roles -->
  <li><a href="reservation_add.jsp">Add Reservation</a></li>
  <li><a href="reservation_view.jsp">View Reservation</a></li>
  <li><a href="bill.jsp">Generate Bill</a></li>

  <!-- MANAGER & ADMIN only -->
  <% if ("ADMIN".equals(role) || "MANAGER".equals(role)) { %>
      <li><a href="room_manage.jsp">Manage Rooms</a></li>
  <% } %>

  <!-- ADMIN only -->
  <% if ("ADMIN".equals(role)) { %>
      <li><a href="user_manage.jsp">Manage Users</a></li>
  <% } %>

  <li><a href="help.jsp">Help</a></li>
  <li><a href="logout">Logout</a></li>

</ul>

</body>
</html>