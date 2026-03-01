<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.model.RoomRate" %>

<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }
%>

<!DOCTYPE html>
<html>
<head>
  <title>Room Rates</title>
</head>
<body>
<h2>Manage Room Rates</h2>

<p><a href="dashboard.jsp">&larr; Back</a></p>

<h3>Add New Rate</h3>
<form method="post" action="<%=request.getContextPath()%>/rates/manage">
  <input type="hidden" name="action" value="create" />

  Room Type:
  <select name="roomType">
    <option value="STANDARD">STANDARD</option>
    <option value="DELUXE">DELUXE</option>
    <option value="SUITE">SUITE</option>
  </select>

  Rate Per Night:
  <input type="text" name="ratePerNight" required />

  Effective From:
  <input type="date" name="effectiveFrom" required />

  Effective To:
  <input type="date" name="effectiveTo" />

  Active:
  <select name="isActive">
    <option value="1">Yes</option>
    <option value="0">No</option>
  </select>

  <button type="submit">Create</button>
</form>

<hr/>

<h3>Rates List</h3>

<table border="1" cellpadding="8" cellspacing="0">
  <tr>
    <th>ID</th>
    <th>Room Type</th>
    <th>Rate</th>
    <th>Effective From</th>
    <th>Effective To</th>
    <th>Active</th>
    <th>Action</th>
  </tr>

  <%
    List<RoomRate> rates = (List<RoomRate>) request.getAttribute("rates");
    if (rates != null) {
      for (RoomRate r : rates) {
  %>
    <tr>
      <td><%= r.getRateId() %></td>
      <td><%= r.getRoomType() %></td>
      <td><%= r.getRatePerNight() %></td>
      <td><%= r.getEffectiveFrom() %></td>
      <td><%= (r.getEffectiveTo()==null ? "-" : r.getEffectiveTo()) %></td>
      <td><%= (r.isActive() ? "Yes" : "No") %></td>
      <td>
        <form method="post" action="<%=request.getContextPath()%>/rates/manage" style="display:inline;">
          <input type="hidden" name="action" value="toggle"/>
          <input type="hidden" name="rateId" value="<%= r.getRateId() %>"/>
          <input type="hidden" name="isActive" value="<%= r.isActive() ? 0 : 1 %>"/>
          <button type="submit"><%= r.isActive() ? "Deactivate" : "Activate" %></button>
        </form>
      </td>
    </tr>
  <%
      }
    }
  %>

</table>

</body>
</html>