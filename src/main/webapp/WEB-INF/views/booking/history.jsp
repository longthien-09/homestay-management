<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.homestay.model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đặt phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 20px; }
        .card { max-width: 900px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#20c997,#0dcaf0); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #d4edda; color: #155724; }
        .badge-cancelled { background: #f8d7da; color: #721c24; }
        .meta { color: #6c757d; }
        .actions { margin-bottom: 16px; display: flex; justify-content: flex-end; }
        .btn { display: inline-block; padding: 8px 14px; border-radius: 8px; text-decoration: none; font-weight: 600; }
        .btn-home { background: #e9ecef; color: #2c3e50; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>🧾 Lịch sử đặt phòng</h2>
        <p class="meta">Xem lại các yêu cầu đặt phòng của bạn</p>
    </div>
    <div class="content">
        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">← Quay lại trang chính</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Ngày nhận</th>
                    <th>Ngày trả</th>
                    <th>Trạng thái</th>
                    <th>Tạo lúc</th>
                </tr>
            </thead>
            <tbody>
                <% if (bookings != null && !bookings.isEmpty()) { int i=1; for (Booking b : bookings) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td>
                            <% String st = b.getStatus(); %>
                            <span class="badge <%= "PENDING".equals(st)?"badge-pending":"CONFIRMED".equals(st)?"badge-confirmed":"badge-cancelled" %>"><%= st %></span>
                        </td>
                        <td><%= b.getCreatedAt() != null ? b.getCreatedAt() : "" %></td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="5" class="meta">Chưa có đặt phòng nào.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List, com.homestay.model.Booking" %>
<%
    List<Booking> bookings = (List<Booking>) request.getAttribute("bookings");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đặt phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 20px; }
        .card { max-width: 900px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#20c997,#0dcaf0); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #d4edda; color: #155724; }
        .badge-cancelled { background: #f8d7da; color: #721c24; }
        .meta { color: #6c757d; }
        .actions { margin-bottom: 16px; display: flex; justify-content: flex-end; }
        .btn { display: inline-block; padding: 8px 14px; border-radius: 8px; text-decoration: none; font-weight: 600; }
        .btn-home { background: #e9ecef; color: #2c3e50; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>🧾 Lịch sử đặt phòng</h2>
        <p class="meta">Xem lại các yêu cầu đặt phòng của bạn</p>
    </div>
    <div class="content">
        <div class="actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">← Quay lại trang chính</a>
        </div>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Ngày nhận</th>
                    <th>Ngày trả</th>
                    <th>Trạng thái</th>
                    <th>Tạo lúc</th>
                </tr>
            </thead>
            <tbody>
                <% if (bookings != null && !bookings.isEmpty()) { int i=1; for (Booking b : bookings) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= b.getCheckIn() %></td>
                        <td><%= b.getCheckOut() %></td>
                        <td>
                            <% String st = b.getStatus(); %>
                            <span class="badge <%= "PENDING".equals(st)?"badge-pending":"CONFIRMED".equals(st)?"badge-confirmed":"badge-cancelled" %>"><%= st %></span>
                        </td>
                        <td><%= b.getCreatedAt() != null ? b.getCreatedAt() : "" %></td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="5" class="meta">Chưa có đặt phòng nào.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
