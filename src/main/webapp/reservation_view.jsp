<%@ page contentType="text/html;charset=UTF-8" %>
<%
  if (session.getAttribute("username") == null) {
    response.sendRedirect("login");
    return;
  }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>View Reservation | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --bg-color: #f8fafc;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
            --accent-bg: #f1f5f9;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 650px;
        }

        .card {
            background: var(--card-bg);
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 20px;
        }

        .header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 25px;
        }

        h2, h3 { margin: 0; color: var(--text-main); }
        h2 { font-size: 1.5rem; }
        h3 { font-size: 1.1rem; margin-bottom: 20px; border-bottom: 2px solid var(--accent-bg); padding-bottom: 10px; }

        .back-link {
            text-decoration: none;
            color: var(--text-muted);
            font-size: 0.9rem;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--primary-color); }

        /* Search Section */
        .search-box {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        input[type="text"] {
            flex: 1;
            padding: 12px;
            border: 1px solid var(--border-color);
            border-radius: 8px;
            font-size: 1rem;
            outline: none;
            transition: border-color 0.2s;
        }

        input:focus { border-color: var(--primary-color); box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1); }

        button {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 8px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s;
        }
        button:hover { background: #1d4ed8; }

        /* Details Display */
        .details-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .detail-item {
            padding: 12px;
            background: var(--accent-bg);
            border-radius: 8px;
        }

        .label {
            display: block;
            font-size: 0.75rem;
            text-transform: uppercase;
            color: var(--text-muted);
            font-weight: 700;
            margin-bottom: 4px;
        }

        .value {
            display: block;
            font-size: 1rem;
            font-weight: 500;
        }

        .full-width { grid-column: span 2; }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.85rem;
            font-weight: 600;
            background: #dcfce7;
            color: #166534;
        }

        .error-msg {
            color: #991b1b;
            background: #fee2e2;
            padding: 12px;
            border-radius: 8px;
            font-size: 0.9rem;
            margin-top: 15px;
        }

        @media (max-width: 500px) {
            .details-grid { grid-template-columns: 1fr; }
            .full-width { grid-column: span 1; }
            .search-box { flex-direction: column; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>View Reservation</h2>
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <div class="card">
        <form method="get" action="<%= request.getContextPath() %>/reservation/view">
            <label style="display:block; margin-bottom:8px; font-size:0.85rem; font-weight:600;">ENTER RESERVATION NUMBER</label>
            <div class="search-box">
                <input type="text" name="reservationNumber" placeholder="e.g. RES-1001" required />
                <button type="submit">Search Details</button>
            </div>
        </form>

        <%-- Error Handling --%>
        <% if (request.getAttribute("error") != null) { %>
            <div class="error-msg"><%= request.getAttribute("error") %></div>
        <% } %>
    </div>

    <%
      Object resObj = request.getAttribute("res");
      if (resObj != null) {
        com.mycompany.ocean_view.model.ReservationDetails res =
            (com.mycompany.ocean_view.model.ReservationDetails) resObj;
    %>
    <div class="card">
        <h3>Reservation Information</h3>
        <div class="details-grid">
            <div class="detail-item">
                <span class="label">Reservation No</span>
                <span class="value"><%= res.getReservationNumber() %></span>
            </div>
            <div class="detail-item">
                <span class="label">Status</span>
                <span class="value"><span class="status-badge"><%= res.getStatus() %></span></span>
            </div>
            <div class="detail-item full-width">
                <span class="label">Guest Name</span>
                <span class="value"><%= res.getGuestName() %></span>
            </div>
            <div class="detail-item">
                <span class="label">Contact Number</span>
                <span class="value"><%= res.getContactNumber() %></span>
            </div>
            <div class="detail-item">
                <span class="label">Room Information</span>
                <span class="value">Room <%= res.getRoomNumber() %> (<%= res.getRoomType() %>)</span>
            </div>
            <div class="detail-item">
                <span class="label">Check-in Date</span>
                <span class="value"><%= res.getCheckIn() %></span>
            </div>
            <div class="detail-item">
                <span class="label">Check-out Date</span>
                <span class="value"><%= res.getCheckOut() %></span>
            </div>
        </div>
    </div>
    <% } %>
</div>

</body>
</html>