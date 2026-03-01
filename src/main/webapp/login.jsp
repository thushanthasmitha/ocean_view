<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html>
<head><title>Ocean View - Login</title></head>
<body>
<h2>Ocean View Resort - Login</h2>

<% if (request.getAttribute("error") != null) { %>
<p style="color:red;"><%= request.getAttribute("error") %></p>
<% } %>

<form method="post" action="login">
  Username:<br><input name="username" required><br><br>
  Password:<br><input type="password" name="password" required><br><br>
  <button type="submit">Login</button>
</form>
</body>
</html>