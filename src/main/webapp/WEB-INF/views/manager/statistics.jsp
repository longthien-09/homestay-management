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
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        body {
  background: #f5f7fb;
  font-family: 'Segoe UI', Arial, sans-serif;
  margin: 0;
  padding: 0;
}

.stat-container {
  padding: 30px 50px;        /* padding trái phải nhiều hơn */
  max-width: 1600px;         /* cho rộng hơn để fit màn hình */
  margin: auto;
}

.stat-header {
  text-align: center;
  font-size: 28px;
  font-weight: bold;
  margin-bottom: 25px;
  color: #333;
}

.stat-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr)); /* responsive tự co dãn */
  gap: 25px;
  margin-bottom: 30px;
}

.stat-box {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.05);
  padding: 25px;
  text-align: center;
  transition: transform 0.2s;
}

.stat-box:hover {
  transform: translateY(-5px);
}

.stat-box .icon {
  font-size: 28px;
  margin-bottom: 10px;
  color: #007bff;
}

.stat-box .label {
  font-size: 16px;
  font-weight: 600;
  color: #444;
  margin-bottom: 6px;
}

.stat-box .value {
  font-size: 22px;
  font-weight: bold;
  color: #007bff;
}

.charts-section {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); /* ô chart tự co */
  gap: 25px;
}

.chart-card {
  background: white;
  border-radius: 16px;
  box-shadow: 0 4px 20px rgba(0,0,0,0.05);
  padding: 20px;
  text-align: center;
}

.chart-card .chart-title {
  font-size: 16px;
  font-weight: 600;
  color: #444;
  margin-bottom: 12px;
}

.chart-card canvas {
  max-height: 240px;
  width: 100%;
}

.note {
  text-align: center;
  color: #888;
  margin-top: 24px;
  font-size: 14px;
}

    </style>
</head>
<body>
<div class="stat-container">
    <div class="stat-header">📊 Báo cáo thống kê tổng quan</div>

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
            <canvas id="revenueChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">Lượt đặt phòng theo tháng</div>
            <canvas id="bookingChart"></canvas>
        </div>
        <div class="chart-card">
            <div class="chart-title">Tỷ lệ dịch vụ đã bán</div>
            <canvas id="servicePieChart"></canvas>
        </div>
    </div>

    <div class="note">(Dữ liệu thống kê sẽ được cập nhật tự động khi có phát sinh giao dịch)</div>
</div>

<script>
  // Doanh thu theo tháng
  var monthlyRevenue = <%= request.getAttribute("monthlyRevenue") != null ? 
      new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(monthlyRevenue) : "[]" %>;
  
  console.log('DEBUG: Monthly Revenue data: ', monthlyRevenue);
  
  var revenueLabels = monthlyRevenue.map(function(item) { return item.month; });
  var revenueData = monthlyRevenue.map(function(item) { return item.revenue; });
  
  var revenueCanvas = document.getElementById('revenueChart');
  if (revenueCanvas) {
    var ctx1 = revenueCanvas.getContext('2d');
    new Chart(ctx1, {
      type: 'bar',
      data: { 
        labels: revenueLabels, 
        datasets: [{ 
          label: 'Doanh thu (₫)', 
          data: revenueData, 
          backgroundColor: '#007bff',
          borderColor: '#0056b3',
          borderWidth: 1
        }] 
      },
      options: { 
        responsive: true, 
        plugins: { legend: { display: false } }, 
        scales: { 
          y: { 
            beginAtZero: true,
            ticks: {
              callback: function(value) {
                return new Intl.NumberFormat('vi-VN').format(value) + '₫';
              }
            }
          } 
        } 
      }
    });
  }

  // Lượt đặt phòng theo tháng
  var monthlyBookings = <%= request.getAttribute("monthlyBookings") != null ? 
      new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(monthlyBookings) : "[]" %>;
  
  console.log('DEBUG: Monthly Bookings data: ', monthlyBookings);
  
  var bookingLabels = monthlyBookings.map(function(item) { return item.month; });
  var bookingData = monthlyBookings.map(function(item) { return item.bookings; });
  
  var bookingCanvas = document.getElementById('bookingChart');
  if (bookingCanvas) {
    var ctx2 = bookingCanvas.getContext('2d');
    new Chart(ctx2, {
      type: 'line',
      data: { 
        labels: bookingLabels, 
        datasets: [{ 
          label: 'Lượt đặt', 
          data: bookingData, 
          borderColor: '#28a745',
          backgroundColor: 'rgba(40,167,69,0.1)',
          fill: true,
          tension: 0.4
        }] 
      },
      options: { 
        responsive: true, 
        plugins: { legend: { display: false } }, 
        scales: { 
          y: { 
            beginAtZero: true,
            ticks: {
              stepSize: 1
            }
          } 
        } 
      }
    });
  }

  // Tỷ lệ dịch vụ đã bán (Pie Chart)
  var serviceStats = <%= request.getAttribute("serviceStats") != null ? 
      new com.fasterxml.jackson.databind.ObjectMapper().writeValueAsString(serviceStats) : "[]" %>;
  
  console.log('DEBUG: Service Stats data: ', serviceStats);
  
  var serviceLabels = serviceStats.map(function(item) { return item.name; });
  var serviceData = serviceStats.map(function(item) { return item.count; });
  var serviceColors = ['#007bff', '#28a745', '#ffc107', '#dc3545', '#6f42c1', '#fd7e14'];
  
  // Nếu không có dữ liệu service, hiển thị thông báo
  if (serviceStats.length === 0) {
    serviceLabels = ['Chưa có dữ liệu'];
    serviceData = [1];
    serviceColors = ['#6c757d'];
  }
  
  var serviceCanvas = document.getElementById('servicePieChart');
  if (serviceCanvas) {
    var ctx3 = serviceCanvas.getContext('2d');
    new Chart(ctx3, {
      type: 'doughnut',
      data: { 
        labels: serviceLabels, 
        datasets: [{ 
          data: serviceData, 
          backgroundColor: serviceColors.slice(0, serviceData.length),
          borderWidth: 2,
          borderColor: '#fff'
        }] 
      },
      options: { 
        responsive: true, 
        plugins: { 
          legend: { 
            display: true,
            position: 'bottom'
          } 
        } 
      }
    });
  } else {
    console.error('Service chart canvas not found!');
  }
</script>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
