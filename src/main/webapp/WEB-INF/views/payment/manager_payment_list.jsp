<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Map<String,Object>> payments = (List<Map<String,Object>>) request.getAttribute("payments");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý thanh toán</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .card { max-width: 1000px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#ff7eb3,#ff758c); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-PAID { background: #d4edda; color: #155724; }
        .badge-UNPAID { background: #fff3cd; color: #856404; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>🧾 Quản lý thanh toán</h2>
        <p>Xem trạng thái thanh toán các booking thuộc homestay bạn quản lý</p>
    </div>
    <div class="content">
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Booking</th>
                    <th>Khách</th>
                    <th>Số tiền</th>
                    <th>Ngày thanh toán</th>
                    <th>Phương thức</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
            <% if (payments != null && !payments.isEmpty()) { int i=1; for (Map<String,Object> p : payments) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td>#<%= p.get("booking_id") %></td>
                    <td><%= p.get("user_name") != null ? p.get("user_name") : "-" %></td>
                    <td>₫<%= p.get("amount") %></td>
                    <td><%= p.get("payment_date") != null ? p.get("payment_date") : "-" %></td>
                    <td><%= p.get("method") != null ? p.get("method") : "-" %></td>
                    <td><span class="badge badge-<%= p.get("status") %>"><%= p.get("status") %></span></td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="7">Không có thanh toán nào.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
