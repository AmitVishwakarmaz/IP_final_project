<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, dao.ComplaintDAO" %>
<%
    String role = (String) session.getAttribute("role");
    if (!"admin".equals(role)) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Data injected by AnalyticsServlet
    @SuppressWarnings("unchecked")
    Map<String,Integer> byCategory = (Map<String,Integer>) request.getAttribute("byCategory");
    @SuppressWarnings("unchecked")
    Map<String,Integer> byStatus   = (Map<String,Integer>) request.getAttribute("byStatus");
    @SuppressWarnings("unchecked")
    Map<String,Integer> byPriority = (Map<String,Integer>) request.getAttribute("byPriority");
    @SuppressWarnings("unchecked")
    Map<String,Integer> monthly    = (Map<String,Integer>) request.getAttribute("monthly");

    int total      = (Integer) request.getAttribute("total");
    int pending    = (Integer) request.getAttribute("pending");
    int inProgress = (Integer) request.getAttribute("inProgress");
    int resolved   = (Integer) request.getAttribute("resolved");
    int rejected   = (Integer) request.getAttribute("rejected");

    // Build JS arrays for charts
    StringBuilder catLabels = new StringBuilder();
    StringBuilder catData   = new StringBuilder();
    if (byCategory != null) {
        for (Map.Entry<String,Integer> e : byCategory.entrySet()) {
            if (catLabels.length() > 0) { catLabels.append(","); catData.append(","); }
            catLabels.append("'").append(e.getKey()).append("'");
            catData.append(e.getValue());
        }
    }

    StringBuilder priLabels = new StringBuilder();
    StringBuilder priData   = new StringBuilder();
    if (byPriority != null) {
        for (Map.Entry<String,Integer> e : byPriority.entrySet()) {
            if (priLabels.length() > 0) { priLabels.append(","); priData.append(","); }
            priLabels.append("'").append(e.getKey()).append("'");
            priData.append(e.getValue());
        }
    }

    StringBuilder monLabels = new StringBuilder();
    StringBuilder monData   = new StringBuilder();
    if (monthly != null) {
        for (Map.Entry<String,Integer> e : monthly.entrySet()) {
            if (monLabels.length() > 0) { monLabels.append(","); monData.append(","); }
            monLabels.append("'").append(e.getKey()).append("'");
            monData.append(e.getValue());
        }
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Analytics Dashboard</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.0/dist/chart.umd.min.js"></script>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }

        body {
            font-family: 'Inter', sans-serif;
            background: #f1f5f9;
            min-height: 100vh;
            padding: 24px 20px 40px;
        }

        /* ── Page header ── */
        .page-header {
            max-width: 1240px;
            margin: 0 auto 1.8rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            flex-wrap: wrap;
            gap: 1rem;
        }

        .page-title {
            font-size: 1.8rem;
            font-weight: 800;
            background: linear-gradient(135deg, #667eea, #764ba2);
            -webkit-background-clip: text;
            -webkit-text-fill-color: transparent;
        }

        .page-sub {
            font-size: 0.88rem;
            color: #9ca3af;
            margin-top: 0.25rem;
        }

        .btn-back {
            display: inline-flex;
            align-items: center;
            gap: 0.4rem;
            padding: 0.6rem 1.2rem;
            background: white;
            color: #374151;
            border: 1.5px solid #e5e7eb;
            border-radius: 10px;
            font-size: 0.9rem;
            font-weight: 500;
            font-family: 'Inter', sans-serif;
            text-decoration: none;
            transition: all 0.2s;
        }

        .btn-back:hover { border-color: #667eea; color: #667eea; }

        /* ── Stat cards ── */
        .stats-grid {
            max-width: 1240px;
            margin: 0 auto 1.8rem;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(190px, 1fr));
            gap: 1rem;
        }

        .stat-card {
            background: white;
            border-radius: 14px;
            padding: 1.3rem 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            display: flex;
            align-items: center;
            gap: 1rem;
            transition: transform 0.2s;
        }

        .stat-card:hover { transform: translateY(-3px); }

        .stat-icon {
            width: 50px; height: 50px;
            border-radius: 12px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 1.4rem;
            flex-shrink: 0;
        }

        .ic-total      { background: linear-gradient(135deg,#667eea,#764ba2); }
        .ic-pending    { background: #fef3c7; }
        .ic-inprogress { background: #dbeafe; }
        .ic-resolved   { background: #d1fae5; }
        .ic-rejected   { background: #fee2e2; }

        .stat-info .value {
            font-size: 1.9rem;
            font-weight: 800;
            color: #1a1a2e;
            line-height: 1;
        }

        .stat-info .label {
            font-size: 0.82rem;
            color: #9ca3af;
            margin-top: 0.3rem;
            font-weight: 500;
        }

        /* ── Chart grid ── */
        .charts-grid {
            max-width: 1240px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 1.2rem;
        }

        .chart-card {
            background: white;
            border-radius: 14px;
            padding: 1.5rem;
            box-shadow: 0 2px 8px rgba(0,0,0,0.06);
            animation: fadeIn 0.5s ease-out;
        }

        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(16px); }
            to   { opacity: 1; transform: translateY(0); }
        }

        .chart-card.wide { grid-column: 1 / -1; }

        .chart-title {
            font-size: 1rem;
            font-weight: 700;
            color: #1a1a2e;
            margin-bottom: 0.3rem;
        }

        .chart-sub {
            font-size: 0.8rem;
            color: #9ca3af;
            margin-bottom: 1.2rem;
        }

        .chart-wrap {
            position: relative;
            height: 260px;
        }

        /* empty state */
        .empty-chart {
            display: flex;
            align-items: center;
            justify-content: center;
            height: 200px;
            color: #d1d5db;
            font-size: 0.95rem;
            flex-direction: column;
            gap: 0.5rem;
        }

        @media (max-width: 700px) {
            .charts-grid { grid-template-columns: 1fr; }
            .chart-card.wide { grid-column: auto; }
            .page-title { font-size: 1.4rem; }
        }
    </style>
</head>
<body>

    <!-- Page header -->
    <div class="page-header">
        <div>
            <h1 class="page-title">📊 Analytics Dashboard</h1>
            <p class="page-sub">Real-time overview of all complaint activity</p>
        </div>
        <a href="dashboard.jsp" class="btn-back">← Back to Dashboard</a>
    </div>

    <!-- Stat cards -->
    <div class="stats-grid">
        <div class="stat-card">
            <div class="stat-icon ic-total" style="color:white">📋</div>
            <div class="stat-info">
                <div class="value"><%= total %></div>
                <div class="label">Total Complaints</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon ic-pending">⏳</div>
            <div class="stat-info">
                <div class="value"><%= pending %></div>
                <div class="label">Pending</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon ic-inprogress">🔄</div>
            <div class="stat-info">
                <div class="value"><%= inProgress %></div>
                <div class="label">In Progress</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon ic-resolved">✅</div>
            <div class="stat-info">
                <div class="value"><%= resolved %></div>
                <div class="label">Resolved</div>
            </div>
        </div>
        <div class="stat-card">
            <div class="stat-icon ic-rejected">❌</div>
            <div class="stat-info">
                <div class="value"><%= rejected %></div>
                <div class="label">Rejected</div>
            </div>
        </div>
    </div>

    <!-- Charts -->
    <div class="charts-grid">

        <!-- By Category (bar chart - wide) -->
        <div class="chart-card wide">
            <div class="chart-title">Complaints by Category</div>
            <div class="chart-sub">Distribution across all complaint categories</div>
            <div class="chart-wrap">
                <% if (byCategory == null || byCategory.isEmpty()) { %>
                    <div class="empty-chart"><span>📭</span><span>No data yet</span></div>
                <% } else { %>
                    <canvas id="catChart"></canvas>
                <% } %>
            </div>
        </div>

        <!-- By Status (doughnut) -->
        <div class="chart-card">
            <div class="chart-title">Complaints by Status</div>
            <div class="chart-sub">Current resolution breakdown</div>
            <div class="chart-wrap">
                <% if (byStatus == null || byStatus.isEmpty()) { %>
                    <div class="empty-chart"><span>📭</span><span>No data yet</span></div>
                <% } else { %>
                    <canvas id="statusChart"></canvas>
                <% } %>
            </div>
        </div>

        <!-- By Priority (horizontal bar) -->
        <div class="chart-card">
            <div class="chart-title">Complaints by Priority</div>
            <div class="chart-sub">High / Medium / Low urgency split</div>
            <div class="chart-wrap">
                <% if (byPriority == null || byPriority.isEmpty()) { %>
                    <div class="empty-chart"><span>📭</span><span>No data yet</span></div>
                <% } else { %>
                    <canvas id="priChart"></canvas>
                <% } %>
            </div>
        </div>

        <!-- Monthly trend (line chart - wide) -->
        <div class="chart-card wide">
            <div class="chart-title">Monthly Trend</div>
            <div class="chart-sub">Number of complaints filed over the last 6 months</div>
            <div class="chart-wrap">
                <% if (monthly == null || monthly.isEmpty()) { %>
                    <div class="empty-chart"><span>📭</span><span>Not enough data for trend (need complaints older than 1 month)</span></div>
                <% } else { %>
                    <canvas id="trendChart"></canvas>
                <% } %>
            </div>
        </div>

    </div>

<script>
Chart.defaults.font.family = "'Inter', sans-serif";
Chart.defaults.color = '#6b7280';

const GRAD_COLORS = [
    '#667eea','#764ba2','#f093fb','#4facfe','#00f2fe',
    '#43e97b','#f5576c','#fa709a','#fee140','#a18cd1'
];

// ── Category Bar Chart ──────────────────────────────────────────
<% if (byCategory != null && !byCategory.isEmpty()) { %>
new Chart(document.getElementById('catChart'), {
    type: 'bar',
    data: {
        labels: [<%= catLabels %>],
        datasets: [{
            label: 'Complaints',
            data: [<%= catData %>],
            backgroundColor: GRAD_COLORS.slice(0, <%= byCategory.size() %>),
            borderRadius: 8,
            borderSkipped: false,
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false },
            tooltip: {
                callbacks: {
                    label: ctx => ' ' + ctx.parsed.y + ' complaint' + (ctx.parsed.y !== 1 ? 's' : '')
                }
            }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: { stepSize: 1 },
                grid: { color: '#f3f4f6' }
            },
            x: { grid: { display: false } }
        }
    }
});
<% } %>

// ── Status Doughnut ─────────────────────────────────────────────
<% if (byStatus != null && !byStatus.isEmpty()) { %>
new Chart(document.getElementById('statusChart'), {
    type: 'doughnut',
    data: {
        labels: ['Pending','In Progress','Resolved','Rejected'],
        datasets: [{
            data: [<%= pending %>, <%= inProgress %>, <%= resolved %>, <%= rejected %>],
            backgroundColor: ['#fef3c7','#dbeafe','#d1fae5','#fee2e2'],
            borderColor:     ['#f59e0b','#3b82f6','#10b981','#ef4444'],
            borderWidth: 2,
            hoverOffset: 10
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        cutout: '62%',
        plugins: {
            legend: {
                position: 'bottom',
                labels: { padding: 16, usePointStyle: true }
            }
        }
    }
});
<% } %>

// ── Priority Horizontal Bar ─────────────────────────────────────
<% if (byPriority != null && !byPriority.isEmpty()) { %>
new Chart(document.getElementById('priChart'), {
    type: 'bar',
    data: {
        labels: [<%= priLabels %>],
        datasets: [{
            label: 'Complaints',
            data: [<%= priData %>],
            backgroundColor: ['#fee2e2','#fef3c7','#d1fae5'],
            borderColor:     ['#ef4444','#f59e0b','#10b981'],
            borderWidth: 2,
            borderRadius: 8,
            borderSkipped: false,
        }]
    },
    options: {
        indexAxis: 'y',
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false },
        },
        scales: {
            x: {
                beginAtZero: true,
                ticks: { stepSize: 1 },
                grid: { color: '#f3f4f6' }
            },
            y: { grid: { display: false } }
        }
    }
});
<% } %>

// ── Monthly Trend Line ──────────────────────────────────────────
<% if (monthly != null && !monthly.isEmpty()) { %>
new Chart(document.getElementById('trendChart'), {
    type: 'line',
    data: {
        labels: [<%= monLabels %>],
        datasets: [{
            label: 'Complaints Filed',
            data: [<%= monData %>],
            borderColor: '#667eea',
            backgroundColor: 'rgba(102,126,234,0.1)',
            tension: 0.4,
            fill: true,
            pointBackgroundColor: '#667eea',
            pointRadius: 5,
            pointHoverRadius: 8
        }]
    },
    options: {
        responsive: true,
        maintainAspectRatio: false,
        plugins: {
            legend: { display: false }
        },
        scales: {
            y: {
                beginAtZero: true,
                ticks: { stepSize: 1 },
                grid: { color: '#f3f4f6' }
            },
            x: { grid: { display: false } }
        }
    }
});
<% } %>
</script>

</body>
</html>
