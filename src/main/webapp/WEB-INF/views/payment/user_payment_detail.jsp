<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, java.util.Map, com.homestay.model.Room, com.homestay.model.Service" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<%
    Map<String,Object> payment = (Map<String,Object>) request.getAttribute("payment");
    com.homestay.model.Booking booking = (com.homestay.model.Booking) request.getAttribute("booking");
    com.homestay.model.Room room = (com.homestay.model.Room) request.getAttribute("room");
    com.homestay.model.Homestay homestay = (com.homestay.model.Homestay) request.getAttribute("homestay");
    List<Service> selectedServices = (List<Service>) request.getAttribute("selectedServices");
    java.math.BigDecimal totalServiceAmount = (java.math.BigDecimal) request.getAttribute("totalServiceAmount");
    java.math.BigDecimal totalAmount = (java.math.BigDecimal) request.getAttribute("totalAmount");
    String qrAccount = "123456789"; // Số tài khoản mẫu
    String qrBank = "VCB"; // Mã ngân hàng mẫu (Vietcombank)
    String qrName = "Nguyen Van A"; // Chủ tài khoản mẫu
    String qrAmount = totalAmount != null ? totalAmount.toString() : (payment != null && payment.get("amount") != null ? payment.get("amount").toString() : "");
    String qrBooking = booking != null ? String.valueOf(booking.getId()) : "";
    String qrContent = "Thanh toan booking #" + qrBooking;
    String qrUrl = "https://img.vietqr.io/image/" + qrBank + "-" + qrAccount + "-compact2.png?amount=" + qrAmount + "&addInfo=" + java.net.URLEncoder.encode(qrContent, "UTF-8") + "&accountName=" + java.net.URLEncoder.encode(qrName, "UTF-8");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết thanh toán</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css"/>
    <style>
        body { font-family: 'Segoe UI', Arial, sans-serif; background: #f4f6fb; margin: 0; padding: 0; }
        .container { max-width: 820px; margin: 36px auto; background: #fff; border-radius: 18px; box-shadow: 0 6px 32px rgba(0,0,0,0.10); overflow: hidden; }
        .header {
            background: linear-gradient(135deg,#20c997,#0dcaf0);
            color: #fff; padding: 28px 36px 18px 36px;
            display: flex; align-items: center; gap: 18px;
        }
        .header .logo {
            width: 54px; height: 54px; border-radius: 12px; background: #fff; display: flex; align-items: center; justify-content: center;
            font-size: 2.2em; color: #20c997; box-shadow: 0 2px 8px #b2f0e6;
        }
        .header .title {
            font-size: 2em; font-weight: 700; margin-bottom: 2px;
        }
        .header .subtitle {
            font-size: 1.1em; opacity: 0.92;
        }
        .main {
            display: flex; gap: 32px; padding: 32px 36px 28px 36px;
            flex-wrap: wrap;
        }
        .main-left { flex: 1 1 320px; min-width: 280px; }
        .main-right { flex: 1 1 260px; min-width: 220px; background: #f8f9fa; border-radius: 12px; padding: 24px 18px; box-shadow: 0 1px 6px #e3e6f0; }
        .homestay-img {
            width: 100%; max-width: 320px; height: 160px; object-fit: cover; border-radius: 12px; box-shadow: 0 2px 12px #e3e6f0; margin-bottom: 18px;
        }
        .info-row { margin-bottom: 14px; }
        .label { color: #888; font-size: 0.98em; min-width: 110px; display: inline-block; }
        .value { font-weight: 600; font-size: 1.08em; }
        .amount {
            color: #20c997; font-size: 2em; font-weight: bold; margin: 18px 0 10px 0; letter-spacing: 1px;
            display: flex; align-items: center; gap: 10px;
        }
        .amount i { color: #20c997; }
        .status { font-size: 1.1em; font-weight: 700; margin-left: 8px; }
        .status-PAID { color: #28a745; }
        .status-UNPAID { color: #e67e22; }
        .form-group { margin-bottom: 18px; }
        .form-group label { 
            display: block; 
            margin-bottom: 8px; 
            font-weight: 600; 
            color: #2c3e50; 
            font-size: 1.05em; 
        }
        .form-group select { 
            width: 100%; 
            padding: 12px 16px; 
            border: 2px solid #e9ecef; 
            border-radius: 10px; 
            font-size: 1em; 
            background: #fff; 
            color: #2c3e50; 
            transition: all 0.3s ease; 
            cursor: pointer;
            appearance: none;
            background-image: url("data:image/svg+xml;charset=UTF-8,%3csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 24 24' fill='none' stroke='currentColor' stroke-width='2' stroke-linecap='round' stroke-linejoin='round'%3e%3cpolyline points='6,9 12,15 18,9'%3e%3c/polyline%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right 12px center;
            background-size: 16px;
            padding-right: 40px;
        }
        .form-group select:focus { 
            outline: none; 
            border-color: #20c997; 
            box-shadow: 0 0 0 3px rgba(32, 201, 151, 0.1); 
        }
        .form-group select:hover { 
            border-color: #20c997; 
        }
        .btn {
            padding: 12px 28px; border-radius: 8px; border: none; background: linear-gradient(90deg,#20c997,#0dcaf0);
            color: #fff; font-weight: 700; font-size: 1.1em; cursor: pointer; box-shadow: 0 2px 8px #b2f0e6;
            transition: background 0.2s;
        }
        .btn[disabled] { background: #ccc; cursor: not-allowed; }
        .pay-instructions { background: #fffbe6; color: #856404; border-radius: 8px; padding: 14px 16px; margin-top: 12px; font-size: 0.98em; }
        .qr-box { text-align: center; margin: 18px 0 8px 0; }
        .qr-box img { width: 180px; height: 180px; border-radius: 12px; box-shadow: 0 2px 12px #e3e6f0; }
        .qr-label { font-size: 1em; color: #20c997; font-weight: 600; margin-top: 8px; }
        .services-section { margin: 20px 0; padding: 20px; background: #f8f9fa; border-radius: 12px; border: 1px solid #e9ecef; }
        .services-title { font-size: 1.1em; font-weight: 600; color: #2c3e50; margin-bottom: 15px; }
        .services-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 12px; }
        .service-item { display: flex; align-items: center; gap: 8px; padding: 8px; background: white; border-radius: 6px; border: 1px solid #dee2e6; }
        .service-item .service-name { font-weight: 600; color: #495057; }
        .service-item .service-price { color: #27ae60; font-weight: 600; font-size: 0.9em; }
        .price-breakdown { background: #f8f9fa; border-radius: 8px; padding: 16px; margin: 16px 0; border: 1px solid #e9ecef; }
        .price-row { display: flex; justify-content: space-between; margin-bottom: 8px; }
        .price-row.total { border-top: 2px solid #dee2e6; padding-top: 8px; margin-top: 8px; font-weight: bold; font-size: 1.1em; color: #20c997; }
        @media (max-width: 900px) {
            .main { flex-direction: column; gap: 18px; padding: 18px 6vw; }
            .header { flex-direction: column; align-items: flex-start; gap: 8px; padding: 18px 6vw 12px 6vw; }
        }
    </style>
    <script>
    function onMethodChange(sel) {
        var bank = document.getElementById('bank-instructions');
        var qr = document.getElementById('qr-box');
        if (sel.value === 'BANK_TRANSFER') {
            bank.style.display = 'block';
            qr.style.display = 'block';
        } else {
            bank.style.display = 'none';
            qr.style.display = 'none';
        }
    }
    </script>
</head>
<body>
<div class="container">
    <div class="header">
        <div class="logo"><i class="fa-solid fa-money-check-dollar"></i></div>
        <div>
            <div class="title">Chi tiết thanh toán</div>
            <div class="subtitle">Vui lòng kiểm tra kỹ thông tin trước khi thanh toán</div>
        </div>
    </div>
    <div class="main">
        <div class="main-left">
            <% if (room != null && room.getImage() != null && !room.getImage().isEmpty()) { %>
                <img class="homestay-img" src="<%= room.getImage() %>" alt="Ảnh phòng" />
            <% } else { %>
                <img class="homestay-img" src="https://cdn-icons-png.flaticon.com/512/2356/2356787.png" alt="Ảnh phòng" />
            <% } %>
            <% if (homestay != null) { %>
            <div class="info-row"><span class="label">Homestay:</span> <span class="value"><%= homestay.getName() %></span></div>
            <div class="info-row"><span class="label">Địa chỉ:</span> <span class="value"><%= homestay.getAddress() != null ? homestay.getAddress() : "-" %></span></div>
            <% } %>
            <% if (room != null) { %>
            <div class="info-row"><span class="label">Phòng:</span> <span class="value">Phòng <%= room.getRoomNumber() %> - <%= room.getType() %></span></div>
            <% } %>
            <% if (booking != null) { %>
            <div class="info-row"><span class="label">Ngày nhận:</span> <span class="value"><%= booking.getCheckIn() %></span></div>
            <div class="info-row"><span class="label">Ngày trả:</span> <span class="value"><%= booking.getCheckOut() %></span></div>
            <div class="info-row"><span class="label">Mã booking:</span> <span class="value">#<%= booking.getId() %></span></div>
            <% } %>
            
            <!-- Phần dịch vụ đã chọn -->
            <% if (selectedServices != null && !selectedServices.isEmpty()) { %>
                <div class="services-section">
                    <div class="services-title">🛎️ Dịch vụ đã chọn</div>
                    <div class="services-grid">
                        <% for (Service service : selectedServices) { %>
                            <div class="service-item">
                                <div class="service-name"><%= service.getName() %></div>
                                <% if (service.getPrice() != null) { %>
                                    <div class="service-price">+<%= formatPrice(service.getPrice()) %></div>
                                <% } %>
                            </div>
                        <% } %>
                    </div>
                </div>
            <% } %>
        </div>
        <div class="main-right">
            <!-- Chi tiết tiền -->
            <div class="price-breakdown">
                <% Boolean serviceOnly = (Boolean) request.getAttribute("serviceOnly"); if (serviceOnly == null) serviceOnly = false; %>
                <% if (!serviceOnly) { %>
                    <div class="price-row">
                        <span>Giá phòng:</span>
                        <span><%= formatPrice(room != null ? room.getPrice() : null) %></span>
                    </div>
                <% } %>
                <% if (totalServiceAmount != null && totalServiceAmount.compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                    <div class="price-row">
                        <span>Dịch vụ bổ sung:</span>
                        <span><%= formatPrice(totalServiceAmount) %></span>
                    </div>
                <% } %>
                <div class="price-row total">
                    <span>Tổng tiền:</span>
                    <span><%= formatPrice(totalAmount != null ? totalAmount : (payment.get("amount") != null ? (java.math.BigDecimal)payment.get("amount") : null)) %></span>
                </div>
            </div>
            
            <div class="info-row"><span class="label">Trạng thái:</span> <span class="status status-<%= payment.get("status") %>"><%= payment.get("status") %></span></div>
            <form method="post" action="/homestay-management/user/payments/<%= payment.get("id") %>/pay">
                <div class="form-group">
                    <label for="method">Phương thức thanh toán:</label>
                    <select id="method" name="method" required onchange="onMethodChange(this)">
                        <option value="CASH">Tiền mặt tại homestay</option>
                        <option value="BANK_TRANSFER">Chuyển khoản ngân hàng</option>
                    </select>
                </div>
                <div id="bank-instructions" class="pay-instructions" style="display:none;">
                    <b>Hướng dẫn chuyển khoản:</b><br/>
                    Chủ tài khoản: <b><%= qrName %></b><br/>
                    Số tài khoản: <b><%= qrAccount %></b> tại <b>Vietcombank</b><br/>
                    Nội dung: <b><%= qrContent %></b><br/>
                    <span style="color:#e67e22;">Vui lòng chuyển đúng số tiền và ghi rõ nội dung để được xác nhận nhanh chóng.</span>
                </div>
                <div id="qr-box" class="qr-box" style="display:none;">
                    <div class="qr-label">Quét mã QR để chuyển khoản nhanh</div>
                    <img src="<%= qrUrl %>" alt="QR chuyển khoản" />
                </div>
                <% if ("UNPAID".equals(payment.get("status"))) { %>
                <button class="btn" type="submit"><i class="fa-solid fa-check"></i> Xác nhận thanh toán</button>
                <% } else { %>
                <button class="btn" type="button" disabled><i class="fa-solid fa-circle-check"></i> Đã thanh toán</button>
                <% } %>
            </form>
        </div>
    </div>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
