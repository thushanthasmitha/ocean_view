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
    <title>Generate Bill | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary-color: #2563eb;
            --bg-color: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border-color: #e2e8f0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg-color);
            color: var(--text-main);
            margin: 0;
            padding: 30px;
            display: flex;
            flex-direction: column;
            align-items: center;
        }

        .container { width: 100%; max-width: 700px; }

        /* Form Styling */
        .card {
            background: var(--card-bg);
            padding: 25px;
            border-radius: 12px;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
            margin-bottom: 30px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .back-link { text-decoration: none; color: var(--text-muted); font-size: 0.9rem; }
        .back-link:hover { color: var(--primary-color); }

        .form-grid {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr;
            gap: 15px;
            align-items: end;
        }

        .form-group label {
            display: block;
            font-size: 0.75rem;
            font-weight: 700;
            margin-bottom: 6px;
            color: var(--text-muted);
            text-transform: uppercase;
        }

        input {
            width: 100%;
            padding: 10px;
            border: 1px solid var(--border-color);
            border-radius: 6px;
            font-size: 0.9rem;
            box-sizing: border-box;
        }

        .btn-generate {
            background: var(--primary-color);
            color: white;
            border: none;
            padding: 11px;
            border-radius: 6px;
            font-weight: 600;
            cursor: pointer;
            width: 100%;
        }

        /* Bill Preview Styling */
        .bill-box {
            background: white;
            padding: 50px;
            border-radius: 4px;
            box-shadow: 0 0 20px rgba(0,0,0,0.05);
            border-top: 8px solid var(--primary-color);
        }

        .bill-title {
            text-align: right;
            border-bottom: 2px solid var(--border-color);
            padding-bottom: 15px;
            margin-bottom: 30px;
        }

        .bill-title h1 { margin: 0; color: var(--primary-color); font-size: 1.8rem; }

        .info-row { display: flex; justify-content: space-between; margin-bottom: 25px; }
        .info-col h4 { margin: 0 0 8px 0; font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; }
        .info-col p { margin: 0; font-weight: 500; }

        .bill-table {
            width: 100%;
            border-collapse: collapse;
            margin: 30px 0;
        }

        .bill-table th {
            text-align: left;
            background: #f8fafc;
            padding: 12px;
            font-size: 0.85rem;
            border-bottom: 2px solid var(--border-color);
        }

        .bill-table td { padding: 12px; border-bottom: 1px solid #f1f5f9; font-size: 0.95rem; }

        .total-section {
            margin-left: auto;
            width: 250px;
            border-top: 2px solid var(--primary-color);
            padding-top: 10px;
        }

        .total-row { display: flex; justify-content: space-between; padding: 5px 0; }
        .total-row.grand { font-weight: 700; font-size: 1.2rem; color: var(--primary-color); margin-top: 10px; }

        .btn-print {
            background: #1e293b;
            color: white;
            border: none;
            padding: 12px 25px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            margin-top: 20px;
            display: inline-flex;
            align-items: center;
        }

        /* Print Media Queries */
        @media print {
            .no-print { display: none !important; }
            body { background: white; padding: 0; }
            .bill-box { box-shadow: none; border: none; padding: 20px; width: 100%; }
            .container { max-width: 100%; }
        }
    </style>

    <script>
        function printBill() { window.print(); }
    </script>
</head>
<body>

<div class="container">
    
    <div class="no-print">
        <div class="header">
            <h2>Generate Bill</h2>
            <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
        </div>

        <div class="card">
            <% if (request.getAttribute("error") != null) { %>
                <p style="color:#991b1b; background:#fee2e2; padding:10px; border-radius:6px; font-size:0.9rem;">
                    <%= request.getAttribute("error") %>
                </p>
            <% } %>

            <form method="post" action="<%= request.getContextPath() %>/bill/generate" class="form-grid">
                <div class="form-group">
                    <label>Reservation No</label>
                    <input type="text" name="reservationNumber" placeholder="RES-XXXX" required>
                </div>
                <div class="form-group">
                    <label>Discount</label>
                    <input type="text" name="discount" value="0.00">
                </div>
                <div class="form-group">
                    <label>Tax</label>
                    <input type="text" name="tax" value="0.00">
                </div>
                <button type="submit" class="btn-generate">Generate</button>
            </form>
        </div>
    </div>

    <%
      Object rObj = request.getAttribute("reservation");
      if (rObj != null) {
        com.mycompany.ocean_view.model.ReservationDetails r =
          (com.mycompany.ocean_view.model.ReservationDetails) rObj;
    %>

    <div class="bill-box print-area">
        <div class="bill-title">
            <h1>INVOICE</h1>
            <p style="color:var(--text-muted); font-size: 0.9rem;">Ocean View Hotel Management</p>
        </div>

        <div class="info-row">
            <div class="info-col">
                <h4>Billed To</h4>
                <p><%= r.getGuestName() %></p>
                <p style="font-size:0.85rem; color:var(--text-muted); font-weight:400;"><%= r.getReservationNumber() %></p>
            </div>
            <div class="info-col" style="text-align: right;">
                <h4>Stay Details</h4>
                <p><%= r.getCheckIn() %> — <%= r.getCheckOut() %></p>
                <p style="font-size:0.85rem; color:var(--text-muted); font-weight:400;">Room: <%= r.getRoomNumber() %> (<%= r.getRoomType() %>)</p>
            </div>
        </div>

        <table class="bill-table">
            <thead>
                <tr>
                    <th>Description</th>
                    <th style="text-align: center;">Nights</th>
                    <th style="text-align: right;">Rate (Rs.)</th>
                    <th style="text-align: right;">Amount (Rs.)</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td>Accommodation Charges (<%= r.getRoomType() %>)</td>
                    <td style="text-align: center;"><%= request.getAttribute("nights") %></td>
                    <td style="text-align: right;"><%= String.format("%.2f", Double.parseDouble(request.getAttribute("rate").toString())) %></td>
                    <td style="text-align: right;"><%= String.format("%.2f", (Double.parseDouble(request.getAttribute("nights").toString()) * Double.parseDouble(request.getAttribute("rate").toString()))) %></td>
                </tr>
            </tbody>
        </table>

        <div class="total-section">
            <div class="total-row">
                <span>Discount</span>
                <span>- <%= request.getAttribute("discount") %></span>
            </div>
            <div class="total-row">
                <span>Tax</span>
                <span>+ <%= request.getAttribute("tax") %></span>
            </div>
            <div class="total-row grand">
                <span>Total</span>
                <span>Rs. <%= request.getAttribute("total") %></span>
            </div>
        </div>
    </div>

    <div class="no-print" style="text-align: center;">
        <button type="button" class="btn-print" onclick="printBill()">
             Print Invoice
        </button>
    </div>

    <% } %>
</div>

</body>
</html>