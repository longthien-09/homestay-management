<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.User, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    // Đã có biến currentUser từ header.jspf, không khai báo lại ở đây
    java.util.List<com.homestay.model.Homestay> homestays = (java.util.List<com.homestay.model.Homestay>) request.getAttribute("homestays");
    java.util.Map<Integer, java.util.List<com.homestay.model.Room>> roomsByHomestay = (java.util.Map<Integer, java.util.List<com.homestay.model.Room>>) request.getAttribute("roomsByHomestay");
    int roomCount = request.getAttribute("roomCount") != null ? (Integer) request.getAttribute("roomCount") : 0;
    int bookingCount = request.getAttribute("bookingCount") != null ? (Integer) request.getAttribute("bookingCount") : 0;
    int totalHomestay = request.getAttribute("totalHomestay") != null ? (Integer) request.getAttribute("totalHomestay") : 0;
    String monthlyRevenueJson = (String) request.getAttribute("monthlyRevenueJson");
    String monthlyBookingsJson = (String) request.getAttribute("monthlyBookingsJson");
    if (monthlyRevenueJson == null) monthlyRevenueJson = "[]";
    if (monthlyBookingsJson == null) monthlyBookingsJson = "[]";
    // Escape ký tự '
    monthlyRevenueJson = monthlyRevenueJson.replace("'", "\\'");
    monthlyBookingsJson = monthlyBookingsJson.replace("'", "\\'");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - Homestay Management</title>
    <style>
        /* Reset & fonts */
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f5f7fb;
            margin: 0;
            padding: 0;
            color: #2c3e50;
        }
    
        /* Container chính */
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto;
            background: #fff;
            border-radius: 20px;
            box-shadow: 0 8px 32px rgba(0,0,0,0.08);
            padding: 36px 32px;
        }
    
        /* Header */
        .dashboard-header {
            display: flex; 
            justify-content: space-between; 
            align-items: center;
            margin-bottom: 28px;
        }
        .dashboard-header h1 {
            font-size: 1.9em;
            font-weight: 700;
            margin: 0;
            color: #34495e;
        }
        .dashboard-header .welcome {
            font-size: 1em;
            color: #667eea;
            font-weight: 500;
        }
    
        /* Cards thống kê */
        .stats, .dashboard-grid {
            display: grid;
            gap: 20px;
            margin-bottom: 28px;
        }
        .dashboard-grid {
            grid-template-columns: repeat(auto-fit, minmax(240px, 1fr));
        }
        .stat-card {
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 14px;
            padding: 24px;
            color: #fff;
            display: flex;
            flex-direction: column;
            align-items: flex-start;
            box-shadow: 0 4px 16px rgba(102,126,234,0.2);
            transition: transform 0.2s, box-shadow 0.2s;
        }
        .stat-card:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 20px rgba(102,126,234,0.25);
        }
        .stat-card .icon {
            font-size: 1.8em;
            opacity: 0.85;
            margin-bottom: 10px;
        }
        .stat-card .label {
            font-size: 0.95em;
            opacity: 0.9;
            margin-bottom: 4px;
        }
        .stat-card .value {
            font-size: 1.6em;
            font-weight: 700;
        }
    
        /* Sidebar quick actions */
        .sidebar-actions {
            width: 260px;
        }
        .quick-actions {
            display: flex;
            flex-direction: column;
            gap: 16px;
        }
        .action-card {
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.06);
            padding: 14px 18px;
            transition: 0.25s;
        }
        .action-card:hover {
            transform: translateY(-3px);
            box-shadow: 0 6px 18px rgba(0,0,0,0.12);
        }
        .action-card .icon {
            color: #667eea;
            font-size: 1.2em;
            margin-bottom: 6px;
        }
        .action-card .title {
            font-weight: 600;
            font-size: 0.95em;
            margin-bottom: 4px;
        }
        .action-card .desc {
            font-size: 0.8em;
            color: #7f8c8d;
            margin-bottom: 8px;
        }
        .action-card a {
            font-size: 0.8em;
            font-weight: 600;
            color: #fff;
            background: #667eea;
            padding: 5px 10px;
            border-radius: 6px;
            text-decoration: none;
            transition: background 0.2s;
        }
        .action-card a:hover {
            background: #5a6fd8;
        }
    
        /* Homestay cards */
        .homestay-buttons {
            display: grid;
            gap: 20px;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            margin-top: 32px;
        }
        .homestay-buttons a {
            background: linear-gradient(135deg, #667eea, #764ba2);
            color: #fff;
            border-radius: 16px;
            padding: 24px 20px;
            text-decoration: none;
            box-shadow: 0 4px 16px rgba(102,126,234,0.2);
            transition: transform 0.25s, box-shadow 0.25s;
        }
        .homestay-buttons a:hover {
            transform: translateY(-4px);
            box-shadow: 0 8px 24px rgba(102,126,234,0.3);
        }
        .homestay-buttons a div {
            margin-bottom: 6px;
        }
    
        /* Search form buttons */
.search-btn, .reset-btn {
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 8px;
    padding: 12px 22px;
    border: none;
    border-radius: 10px;
    font-weight: 600;
    font-size: 14px;
    cursor: pointer;
    transition: all 0.25s ease-in-out;
    box-shadow: 0 2px 6px rgba(0,0,0,0.15);
}

.search-btn {
    background: linear-gradient(135deg, #4facfe 0%, #00f2fe 100%);
    color: #fff;
}

.search-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(79,172,254,0.4);
    background: linear-gradient(135deg, #3b8ff7 0%, #00d4d8 100%);
}

.search-btn:active {
    transform: translateY(0);
    box-shadow: 0 3px 8px rgba(79,172,254,0.3);
}

.reset-btn {
    background: linear-gradient(135deg, #adb5bd 0%, #6c757d 100%);
    color: #fff;
}

.reset-btn:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 16px rgba(108,117,125,0.35);
    background: linear-gradient(135deg, #9aa0a6 0%, #5a6268 100%);
}

.reset-btn:active {
    transform: translateY(0);
    box-shadow: 0 3px 8px rgba(108,117,125,0.25);
}

.search-btn i, .reset-btn i {
    font-size: 16px;
    transition: transform 0.25s ease;
}

.search-btn:hover i, .reset-btn:hover i {
    transform: scale(1.15);
}

        /* Responsive */
        @media (max-width: 900px) {
            .dashboard-container {
                padding: 20px;
            }
            .sidebar-actions {
                display: none; /* Ẩn sidebar trên mobile */
            }
        }
    </style>
    
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
</head>
<body>
<div style="display: flex; align-items: flex-start; max-width: 1400px; margin: 0 auto;">
    <div class="sidebar-actions" style="width: 260px; min-width: 220px; margin-right: 32px;">
        <div class="quick-actions" style="display: flex; flex-direction: column; gap: 18px;">
            <div class="action-card">
                <div class="icon"><i class="fa-solid fa-house"></i></div>
                <div class="title">Quản lý Homestay</div>
                <div class="desc">Xem danh sách homestay bạn quản lý.</div>
                <a href="/homestay-management/manager/homestays">Xem danh sách homestay</a>
            </div>
            <div class="action-card">
                <div class="icon"><i class="fa-solid fa-calendar-check"></i></div>
                <div class="title">Quản lý đặt phòng</div>
                <div class="desc">Xem và xác nhận các lượt đặt phòng của khách.</div>
                <a href="/homestay-management/manager/bookings">Xem đặt phòng</a>
            </div>
            <div class="action-card">
                <div class="icon"><i class="fa-solid fa-concierge-bell"></i></div>
                <div class="title">Quản lý dịch vụ</div>
                <div class="desc">Thêm, sửa, xóa các dịch vụ tiện ích cho homestay.</div>
                <a href="/homestay-management/manager/services">Quản lý dịch vụ</a>
            </div>
            <div class="action-card">
                <div class="icon"><i class="fa-solid fa-money-check-dollar"></i></div>
                <div class="title">Quản lý thanh toán</div>
                <div class="desc">Xem trạng thái thanh toán của các booking thuộc homestay bạn quản lý.</div>
                <a href="/homestay-management/manager/payments">Quản lý thanh toán</a>
            </div>
            <div class="action-card">
                <div class="icon"><i class="fa-solid fa-chart-bar"></i></div>
                <div class="title">Báo cáo thống kê</div>
                <div class="desc">Xem tổng quan doanh thu, lượt đặt phòng, dịch vụ,... của homestay bạn quản lý.</div>
                <a href="/homestay-management/manager/statistics">Xem thống kê</a>
            </div>
        </div>
    </div>
    <div class="dashboard-container" style="flex: 1;">
        <div class="dashboard-header">
            <h1>Xin chào, <%= currentUser != null ? currentUser.getFullName() : "Quản lý" %>!</h1>
            <div class="welcome">Chào mừng bạn đến với trang quản lý Homestay</div>
        </div>
        <div class="dashboard-grid" style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 24px; margin-bottom: 24px;">
            <div class="stat-card" style="padding: 18px 10px; min-width: 0;">
                <div class="icon"><i class="fa-solid fa-money-bill-wave"></i></div>
                <div class="label">Tổng doanh thu</div>
                <div class="value" style="font-size: 2em;">
                    <%
                        java.math.BigDecimal _rev = java.math.BigDecimal.ZERO;
                        Object _mapObj = request.getAttribute("overviewStats");
                        if (_mapObj instanceof java.util.Map) {
                            Object v = ((java.util.Map)_mapObj).get("totalRevenue");
                            if (v instanceof java.math.BigDecimal) _rev = (java.math.BigDecimal) v;
                            else if (v != null) try { _rev = new java.math.BigDecimal(v.toString()); } catch(Exception ignore) {}
                        }
                        java.text.NumberFormat nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                        nf.setMaximumFractionDigits(0);
                    %>
                    <%= nf.format(_rev) %> đ
                </div>
            </div>
            <div class="stat-card" style="padding: 18px 10px; min-width: 0;">
                <div class="icon"><i class="fa-solid fa-calendar-check"></i></div>
                <div class="label">Lượt đặt phòng</div>
                <div class="value" style="font-size: 2em;"><%= request.getAttribute("overviewStats") != null ? ((java.util.Map)request.getAttribute("overviewStats")).get("totalBookings") : 0 %></div>
            </div>
            <div class="stat-card" style="padding: 18px 10px; min-width: 0;">
                <div class="icon"><i class="fa-solid fa-bell-concierge"></i></div>
                <div class="label">Dịch vụ đã bán</div>
                <div class="value" style="font-size: 2em;"><%= request.getAttribute("overviewStats") != null ? ((java.util.Map)request.getAttribute("overviewStats")).get("totalServices") : 0 %></div>
            </div>
        </div>
        <div class="dashboard-charts" style="display: grid; grid-template-columns: 1fr 1fr; gap: 24px; align-items: start;">
            <div style="background: #f8f9fa; border-radius: 12px; padding: 16px; min-width: 0;">
                <div style="font-weight: 600; margin-bottom: 8px; text-align: center;">Doanh thu theo tháng</div>
                <canvas id="revenueChart" style="height: 220px; width: 100%;"></canvas>
            </div>
            <div style="background: #f8f9fa; border-radius: 12px; padding: 16px; min-width: 0;">
                <div style="font-weight: 600; margin-bottom: 8px; text-align: center;">Lượt đặt phòng theo tháng</div>
                <canvas id="bookingChart" style="height: 220px; width: 100%;"></canvas>
            </div>
        </div>
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
        <script>
            console.log('DEBUG: Monthly Revenue JSON: <%= monthlyRevenueJson %>');
            console.log('DEBUG: Monthly Bookings JSON: <%= monthlyBookingsJson %>');
            
            var monthlyRevenue = JSON.parse('<%= monthlyRevenueJson %>');
            console.log('DEBUG: Parsed Monthly Revenue: ', monthlyRevenue);
            
            var revenueLabels = monthlyRevenue.map(function(item) { return item.month; });
            var revenueData = monthlyRevenue.map(function(item) { return item.revenue; });
            console.log('DEBUG: Revenue Labels: ', revenueLabels);
            console.log('DEBUG: Revenue Data: ', revenueData);
            
            var revenueCanvas = document.getElementById('revenueChart');
            if (revenueCanvas) {
                var ctx1 = revenueCanvas.getContext('2d');
                new Chart(ctx1, {
                    type: 'bar',
                    data: { labels: revenueLabels, datasets: [{ label: 'Doanh thu', data: revenueData, backgroundColor: '#667eea' }] },
                    options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
                });
            } else {
                console.error('Revenue chart canvas not found!');
            }
            
            var monthlyBookings = JSON.parse('<%= monthlyBookingsJson %>');
            console.log('DEBUG: Parsed Monthly Bookings: ', monthlyBookings);
            
            var bookingLabels = monthlyBookings.map(function(item) { return item.month; });
            var bookingData = monthlyBookings.map(function(item) { return item.bookings; });
            console.log('DEBUG: Booking Labels: ', bookingLabels);
            console.log('DEBUG: Booking Data: ', bookingData);
            
            var bookingCanvas = document.getElementById('bookingChart');
            if (bookingCanvas) {
                var ctx2 = bookingCanvas.getContext('2d');
                new Chart(ctx2, {
                    type: 'line',
                    data: { labels: bookingLabels, datasets: [{ label: 'Lượt đặt', data: bookingData, borderColor: '#764ba2', backgroundColor: 'rgba(118,75,162,0.1)', fill: true }] },
                    options: { responsive: true, plugins: { legend: { display: false } }, scales: { y: { beginAtZero: true } } }
                });
            } else {
                console.error('Booking chart canvas not found!');
            }
        </script>
        
        <script>
            function clearSearchForm() {
                document.getElementById('homestayId').value = '';
                document.getElementById('checkInDate').value = '';
                document.getElementById('checkOutDate').value = '';
                document.getElementById('roomType').value = '';
                document.getElementById('maxPrice').value = '';
            }
        </script>
        
        <!-- Form tìm kiếm phòng trống -->
        <div style="background: #f8f9fa; padding: 24px; margin: 24px 0; border-radius: 16px; border: 1px solid #e9ecef;">
            <h3 style="margin: 0 0 20px 0; color: #2c3e50; font-size: 1.3em; display: flex; align-items: center; gap: 10px;">
                <i class="fa-solid fa-search" style="color: #667eea;"></i>
                Tìm kiếm phòng trống
            </h3>
            <form method="get" action="/homestay-management/manager/search-rooms" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 20px; align-items: end;">
                <div>
                    <label for="homestayId" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Chọn homestay:</label>
                    <select id="homestayId" name="homestayId" required style="width: 100%; padding: 10px 12px; border: 1px solid #dce1eb; border-radius: 8px; font-size: 14px; background: white;">
                        <option value="">-- Chọn homestay --</option>
                        <% if (homestays != null) for (Homestay h : homestays) { %>
                            <option value="<%= h.getId() %>"><%= h.getName() %></option>
                        <% } %>
                    </select>
                </div>
                <div>
                    <label for="checkInDate" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Ngày nhận phòng:</label>
                    <input type="date" id="checkInDate" name="checkInDate" required
                           min="<%= java.time.LocalDate.now() %>"
                           style="width: 100%; padding: 10px 12px; border: 1px solid #dce1eb; border-radius: 8px; font-size: 14px;">
                </div>
                <div>
                    <label for="checkOutDate" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Ngày trả phòng:</label>
                    <input type="date" id="checkOutDate" name="checkOutDate" required
                           min="<%= java.time.LocalDate.now().plusDays(1) %>"
                           style="width: 100%; padding: 10px 12px; border: 1px solid #dce1eb; border-radius: 8px; font-size: 14px;">
                </div>
                <div>
                    <label for="roomType" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Loại phòng:</label>
                    <select id="roomType" name="roomType" style="width: 100%; padding: 10px 12px; border: 1px solid #dce1eb; border-radius: 8px; font-size: 14px; background: white;">
                        <option value="">Tất cả loại phòng</option>
                        <option value="đơn">Phòng đơn</option>
                        <option value="đôi">Phòng đôi</option>
                        <option value="hai giường">Phòng hai giường</option>
                        <option value="gia đình">Phòng gia đình</option>
                        <option value="studio">Studio</option>
                        <option value="căn hộ">Căn hộ</option>
                    </select>
                </div>
                <div>
                    <label for="maxPrice" style="display: block; margin-bottom: 8px; font-weight: 600; color: #2c3e50;">Giá tối đa (₫):</label>
                    <input type="number" id="maxPrice" name="maxPrice" 
                           placeholder="Nhập giá tối đa"
                           style="width: 100%; padding: 10px 12px; border: 1px solid #dce1eb; border-radius: 8px; font-size: 14px;">
                </div>
                <div style="display: flex; gap: 16px; align-items: end;">
                    <button type="submit" class="search-btn">
                        <i class="fa-solid fa-search"></i>
                        <span>Tìm kiếm</span>
                    </button>
                    <button type="button" onclick="clearSearchForm()" class="reset-btn">
                        <i class="fa-solid fa-eraser"></i>
                        <span>Làm mới</span>
                    </button>
                </div>
            </form>
        </div>
        
        <div class="homestay-buttons" style="display: flex; flex-wrap: wrap; gap: 32px; margin-top: 32px;">
            <% if (homestays != null && !homestays.isEmpty()) {
                java.util.Map<Integer, java.math.BigDecimal> revenueByHomestay = (java.util.Map<Integer, java.math.BigDecimal>) request.getAttribute("revenueByHomestay");
                java.util.Map<Integer, Integer> availableRoomsByHomestay = (java.util.Map<Integer, Integer>) request.getAttribute("availableRoomsByHomestay");
                for (Homestay h : homestays) { %>
                    <a href="/homestay-management/manager/homestays/<%=h.getId()%>/rooms" style="flex: 1 1 320px; min-width: 320px; max-width: 400px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); color: #fff; border-radius: 16px; padding: 32px 28px; margin-bottom: 18px; text-decoration: none; box-shadow: 0 2px 12px rgba(102,126,234,0.08); display: block; transition: box-shadow 0.2s, transform 0.2s;">
                        <div style="font-size: 2em; margin-bottom: 10px;"><i class="fa-solid fa-house"></i></div>
                        <div style="font-size: 1.3em; font-weight: 600; margin-bottom: 8px;"><%= h.getName() %></div>
                        <div style="margin-bottom: 6px;">Tổng doanh thu: <b><%= revenueByHomestay != null && revenueByHomestay.get(h.getId()) != null ? revenueByHomestay.get(h.getId()) : 0 %> đ</b></div>
                        <div style="margin-bottom: 6px;">Phòng trống: <b><%= availableRoomsByHomestay != null && availableRoomsByHomestay.get(h.getId()) != null ? availableRoomsByHomestay.get(h.getId()) : 0 %></b></div>
                        <div style="margin-top: 10px; font-size: 0.98em; opacity: 0.85;">Xem chi tiết & quản lý phòng</div>
                    </a>
            <%   }
               } else { %>
                <div>Chưa có homestay nào bạn quản lý.</div>
            <% } %>
        </div>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
