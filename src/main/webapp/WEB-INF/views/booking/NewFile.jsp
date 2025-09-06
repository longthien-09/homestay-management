<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Service, com.homestay.model.Homestay, com.homestay.model.Room" %>
<%@ include file="../partials/header.jsp" %>
<%! 
    private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
    }
%>
<%
    Integer homestayId = (Integer) request.getAttribute("homestayId");
    Integer roomId = (Integer) request.getAttribute("roomId");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
    List<Service> homestayServices = (List<Service>) request.getAttribute("homestayServices");
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    Room room = (Room) request.getAttribute("room");
    
    // Get URL parameters for dates
    String checkinParam = request.getParameter("checkin");
    String checkoutParam = request.getParameter("checkout");
    // Compute nights for pricing (default 1)
    long nightsCount = 1;
    try {
        if (checkinParam != null && checkoutParam != null && !checkinParam.isEmpty() && !checkoutParam.isEmpty()) {
            java.time.LocalDate ciTmp = java.time.LocalDate.parse(checkinParam);
            java.time.LocalDate coTmp = java.time.LocalDate.parse(checkoutParam);
            long diff = java.time.temporal.ChronoUnit.DAYS.between(ciTmp, coTmp);
            if (diff > 0) nightsCount = diff;
        }
    } catch (Exception ignore) { nightsCount = 1; }
    // Auto-discount rule (no input): long-stay
    // >=7 đêm: 15%, >=3 đêm: 10%, else 0%
    int discountPercent = 0;
    if (nightsCount >= 7) discountPercent = 15;
    else if (nightsCount >= 3) discountPercent = 10;
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt phòng - <%= homestay != null ? homestay.getName() : "Homestay" %></title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background-color: #f7f7f7;
            color: #333;
            line-height: 1.6;
        }
        
        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 20px;
        }
        
        /* Header */
        .booking-header {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .booking-title {
            font-size: 24px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        /* Progress Bar */
        .progress-bar {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
        }
        
        .progress-step {
            display: flex;
            align-items: center;
            flex: 1;
            position: relative;
        }
        
        /* Connector between steps: draw from previous step to current, not overlapping circles */
        .progress-step + .progress-step::before {
            content: '';
            position: absolute;
            left: calc(-50% + 22px); /* start a bit after center of previous circle */
            top: 50%;
            transform: translateY(-50%);
            width: calc(100% - 44px); /* leave space for both circles */
            height: 2px;
            background: #e5e7eb;
            z-index: 0; /* stay behind text/circles */
        }
        .progress-step.completed + .progress-step::before {
            background: #003580;
        }

        /* Ensure text overlays the connector so the line doesn't cut through it */
        .step-number, .step-text {
            position: relative;
            z-index: 1;
        }
        .step-text {
            background: #fff;
            padding: 0 4px;
        }
        
        .step-number {
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 600;
            font-size: 14px;
            margin-right: 12px;
            background: #e5e7eb;
            color: #6b7280;
        }
        
        .progress-step.completed .step-number {
            background: #003580;
            color: white;
        }
        
        .progress-step.current .step-number {
            background: #003580;
            color: white;
        }
        
        .step-text {
            font-size: 14px;
            font-weight: 500;
            color: #6b7280;
        }
        
        .progress-step.completed .step-text,
        .progress-step.current .step-text {
            color: #003580;
        }
        
        .success-banner {
            background: #d1fae5;
            color: #065f46;
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 24px;
            font-size: 14px;
            font-weight: 500;
        }
        
        /* Main Content */
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 24px;
        }
        
        .booking-summary {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: fit-content;
        }
        
        .booking-form {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        /* Booking Summary */
        .summary-section {
            margin-bottom: 24px;
        }
        
        .summary-section:last-child {
            margin-bottom: 0;
        }
        
        .summary-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        
        .booking-details {
            display: flex;
            flex-direction: column;
            gap: 8px;
        }
        
        .detail-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #f3f4f6;
        }
        
        .detail-item:last-child {
            border-bottom: none;
        }
        
        .detail-label {
            font-size: 14px;
            color: #6b7280;
        }
        
        .detail-value {
            font-size: 14px;
            font-weight: 500;
            color: #1a1a1a;
        }
        
        .price-summary {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 16px;
        }
        
        .price-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .price-item:last-child {
            margin-bottom: 0;
            padding-top: 8px;
            border-top: 1px solid #e5e7eb;
            font-weight: 600;
            font-size: 16px;
        }
        
        .price-label {
            font-size: 14px;
            color: #6b7280;
        }
        
        .price-value {
            font-size: 14px;
            font-weight: 500;
            color: #1a1a1a;
        }
        
        .price-item:last-child .price-value {
            color: #003580;
            font-size: 16px;
        }
        
        .tax-note {
            font-size: 12px;
            color: #6b7280;
            margin-top: 8px;
        }
        
        .booking-conditions {
            margin-top: 16px;
        }
        
        .conditions-link {
            color: #003580;
            text-decoration: none;
            font-size: 14px;
        }
        
        .conditions-link:hover {
            text-decoration: underline;
        }
        
        .partner-benefits {
            background: #f0f9ff;
            border-radius: 8px;
            padding: 16px;
            margin-top: 16px;
        }
        
        .benefits-title {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 12px;
        }
        
        .benefits-list {
            list-style: none;
            padding: 0;
        }
        
        .benefits-list li {
            font-size: 13px;
            color: #374151;
            margin-bottom: 6px;
            padding-left: 16px;
            position: relative;
        }
        
        .benefits-list li::before {
            content: '•';
            position: absolute;
            left: 0;
            color: #003580;
        }
        
        /* Property Details */
        .property-section {
            margin-bottom: 24px;
        }
        
        .property-images {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr 1fr;
            gap: 4px;
            margin-bottom: 16px;
            border-radius: 8px;
            overflow: hidden;
        }
        
        .main-property-image {
            grid-column: 1 / 3;
            grid-row: 1 / 3;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 12px;
            min-height: 80px;
        }
        
        .property-thumbnail {
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 10px;
            min-height: 40px;
        }
        
        .property-info {
            margin-bottom: 16px;
        }
        
        .property-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }
        
        .rating-badge {
            background: #003580;
            color: white;
            padding: 4px 8px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .rating-text {
            font-size: 12px;
            color: #6b7280;
        }
        
        .property-name {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .property-amenities {
            display: flex;
            gap: 8px;
            margin-bottom: 8px;
        }
        
        .amenity-tag {
            background: #f3f4f6;
            color: #374151;
            padding: 2px 6px;
            border-radius: 4px;
            font-size: 11px;
        }
        
        .property-address {
            font-size: 12px;
            color: #6b7280;
            margin-bottom: 8px;
        }
        
        .location-highlight {
            background: #fef3c7;
            color: #92400e;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
        }
        
        /* Login Section */
        .login-section {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
            display: flex;
            align-items: center;
            gap: 12px;
        }
        
        .login-icon {
            width: 24px;
            height: 24px;
            background: #003580;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }
        
        .login-text {
            font-size: 13px;
            color: #374151;
            flex: 1;
        }
        
        .login-link {
            color: #003580;
            text-decoration: none;
            font-weight: 500;
        }
        
        .login-link:hover {
            text-decoration: underline;
        }
        
        /* Form Styles */
        .form-section {
            margin-bottom: 24px;
        }
        
        .form-section:last-child {
            margin-bottom: 0;
        }
        
        .section-title {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 16px;
        }
        
        .form-row {
            display: flex;
            gap: 16px;
            margin-bottom: 16px;
        }
        
        .form-group {
            flex: 1;
        }
        
        .form-group.full-width {
            flex: 1 1 100%;
        }
        
        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #374151;
            margin-bottom: 6px;
        }
        
        .required {
            color: #dc2626;
        }
        
        .form-input, .form-select {
            width: 100%;
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s, box-shadow 0.3s;
        }
        
        .form-input:focus, .form-select:focus {
            outline: none;
            border-color: #003580;
            box-shadow: 0 0 0 3px rgba(0, 53, 128, 0.1);
        }
        
        .form-help {
            font-size: 12px;
            color: #6b7280;
            margin-top: 4px;
        }
        
        .phone-input-group {
            display: flex;
            gap: 8px;
        }
        
        .country-select {
            flex: 0 0 120px;
        }
        
        .phone-input {
            flex: 1;
        }
        
        /* Room Details */
        .room-details {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
        }
        
        .room-name {
            font-size: 14px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .room-policies {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }
        
        .policy-icon {
            width: 16px;
            height: 16px;
            background: #dc2626;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 10px;
        }
        
        .policy-text {
            font-size: 12px;
            color: #6b7280;
        }
        
        .room-rating {
            display: flex;
            align-items: center;
            gap: 8px;
            background: #d1fae5;
            color: #065f46;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 12px;
            font-weight: 500;
        }
        
        /* Next Button */
        .next-button {
            background: #003580;
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
            width: 100%;
        }
        
        .next-button:hover {
            background: #002966;
        }
        
        .next-button:disabled {
            background: #9ca3af;
            cursor: not-allowed;
        }
        
        .button-note {
            font-size: 12px;
            color: #6b7280;
            text-align: center;
            margin-top: 8px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
            
            .progress-bar {
                flex-direction: column;
                gap: 12px;
            }
            
            .progress-step:not(:last-child)::after {
                display: none;
            }
            
            .form-row {
                flex-direction: column;
                gap: 12px;
            }
            
            .phone-input-group {
                flex-direction: column;
            }
            
            .country-select {
                flex: 1;
            }
        }
        
        /* Alert Styles */
        .alert {
            padding: 12px 16px;
            border-radius: 8px;
            margin-bottom: 16px;
            font-size: 14px;
        }
        
        .alert-error {
            background: #fef2f2;
            color: #dc2626;
            border: 1px solid #fecaca;
        }
        
        .alert-success {
            background: #f0fdf4;
            color: #166534;
            border: 1px solid #bbf7d0;
        }
        
        /* Services Section */
        .services-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 12px;
            margin-bottom: 16px;
        }
        
        .service-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 12px;
            background: white;
            border: 2px solid #e5e7eb;
            border-radius: 8px;
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .service-item:hover {
            border-color: #3b82f6;
            box-shadow: 0 2px 8px rgba(59, 130, 246, 0.1);
        }
        
        .service-item.checked {
            border-color: #3b82f6;
            background: #eff6ff;
        }
        
        .service-checkbox {
            width: 18px;
            height: 18px;
            accent-color: #3b82f6;
        }
        
        .service-label {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            cursor: pointer;
            margin: 0;
        }
        
        .service-name {
            font-weight: 500;
            color: #374151;
            font-size: 14px;
        }
        
        .service-price {
            color: #059669;
            font-weight: 600;
            font-size: 14px;
        }
        
        .service-total {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 12px 16px;
            background: #f8fafc;
            border: 1px solid #e2e8f0;
            border-radius: 8px;
            margin-top: 16px;
        }
        
        .service-total-label {
            font-weight: 600;
            color: #374151;
        }
        
        .service-total-amount {
            font-weight: 700;
            color: #059669;
            font-size: 16px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Header -->
        <div class="booking-header">
            <h1 class="booking-title">Đặt phòng</h1>
            
            <!-- Progress Bar -->
            <div class="progress-bar">
                <div class="progress-step completed">
                    <div class="step-number">✓</div>
                    <div class="step-text">Lựa chọn của bạn</div>
                </div>
                <div class="progress-step current">
                    <div class="step-number">2</div>
                    <div class="step-text">Nhập thông tin chi tiết của bạn</div>
                </div>
                <div class="progress-step">
                    <div class="step-number">3</div>
                    <div class="step-text">Xác nhận đặt phòng của bạn</div>
                </div>
            </div>           
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Left Column - Booking Summary -->
            <div class="booking-summary">
                <!-- Booking Details -->
                <div class="summary-section">
                    <h3 class="summary-title">Chi tiết đặt chỗ của bạn</h3>
                    <div class="booking-details">
                        <div class="detail-item">
                            <span class="detail-label">Nhận phòng</span>
                            <span class="detail-value" id="checkin-display">
                                <% if (checkinParam != null && !checkinParam.isEmpty()) { %>
                                    <%= checkinParam %> từ 2:00 PM
                                <% } else { %>
                                    Chọn ngày nhận phòng
                                <% } %>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Trả phòng</span>
                            <span class="detail-value" id="checkout-display">
                                <% if (checkoutParam != null && !checkoutParam.isEmpty()) { %>
                                    <%= checkoutParam %> đến 12:00 PM
                                <% } else { %>
                                    Chọn ngày trả phòng
                                <% } %>
                            </span>
                        </div>
                        <div class="detail-item">
                            <span class="detail-label">Tổng thời gian lưu trú</span>
                            <span class="detail-value" id="nights-display">
                                <% if (checkinParam != null && checkoutParam != null && !checkinParam.isEmpty() && !checkoutParam.isEmpty()) { %>
                                    <%
                                        try {
                                            java.time.LocalDate checkin = java.time.LocalDate.parse(checkinParam);
                                            java.time.LocalDate checkout = java.time.LocalDate.parse(checkoutParam);
                                            long nights = java.time.temporal.ChronoUnit.DAYS.between(checkin, checkout);
                                    %>
                                        <%= nights %> đêm
                                    <%
                                        } catch (Exception e) {
                                    %>
                                        1 đêm
                                    <%
                                        }
                                    %>
                                <% } else { %>
                                    1 đêm
                                <% } %>
                            </span>
                        </div>
                    </div>
                </div>

                <!-- Price Summary -->
                <div class="summary-section">
                    <h3 class="summary-title">Tóm tắt giá của bạn</h3>
                    <div class="price-summary">
                        <div class="price-item">
                            <span class="price-label">Tổng giá (<%= nightsCount %> đêm)</span>
                            <span class="price-value">
                                <% java.math.BigDecimal subtotal = java.math.BigDecimal.ZERO; %>
                                <% if (room != null) { subtotal = room.getPrice().multiply(new java.math.BigDecimal(nightsCount)); %>
                                    <%= formatPrice(subtotal) %>
                                <% } else { %>
                                    0₫
                                <% } %>
                            </span>
                        </div>
                        <% if (discountPercent > 0) { %>
                        <div class="price-item">
                            <span class="price-label">Giảm giá tự động (<%= discountPercent %>%)</span>
                            <span class="price-value">
                                <% java.math.BigDecimal discount = subtotal.multiply(new java.math.BigDecimal(discountPercent)).divide(new java.math.BigDecimal(100)); %>
                                -<%= formatPrice(discount) %>
                            </span>
                        </div>
                        <div class="price-item">
                            <span class="price-label">Thành tiền</span>
                            <span class="price-value">
                                <% java.math.BigDecimal total = subtotal.subtract(subtotal.multiply(new java.math.BigDecimal(discountPercent)).divide(new java.math.BigDecimal(100))); %>
                                <%= formatPrice(total) %>
                            </span>
                        </div>
                        <% } %>
                        <div class="tax-note">Bao gồm thuế và phí</div>
                    </div>
                </div>

                <!-- Booking Conditions -->
                <div class="booking-conditions">
                    <a href="#" class="conditions-link">Xem lại điều kiện đặt chỗ của bạn</a>
                </div>

                <!-- Partner Benefits -->
                <div class="partner-benefits">
                    <h4 class="benefits-title">Ưu đãi đối tác</h4>
                    <ul class="benefits-list">
                        <li>Bạn sẽ thanh toán an toàn bằng Booking.com ngay hôm nay</li>
                        <li>Bạn sẽ không thể thay đổi thông tin cá nhân hoặc thông tin đặt chỗ sau khi đặt phòng hoàn tất</li>
                        <li>Hóa đơn sẽ được phát hành bởi công ty đối tác của chúng tôi</li>
                    </ul>
                </div>
            </div>

            <!-- Right Column - Booking Form -->
            <div class="booking-form">
                <!-- Error/Success Messages -->
            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>
            <% if (message != null) { %>
                <div class="alert alert-success"><%= message %></div>
            <% } %>
                
                <!-- Property Details -->
                <div class="property-section">
                    

                    
                    <div class="property-info">
                        <h3 class="property-name">
                            <%= homestay != null ? homestay.getName() : "Homestay" %>
                        </h3>
                        <div class="property-amenities">
                            <span class="amenity-tag">Bãi biển</span>
                            <span class="amenity-tag">P Bãi đậu xe</span>
                        </div>
                        <div class="property-address">
                            <%= homestay != null && homestay.getAddress() != null ? homestay.getAddress() : "Địa chỉ chưa cập nhật" %>
                    </div>
                    </div>
                </div>

                <!-- Personal Details Form -->
                <form method="post" action="/homestay-management/homestays/<%= homestayId %>/rooms/<%= roomId %>/book">
                    <div class="form-section">
                        <h3 class="section-title">Thông tin cá nhân</h3>
                        
                <div class="form-row">
                    <div class="form-group">
                                <label for="firstName" class="form-label">Tên thánh <span class="required">*</span></label>
                                <input type="text" id="firstName" name="firstName" class="form-input" required>
                            </div>
                            <div class="form-group">
                                <label for="lastName" class="form-label">Họ <span class="required">*</span></label>
                                <input type="text" id="lastName" name="lastName" class="form-input" required>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group full-width">
                                <label for="email" class="form-label">Địa chỉ email <span class="required">*</span></label>
                                <input type="email" id="email" name="email" class="form-input" required placeholder="Kiểm tra kỹ lỗi chính tả">
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group full-width">
                                <label for="confirmEmail" class="form-label">Xác nhận địa chỉ email <span class="required">*</span></label>
                                <input type="email" id="confirmEmail" name="confirmEmail" class="form-input" required>
                    </div>
                </div>
                
                        <div class="form-row">
                            <div class="form-group full-width">
                                <label for="phone" class="form-label">Điện thoại (ưu tiên số điện thoại di động) <span class="required">*</span></label>
                                <div class="phone-input-group">
                                    <select class="form-select country-select">
                                        <option value="+84">🇻🇳 +84</option>
                                        <option value="+1">🇺🇸 +1</option>
                                        <option value="+44">🇬🇧 +44</option>
                                    </select>
                                    <input type="tel" id="phone" name="phone" class="form-input phone-input" required pattern="\\d{10}" inputmode="numeric" minlength="10" maxlength="10" placeholder="Ví dụ: 0912345678" oninput="this.value=this.value.replace(/[^0-9]/g,'').slice(0,10)">
                                </div>
                            </div>
                        </div>
                        
                        <!-- Hidden fields for dates -->
                        <input type="hidden" id="checkIn" name="checkIn" value="<%= checkinParam != null ? checkinParam : "" %>">
                        <input type="hidden" id="checkOut" name="checkOut" value="<%= checkoutParam != null ? checkoutParam : "" %>">
                        <input type="hidden" name="quantity" value="1">
                </div>
                
                <!-- Services Section -->
                    <% if (homestayServices != null && !homestayServices.isEmpty()) { %>
                <div class="form-section">
                    <h3 class="section-title">🛎️ Dịch vụ bổ sung (có phí)</h3>
                        <div class="services-grid">
                            <% for (Service service : homestayServices) { %>
                            <% if (service.getPrice() != null && service.getPrice().compareTo(java.math.BigDecimal.ZERO) > 0) { %>
                                <div class="service-item">
                                <input type="checkbox" id="service_<%= service.getId() %>" name="services" value="<%= service.getId() %>" class="service-checkbox" onchange="updateServiceTotal()">
                                <label for="service_<%= service.getId() %>" class="service-label">
                                    <div class="service-name"><%= service.getName() %></div>
                                    <div class="service-price">+<%= formatPrice(service.getPrice()) %></div>
                                    </label>
                                </div>
                            <% } %>
                        <% } %>
                    </div>
                    <div class="service-total" id="serviceTotal" style="display: none;">
                        <div class="service-total-label">Tổng dịch vụ:</div>
                        <div class="service-total-amount" id="serviceTotalAmount">0₫</div>
                        </div>
                </div>
                <% } %>

                    <!-- Booking Conditions -->
                    <div style="margin-bottom: 24px;">
                        <a href="#" class="conditions-link">Điều kiện đặt chỗ của tôi là gì?</a>
                </div>

                    <!-- Next Button -->
                    <button type="button" class="next-button">
                        Tiếp theo: Thông tin chi tiết cuối cùng >
                    </button>
                    <p class="button-note">Đừng lo lắng - bạn sẽ chưa bị tính phí!</p>
            </form>
            </div>
        </div>
    </div>

    <script>
        function presetMinDates() {
            const today = new Date().toISOString().split('T')[0];
            const ci = document.getElementById('checkIn');
            const co = document.getElementById('checkOut');
            
            // Set default values from URL parameters
            if ('<%= checkinParam %>' !== 'null' && '<%= checkinParam %>' !== '') {
                ci.value = '<%= checkinParam %>';
            } else if (!ci.value) {
                ci.value = today;
            }
            
            if ('<%= checkoutParam %>' !== 'null' && '<%= checkoutParam %>' !== '') {
                co.value = '<%= checkoutParam %>';
            } else if (!co.value) {
                co.value = today;
            }
            
            ci.min = today;
            co.min = today;
            
            ci.addEventListener('change', () => {
                co.min = ci.value;
                if (co.value < ci.value) co.value = ci.value;
            });
        }
        
        function validateForm() {
            const requiredFields = document.querySelectorAll('input[required], select[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    field.style.borderColor = '#dc2626';
                    isValid = false;
                } else {
                    field.style.borderColor = '#d1d5db';
                }
            });
            
            // Email validation
            const email = document.getElementById('email');
            const confirmEmail = document.getElementById('confirmEmail');
            const phone = document.getElementById('phone');
            
            if (email.value && !email.value.includes('@')) {
                email.style.borderColor = '#dc2626';
                isValid = false;
            }
            
            if (confirmEmail.value && email.value !== confirmEmail.value) {
                confirmEmail.style.borderColor = '#dc2626';
                isValid = false;
            }
            
            // Phone validation: numeric and exactly 10 digits
            const phoneRegex = /^\d{10}$/;
            if (!phoneRegex.test((phone.value || '').trim())) {
                phone.style.borderColor = '#dc2626';
                isValid = false;
            } else {
                phone.style.borderColor = '#d1d5db';
            }
            
            return isValid;
        }
        
        // Service total calculation
        function updateServiceTotal() {
            const checkboxes = document.querySelectorAll('.service-checkbox:checked');
            const serviceTotal = document.getElementById('serviceTotal');
            const serviceTotalAmount = document.getElementById('serviceTotalAmount');
            
            let total = 0;
            checkboxes.forEach(checkbox => {
                const serviceItem = checkbox.closest('.service-item');
                const priceText = serviceItem.querySelector('.service-price').textContent;
                const price = parseFloat(priceText.replace(/[^\d]/g, ''));
                if (!isNaN(price)) {
                    total += price;
                }
                
                // Update visual state
                if (checkbox.checked) {
                    serviceItem.classList.add('checked');
                } else {
                    serviceItem.classList.remove('checked');
                }
            });
            
            if (total > 0) {
                serviceTotal.style.display = 'flex';
                serviceTotalAmount.textContent = formatPrice(total);
            } else {
                serviceTotal.style.display = 'none';
            }
        }
        
        function formatPrice(amount) {
            return new Intl.NumberFormat('vi-VN', {
                style: 'currency',
                currency: 'VND',
                minimumFractionDigits: 0
            }).format(amount).replace('₫', '₫');
        }
        
        document.addEventListener('DOMContentLoaded', function() {
            presetMinDates();
            updateServiceTotal();
            
            const form = document.querySelector('form');
            const nextButton = document.querySelector('.next-button');
            
            if (form && nextButton) {
                nextButton.addEventListener('click', function(e) {
                    e.preventDefault();
                    
                    if (validateForm()) {
                        // Submit form ngay, không hiển thị trạng thái "Đang xử lý..."
                        form.submit();
                    } else {
                        alert('Vui lòng điền đầy đủ thông tin bắt buộc và kiểm tra lại email!');
                    }
                });
            }
        });
    </script>

    <%@ include file="../partials/footer.jsp" %>
</body>
</html>
