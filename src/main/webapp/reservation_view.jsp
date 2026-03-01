<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }
%>
<!DOCTYPE html>
<html>
<head><title>View Reservation</title></head>
<body>
<h2>View Reservation</h2>
<a href="dashboard.jsp">← Back</a>

<form method="get" action="<%= request.getContextPath() %>/reservation/view">
  <label>Reservation Number</label>
  <input type="text" name="reservationNumber" required />
  <button type="submit">Search</button>
</form>

<%
  Object resObj = request.getAttribute("res");
  Object errObj = request.getAttribute("error");
  if (errObj != null) {
%>
    <p style="color:red;"><%= errObj %></p>
<%
  }
  if (resObj != null) {
    com.mycompany.ocean_view.model.ReservationDetails res =
        (com.mycompany.ocean_view.model.ReservationDetails) resObj;
%>
    <h3>Reservation Details</h3>
    <p><b>Reservation No:</b> <%= res.getReservationNumber() %></p>
    <p><b>Guest:</b> <%= res.getGuestName() %></p>
    <p><b>Contact:</b> <%= res.getContactNumber() %></p>
    <p><b>Room:</b> <%= res.getRoomNumber() %> (<%= res.getRoomType() %>)</p>
    <p><b>Check-in:</b> <%= res.getCheckIn() %></p>
    <p><b>Check-out:</b> <%= res.getCheckOut() %></p>
    <p><b>Status:</b> <%= res.getStatus() %></p>
<%
  }
%>
</body>
</html>