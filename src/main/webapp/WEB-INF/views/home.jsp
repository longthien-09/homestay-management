<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="partials/header.jspf" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Homestay Management - Trang chủ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; margin: 0; }
        .container {
            max-width: 900px; margin: 40px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 40px 30px 30px 30px;
        }
        h1 { text-align: center; color: #007bff; margin-bottom: 20px; }
        .intro { text-align: center; font-size: 20px; color: #333; margin-bottom: 30px; }
        .features { display: flex; flex-wrap: wrap; justify-content: space-around; }
        .feature {
            width: 260px; background: #f8f9fa; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.07);
            margin: 15px; padding: 22px 18px; text-align: center;
        }
        .feature h3 { color: #007bff; margin-bottom: 10px; }
        .feature p { color: #555; }
    </style>
</head>
<body>
<div class="container">
    <h1>Hệ thống quản lý Homestay</h1>
    <div class="intro">
        Chào mừng đến với hệ thống quản lý Homestay!<br/>
        Quản lý đặt phòng, người dùng, dịch vụ, thanh toán và nhiều hơn nữa một cách dễ dàng.
    </div>
    <div class="features">
        <div class="feature">
            <h3>Đặt phòng nhanh chóng</h3>
            <p>Cho phép người dùng đặt phòng, xem trạng thái phòng, lịch sử đặt phòng.</p>
        </div>
        <div class="feature">
            <h3>Quản lý người dùng</h3>
            <p>Admin có thể quản lý, khóa/mở tài khoản, xem thông tin chi tiết người dùng.</p>
        </div>
        <div class="feature">
            <h3>Quản lý dịch vụ</h3>
            <p>Thêm, sửa, xóa các dịch vụ tiện ích cho từng homestay.</p>
        </div>
        <div class="feature">
            <h3>Thanh toán minh bạch</h3>
            <p>Quản lý các khoản thanh toán, trạng thái hóa đơn, phương thức thanh toán.</p>
        </div>
    </div>
</div>
<%@ include file="partials/footer.jspf" %>
</body>
</html>
