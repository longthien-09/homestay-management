<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.homestay.model.User, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jspf" %>
<%
    // Đã có biến currentUser từ header.jspf, không khai báo lại ở đây
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    int roomCount = request.getAttribute("roomCount") != null ? (Integer) request.getAttribute("roomCount") : 0;
    int bookingCount = request.getAttribute("bookingCount") != null ? (Integer) request.getAttribute("bookingCount") : 0;
    int totalHomestay = request.getAttribute("totalHomestay") != null ? (Integer) request.getAttribute("totalHomestay") : 0;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manager Dashboard - Homestay Management</title>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6fb; margin: 0; }
        .dashboard-container {
            max-width: 1200px;
            margin: 40px auto 0 auto;
            background: #fff;
            border-radius: 18px;
            box-shadow: 0 6px 32px rgba(0,0,0,0.08);
            padding: 40px 36px 30px 36px;
        }
        .dashboard-header {
            display: flex; align-items: center; justify-content: space-between;
            border-bottom: 1px solid #eee; padding-bottom: 18px; margin-bottom: 30px;
        }
        .dashboard-header h1 {
            font-size: 2.2em; color: #2c3e50; margin: 0; font-weight: 600;
        }
        .dashboard-header .welcome {
            color: #667eea; font-size: 1.1em; font-weight: 500;
        }
        .stats {
            display: flex; gap: 32px; margin-bottom: 36px; flex-wrap: wrap;
        }
        .stat-card {
            flex: 1 1 220px; background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: #fff; border-radius: 14px; padding: 32px 28px; box-shadow: 0 2px 12px rgba(102,126,234,0.08);
            display: flex; flex-direction: column; align-items: flex-start; min-width: 220px;
        }
        .stat-card .icon {
            font-size: 2.2em; margin-bottom: 12px; opacity: 0.85;
        }
        .stat-card .label {
            font-size: 1.1em; margin-bottom: 6px; opacity: 0.92;
        }
        .stat-card .value {
            font-size: 2.1em; font-weight: 700; letter-spacing: 1px;
        }
        .quick-actions {
            display: flex; gap: 24px; flex-wrap: wrap; margin-bottom: 30px;
        }
        .action-card {
            flex: 1 1 260px; background: #f8f9fa; border-radius: 12px; box-shadow: 0 1px 6px #e3e6f0;
            padding: 28px 22px; display: flex; flex-direction: column; align-items: flex-start;
            transition: box-shadow 0.2s, transform 0.2s; min-width: 220px;
        }
        .action-card:hover {
            box-shadow: 0 4px 18px #d1d8e6; transform: translateY(-2px) scale(1.02);
        }
        .action-card .icon {
            font-size: 1.8em; color: #667eea; margin-bottom: 10px;
        }
        .action-card .title {
            font-size: 1.15em; font-weight: 600; color: #2c3e50; margin-bottom: 6px;
        }
        .action-card .desc {
            color: #7f8c8d; font-size: 0.98em; margin-bottom: 12px;
        }
        .action-card a {
            background: #667eea; color: #fff; padding: 8px 18px; border-radius: 6px;
            text-decoration: none; font-weight: 500; font-size: 1em; transition: background 0.2s;
        }
        .action-card a:hover { background: #5a6fd8; }
        .homestay-info {
            background: #f4f6fb; border-radius: 10px; padding: 22px 18px; margin-top: 18px;
            box-shadow: 0 1px 6px #e3e6f0; display: flex; gap: 32px; align-items: flex-start;
        }
        .homestay-info .img {
            width: 120px; height: 90px; border-radius: 8px; object-fit: cover; box-shadow: 0 1px 6px #ccc;
            background: #eee; display: flex; align-items: center; justify-content: center; font-size: 2.5em; color: #bbb;
        }
        .homestay-info .details { flex: 1; }
        .homestay-info h2 { margin: 0 0 8px 0; color: #2980b9; font-size: 1.3em; font-weight: 600; }
        .homestay-info .meta { color: #555; font-size: 1em; margin-bottom: 4px; }
        .homestay-info .desc { color: #7f8c8d; font-size: 0.98em; }
        @media (max-width: 900px) {
            .dashboard-container { padding: 18px 6vw; }
            .stats, .quick-actions, .homestay-info { flex-direction: column; gap: 18px; }
        }
    </style>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
</head>
<body>
<div class="dashboard-container">
    <div class="dashboard-header">
        <h1>Xin chào, <%= currentUser != null ? currentUser.getFullName() : "Quản lý" %>!</h1>
        <div class="welcome">Chào mừng bạn đến với trang quản lý Homestay</div>
    </div>
    <div class="stats">
        <div class="stat-card">
            <div class="icon"><i class="fa-solid fa-house"></i></div>
            <div class="label">Homestay của bạn <span style="font-size:0.95em;color:#888;">(Tổng: <%= totalHomestay %>)</span></div>
            <div class="value"><%= homestay != null ? homestay.getName() : "Chưa gán" %></div>
        </div>
        <div class="stat-card">
            <div class="icon"><i class="fa-solid fa-bed"></i></div>
            <div class="label">Số phòng</div>
            <div class="value"><%= roomCount %></div>
        </div>
        <div class="stat-card">
            <div class="icon"><i class="fa-solid fa-calendar-check"></i></div>
            <div class="label">Lượt đặt phòng</div>
            <div class="value"><%= bookingCount %></div>
        </div>
    </div>
    <div class="quick-actions">
        <div class="action-card">
            <div class="icon"><i class="fa-solid fa-house"></i></div>
            <div class="title">Quản lý Homestay</div>
            <div class="desc">Xem danh sách tất cả homestay trong hệ thống.</div>
            <a href="/homestay-management/admin/homestays">Quản lý homestay</a>
        </div>
        <div class="action-card">
            <div class="icon"><i class="fa-solid fa-bed"></i></div>
            <div class="title">Quản lý phòng</div>
            <div class="desc">Thêm, sửa, xóa và xem danh sách phòng thuộc homestay của bạn.</div>
            <a href="/homestay-management/homestays/<%= homestay != null ? homestay.getId() : 0 %>/rooms">Xem phòng</a>
        </div>
        <div class="action-card">
            <div class="icon"><i class="fa-solid fa-calendar-check"></i></div>
            <div class="title">Quản lý đặt phòng</div>
            <div class="desc">Xem và xác nhận các lượt đặt phòng của khách.</div>
            <a href="#">Xem đặt phòng</a>
        </div>
        <div class="action-card">
            <div class="icon"><i class="fa-solid fa-concierge-bell"></i></div>
            <div class="title">Quản lý dịch vụ</div>
            <div class="desc">Thêm, sửa, xóa các dịch vụ tiện ích cho homestay.</div>
            <a href="#">Quản lý dịch vụ</a>
        </div>
        <div class="action-card">
            <div class="icon"><i class="fa-solid fa-user"></i></div>
            <div class="title">Thông tin cá nhân</div>
            <div class="desc">Cập nhật thông tin quản lý, đổi mật khẩu.</div>
            <a href="/homestay-management/user/profile">Cá nhân</a>
        </div>
    </div>
    <div class="homestay-info">
        <div class="img">
            <% if (homestay != null && homestay.getImage() != null && !homestay.getImage().trim().isEmpty()) { %>
                <img src="<%= homestay.getImage() %>" alt="Homestay" style="width:100%;height:100%;object-fit:cover;border-radius:8px;"/>
            <% } else { %>
                <i class="fa-solid fa-house"></i>
            <% } %>
        </div>
        <div class="details">
            <h2><%= homestay != null ? homestay.getName() : "Chưa có homestay" %></h2>
            <div class="meta"><b>Địa chỉ:</b> <%= homestay != null && homestay.getAddress() != null ? homestay.getAddress() : "Chưa cập nhật" %></div>
            <div class="meta"><b>Email:</b> <%= homestay != null && homestay.getEmail() != null ? homestay.getEmail() : "Chưa cập nhật" %></div>
            <div class="meta"><b>Số điện thoại:</b> <%= homestay != null && homestay.getPhone() != null ? homestay.getPhone() : "Chưa cập nhật" %></div>
            <div class="desc"><b>Mô tả:</b> <%= homestay != null && homestay.getDescription() != null ? homestay.getDescription() : "Chưa có mô tả." %></div>
        </div>
    </div>
</div>
<%@ include file="../partials/footer.jspf" %>
</body>
</html>
