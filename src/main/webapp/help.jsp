<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("username") == null) { 
      response.sendRedirect("login"); 
      return; 
  }
%>
<!DOCTYPE html>
<html>
<head>
  <title>Help</title>
</head>
<body>
  <h2>Help - Ocean View Reservation System</h2>
  <a href="dashboard.jsp">&#8592; Back</a>

  <ol>
    <li>Login to the system.</li>
    <li>Open the Add Reservation page, enter guest details + room + dates, then click Save.</li>
    <li>Open View Reservation, enter the reservation number, and view the details.</li>
    <li>Open Generate Bill, enter the reservation number, add discount/tax if needed, then generate/print the bill.</li>
    <li>Logout and exit the system safely.</li>
  </ol>
</body>
</html>