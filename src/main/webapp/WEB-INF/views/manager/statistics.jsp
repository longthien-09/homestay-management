<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, java.math.BigDecimal" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<%
    Map<String, Object> overviewStats = (Map<String, Object>) request.getAttribute("overviewStats");
    List<Map<String, Object>> monthlyRevenue = (List<Map<String, Object>>) request.getAttribute("monthlyRevenue");
    List<Map<String, Object>> monthlyBookings = (List<Map<String, Object>>) request.getAttribute("monthlyBookings");
    List<Map<String, Object>> serviceStats = (List<Map<String, Object>>) request.getAttribute("serviceStats");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Báo cáo thống kê - Quản lý Homestay</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6fb; margin: 0; padding: 0; }
        .stat-container { max-width: 1100px; margin: 40px auto; background: #fff; border-radius: 18px; box-shadow: 0 6px 32px rgba(0,0,0,0.08); padding: 40px 36px 30px 36px; }
        .stat-header { font-size: 2em; font-weight: 700; color: #2c3e50; margin-bottom: 30px; text-align: center; }
        .stat-grid { display: flex; gap: 32px; flex-wrap: wrap; justify-content: center; }
        .stat-box { flex: 1 1 220px; background: linear-gradient(135deg, #667eea 0%, #20c997 100%); color: #fff; border-radius: 14px; padding: 32px 28px; box-shadow: 0 2px 12px rgba(102,126,234,0.08); display: flex; flex-direction: column; align-items: center; min-width: 220px; margin-bottom: 24px; }
        .stat-box .icon { font-size: 2.5em; margin-bottom: 14px; opacity: 0.92; }
        .stat-box .label { font-size: 1.1em; margin-bottom: 8px; opacity: 0.95; }
        .stat-box .value { font-size: 2.2em; font-weight: 700; letter-spacing: 1px; }
        .charts-section { margin-top: 40px; }
        .chart-card { background: #f8f9fa; border-radius: 14px; box-shadow: 0 1px 6px #e3e6f0; padding: 16px 14px; margin-bottom: 22px; }
        .chart-title { font-size: 1em; font-weight: 600; color: #2c3e50; margin-bottom: 12px; text-align: center; }
        .chart-card canvas { max-height: 220px; }
        @media (max-width: 900px) { .stat-container { padding: 18px 6vw; } .stat-grid { flex-direction: column; gap: 18px; } }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
</head>
<body>
<div class="stat-container">
    <div class="stat-header">Báo cáo thống kê tổng quan</div>
    <div class="stat-grid">
        <div class="stat-box">
            <div class="icon"><i class="fa-solid fa-sack-dollar"></i></div>
            <div class="label">Tổng doanh thu</div>
            <div class="value"><%= formatPrice((java.math.BigDecimal)overviewStats.get("totalRevenue")) %></div>
        </div>
        <div class="stat-box">
            <div class="icon"><i class="fa-solid fa-calendar-check"></i></div>
            <div class="label">Lượt đặt phòng</div>
            <div class="value"><%= overviewStats != null && overviewStats.get("totalBookings") != null ? overviewStats.get("totalBookings") : "0" %></div>
        </div>
        <div class="stat-box">
            <div class="icon"><i class="fa-solid fa-concierge-bell"></i></div>
            <div class="label">Dịch vụ đã bán</div>
            <div class="value"><%= overviewStats != null && overviewStats.get("totalServices") != null ? overviewStats.get("totalServices") : "0" %></div>
        </div>
    </div>
    <div class="charts-section">
        <div class="chart-card">
            <div class="chart-title">Doanh thu theo tháng</div>
            <canvas id="revenueChart" height="60"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">Lượt đặt phòng theo tháng</div>
            <canvas id="bookingChart" height="60"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">Tỷ lệ dịch vụ đã bán</div>
            <canvas id="servicePieChart" height="60"></canvas>
        </div>
    </div>
    <div style="text-align:center; color:#888; margin-top:24px;">(Dữ liệu thống kê sẽ được cập nhật tự động khi có phát sinh giao dịch)</div>
</div>
<script>
// Dữ liệu thực từ backend
const revenueData = {
    labels: [
        <% if (monthlyRevenue != null && !monthlyRevenue.isEmpty()) { %>
            <% for (int i = 0; i < monthlyRevenue.size(); i++) { %>
                '<%= monthlyRevenue.get(i).get("month") %>'<%= i < monthlyRevenue.size() - 1 ? "," : "" %>
            <% } %>
        <% } else { %>
            'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8'
        <% } %>
    ],
    datasets: [{
        label: 'Doanh thu (triệu đồng)',
        data: [
            <% if (monthlyRevenue != null && !monthlyRevenue.isEmpty()) { %>
                <% for (int i = 0; i < monthlyRevenue.size(); i++) { %>
                    <%= ((BigDecimal)monthlyRevenue.get(i).get("revenue")).doubleValue() / 1000000 %><%= i < monthlyRevenue.size() - 1 ? "," : "" %>
                <% } %>
            <% } else { %>
                0, 0, 0, 0, 0, 0, 0, 0
            <% } %>
        ],
        backgroundColor: 'rgba(32,201,151,0.7)',
        borderColor: '#20c997',
        borderWidth: 2
    }]
};

const bookingData = {
    labels: [
        <% if (monthlyBookings != null && !monthlyBookings.isEmpty()) { %>
            <% for (int i = 0; i < monthlyBookings.size(); i++) { %>
                '<%= monthlyBookings.get(i).get("month") %>'<%= i < monthlyBookings.size() - 1 ? "," : "" %>
            <% } %>
        <% } else { %>
            'Tháng 1', 'Tháng 2', 'Tháng 3', 'Tháng 4', 'Tháng 5', 'Tháng 6', 'Tháng 7', 'Tháng 8'
        <% } %>
    ],
    datasets: [{
        label: 'Lượt đặt phòng',
        data: [
            <% if (monthlyBookings != null && !monthlyBookings.isEmpty()) { %>
                <% for (int i = 0; i < monthlyBookings.size(); i++) { %>
                    <%= monthlyBookings.get(i).get("bookings") %><%= i < monthlyBookings.size() - 1 ? "," : "" %>
                <% } %>
            <% } else { %>
                0, 0, 0, 0, 0, 0, 0, 0
            <% } %>
        ],
        fill: false,
        borderColor: '#667eea',
        backgroundColor: '#667eea',
        tension: 0.3
    }]
};

const servicePieData = {
    labels: [
        <% if (serviceStats != null && !serviceStats.isEmpty()) { %>
            <% for (int i = 0; i < serviceStats.size(); i++) { %>
                '<%= serviceStats.get(i).get("name") %>'<%= i < serviceStats.size() - 1 ? "," : "" %>
            <% } %>
        <% } else { %>
            'Chưa có dịch vụ nào'
        <% } %>
    ],
    datasets: [{
        data: [
            <% if (serviceStats != null && !serviceStats.isEmpty()) { %>
                <% for (int i = 0; i < serviceStats.size(); i++) { %>
                    <%= serviceStats.get(i).get("count") %><%= i < serviceStats.size() - 1 ? "," : "" %>
                <% } %>
            <% } else { %>
                1
            <% } %>
        ],
        backgroundColor: [
            '#20c997', '#667eea', '#ffb347', '#ff758c', '#a8edea'
        ],
        borderWidth: 1
    }]
};
new Chart(document.getElementById('revenueChart'), {
    type: 'bar',
    data: revenueData,
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true } }
    }
});
new Chart(document.getElementById('bookingChart'), {
    type: 'line',
    data: bookingData,
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true } }
    }
});
new Chart(document.getElementById('servicePieChart'), {
    type: 'pie',
    data: servicePieData,
    options: {
        responsive: true,
        plugins: { legend: { position: 'bottom' } }
    }
});
</script>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
