<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.mycompany.ocean_view.model.ReservationDetails" %>
<%@ page import="com.mycompany.ocean_view.service.BillingService.BillResult" %>
<%
  if (session.getAttribute("username") == null) { response.sendRedirect("login"); return; }
  ReservationDetails res = (ReservationDetails) request.getAttribute("res");
  BillResult bill = (BillResult) request.getAttribute("bill");
%>
<!DOCTYPE html>
<html>
<head><title>Generate Bill</title></head>
<body>
<h2>Generate Bill</h2>
<a href="dashboard.jsp">← Back</a>

<% if (request.getAttribute("msg") != null) { %>
<p style="color:green;"><%= request.getAttribute("msg") %></p>
<% } %>
<% if (request.getAttribute("error") != null) { %>
<p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

<form method="post" action="bill/generate">
  Reservation Number: <input name="reservationNumber" required><br><br>
  Discount: <input name="discount" value="0.00" required><br><br>
  Tax: <input name="tax" value="0.00" required><br><br>
  <button type="submit">Generate</button>
</form>

<% if (res != null && bill != null) { %>
<hr>
<h3>Bill</h3>
<p><b>Reservation:</b> <%= res.getReservationNumber() %></p>
<p><b>Guest:</b> <%= res.getGuestName() %></p>
<p><b>Room:</b> <%= res.getRoomNumber() %> (<%= res.getRoomType() %>)</p>
<p><b>Dates:</b> <%= res.getCheckIn() %> to <%= res.getCheckOut() %></p>

<p><b>Nights:</b> <%= bill.nights %></p>
<p><b>Rate per night:</b> <%= bill.rate %></p>
<p><b>SubTotal:</b> <%= bill.subTotal %></p>
<p><b>Discount:</b> <%= bill.discount %></p>
<p><b>Tax:</b> <%= bill.tax %></p>
<p><b>Total:</b> <%= bill.total %></p>

<button onclick="window.print()">Print</button>
<% } %>

</body>
</html>