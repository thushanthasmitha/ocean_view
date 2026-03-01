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
  <title>Generate Bill</title>

  <style>
    /* Optional small styling */
    .bill-box {
      border: 1px solid #ccc;
      padding: 16px;
      width: 520px;
    }

    /* Print only the bill preview area */
    @media print {
      .no-print { display: none !important; }
      .print-area { display: block; }
      body { margin: 0; }
    }
  </style>

  <script>
    function printBill() {
      window.print();
    }
  </script>
</head>
<body>

<h2>Generate Bill</h2>

<div class="no-print">
  <p><a href="dashboard.jsp">&larr; Back</a></p>

  <% if (request.getAttribute("error") != null) { %>
    <p style="color:red;"><%= request.getAttribute("error") %></p>
  <% } %>

  <% if (request.getAttribute("success") != null) { %>
    <p style="color:green;"><%= request.getAttribute("success") %></p>
  <% } %>

  <form method="post" action="<%= request.getContextPath() %>/bill/generate">
    <p>
      Reservation Number:
      <input type="text" name="reservationNumber" required>
    </p>

    <p>
      Discount:
      <input type="text" name="discount" value="0.00">
    </p>

    <p>
      Tax:
      <input type="text" name="tax" value="0.00">
    </p>

    <button type="submit">Generate</button>
  </form>

  <hr/>
</div>

<%
  Object rObj = request.getAttribute("reservation");
  if (rObj != null) {
    com.mycompany.ocean_view.model.ReservationDetails r =
      (com.mycompany.ocean_view.model.ReservationDetails) rObj;
%>

<h3>Bill Preview</h3>

<div class="print-area bill-box">
  <p><b>Reservation Number:</b> <%= r.getReservationNumber() %></p>
  <p><b>Guest:</b> <%= r.getGuestName() %></p>
  <p><b>Room:</b> <%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</p>
  <p><b>Check-in:</b> <%= r.getCheckIn() %></p>
  <p><b>Check-out:</b> <%= r.getCheckOut() %></p>

  <p><b>Nights:</b> <%= request.getAttribute("nights") %></p>
  <p><b>Rate per Night:</b> <%= request.getAttribute("rate") %></p>
  <p><b>Discount:</b> <%= request.getAttribute("discount") %></p>
  <p><b>Tax:</b> <%= request.getAttribute("tax") %></p>
  <p><b>Total Amount:</b> <%= request.getAttribute("total") %></p>
</div>

<div class="no-print" style="margin-top:10px;">
  <button type="button" onclick="printBill()">Print Bill</button>
</div>

<% } %>

</body>
</html>