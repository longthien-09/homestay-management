<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
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
        .card { max-width: 1400px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#ff7eb3,#ff758c); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        th, td { padding: 15px 12px; border-bottom: 1px solid #eee; text-align: left; word-wrap: break-word; }
        th:nth-child(1), td:nth-child(1) { width: 5%; } /* # */
        th:nth-child(2), td:nth-child(2) { width: 18%; } /* Tên homestay */
        th:nth-child(3), td:nth-child(3) { width: 8%; } /* Số phòng */
        th:nth-child(4), td:nth-child(4) { width: 12%; } /* Tên khách */
        th:nth-child(5), td:nth-child(5) { width: 10%; } /* Số tiền */
        th:nth-child(6), td:nth-child(6) { width: 10%; } /* Ngày thanh toán */
        th:nth-child(7), td:nth-child(7) { width: 8%; } /* Giờ thanh toán */
        th:nth-child(8), td:nth-child(8) { width: 9%; } /* Phương thức */
        th:nth-child(9), td:nth-child(9) { width: 9%; } /* Trạng thái */
        th:nth-child(10), td:nth-child(10) { width: 7%; } /* Thao tác */
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-PAID { background: #d4edda; color: #155724; }
        .badge-PENDING { background: #cce5ff; color: #004085; }
        .badge-UNPAID { background: #fff3cd; color: #856404; }
        .btn-confirm { background: #28a745; color: white; padding: 4px 8px; border-radius: 4px; text-decoration: none; font-size: 11px; }
        .btn-confirm:hover { background: #218838; color: white; }
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
                    <th>ID</th>
                    <th>Tên homestay</th>
                    <th>Số phòng</th>
                    <th>Tên khách</th>
                    <th>Số tiền</th>
                    <th>Ngày thanh toán</th>
                    <th>Giờ thanh toán</th>
                    <th>Phương thức</th>
                    <th>Trạng thái</th>
                    <th>Thao tác</th>
                </tr>
            </thead>
            <tbody>
            <% if (payments != null && !payments.isEmpty()) { int i=1; for (Map<String,Object> p : payments) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= p.get("homestay_name") != null ? p.get("homestay_name") : "" %></td>
                    <td><%= p.get("room_number") != null ? p.get("room_number") : "" %></td>
                    <td><%= p.get("user_name") != null ? p.get("user_name") : "" %></td>
                    <td><%= formatPrice((java.math.BigDecimal)p.get("amount")) %></td>
                    <td><%= p.get("payment_date_formatted") != null ? p.get("payment_date_formatted") : "" %></td>
                    <td><%= p.get("payment_time") != null ? p.get("payment_time") : "" %></td>
                    <td><%= p.get("method") != null ? 
                        ("BANK_TRANSFER".equals(p.get("method")) ? "Chuyển khoản" : 
                         "CASH".equals(p.get("method")) ? "Tiền mặt" : 
                         p.get("method").toString()) : "" %></td>
                    <td><span class="badge badge-<%= p.get("status") %>"><%= 
                        "PAID".equals(p.get("status")) ? "Đã thanh toán" : 
                        "PENDING".equals(p.get("status")) ? "Chờ xử lý" : 
                        p.get("status") %></span></td>
                    <td>
                        <% if ("PENDING".equals(p.get("status")) && "CASH".equals(p.get("method"))) { %>
                            <form method="post" action="<%= (request.getContextPath() != null ? request.getContextPath() : "") %>/manager/payments/<%= p.get("id") %>/confirm" style="display: inline;">
                                <button type="submit" class="btn-confirm" onclick="return confirm('Xác nhận thanh toán tiền mặt?')">Xác nhận</button>
                            </form>
                        <% } else { %>
                            <span style="color: #6c757d;"></span>
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
