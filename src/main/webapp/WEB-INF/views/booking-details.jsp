<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Homestay, com.homestay.model.Room" %>
<%
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    Room room = (Room) request.getAttribute("room");
    String checkin = (String) request.getAttribute("checkin");
    String checkout = (String) request.getAttribute("checkout");
    String guests = (String) request.getAttribute("guests");
    
    if (homestay == null) {
        homestay = new com.homestay.model.Homestay();
        homestay.setName("TMS Luxury Codotel Quy Nhơn - Ban Công Trực Diện Biển, Có Bếp");
        homestay.setAddress("28 Nguyễn Huệ, Quy Nhơn, Việt Nam");
    }
    
    if (room == null) {
        room = new com.homestay.model.Room();
        room.setType("Phòng 4 Người Nhìn Ra Biển");
        room.setPrice(new java.math.BigDecimal("1500000"));
    }
    
    if (checkin == null) checkin = "2025-08-30";
    if (checkout == null) checkout = "2025-09-01";
    if (guests == null) guests = "2";
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Chi tiết về bạn - Đặt phòng | HomestayPro</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.6; color: #333; background: #f8f9fa; }
        
        .header { background: #003580; color: white; padding: 15px 0; position: sticky; top: 0; z-index: 1000; }
        .header-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .header-top { display: flex; justify-content: space-between; align-items: center; }
        .logo { font-size: 24px; font-weight: bold; color: white; text-decoration: none; }
        .header-actions { display: flex; gap: 15px; align-items: center; }
        .btn-login, .btn-register { padding: 8px 16px; border-radius: 20px; text-decoration: none; font-weight: 500; transition: all 0.3s ease; }
        .btn-login { border: 1px solid white; background: transparent; color: white; }
        .btn-register { background: white; color: #003580; }
        
        .progress-bar { background: white; padding: 20px 0; border-bottom: 1px solid #eee; }
        .progress-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .progress-steps { display: flex; justify-content: center; align-items: center; gap: 40px; }
        .progress-step { display: flex; align-items: center; gap: 10px; color: #999; }
        .progress-step.active { color: #0071c2; font-weight: 600; }
        .step-number { width: 30px; height: 30px; border-radius: 50%; background: #eee; display: flex; align-items: center; justify-content: center; font-weight: 600; font-size: 14px; }
        .progress-step.active .step-number { background: #0071c2; color: white; }
        
        .main-container { max-width: 1200px; margin: 20px auto; padding: 0 20px; display: grid; grid-template-columns: 1fr 1fr; gap: 40px; }
        
        .homestay-info { background: white; border-radius: 8px; padding: 25px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); height: fit-content; }
        .homestay-image { width: 100%; height: 200px; border-radius: 8px; overflow: hidden; margin-bottom: 20px; }
        .homestay-image img { width: 100%; height: 100%; object-fit: cover; }
        .homestay-name { font-size: 18px; font-weight: 600; color: #333; margin-bottom: 10px; line-height: 1.4; }
        .homestay-address { color: #666; margin-bottom: 15px; display: flex; align-items: center; gap: 8px; }
        .homestay-rating { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; }
        .stars { color: #ffc107; font-size: 16px; }
        .rating-text { color: #333; font-size: 14px; }
        .homestay-amenities { display: flex; gap: 15px; margin-bottom: 20px; }
        .amenity { display: flex; align-items: center; gap: 5px; color: #666; font-size: 14px; }
        .amenity i { color: #0071c2; }
        
        .booking-details { background: #f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
        .booking-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .booking-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
        .booking-label { color: #666; }
        .booking-value { color: #333; font-weight: 500; }
        .change-link { color: #0071c2; text-decoration: none; font-size: 14px; }
        .change-link:hover { text-decoration: underline; }
        
        .price-summary { background: #f8f9fa; border-radius: 8px; padding: 20px; }
        .price-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .price-item { display: flex; justify-content: space-between; margin-bottom: 10px; font-size: 14px; }
        .price-label { color: #666; }
        .price-value { color: #333; font-weight: 500; }
        .discount-offer { background: #fff5f5; border-radius: 8px; padding: 15px; margin: 15px 0; border-left: 4px solid #e31e24; }
        .discount-title { color: #e31e24; font-weight: 600; margin-bottom: 5px; }
        .discount-description { color: #666; font-size: 13px; }
        .total-price { border-top: 1px solid #ddd; padding-top: 15px; margin-top: 15px; }
        .total-original { text-decoration: line-through; color: #999; font-size: 14px; }
        .total-final { font-size: 20px; font-weight: 700; color: #333; }
        .tax-info { color: #666; font-size: 12px; margin-top: 10px; }
        .tax-details { color: #0071c2; text-decoration: none; font-size: 12px; }
        
        .payment-info { background: #f8f9fa; border-radius: 8px; padding: 20px; margin-top: 20px; }
        .payment-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .payment-text { color: #666; font-size: 14px; margin-bottom: 15px; }
        .cancellation-info { background: #fff5f5; border-radius: 8px; padding: 15px; border-left: 4px solid #e31e24; }
        .cancellation-title { color: #e31e24; font-weight: 600; margin-bottom: 5px; }
        .cancellation-text { color: #666; font-size: 13px; }
        
        .user-form { background: white; border-radius: 8px; padding: 30px; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
        .form-header { margin-bottom: 25px; }
        .form-title { font-size: 24px; font-weight: 600; color: #333; margin-bottom: 10px; }
        .form-subtitle { color: #666; font-size: 16px; margin-bottom: 15px; }
        .form-instruction { background: #f0f8ff; border-radius: 8px; padding: 15px; margin-bottom: 25px; border-left: 4px solid #0071c2; }
        .instruction-text { color: #333; font-size: 14px; line-height: 1.5; }
        
        .form-group { margin-bottom: 20px; }
        .form-label { display: block; font-size: 14px; font-weight: 500; color: #333; margin-bottom: 8px; }
        .required { color: #e31e24; }
        .form-input { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; transition: border-color 0.3s ease; }
        .form-input:focus { outline: none; border-color: #0071c2; box-shadow: 0 0 0 2px rgba(0, 113, 194, 0.1); }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; }
        .phone-group { display: flex; gap: 10px; }
        .country-code { width: 120px; }
        .phone-number { flex: 1; }
        
        .checkbox-group { display: flex; align-items: flex-start; gap: 10px; margin-bottom: 20px; }
        .checkbox-group input[type="checkbox"] { margin-top: 3px; }
        .checkbox-label { font-size: 14px; color: #333; line-height: 1.4; }
        .checkbox-note { color: #666; font-size: 12px; margin-top: 5px; }
        
        .radio-group { margin-bottom: 20px; }
        .radio-option { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; }
        .radio-option input[type="radio"] { margin: 0; }
        .radio-label { font-size: 14px; color: #333; }
        
        .tips-section { background: #f8f9fa; border-radius: 8px; padding: 20px; margin: 25px 0; }
        .tips-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .tip-item { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; color: #388e3c; font-size: 14px; }
        .tip-icon { color: #388e3c; }
        
        .room-info-section { background: #f8f9fa; border-radius: 8px; padding: 20px; margin: 25px 0; }
        .room-info-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .room-feature { display: flex; align-items: center; gap: 10px; margin-bottom: 10px; color: #388e3c; font-size: 14px; }
        .room-feature i { color: #388e3c; }
        .room-details-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 15px; margin: 15px 0; }
        .room-detail-item { display: flex; align-items: center; gap: 8px; color: #666; font-size: 13px; }
        .room-detail-icon { color: #0071c2; }
        
        .additional-services { margin: 25px 0; }
        .service-item { display: flex; align-items: flex-start; gap: 10px; margin-bottom: 15px; padding: 15px; background: #f8f9fa; border-radius: 8px; }
        .service-icon { color: #0071c2; margin-top: 2px; }
        .service-content { flex: 1; }
        .service-title { font-size: 14px; font-weight: 500; color: #333; margin-bottom: 5px; }
        .service-description { color: #666; font-size: 12px; line-height: 1.4; }
        
        .special-requests { margin: 25px 0; }
        .requests-title { font-size: 16px; font-weight: 600; margin-bottom: 10px; color: #333; }
        .requests-text { color: #666; font-size: 13px; margin-bottom: 15px; line-height: 1.5; }
        .requests-textarea { width: 100%; min-height: 80px; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; resize: vertical; }
        
        .arrival-time { margin: 25px 0; }
        .arrival-title { font-size: 16px; font-weight: 600; margin-bottom: 15px; color: #333; }
        .arrival-info { background: #f8f9fa; border-radius: 8px; padding: 20px; margin-bottom: 20px; }
        .arrival-item { display: flex; align-items: center; gap: 10px; margin-bottom: 15px; color: #388e3c; font-size: 14px; }
        .arrival-icon { color: #388e3c; }
        .arrival-dropdown { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 14px; background: white; }
        .arrival-note { color: #666; font-size: 12px; margin-top: 10px; }
        
        .general-rules { margin: 25px 0; }
        .rules-title { font-size: 16px; font-weight: 600; margin-bottom: 10px; color: #333; }
        .rules-text { color: #666; font-size: 13px; margin-bottom: 15px; line-height: 1.5; }
        .rules-list { list-style: none; margin-bottom: 15px; }
        .rules-list li { color: #666; font-size: 13px; margin-bottom: 8px; padding-left: 20px; position: relative; }
        .rules-list li:before { content: "•"; color: #0071c2; position: absolute; left: 0; }
        .rules-agreement { color: #666; font-size: 13px; line-height: 1.5; }
        
        .action-section { position: sticky; bottom: 0; background: white; border-top: 1px solid #eee; padding: 20px 0; margin-top: 40px; }
        .action-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; display: flex; justify-content: space-between; align-items: center; }
        .price-match { display: flex; align-items: center; gap: 10px; color: #0071c2; text-decoration: none; font-size: 14px; }
        .price-match:hover { text-decoration: underline; }
        .next-button { background: #0071c2; color: white; border: none; padding: 15px 30px; border-radius: 6px; font-size: 16px; font-weight: 600; cursor: pointer; transition: background 0.3s ease; }
        .next-button:hover { background: #005a9e; }
        .booking-conditions { color: #0071c2; text-decoration: none; font-size: 14px; }
        .booking-conditions:hover { text-decoration: underline; }
        
        .footer { background: white; border-top: 1px solid #eee; padding: 30px 0; margin-top: 40px; }
        .footer-container { max-width: 1200px; margin: 0 auto; padding: 0 20px; }
        .footer-links { display: flex; justify-content: center; gap: 30px; margin-bottom: 20px; }
        .footer-link { color: #666; text-decoration: none; font-size: 14px; }
        .footer-link:hover { color: #0071c2; }
        .footer-copyright { text-align: center; color: #999; font-size: 12px; }
        
        @media (max-width: 768px) {
            .main-container { grid-template-columns: 1fr; gap: 20px; }
            .progress-steps { gap: 20px; }
            .form-row { grid-template-columns: 1fr; }
            .action-container { flex-direction: column; gap: 15px; text-align: center; }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="header-top">
                <a href="<%= request.getContextPath() %>/" class="logo">
                    <i class="fas fa-home"></i> HomestayPro
                </a>
                <div class="header-actions">
                    <a href="<%= request.getContextPath() %>/login" class="btn-login">Đăng nhập</a>
                    <a href="<%= request.getContextPath() %>/register" class="btn-register">Đăng ký</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Progress Bar -->
    <div class="progress-bar">
        <div class="progress-container">
            <div class="progress-steps">
                <div class="progress-step">
                    <div class="step-number">1</div>
                    <span>Bạn chọn</span>
                </div>
                <div class="progress-step active">
                    <div class="step-number">2</div>
                    <span>Chi tiết về bạn</span>
                </div>
                <div class="progress-step">
                    <div class="step-number">3</div>
                    <span>Hoàn tất đặt phòng</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Left Column - Homestay Info -->
        <div class="homestay-info">
            <div class="homestay-image">
                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" 
                     alt="<%= homestay.getName() %>">
            </div>

            <h2 class="homestay-name"><%= homestay.getName() %></h2>
            <div class="homestay-address">
                <i class="fas fa-map-marker-alt"></i>
                <%= homestay.getAddress() %>
            </div>
            <div class="homestay-rating">
                <div class="stars">★★★★☆</div>
                <div class="rating-text">Vị trí xuất sắc - 9.4</div>
            </div>
            <div class="homestay-rating">
                <div class="rating-text">9.5 Xuất sắc - 4 đánh giá</div>
            </div>

            <div class="homestay-amenities">
                <div class="amenity">
                    <i class="fas fa-wifi"></i>
                    <span>WiFi miễn phí</span>
                </div>
                <div class="amenity">
                    <i class="fas fa-parking"></i>
                    <span>Chỗ đỗ xe</span>
                </div>
                <div class="amenity">
                    <i class="fas fa-swimming-pool"></i>
                    <span>Hồ bơi</span>
                </div>
            </div>

            <div class="booking-details">
                <h3 class="booking-title">Chi tiết đặt phòng của bạn</h3>
                <div class="booking-item">
                    <span class="booking-label">Nhận phòng</span>
                    <span class="booking-value">T7, 30 tháng 8 2025</span>
                </div>
                <div class="booking-item">
                    <span class="booking-label"></span>
                    <span class="booking-value">14:00-23:30</span>
                </div>
                <div class="booking-item">
                    <span class="booking-label">Trả phòng</span>
                    <span class="booking-value">T2, 1 tháng 9 2025</span>
                </div>
                <div class="booking-item">
                    <span class="booking-label"></span>
                    <span class="booking-value">00:00-00:00</span>
                </div>
                <div class="booking-item">
                    <span class="booking-label">Bạn đã chọn</span>
                    <span class="booking-value">2 đêm, 1 phòng cho 2 người lớn</span>
                </div>
                <div class="booking-item">
                    <span class="booking-label"></span>
                    <span class="booking-value">1 x <%= room.getType() %></span>
                </div>
                <div class="booking-item">
                    <span class="booking-label"></span>
                    <a href="#" class="change-link">Đổi lựa chọn của bạn</a>
                </div>
            </div>

            <div class="price-summary">
                <h3 class="price-title">Tóm tắt giá</h3>
                <div class="price-item">
                    <span class="price-label">Giá gốc</span>
                    <span class="price-value">VND 7.980.000</span>
                </div>
                <div class="discount-offer">
                    <div class="discount-title">Ưu Đãi Trong Thời Gian Có Hạn</div>
                    <div class="discount-description">- VND 4.708.200</div>
                </div>
                <div class="price-item total-price">
                    <span class="price-label">Tổng cộng</span>
                    <span class="price-value">
                        <div class="total-original">VND 7.900.000</div>
                        <div class="total-final">VND 3.271.800</div>
                    </span>
                </div>
                <div class="tax-info">
                    Đã bao gồm thuế và phí<br>
                    <a href="#" class="tax-details">Ấn chi tiết</a> - Bao gồm VND 242.356 phí và thuế<br>
                    8% Thuế GTGT
                </div>
            </div>

            <div class="payment-info">
                <h3 class="payment-title">Lịch thanh toán của bạn</h3>
                <div class="payment-text">Không cần thanh toán hôm nay. Bạn sẽ trả khi đến nghỉ.</div>
                <div class="cancellation-info">
                    <div class="cancellation-title">Chi phí hủy là bao nhiêu?</div>
                    <div class="cancellation-text">Nếu hủy, bạn sẽ phải thanh toán VND 1.635.900</div>
                </div>
            </div>
        </div>

        <!-- Right Column - User Form -->
        <div class="user-form">
            <div class="form-header">
                <h1 class="form-title">Nhập thông tin chi tiết của bạn</h1>
                <div class="form-subtitle">Gần xong rồi! Chỉ cần điền phần thông tin * bắt buộc</div>
                <div class="form-instruction">
                    <div class="instruction-text">Vui lòng nhập thông tin của bạn bằng ký tự Latin để chỗ nghỉ có thể hiểu được</div>
                </div>
            </div>

            <form id="bookingForm">
                <div class="form-row">
                    <div class="form-group">
                        <label class="form-label">Họ (tiếng Anh) <span class="required">*</span></label>
                        <input type="text" class="form-input" placeholder="Nguyễn" required>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tên (tiếng Anh) <span class="required">*</span></label>
                        <input type="text" class="form-input" placeholder="Tuấn" required>
                    </div>
                </div>

                <div class="form-group">
                    <label class="form-label">Địa chỉ email <span class="required">*</span></label>
                    <input type="email" class="form-input" placeholder="example@email.com" required>
                    <div class="checkbox-note">Email xác nhận đặt phòng sẽ được gửi đến địa chỉ này</div>
                </div>

                <div class="form-group">
                    <label class="form-label">Vùng/quốc gia <span class="required">*</span></label>
                    <select class="form-input" required>
                        <option value="VN" selected>Việt Nam</option>
                        <option value="US">Hoa Kỳ</option>
                        <option value="SG">Singapore</option>
                    </select>
                </div>

                <div class="form-group">
                    <label class="form-label">Số điện thoại <span class="required">*</span></label>
                    <div class="phone-group">
                        <select class="form-input country-code">
                            <option value="VN" selected>VN +84</option>
                            <option value="US">US +1</option>
                        </select>
                        <input type="tel" class="form-input phone-number" placeholder="Số điện thoại" required>
                    </div>
                    <div class="checkbox-note">Để xác minh đơn hàng và liên hệ từ chỗ nghỉ</div>
                </div>

                <div class="checkbox-group">
                    <input type="checkbox" id="electronic-confirmation">
                    <div>
                        <label for="electronic-confirmation" class="checkbox-label">Có, tôi muốn xác nhận điện tử miễn phí (được đề xuất)</label>
                        <div class="checkbox-note">Để gửi link tải app</div>
                    </div>
                </div>

                <div class="radio-group">
                    <div class="form-label">Bạn đặt phòng cho ai?</div>
                    <div class="radio-option">
                        <input type="radio" id="main-guest" name="booking-for" value="main-guest" checked>
                        <label for="main-guest" class="radio-label">Tôi là khách lưu trú chính</label>
                    </div>
                    <div class="radio-option">
                        <input type="radio" id="other-guest" name="booking-for" value="other-guest">
                        <label for="other-guest" class="radio-label">Đặt phòng này là cho người khác</label>
                    </div>
                </div>

                <div class="radio-group">
                    <div class="form-label">Bạn sắp đi công tác?</div>
                    <div class="radio-option">
                        <input type="radio" id="business-yes" name="business-trip" value="yes" checked>
                        <label for="business-yes" class="radio-label">Đúng</label>
                    </div>
                    <div class="radio-option">
                        <input type="radio" id="business-no" name="business-trip" value="no">
                        <label for="business-no" class="radio-label">Sai</label>
                    </div>
                </div>

                <div class="tips-section">
                    <h3 class="tips-title">Mách nhỏ</h3>
                    <div class="tip-item">
                        <i class="fas fa-check-circle tip-icon"></i>
                        <span>Không cần thẻ tín dụng</span>
                    </div>
                    <div class="tip-item">
                        <i class="fas fa-check-circle tip-icon"></i>
                        <span>Không cần trả tiền ngay. Bạn sẽ thanh toán tại chỗ nghỉ.</span>
                    </div>
                </div>

                <div class="room-info-section">
                    <h3 class="room-info-title"><%= room.getType() %></h3>
                    <div class="room-feature">
                        <i class="fas fa-check-circle"></i>
                        <span>Bao gồm đi bộ khám phá safari + chỗ đậu xe + nhận phòng sớm + internet tốc độ cao</span>
                    </div>
                    <div class="room-details-grid">
                        <div class="room-detail-item">
                            <i class="fas fa-exclamation-triangle room-detail-icon"></i>
                            <span>Phí hủy: Tiền phòng đêm đầu</span>
                        </div>
                        <div class="room-detail-item">
                            <i class="fas fa-users room-detail-icon"></i>
                            <span>Khách: 2 người lớn</span>
                        </div>
                        <div class="room-detail-item">
                            <i class="fas fa-smoking-ban room-detail-icon"></i>
                            <span>Không hút thuốc</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Tên đầy đủ của khách <span class="required">*</span></label>
                        <input type="text" class="form-input" placeholder="Họ, tên (không dấu)" required>
                    </div>
                </div>

                <div class="additional-services">
                    <h3 class="form-label">Thêm vào kỳ nghỉ</h3>
                    <div class="service-item">
                        <input type="checkbox" id="flight-tickets">
                        <i class="fas fa-plane service-icon"></i>
                        <div class="service-content">
                            <div class="service-title">Tôi cần vé máy bay cho chuyến đi</div>
                            <div class="service-description">Chuyến bay khứ hồi từ TP. Hồ Chí Minh đến Quy Nhơn</div>
                        </div>
                    </div>
                    <div class="service-item">
                        <input type="checkbox" id="car-rental">
                        <i class="fas fa-car service-icon"></i>
                        <div class="service-content">
                            <div class="service-title">Tôi muốn thuê một chiếc xe</div>
                            <div class="service-description">Thuê xe tại Quy Nhơn</div>
                        </div>
                    </div>
                </div>

                <div class="special-requests">
                    <h3 class="requests-title">Các Yêu Cầu Đặc Biệt</h3>
                    <div class="requests-text">
                        Các yêu cầu đặc biệt không đảm bảo sẽ được đáp ứng – tuy nhiên, chỗ nghỉ sẽ cố gắng hết sức để thực hiện. Bạn luôn có thể gửi yêu cầu đặc biệt sau khi hoàn tất đặt phòng của mình!
                    </div>
                    <textarea class="requests-textarea" placeholder="Vui lòng ghi yêu cầu của bạn tại đây. (không bắt buộc)"></textarea>
                </div>

                <div class="arrival-time">
                    <h3 class="arrival-title">Thời gian đến của bạn</h3>
                    <div class="arrival-info">
                        <div class="arrival-item">
                            <i class="fas fa-check-circle"></i>
                            <span>Nhận phòng sớm từ 13:00.</span>
                        </div>
                        <div class="arrival-item">
                            <i class="fas fa-user-tie"></i>
                            <span>Lễ tân 24 giờ - Luôn có trợ giúp mỗi khi bạn cần!</span>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Thêm thời gian đến dự kiến của bạn (không bắt buộc)</label>
                        <select class="arrival-dropdown">
                            <option value="">Vui lòng chọn</option>
                            <option value="morning">Sáng (06:00 - 12:00)</option>
                            <option value="afternoon">Chiều (12:00 - 18:00)</option>
                            <option value="evening">Tối (18:00 - 24:00)</option>
                            <option value="night">Đêm (00:00 - 06:00)</option>
                        </select>
                        <div class="arrival-note">Thời gian theo múi giờ của Quy Nhơn</div>
                    </div>
                </div>

                <div class="general-rules">
                    <h3 class="rules-title">Xem lại quy tắc chung</h3>
                    <div class="rules-text">
                        Chủ chỗ nghỉ muốn bạn đồng ý với các quy tắc chung này:
                    </div>
                    <ul class="rules-list">
                        <li>Không tiệc tùng/sự kiện</li>
                        <li>Không cho phép thú cưng</li>
                    </ul>
                    <div class="rules-agreement">
                        Khi tiếp tục các bước tiếp theo, bạn đồng ý với các quy tắc chung này.
                    </div>
                </div>
            </form>
        </div>
    </div>

    <!-- Action Section -->
    <div class="action-section">
        <div class="action-container">
            <a href="#" class="price-match">
                <i class="fas fa-percentage"></i>
                Chúng Tôi Luôn Khớp Giá!
            </a>
            <button type="submit" form="bookingForm" class="next-button">
                Thông tin cuối cùng >
            </button>
            <a href="#" class="booking-conditions">
                Các điều kiện đặt phòng là gì?
            </a>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-links">
                <a href="#" class="footer-link">Về HomestayPro</a>
                <a href="#" class="footer-link">Dịch vụ khách hàng</a>
                <a href="#" class="footer-link">Điều khoản và điều kiện</a>
                <a href="#" class="footer-link">Chính sách về Bảo mật & Cookie</a>
            </div>
            <div class="footer-copyright">
                Bản quyền © 1996-2025 HomestayPro. Bảo lưu mọi quyền.
            </div>
        </div>
    </footer>

    <script>
        document.getElementById('bookingForm').addEventListener('submit', function(e) {
            e.preventDefault();
            
            const requiredFields = this.querySelectorAll('[required]');
            let isValid = true;
            
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#e31e24';
                } else {
                    field.style.borderColor = '#ddd';
                }
            });
            
            if (isValid) {
                window.location.href = '<%= request.getContextPath() %>/booking/final';
            } else {
                alert('Vui lòng điền đầy đủ thông tin bắt buộc!');
            }
        });

        document.querySelector('.phone-number').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 10) {
                value = value.substring(0, 10);
            }
            e.target.value = value;
        });
    </script>
</body>
</html>
