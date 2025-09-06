<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map" %>
<%
    List<Map<String,Object>> bookings = (List<Map<String,Object>>) request.getAttribute("bookings");
%>
<%@ include file="../partials/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Lịch sử đặt phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .card { max-width: 1200px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#20c997,#0dcaf0); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        table { width: 100%; border-collapse: collapse; table-layout: fixed; }
        th, td { padding: 12px 8px; border-bottom: 1px solid #eee; text-align: left; word-wrap: break-word; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        th:nth-child(1), td:nth-child(1) { width: 5%; } /* # */
        th:nth-child(2), td:nth-child(2) { width: 25%; } /* Tên homestay */
        th:nth-child(3), td:nth-child(3) { width: 10%; } /* Số phòng */
        th:nth-child(4), td:nth-child(4) { width: 12%; } /* Ngày nhận */
        th:nth-child(5), td:nth-child(5) { width: 12%; } /* Ngày trả */
        th:nth-child(6), td:nth-child(6) { width: 12%; } /* Ngày đặt */
        th:nth-child(7), td:nth-child(7) { width: 8%; } /* Giờ đặt */
        th:nth-child(8), td:nth-child(8) { width: 16%; } /* Trạng thái */
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-pending { background: #fff3cd; color: #856404; }
        .badge-confirmed { background: #d4edda; color: #155724; }
        .badge-checked-in { background: #cce5ff; color: #004085; }
        .badge-checked-out { background: #d1ecf1; color: #0c5460; }
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
                    <th>ID</th>
                    <th>Tên homestay</th>
                    <th>Số phòng</th>
                    <th>Ngày nhận</th>
                    <th>Ngày trả</th>
                    <th>Ngày đặt</th>
                    <th>Giờ đặt</th>
                    <th>Trạng thái</th>
                </tr>
            </thead>
            <tbody>
                <% if (bookings != null && !bookings.isEmpty()) { int i=1; for (Map<String,Object> b : bookings) { %>
                    <tr>
                        <td><%= i++ %></td>
                        <td><%= b.get("homestay_name") != null ? b.get("homestay_name") : "" %></td>
                        <td><%= b.get("room_number") != null ? b.get("room_number") : "" %></td>
                        <td>
                            <%
                                Object ciObj = b.get("check_in");
                                String ciStr = "";
                                try {
                                    java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                    if (ciObj instanceof java.sql.Date) {
                                        java.time.LocalDate ld = ((java.sql.Date) ciObj).toLocalDate();
                                        ciStr = ld.format(fmt);
                                    } else if (ciObj != null) {
                                        java.time.LocalDate ld = java.time.LocalDate.parse(ciObj.toString());
                                        ciStr = ld.format(fmt);
                                    }
                                } catch (Exception ignore) { ciStr = String.valueOf(ciObj); }
                            %>
                            <%= ciStr %>
                        </td>
                        <td>
                            <%
                                Object coObj = b.get("check_out");
                                String coStr = "";
                                try {
                                    java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                    if (coObj instanceof java.sql.Date) {
                                        java.time.LocalDate ld = ((java.sql.Date) coObj).toLocalDate();
                                        coStr = ld.format(fmt);
                                    } else if (coObj != null) {
                                        java.time.LocalDate ld = java.time.LocalDate.parse(coObj.toString());
                                        coStr = ld.format(fmt);
                                    }
                                } catch (Exception ignore) { coStr = String.valueOf(coObj); }
                            %>
                            <%= coStr %>
                        </td>
                        <td><%= b.get("created_date_formatted") != null ? b.get("created_date_formatted") : "" %></td>
                        <td><%= b.get("created_time") != null ? b.get("created_time") : "" %></td>
                        <td>
                            <%
                                String st = String.valueOf(b.get("booking_status"));
                                String stVi;
                                String stClass;
                                if ("CONFIRMED".equalsIgnoreCase(st)) { 
                                    stVi = "✅ Đã duyệt"; 
                                    stClass = "badge-confirmed";
                                } else if ("CHECKED_IN".equalsIgnoreCase(st)) { 
                                    stVi = "🏠 Đang ở"; 
                                    stClass = "badge-checked-in";
                                } else if ("CHECKED_OUT".equalsIgnoreCase(st)) { 
                                    stVi = "✅ Đã trả"; 
                                    stClass = "badge-checked-out";
                                } else if ("CANCELLED".equalsIgnoreCase(st)) { 
                                    stVi = "❌ Đã hủy"; 
                                    stClass = "badge-cancelled";
                                } else { 
                                    stVi = "⏳ Chờ duyệt"; 
                                    stClass = "badge-pending";
                                }
                            %>
                            <span class="badge <%= stClass %>"><%= stVi %></span>
                        </td>
                    </tr>
                <% } } else { %>
                    <tr>
                        <td colspan="8" class="meta">Chưa có đặt phòng nào.</td>
                    </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
