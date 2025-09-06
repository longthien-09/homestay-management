<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*" %>
<%@ page import="com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Map<String,Object>> bookings = (List<Map<String,Object>>) request.getAttribute("bookings");
    Integer homestayId = (Integer) request.getAttribute("homestayId");
    String status = (String) request.getAttribute("status");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đặt phòng (Admin)</title>
    <style>
        body {
            font-family: "Segoe UI", Tahoma, sans-serif;
            background: #f4f6f9;
            margin: 0;
            padding: 0;
            color: #2d3748;
        }
        .card {
            max-width: 1600px;
            margin: 32px auto;
            background: #fff;
            border-radius: 14px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.05);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg,#4f8cff,#3b6ed7);
            color: #fff;
            padding: 22px 28px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        .header h2 {
            margin: 0;
            font-size: 22px;
            font-weight: 600;
        }
        .header small {
            opacity: .9;
            display: block;
            font-size: 13px;
            margin-top: 2px;
        }
        .content {
            padding: 24px 28px 32px;
        }
        .filters { display: flex; gap: 12px; margin-bottom: 20px; align-items: center; flex-wrap: wrap; }
        .filters .field { display: flex; flex-direction: column; gap: 6px; }
        .filters .field label { font-size: 12px; color: #6b7280; font-weight: 600; }
        input, select, textarea {
            padding: 10px 14px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            background: #fff;
            font-size: 15px;
            transition: border-color .2s, box-shadow .2s;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #4f8cff;
            outline: none;
            box-shadow: 0 0 0 3px rgba(79,140,255,0.15);
        }
        .table-wrapper { overflow-x: auto; border-radius: 12px; }
        table {
            width: 100%;
            border-collapse: collapse;
            background: #fff;
            border-radius: 12px;
            overflow: hidden;
            table-layout: fixed;
        }
        th, td {
            padding: 14px 16px;
            border-bottom: 1px solid #eaecef;
            text-align: left;
            font-size: 14px;
            word-wrap: break-word;
        }
        
        /* Độ rộng các cột */
        th:nth-child(1), td:nth-child(1) { width: 3%; } /* # */
        th:nth-child(2), td:nth-child(2) { width: 22%; } /* Homestay */
        th:nth-child(3), td:nth-child(3) { width: 5%; } /* Phòng */
        th:nth-child(4), td:nth-child(4) { width: 10%; } /* Khách */
        th:nth-child(5), td:nth-child(5) { width: 9%; } /* SĐT */
        th:nth-child(6), td:nth-child(6) { width: 9%; } /* Nhận */
        th:nth-child(7), td:nth-child(7) { width: 9%; } /* Trả */
        th:nth-child(8), td:nth-child(8) { width: 10%; } /* Loại phòng */
        th:nth-child(9), td:nth-child(9) { width: 9%; } /* Tổng tiền */
        th:nth-child(10), td:nth-child(10) { width: 18%; } /* Trạng thái */
        th:nth-child(11), td:nth-child(11) { width: 18%; } /* Thanh toán */
        th:nth-child(12), td:nth-child(12) { width: 18%; } /* Thao tác */
        
        /* Ngăn xuống hàng cho các cột quan trọng */
        th:nth-child(2), td:nth-child(2) { white-space: nowrap; overflow: hidden; text-overflow: ellipsis; } /* Homestay */
        th:nth-child(3), td:nth-child(3) { white-space: nowrap; }
        th:nth-child(10), td:nth-child(10) { white-space: nowrap; } /* Trạng thái */
        th:nth-child(11), td:nth-child(11) { white-space: nowrap; } /* Thanh toán */
        th:nth-child(12), td:nth-child(12) { white-space: nowrap; } /* Thao tác */
        th:nth-child(6), td:nth-child(6) { white-space: nowrap; } /* Nhận */
        th:nth-child(7), td:nth-child(7) { white-space: nowrap; } /* Trả */
        th:nth-child(9), td:nth-child(9) { white-space: nowrap; } /* Tổng tiền */
        th:nth-child(8), td:nth-child(8) { white-space: nowrap; }
        th:nth-child(4), td:nth-child(4) { white-space: nowrap; }
        th:nth-child(5), td:nth-child(5) { white-space: nowrap; }
        th {
            background: #f1f4f9;
            font-weight: 600;
            color: #374151;
            position: sticky;
            top: 0;
            z-index: 1;
        }
        tbody tr:nth-child(even) {
            background: #fafbfc;
        }
tbody tr:hover { background: #f0f7ff; transition: background 0.2s; }
        tbody tr { transition: background 0.2s; }
        .text-right { text-align: right; }
        .text-center { text-align: center; }
        .badge {
            padding: 6px 10px;
            border-radius: 8px;
            font-size: 12px;
            font-weight: 600;
            display: inline-block;
        }
        .badge-PENDING { background: #fff7e6; color: #d97706; }
        .badge-CONFIRMED { background: #e6ffed; color: #059669; }
        .badge-CANCELLED { background: #ffe6e6; color: #dc2626; }
        .badge-checked-in { background: #e0f2fe; color: #0369a1; }
        .badge-checked-out { background: #f0fdf4; color: #166534; }
        
        /* Status dropdown */
        .status-dropdown {
            padding: 6px 10px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            background: #fff;
            font-size: 12px;
            font-weight: 600;
            cursor: pointer;
            min-width: 120px;
        }
        .status-dropdown:focus {
            outline: none;
            border-color: #4f8cff;
            box-shadow: 0 0 0 2px rgba(79,140,255,0.15);
        }

        /* Thao tác: 1 hàng, nút dạng pill */
        /* Badge thanh toán */
        .badge-pay { padding: 6px 10px; border-radius: 8px; font-size: 12px; font-weight: 700; display: inline-block; }
        .badge-pay-UNPAID { background: #fff1f1; color: #b91c1c; }
        .badge-pay-PENDING { background: #fff7e6; color: #d97706; }
        .badge-pay-PAID { background: #e6ffed; color: #059669; }
        .actions { display: flex; gap: 8px; align-items: center; flex-wrap: wrap; }
        .inline-form { display: inline; }
        .btn {
            padding: 8px 16px;
            border-radius: 999px;
            cursor: pointer;
            font-weight: 600;
            font-size: 14px;
            border: 1px solid transparent;
            transition: background-color .2s, color .2s, border-color .2s, transform .05s, box-shadow .2s;
        }
        .btn:active { transform: translateY(1px); }
        .btn-approve { background: #e8f8f0; color: #0f5132; border-color: #b6e9d0; }
        .btn-approve:hover { background: #10b981; color: #fff; border-color: #10b981; }
        .btn-reject { background: #fff1f1; color: #b91c1c; border-color: #f9c5c5; }
        .btn-reject:hover { background: #ef4444; color: #fff; border-color: #ef4444; }
        .btn-edit { background: #eef2ff; color: #1e40af; border-color: #c7d2fe; text-align: center; }
        .btn-edit:hover { background: #3b82f6; color: #fff; border-color: #3b82f6; }

        /* Nút lọc */
        .btn-filter { background: #3b82f6; color: #fff; border-color: #3b82f6; }
        .btn-filter:hover { background: #2563eb; color: #fff; border-color: #2563eb; box-shadow: 0 6px 14px rgba(37,99,235,0.25); }
        .btn-reset { background: #f3f4f6; color: #374151; border-color: #e5e7eb; }
        .btn-reset:hover { background: #e5e7eb; }

        .btn-home {
            display: inline-block;
            padding: 8px 16px;
            background: #f3f4f6;
            color: #374151;
            border-radius: 8px;
            font-weight: 600;
            text-decoration: none;
            transition: background-color 0.2s;
        }
        .btn-home:hover { background: #e5e7eb; }
        .top-actions {
            display: flex;
            justify-content: flex-end;
            margin-bottom: 16px;
        }
        /* Inline edit form */
        .edit-form {
            margin-top: 20px;
padding: 18px 20px;
            border: 1px solid #e5e7eb;
            border-radius: 14px;
            background: #f9fafb;
            display: none;
            font-size: 15px;
        }
        .edit-form.visible { display: block; }
        .edit-form h3 { margin: 0 0 8px; font-size: 18px; font-weight: 700; color: #111827; }
        .edit-form p.help { margin: 0 0 16px; color: #6b7280; font-size: 13px; }
        .edit-form .row { display: flex; gap: 14px; flex-wrap: wrap; margin-bottom: 14px; align-items: center; }
        .edit-form .row--2col { display: grid; grid-template-columns: repeat(2, minmax(220px, 280px)) auto; gap: 16px; align-items: end; }
        .edit-form label { font-weight: 700; font-size: 14px; color: #111827; margin-bottom: 6px; display: inline-block; }
        .edit-form input[type="date"],
        .edit-form input[type="text"],
        .edit-form input[type="number"],
        .edit-form textarea {
            padding: 10px 12px;
            border: 1px solid #d1d5db;
            border-radius: 10px;
            background: #fff;
            font-size: 14px;
            transition: border-color .2s, box-shadow .2s;
            box-shadow: 0 1px 0 rgba(0,0,0,0.02);
        }
        .edit-form textarea { width: 100%; resize: vertical; min-height: 72px; }
        @media (max-width: 768px) {
            .edit-form .row--2col { grid-template-columns: 1fr; }
        }
        .edit-form input[type="date"]:focus { border-color: #4f8cff; box-shadow: 0 0 0 3px rgba(79,140,255,0.15); outline: none; }
        .edit-form input[type="text"]:focus,
        .edit-form input[type="number"]:focus,
        .edit-form textarea:focus { border-color: #4f8cff; box-shadow: 0 0 0 3px rgba(79,140,255,0.15); outline: none; }
        .edit-actions { display: flex; gap: 10px; align-items: center; justify-content: flex-end; }
        .edit-actions .btn { padding: 10px 20px; font-size: 15px; }
        
        /* Calendar styles */
        .calendar-section {
            margin-bottom: 20px;
            background: #fff;
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.05);
        }
        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 15px;
        }
        .calendar-title {
            font-size: 18px;
            font-weight: 600;
            color: #2d3748;
        }
        .calendar-nav {
            display: flex;
            gap: 10px;
        }
        .calendar-nav button {
            padding: 8px 12px;
            border: 1px solid #d1d5db;
            border-radius: 8px;
            background: #fff;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.2s;
        }
        .calendar-nav button:hover {
            background: #f3f4f6;
            border-color: #9ca3af;
        }
        .calendar-grid {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 1px;
            background: #e5e7eb;
            border-radius: 8px;
            overflow: hidden;
        }
        .calendar-day-header {
            background: #f9fafb;
            padding: 12px 8px;
            text-align: center;
            font-weight: 600;
            font-size: 12px;
            color: #6b7280;
        }
        .calendar-day {
            background: #fff;
            padding: 12px 8px;
            text-align: center;
            cursor: pointer;
            transition: all 0.2s;
            min-height: 40px;
            display: flex;
            align-items: center;
            justify-content: center;
            position: relative;
        }
        .calendar-day:hover {
            background: #f0f7ff;
        }
        .calendar-day.other-month {
            background: #f9fafb;
            color: #9ca3af;
        }
        .calendar-day.today {
            background: #dbeafe;
            color: #1e40af;
            font-weight: 600;
        }
        .calendar-day.has-booking {
            background: #fef3c7;
            color: #d97706;
            font-weight: 600;
        }
        .calendar-day.has-booking::after {
            content: '●';
            position: absolute;
            top: 2px;
            right: 2px;
            font-size: 8px;
        }
        .calendar-day.booking-many {
            background: #f0f9ff;
            color: #0369a1;
        }
        .calendar-day.booking-many::after {
            content: '●';
            position: absolute;
            bottom: 2px;
            right: 2px;
            font-size: 8px;
            color: #10b981;
        }
        .calendar-day.booking-medium {
            background: #fef3c7;
            color: #d97706;
        }
        .calendar-day.booking-medium::after {
            content: '●';
            position: absolute;
            bottom: 2px;
            right: 2px;
            font-size: 8px;
            color: #f59e0b;
        }
        .calendar-day.booking-few {
            background: #fef2f2;
            color: #dc2626;
        }
        .calendar-day.booking-few::after {
            content: '●';
            position: absolute;
            bottom: 2px;
            right: 2px;
            font-size: 8px;
            color: #ef4444;
        }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <div style="font-size:24px">🧭</div>
        <div>
            <h2>Quản lý đặt phòng</h2>
            <small>Lọc theo homestay và trạng thái</small>
        </div>
    </div>
    <div class="content">
        <!-- Calendar Section -->
        <div class="calendar-section">
            <div class="calendar-header">
                <h3 class="calendar-title">📅 Lịch đặt phòng</h3>
                <div class="calendar-nav">
                    <button id="prevMonth">‹ Tháng trước</button>
                    <button id="nextMonth">Tháng sau ›</button>
                </div>
            </div>
            <div id="calendarContainer">
                <!-- Calendar will be generated by JavaScript -->
            </div>
        </div>
        
        <div class="top-actions">
            <a href="${pageContext.request.contextPath}/" class="btn-home">← Quay lại trang chính</a>
        </div>
        <form method="get" action="/homestay-management/manager/bookings" class="filters">
            <div class="field">
                <label>Homestay</label>
                <select name="homestayName">
                    <option value="">Tất cả homestay</option>
                    <% 
                        List<Homestay> managerHomestays = (List<Homestay>) request.getAttribute("managerHomestays");
                        String selectedHomestayName = (String) request.getAttribute("homestayName");
                        if (managerHomestays != null) {
                            for (Homestay homestay : managerHomestays) { 
                    %>
                        <option value="<%= homestay.getName() %>" 
                            <%= homestay.getName().equals(selectedHomestayName) ? "selected" : "" %>>
                            <%= homestay.getName() %>
                        </option>
                    <% 
                            }
                        } 
                    %>
                </select>
            </div>
            <div class="field">
                <label>Số phòng</label>
<input type="text" name="roomNumber" placeholder="Ví dụ: 102" value="<%= request.getAttribute("roomNumber") != null ? request.getAttribute("roomNumber") : "" %>"/>
            </div>
            <div class="field">
                <label>Trạng thái</label>
                <select name="status">
                    <option value="" <%= (status==null||status.isEmpty())?"selected":"" %>>Tất cả trạng thái</option>
                    <option value="PENDING" <%= "PENDING".equals(status)?"selected":"" %>>⏳ Chờ duyệt</option>
                    <option value="CHECKED_IN" <%= "CHECKED_IN".equals(status)?"selected":"" %>>🏠 Đang ở</option>
                    <option value="CHECKED_OUT" <%= "CHECKED_OUT".equals(status)?"selected":"" %>>✅ Đã trả</option>
                    <option value="CANCELLED" <%= "CANCELLED".equals(status)?"selected":"" %>>❌ Đã hủy</option>
                </select>
            </div>
            <div class="field" style="align-self:flex-end; display:flex; gap:8px;">
                <button type="submit" class="btn btn-filter">🔎 Lọc</button>
            </div>
        </form>
        <div class="table-wrapper">
        <table>
            <thead>
            <tr>
                <th>ID</th>
                <th>Homestay</th>
                <th>Phòng</th>
                <th>Khách</th>
                <th>SĐT</th>
                <th class="text-center">Nhận</th>
                <th class="text-center">Trả</th>
                <th>Loại phòng</th>
                <th class="text-right">Tổng tiền</th>
                <th>Trạng thái</th>
                <th>Thanh toán</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (bookings != null && !bookings.isEmpty()) { int i=1; for (Map<String,Object> r : bookings) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= r.get("homestay_name") %></td>
                    <td><%= r.get("room_number") %></td>
                    <td><%= r.get("user_name") %></td>
                    <td><%= r.get("phone") != null ? r.get("phone") : "-" %></td>
                    <td class="text-center">
                        <%
                            Object ciObj = r.get("check_in");
                            String ciStr = "";
                            String ciIso = "";
                            try {
                                java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                java.time.format.DateTimeFormatter iso = java.time.format.DateTimeFormatter.ISO_LOCAL_DATE;
                                if (ciObj instanceof java.sql.Date) {
                                    java.time.LocalDate ld = ((java.sql.Date) ciObj).toLocalDate();
                                    ciStr = ld.format(fmt);
                                    ciIso = ld.format(iso);
                                } else if (ciObj != null) {
java.time.LocalDate ld = java.time.LocalDate.parse(ciObj.toString());
                                    ciStr = ld.format(fmt);
                                    ciIso = ld.format(iso);
                                }
                            } catch (Exception ignore) { ciStr = String.valueOf(ciObj); }
                        %>
                        <%= ciStr %>
                    </td>
                    <td class="text-center">
                        <%
                            Object coObj = r.get("check_out");
                            String coStr = "";
                            String coIso = "";
                            try {
                                java.time.format.DateTimeFormatter fmt = java.time.format.DateTimeFormatter.ofPattern("dd/MM/yyyy");
                                java.time.format.DateTimeFormatter iso = java.time.format.DateTimeFormatter.ISO_LOCAL_DATE;
                                if (coObj instanceof java.sql.Date) {
                                    java.time.LocalDate ld = ((java.sql.Date) coObj).toLocalDate();
                                    coStr = ld.format(fmt);
                                    coIso = ld.format(iso);
                                } else if (coObj != null) {
                                    java.time.LocalDate ld = java.time.LocalDate.parse(coObj.toString());
                                    coStr = ld.format(fmt);
                                    coIso = ld.format(iso);
                                }
                            } catch (Exception ignore) { coStr = String.valueOf(coObj); }
                        %>
                        <%= coStr %>
                    </td>
                    <td><%= r.get("room_type") != null ? r.get("room_type") : "-" %></td>
                    <td class="text-right">
                        <% java.math.BigDecimal amt = (java.math.BigDecimal) r.get("total_amount");
                           java.text.NumberFormat vnd = java.text.NumberFormat.getInstance(new java.util.Locale("vi","VN")); %>
                        <%= (amt != null) ? (vnd.format(amt) + " đ") : "0 đ" %>
                    </td>
                    <td>
                        <%
                            String bookingStatus = String.valueOf(r.get("booking_status"));
                            String stVi;
                            String stIcon;
                            String badgeClass;
                            if ("CHECKED_IN".equalsIgnoreCase(bookingStatus)) { 
                                stVi = "Đang ở"; 
                                stIcon = "🏠 "; 
                                badgeClass = "badge-checked-in";
                            } else if ("CHECKED_OUT".equalsIgnoreCase(bookingStatus)) { 
                                stVi = "Đã trả"; 
                                stIcon = "✅ "; 
                                badgeClass = "badge-checked-out";
                            } else if ("CANCELLED".equalsIgnoreCase(bookingStatus)) { 
                                stVi = "Đã hủy"; 
                                stIcon = "❌ "; 
                                badgeClass = "badge-cancelled";
                            } else { 
                                stVi = "Chờ duyệt"; 
                                stIcon = "⏳ "; 
                                badgeClass = "badge-pending";
                            }
                        %>
                        <select class="status-dropdown" data-booking-id="<%= r.get("id") %>" onchange="updateBookingStatus(this)">
                            <option value="PENDING" <%= "PENDING".equals(String.valueOf(r.get("booking_status"))) ? "selected" : "" %>>⏳ Chờ duyệt</option>
                            <option value="CONFIRMED" <%= "CONFIRMED".equals(String.valueOf(r.get("booking_status"))) ? "selected" : "" %>>✅ Đã duyệt</option>
                            <option value="CHECKED_IN" <%= "CHECKED_IN".equals(String.valueOf(r.get("booking_status"))) ? "selected" : "" %>>🏠 Đang ở</option>
                            <option value="CHECKED_OUT" <%= "CHECKED_OUT".equals(String.valueOf(r.get("booking_status"))) ? "selected" : "" %>>✅ Đã trả</option>
                        </select>
                    </td>
                    <td>
                        <%
                            Object pstObj = r.get("payment_status");
                            String pst = pstObj != null ? pstObj.toString() : "UNPAID";
                            String pstVi; String pstIcon;
                            
                            
                            if ("PAID".equalsIgnoreCase(pst)) { 
                                pstVi = "Đã thanh toán"; 
                                pstIcon = "💰 "; 
                            } else if ("PENDING".equalsIgnoreCase(pst)) { 
                                pstVi = "Chờ xử lý"; 
                                pstIcon = "💳 "; 
                            } else { 
                                pstVi = "Chưa thanh toán"; 
                                pstIcon = "⚠️ "; 
                                pst = "UNPAID"; 
                            }
                        %>
                        <span class="badge-pay badge-pay-<%= pst %>"><%= pstIcon %><%= pstVi %></span>
                    </td>
                    <td>
                        <div class="actions">
                            <a class="btn btn-edit js-edit" href="#" data-id="<%= r.get("id") %>" data-ci="<%= ciIso %>" data-co="<%= coIso %>" data-rn="<%= r.get("room_number") %>">✎ Chỉnh sửa</a>
                        </div>
                    </td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="12" class="text-center">Không có đặt phòng nào.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
        </div>

        <!-- Inline Edit Form -->
        <form id="editForm" class="edit-form" method="post">
            <h3>Chỉnh sửa đặt phòng</h3>
            <p class="help">Chỉ thay đổi ngày nhận/trả. Sau khi lưu, danh sách sẽ tự cập nhật.</p>
            <div class="row row--2col">
                <div>
                    <label>Ngày nhận</label><br>
                    <input type="date" name="checkIn" required>
                </div>
                <div>
                    <label>Ngày trả</label><br>
                    <input type="date" name="checkOut" required>
                </div>
                <div class="edit-actions">
                    <button type="submit" class="btn btn-approve">Lưu</button>
                    <button type="button" id="cancelEdit" class="btn btn-reject">Hủy</button>
                </div>
            </div>
        </form>
    </div>
</div>

<script>
// Calendar functionality
let currentDate = new Date();
let currentMonth = currentDate.getMonth();
let currentYear = currentDate.getFullYear();

const monthNames = [
    "Tháng 1", "Tháng 2", "Tháng 3", "Tháng 4", "Tháng 5", "Tháng 6",
    "Tháng 7", "Tháng 8", "Tháng 9", "Tháng 10", "Tháng 11", "Tháng 12"
];

const dayNames = ["CN", "T2", "T3", "T4", "T5", "T6", "T7"];

// Booking data from server
const bookingData = [
    <% if (bookings != null && !bookings.isEmpty()) { %>
        <% for (Map<String,Object> booking : bookings) { %>
            {
                checkIn: '<%= booking.get("check_in") %>',
                checkOut: '<%= booking.get("check_out") %>',
                status: '<%= booking.get("status") %>'
            },
        <% } %>
    <% } %>
];

function generateCalendar() {
    const calendarContainer = document.getElementById('calendarContainer');
    const firstDay = new Date(currentYear, currentMonth, 1);
    const lastDay = new Date(currentYear, currentMonth + 1, 0);
    const daysInMonth = lastDay.getDate();
    const startingDayOfWeek = firstDay.getDay();
    
    let calendarHTML = '<div class="calendar-grid">';
    
    // Add day headers
    for (let i = 0; i < dayNames.length; i++) {
        calendarHTML += '<div class="calendar-day-header">' + dayNames[i] + '</div>';
    }
    
    // Add empty cells for days before the first day of the month
    for (let i = 0; i < startingDayOfWeek; i++) {
        const prevMonth = new Date(currentYear, currentMonth, 0);
        const day = prevMonth.getDate() - startingDayOfWeek + i + 1;
        calendarHTML += '<div class="calendar-day other-month">' + day + '</div>';
    }
    
    // Add days of the current month
    for (let day = 1; day <= daysInMonth; day++) {
        const date = new Date(currentYear, currentMonth, day);
        const isToday = date.toDateString() === new Date().toDateString();
        const bookingCount = getBookingCountForDate(date);
        
        let dayClass = 'calendar-day';
        if (isToday) dayClass += ' today';
        
        // Add booking class based on count
        if (bookingCount > 0) {
            if (bookingCount >= 5) {
                dayClass += ' booking-many'; // Nhiều đặt phòng - chấm xanh
            } else if (bookingCount >= 3) {
                dayClass += ' booking-medium'; // Vừa - chấm vàng
            } else {
                dayClass += ' booking-few'; // Ít - chấm đỏ
            }
        }
        
        const dateStr = date.toISOString().split('T')[0];
        calendarHTML += '<div class="' + dayClass + '" data-date="' + dateStr + '">' + day + '</div>';
    }
    
    // Add empty cells for days after the last day of the month
    const remainingCells = 42 - (startingDayOfWeek + daysInMonth);
    for (let day = 1; day <= remainingCells; day++) {
        calendarHTML += '<div class="calendar-day other-month">' + day + '</div>';
    }
    
    calendarHTML += '</div>';
    calendarContainer.innerHTML = calendarHTML;
    
    // Update calendar title
    document.querySelector('.calendar-title').textContent = '📅 ' + monthNames[currentMonth] + ' ' + currentYear;
}

function getBookingCountForDate(date) {
    const dateStr = date.toISOString().split('T')[0];
    let count = 0;
    
    for (let i = 0; i < bookingData.length; i++) {
        const booking = bookingData[i];
        const checkIn = new Date(booking.checkIn);
        const checkOut = new Date(booking.checkOut);
        
        // Check if the date falls within the booking period
        if (date >= checkIn && date < checkOut) {
            count++;
        }
    }
    
    return count;
}

// Event listeners
document.getElementById('prevMonth').addEventListener('click', function() {
    currentMonth--;
    if (currentMonth < 0) {
        currentMonth = 11;
        currentYear--;
    }
    generateCalendar();
});

document.getElementById('nextMonth').addEventListener('click', function() {
    currentMonth++;
    if (currentMonth > 11) {
        currentMonth = 0;
        currentYear++;
    }
    generateCalendar();
});

// Initialize calendar
generateCalendar();
</script>

<%@ include file="../partials/footer.jsp" %>
<script>
  (function(){
    const form = document.getElementById('editForm');
    const ciInput = form.querySelector('input[name="checkIn"]');
    const coInput = form.querySelector('input[name="checkOut"]');
    const cancelBtn = document.getElementById('cancelEdit');
    // Đã bỏ trường đổi phòng

    document.addEventListener('click', function(e){
      const a = e.target.closest('.js-edit');
      if (!a) return;
      e.preventDefault();
      const id = a.getAttribute('data-id');
      const ci = a.getAttribute('data-ci') || '';
      const co = a.getAttribute('data-co') || '';
      // const rn = a.getAttribute('data-rn') || '';
      // set action to POST edit endpoint
      form.action = '/homestay-management/manager/bookings/' + id + '/edit';
      ciInput.value = ci;
      coInput.value = co;
      // Không còn xử lý đổi phòng
      form.classList.add('visible');
      form.scrollIntoView({behavior: 'smooth', block: 'start'});
    });

    cancelBtn.addEventListener('click', function(){
      form.classList.remove('visible');
    });

    // Không còn toggle đổi phòng
    })();

    // Function to update booking status
    function updateBookingStatus(selectElement) {
        const bookingId = selectElement.getAttribute('data-booking-id');
        const newStatus = selectElement.value;
        
        if (confirm('Bạn có chắc chắn muốn thay đổi trạng thái?')) {
            // Create form and submit
            const form = document.createElement('form');
            form.method = 'POST';
            form.action = '<%= (request.getContextPath() != null ? request.getContextPath() : "") %>/manager/bookings/' + bookingId + '/update-status';
            
            const statusInput = document.createElement('input');
            statusInput.type = 'hidden';
            statusInput.name = 'status';
            statusInput.value = newStatus;
            
            // Add CSRF token if available
            const csrfToken = document.querySelector('meta[name="_csrf"]');
            if (csrfToken) {
                const csrfInput = document.createElement('input');
                csrfInput.type = 'hidden';
                csrfInput.name = '_csrf';
                csrfInput.value = csrfToken.getAttribute('content');
                form.appendChild(csrfInput);
            }
            
            form.appendChild(statusInput);
            document.body.appendChild(form);
            form.submit();
        } else {
            // Reset to original value
            location.reload();
        }
    }
</script>
</body>
</html>