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
    <title>Help Center | Ocean View</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #2563eb;
            --bg: #f8fafc;
            --card: #ffffff;
            --text: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
        }

        body {
            font-family: 'Inter', sans-serif;
            background-color: var(--bg);
            color: var(--text);
            margin: 0;
            padding: 40px 20px;
            display: flex;
            justify-content: center;
        }

        .container {
            width: 100%;
            max-width: 800px;
        }

        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 40px;
            border-bottom: 2px solid var(--border);
            padding-bottom: 20px;
        }

        h2 { margin: 0; font-size: 1.8rem; color: var(--primary); }
        
        .back-link {
            text-decoration: none;
            color: var(--text-muted);
            font-weight: 500;
            transition: color 0.2s;
        }
        .back-link:hover { color: var(--primary); }

        /* Help Steps Styling */
        .help-list {
            list-style: none;
            padding: 0;
            counter-reset: help-counter;
        }

        .help-item {
            background: var(--card);
            margin-bottom: 20px;
            padding: 25px;
            border-radius: 12px;
            display: flex;
            align-items: flex-start;
            box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05);
            border: 1px solid var(--border);
            transition: transform 0.2s;
        }

        .help-item:hover {
            transform: translateY(-2px);
            border-color: var(--primary);
        }

        .help-item::before {
            counter-increment: help-counter;
            content: counter(help-counter);
            background: var(--primary);
            color: white;
            min-width: 35px;
            height: 35px;
            border-radius: 50%;
            display: flex;
            justify-content: center;
            align-items: center;
            font-weight: 700;
            margin-right: 20px;
            font-size: 0.9rem;
        }

        .help-content h3 {
            margin: 0 0 8px 0;
            font-size: 1.1rem;
            color: var(--text);
        }

        .help-content p {
            margin: 0;
            line-height: 1.6;
            color: var(--text-muted);
            font-size: 0.95rem;
        }

        /* Footer info */
        .footer-note {
            margin-top: 40px;
            text-align: center;
            padding: 20px;
            background: #eff6ff;
            border-radius: 8px;
            color: var(--primary);
            font-size: 0.9rem;
            font-weight: 500;
        }

        @media (max-width: 600px) {
            .help-item { padding: 15px; }
            h2 { font-size: 1.4rem; }
        }
    </style>
</head>
<body>

<div class="container">
    <div class="header">
        <h2>User Guide & Help</h2>
        <a href="dashboard.jsp" class="back-link">← Back to Dashboard</a>
    </div>

    <div class="help-list">
        <div class="help-item">
            <div class="help-content">
                <h3>Authentication</h3>
                <p>Securely log in to the system using your authorized username and password to access the management tools.</p>
            </div>
        </div>

        <div class="help-item">
            <div class="help-content">
                <h3>Creating Reservations</h3>
                <p>Navigate to <b>"Add Reservation"</b>. Enter the guest's personal details, select an available room, and specify the check-in/check-out dates. Click <b>"Save"</b> to confirm.</p>
            </div>
        </div>

        <div class="help-item">
            <div class="help-content">
                <h3>Finding Records</h3>
                <p>Use the <b>"View Reservation"</b> section to search for existing bookings by entering the unique Reservation Number. All guest and stay information will be displayed.</p>
            </div>
        </div>

        <div class="help-item">
            <div class="help-content">
                <h3>Billing & Invoicing</h3>
                <p>Go to <b>"Generate Bill"</b>, input the Reservation Number, and apply any necessary taxes or discounts. You can then preview and print a professional invoice for the guest.</p>
            </div>
        </div>

        <div class="help-item">
            <div class="help-content">
                <h3>Session Safety</h3>
                <p>Always use the <b>"Logout"</b> button before closing your browser to clear your session and protect the system's data integrity.</p>
            </div>
        </div>
    </div>

    <div class="footer-note">
        Need further assistance? Contact the system administrator for technical support.
    </div>
</div>

</body>
</html>