<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.*" %>
<%@ page import="com.mycompany.ocean_view.model.User" %>

<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect(request.getContextPath() + "/login");
    return;
  }

  // Only ADMIN can access (optional but recommended)
  Object roleObj = session.getAttribute("role");
  if (roleObj == null || !"ADMIN".equals(String.valueOf(roleObj))) {
    response.sendRedirect(request.getContextPath() + "/dashboard.jsp");
    return;
  }

  String ctx = request.getContextPath();
  List<User> users = (List<User>) request.getAttribute("users");
  if (users == null) users = new ArrayList<>();
%>

<!DOCTYPE html>
<html>
<head>
  <title>Manage Users</title>
  <style>
    table { border-collapse: collapse; width: 100%; }
    th, td { border: 1px solid #ddd; padding: 8px; }
    th { background: #f2f2f2; }
    form { margin: 0; }
    .row-actions { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
  </style>
</head>
<body>

<h2>Manage Users</h2>
<a href="<%= ctx %>/dashboard.jsp">← Back</a>

<hr/>

<h3>Create New User</h3>

<form method="post" action="<%= ctx %>/users/manage">
  <input type="hidden" name="action" value="create"/>

  Username:
  <input type="text" name="username" required/>

  Password:
  <input type="text" name="password" required/>

  Role:
  <select name="role">
    <option value="ADMIN">ADMIN</option>
    <option value="MANAGER">MANAGER</option>
    <option value="RECEPTIONIST">RECEPTIONIST</option>
  </select>

  Active:
  <select name="active">
    <option value="1">Yes</option>
    <option value="0">No</option>
  </select>

  <button type="submit">Create</button>
</form>

<hr/>

<h3>Users List</h3>

<table>
  <thead>
    <tr>
      <th>ID</th>
      <th>Username</th>
      <th>Role</th>
      <th>Active</th>
      <th>Actions</th>
    </tr>
  </thead>

  <tbody>
  <%
    for (User u : users) {
      String activeText = u.isActive() ? "Yes" : "No";
  %>
    <tr>
      <td><%= u.getUserId() %></td>
      <td><%= u.getUsername() %></td>
      <td><%= u.getRole() %></td>
      <td><%= activeText %></td>
      <td>
        <div class="row-actions">

          <!-- Toggle Active -->
          <form method="post" action="<%= ctx %>/users/manage">
            <input type="hidden" name="action" value="toggleActive"/>
            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
            <input type="hidden" name="active" value="<%= u.isActive() ? "0" : "1" %>"/>
            <button type="submit"><%= u.isActive() ? "Deactivate" : "Activate" %></button>
          </form>

          <!-- Update Role -->
          <form method="post" action="<%= ctx %>/users/manage">
            <input type="hidden" name="action" value="updateRole"/>
            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
            <select name="role">
              <option value="ADMIN" <%= "ADMIN".equals(u.getRole()) ? "selected" : "" %>>ADMIN</option>
              <option value="MANAGER" <%= "MANAGER".equals(u.getRole()) ? "selected" : "" %>>MANAGER</option>
              <option value="RECEPTIONIST" <%= "RECEPTIONIST".equals(u.getRole()) ? "selected" : "" %>>RECEPTIONIST</option>
            </select>
            <button type="submit">Update Role</button>
          </form>

          <!-- Reset Password -->
          <form method="post" action="<%= ctx %>/users/manage">
            <input type="hidden" name="action" value="resetPassword"/>
            <input type="hidden" name="userId" value="<%= u.getUserId() %>"/>
            <input type="text" name="newPassword" placeholder="new password" required/>
            <button type="submit">Reset</button>
          </form>

        </div>
      </td>
    </tr>
  <%
    }
  %>
  </tbody>
</table>

</body>
</html>