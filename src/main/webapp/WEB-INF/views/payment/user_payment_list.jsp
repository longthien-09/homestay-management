<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String,Object>> payments = (List<Map<String,Object>>) request.getAttribute("payments");
%>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thanh toán của tôi</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .card { max-width: 1200px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#20c997,#0dcaf0); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 10px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-PAID { background: #d4edda; color: #155724; }
        .badge-PENDING { background: #cce5ff; color: #004085; }
        .badge-UNPAID { background: #fff3cd; color: #856404; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>💳 Thanh toán của tôi</h2>
        <p>Xem và thanh toán các booking đã xác nhận</p>
    </div>
    <div class="content">
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Số phòng</th>
                    <th>Tên homestay</th>
                    <th>Số tiền</th>
                    <th>Ngày thanh toán</th>
                    <th>Giờ thanh toán</th>
                    <th>Hình thức</th>
                    <th>Tình trạng</th>
                </tr>
            </thead>
            <tbody>
            <% if (payments != null && !payments.isEmpty()) { int i=1; for (Map<String,Object> p : payments) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= p.get("room_number") != null ? p.get("room_number") : "" %></td>
                    <td><%= p.get("homestay_name") != null ? p.get("homestay_name") : "" %></td>
                    <td><%= formatPrice((java.math.BigDecimal)p.get("amount")) %></td>
                    <td><%= p.get("payment_date_formatted") != null ? p.get("payment_date_formatted") : "-" %></td>
                    <td><%= p.get("payment_time") != null ? p.get("payment_time") : "-" %></td>
                    <td><%= p.get("method") != null ? 
                        ("BANK_TRANSFER".equals(p.get("method")) ? "Chuyển khoản" : 
                         "CASH".equals(p.get("method")) ? "Tiền mặt" : 
                         p.get("method").toString()) : "" %></td>
                    <td><span class="badge badge-<%= p.get("status") %>"><%= 
                        "PAID".equals(p.get("status")) ? "Đã thanh toán" : 
                        "PENDING".equals(p.get("status")) ? "Chờ xử lý" : 
                        "" %></span></td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="8">Không có thanh toán nào.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>