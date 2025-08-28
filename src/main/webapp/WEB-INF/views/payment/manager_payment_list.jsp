<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<%
    List<Map<String,Object>> payments = (List<Map<String,Object>>) request.getAttribute("payments");
    String success = request.getParameter("success");
    String paymentId = request.getParameter("paymentId");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý thanh toán</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .card { max-width: 1400px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#ff7eb3,#ff758c); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 14px 12px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        /* Định nghĩa độ rộng cột */
        th:nth-child(1), td:nth-child(1) { width: 50px; } /* # */
        th:nth-child(2), td:nth-child(2) { width: 80px; } /* Booking */
        th:nth-child(3), td:nth-child(3) { width: 120px; } /* Khách */
        th:nth-child(4), td:nth-child(4) { width: 180px; } /* Homestay */
        th:nth-child(5), td:nth-child(5) { width: 100px; } /* Phòng */
        th:nth-child(6), td:nth-child(6) { width: 100px; } /* Số tiền */
        th:nth-child(7), td:nth-child(7) { width: 140px; } /* Ngày thanh toán */
        th:nth-child(8), td:nth-child(8) { width: 120px; } /* Phương thức */
        th:nth-child(9), td:nth-child(9) { width: 120px; } /* Trạng thái */
        th:nth-child(10), td:nth-child(10) { width: 100px; } /* Thao tác */
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-PAID { background: #d4edda; color: #155724; }
        .badge-UNPAID { background: #fff3cd; color: #856404; }
        .badge-PENDING { background: #cce5ff; color: #004085; }
        .btn { padding: 6px 10px; border-radius: 6px; border: none; cursor: pointer; font-weight: 600; }
        .btn-confirm { background: #17a2b8; color: #fff; }
        .btn-confirm:hover { background: #138496; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>🧾 Quản lý thanh toán</h2>
        <p>Xem trạng thái thanh toán các booking thuộc homestay bạn quản lý</p>
    </div>
    <div class="content">
        <% if ("true".equals(success) && paymentId != null) { %>
            <div class="alert alert-success" style="background:#d4edda; color:#155724; padding:12px 16px; border-radius:8px; margin-bottom:20px; border:1px solid #c3e6cb;">
                ✅ Đã xác nhận thanh toán thành công! Payment #<%= paymentId %> đã được cập nhật.
            </div>
        <% } %>
        
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Booking</th>
                    <th>Khách</th>
                    <th>Homestay</th>
                    <th>Phòng</th>
                    <th>Số tiền</th>
                    <th>Ngày thanh toán</th>
                    <th>Phương thức</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <% if (payments != null && !payments.isEmpty()) { int i=1; for (Map<String,Object> p : payments) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td>#<%= p.get("booking_id") %></td>
                    <td><%= p.get("user_name") != null ? p.get("user_name") : "-" %></td>
                    <td><%= p.get("homestay_name") != null ? p.get("homestay_name") : "-" %></td>
                    <td><%= p.get("room_number") != null ? "Phòng " + p.get("room_number") : "-" %></td>
                    <td><%= formatPrice((java.math.BigDecimal)p.get("amount")) %></td>
                    <td><%= p.get("payment_date") != null ? p.get("payment_date") : "-" %></td>
                    <td><%= p.get("method") != null ? p.get("method") : "-" %></td>
                    <td>
                        <% if ("PENDING".equals(p.get("status"))) { %>
                            <span class="badge badge-PENDING">Chờ xử lý</span>
                        <% } else if ("PAID".equals(p.get("status"))) { %>
                            <span class="badge badge-PAID">Đã thanh toán</span>
                        <% } else { %>
                            <span class="badge badge-UNPAID">Chưa thanh toán</span>
                        <% } %>
                    </td>
                    <td>
                        <% if ("PENDING".equals(p.get("status"))) { %>
                            <form method="post" action="/homestay-management/manager/payments/<%= p.get("id") %>/confirm" style="display:inline;">
                                <button class="btn btn-confirm" type="submit">Xác nhận</button>
                            </form>
                        <% } else if ("PAID".equals(p.get("status"))) { %>
                            <span style="color:#28a745; font-weight:600;">✓ Hoàn tất</span>
                        <% } else { %>
                            <span style="color:#6c757d;">-</span>
                        <% } %>
                    </td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="10">Không có thanh toán nào.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
