<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Hoàn tất đặt phòng - Homestay Management</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            line-height: 1.6;
            color: #333;
            background-color: #f8f9fa;
        }

        .container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        /* Header */
        .header {
            background: white;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 100;
        }

        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #0071c2;
        }

        .header-actions {
            display: flex;
            gap: 20px;
            align-items: center;
        }

        .login-btn, .register-btn {
            padding: 8px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            font-size: 14px;
            transition: all 0.3s ease;
        }

        .login-btn {
            background: transparent;
            color: #0071c2;
            border: 1px solid #0071c2;
        }

        .register-btn {
            background: #0071c2;
            color: white;
        }

        .login-btn:hover {
            background: #0071c2;
            color: white;
        }

        .register-btn:hover {
            background: #005a9e;
        }

        /* Progress Bar */
        .progress-container {
            background: white;
            padding: 30px 0;
            margin-bottom: 30px;
        }

        .progress-steps {
            display: flex;
            justify-content: center;
            align-items: center;
            max-width: 600px;
            margin: 0 auto;
        }

        .step {
            display: flex;
            align-items: center;
            flex: 1;
        }

        .step-number {
            width: 40px;
            height: 40px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            margin-right: 15px;
        }

        .step.completed .step-number {
            background: #28a745;
            color: white;
        }

        .step.active .step-number {
            background: #0071c2;
            color: white;
        }

        .step.pending .step-number {
            background: #e9ecef;
            color: #6c757d;
        }

        .step-text {
            font-size: 14px;
            color: #6c757d;
        }

        .step.active .step-text {
            color: #0071c2;
            font-weight: 600;
        }

        .step.completed .step-text {
            color: #28a745;
        }

        .step-connector {
            flex: 1;
            height: 2px;
            background: #e9ecef;
            margin: 0 15px;
        }

        .step.completed .step-connector {
            background: #28a745;
        }

        /* Main Content */
        .main-content {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 40px;
            margin-bottom: 40px;
        }

        .left-column, .right-column {
            background: white;
            border-radius: 10px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .section-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
            border-bottom: 2px solid #0071c2;
            padding-bottom: 10px;
        }

        /* Booking Summary */
        .homestay-info {
            display: flex;
            align-items: center;
            margin-bottom: 20px;
            padding: 20px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .homestay-image {
            width: 80px;
            height: 80px;
            border-radius: 8px;
            object-fit: cover;
            margin-right: 20px;
        }

        .homestay-details h3 {
            color: #0071c2;
            margin-bottom: 5px;
        }

        .homestay-details p {
            color: #6c757d;
            font-size: 14px;
        }

        .booking-details {
            margin-bottom: 20px;
        }

        .detail-row {
            display: flex;
            justify-content: space-between;
            padding: 10px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .detail-row:last-child {
            border-bottom: none;
        }

        .detail-label {
            color: #6c757d;
        }

        .detail-value {
            font-weight: 600;
            color: #333;
        }

        .price-summary {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .price-row {
            display: flex;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .price-row.total {
            border-top: 2px solid #0071c2;
            padding-top: 15px;
            margin-top: 15px;
            font-size: 18px;
            font-weight: bold;
            color: #0071c2;
        }

        .discount {
            color: #28a745;
        }

        /* Payment Methods */
        .payment-methods {
            margin-bottom: 20px;
        }

        .payment-option {
            display: flex;
            align-items: center;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            margin-bottom: 10px;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .payment-option:hover {
            border-color: #0071c2;
        }

        .payment-option.selected {
            border-color: #0071c2;
            background: #f0f8ff;
        }

        .payment-option input[type="radio"] {
            margin-right: 15px;
            transform: scale(1.2);
        }

        .payment-icon {
            width: 40px;
            height: 25px;
            margin-right: 15px;
            display: flex;
            align-items: center;
            justify-content: center;
            background: #f8f9fa;
            border-radius: 4px;
            font-size: 12px;
            color: #6c757d;
        }

        .payment-info h4 {
            margin-bottom: 5px;
            color: #333;
        }

        .payment-info p {
            color: #6c757d;
            font-size: 14px;
        }

        /* User Details */
        .user-details {
            margin-bottom: 20px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
        }

        .form-group input, .form-group select {
            width: 100%;
            padding: 12px;
            border: 2px solid #e9ecef;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #0071c2;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        /* Terms and Conditions */
        .terms-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 20px;
        }

        .terms-checkbox {
            display: flex;
            align-items: flex-start;
            margin-bottom: 15px;
        }

        .terms-checkbox input[type="checkbox"] {
            margin-right: 15px;
            margin-top: 3px;
            transform: scale(1.2);
        }

        .terms-text {
            font-size: 14px;
            color: #6c757d;
            line-height: 1.5;
        }

        .terms-text a {
            color: #0071c2;
            text-decoration: none;
        }

        .terms-text a:hover {
            text-decoration: underline;
        }

        /* Action Section */
        .action-section {
            background: white;
            padding: 20px 0;
            border-top: 1px solid #e9ecef;
            position: sticky;
            bottom: 0;
            z-index: 100;
        }

        .action-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .price-match {
            color: #28a745;
            font-weight: 600;
            font-size: 16px;
        }

        .confirm-btn {
            background: #28a745;
            color: white;
            border: none;
            padding: 15px 40px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .confirm-btn:hover {
            background: #218838;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }

        .confirm-btn:disabled {
            background: #6c757d;
            cursor: not-allowed;
            transform: none;
            box-shadow: none;
        }

        /* Footer */
        .footer {
            background: #333;
            color: white;
            padding: 40px 0;
            margin-top: 60px;
        }

        .footer-content {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
        }

        .footer-section h3 {
            margin-bottom: 20px;
            color: #0071c2;
        }

        .footer-section ul {
            list-style: none;
        }

        .footer-section ul li {
            margin-bottom: 10px;
        }

        .footer-section ul li a {
            color: #ccc;
            text-decoration: none;
            transition: color 0.3s ease;
        }

        .footer-section ul li a:hover {
            color: #0071c2;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #555;
            color: #ccc;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
                gap: 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .action-content {
                flex-direction: column;
                gap: 20px;
                text-align: center;
            }

            .progress-steps {
                flex-direction: column;
                gap: 20px;
            }

            .step-connector {
                display: none;
            }
        }

        /* Success Animation */
        .success-animation {
            text-align: center;
            padding: 40px 20px;
        }

        .success-icon {
            font-size: 80px;
            color: #28a745;
            margin-bottom: 20px;
            animation: bounce 1s ease-in-out;
        }

        @keyframes bounce {
            0%, 20%, 50%, 80%, 100% {
                transform: translateY(0);
            }
            40% {
                transform: translateY(-20px);
            }
            60% {
                transform: translateY(-10px);
            }
        }

        .success-title {
            font-size: 28px;
            color: #28a745;
            margin-bottom: 15px;
        }

        .success-message {
            color: #6c757d;
            margin-bottom: 30px;
            line-height: 1.6;
        }

        .booking-number {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 8px;
            margin-bottom: 30px;
            border-left: 4px solid #0071c2;
        }

        .booking-number h4 {
            color: #0071c2;
            margin-bottom: 10px;
        }

        .booking-number .number {
            font-size: 24px;
            font-weight: bold;
            color: #333;
            font-family: monospace;
        }

        /* QR Code Styles */
        .qr-section {
            text-align: center;
            margin-bottom: 30px;
            display: none;
        }

        .qr-section h4 {
            color: #0071c2;
            margin-bottom: 15px;
        }

        .qr-container {
            display: inline-block;
            padding: 20px;
            background: white;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            border: 2px solid #e9ecef;
        }

        #qrcode {
            margin-bottom: 15px;
        }

        #qrcode img {
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .qr-note {
            color: #6c757d;
            font-size: 14px;
            margin: 0;
            font-style: italic;
        }

        .bank-info {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-top: 15px;
            text-align: left;
            max-width: 300px;
            margin-left: auto;
            margin-right: auto;
        }

        .bank-info h5 {
            color: #0071c2;
            margin-bottom: 10px;
            font-size: 16px;
        }

        .bank-info p {
            margin: 5px 0;
            font-size: 14px;
            color: #333;
        }

        .bank-info .account-number {
            font-family: monospace;
            font-size: 16px;
            font-weight: bold;
            color: #28a745;
            background: white;
            padding: 8px;
            border-radius: 4px;
            border: 1px solid #ddd;
        }
    </style>
    <script src="https://cdn.jsdelivr.net/npm/qrcode@1.5.3/build/qrcode.min.js"></script>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo">
                    <i class="fas fa-home"></i> Homestay Management
                </div>
                <div class="header-actions">
                    <button class="login-btn">Đăng nhập</button>
                    <button class="register-btn">Đăng ký</button>
                </div>
            </div>
        </div>
    </header>

    <!-- Progress Bar -->
    <div class="progress-container">
        <div class="container">
            <div class="progress-steps">
                <div class="step completed">
                    <div class="step-number">1</div>
                    <div class="step-text">Bạn chọn</div>
                </div>
                <div class="step-connector"></div>
                <div class="step completed">
                    <div class="step-number">2</div>
                    <div class="step-text">Chi tiết về bạn</div>
                </div>
                <div class="step-connector"></div>
                <div class="step active">
                    <div class="step-number">3</div>
                    <div class="step-text">Hoàn tất đặt phòng</div>
                </div>
            </div>
        </div>
    </div>

    <!-- Main Content -->
    <div class="container">
        <div class="main-content">
            <!-- Left Column - Booking Summary -->
            <div class="left-column">
                <h2 class="section-title">Tóm tắt đặt phòng</h2>
                
                <!-- Homestay Info -->
                <div class="homestay-info">
                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?w=400&h=300&fit=crop" 
                         alt="Homestay" class="homestay-image">
                    <div class="homestay-details">
                        <h3>Villa Ocean View Đà Nẵng</h3>
                        <p><i class="fas fa-map-marker-alt"></i> 123 Đường Biển, Sơn Trà, Đà Nẵng</p>
                        <p><i class="fas fa-star"></i> 4.8 (128 đánh giá)</p>
                    </div>
                </div>

                <!-- Booking Details -->
                <div class="booking-details">
                    <h3 class="section-title">Chi tiết đặt phòng</h3>
                    <div class="detail-row">
                        <span class="detail-label">Ngày nhận phòng:</span>
                        <span class="detail-value">15/09/2025</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Ngày trả phòng:</span>
                        <span class="detail-value">18/09/2025</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Số đêm:</span>
                        <span class="detail-value">3 đêm</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Số khách:</span>
                        <span class="detail-value">2 người lớn</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Loại phòng:</span>
                        <span class="detail-value">Phòng Deluxe Ocean View</span>
                    </div>
                </div>

                <!-- Price Summary -->
                <div class="price-summary">
                    <h3 class="section-title">Tổng tiền</h3>
                    <div class="price-row">
                        <span>Giá gốc (3 đêm):</span>
                        <span>3,600,000 VNĐ</span>
                    </div>
                    <div class="price-row">
                        <span>Giảm giá:</span>
                        <span class="discount">-360,000 VNĐ</span>
                    </div>
                    <div class="price-row">
                        <span>Phí dịch vụ:</span>
                        <span>0 VNĐ</span>
                    </div>
                    <div class="price-row total">
                        <span>Tổng cộng:</span>
                        <span>3,240,000 VNĐ</span>
                    </div>
                </div>

                <!-- Payment Methods -->
                <div class="payment-methods">
                    <h3 class="section-title">Phương thức thanh toán</h3>
                    <div class="payment-option selected">
                        <input type="radio" name="payment" id="credit-card" checked>
                        <div class="payment-icon">
                            <i class="fas fa-credit-card"></i>
                        </div>
                        <div class="payment-info">
                            <h4>Thẻ tín dụng/ghi nợ</h4>
                            <p>Visa, Mastercard, JCB, American Express</p>
                        </div>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="payment" id="bank-transfer">
                        <div class="payment-icon">
                            <i class="fas fa-university"></i>
                        </div>
                        <div class="payment-info">
                            <h4>Chuyển khoản ngân hàng</h4>
                            <p>Chuyển khoản trực tiếp vào tài khoản</p>
                        </div>
                    </div>
                    <div class="payment-option">
                        <input type="radio" name="payment" id="cash">
                        <div class="payment-icon">
                            <i class="fas fa-money-bill-wave"></i>
                        </div>
                        <div class="payment-info">
                            <h4>Tiền mặt</h4>
                            <p>Thanh toán khi nhận phòng</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Right Column - User Details & Confirmation -->
            <div class="right-column">
                <h2 class="section-title">Thông tin thanh toán</h2>
                
                <!-- User Details -->
                <div class="user-details">
                    <div class="form-group">
                        <label for="card-name">Tên chủ thẻ</label>
                        <input type="text" id="card-name" name="card-name" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="card-number">Số thẻ</label>
                        <input type="text" id="card-number" name="card-number" maxlength="19" required>
                    </div>
                    
                    <div class="form-row">
                        <div class="form-group">
                            <label for="expiry">Ngày hết hạn</label>
                            <input type="text" id="expiry" name="expiry" placeholder="MM/YY" maxlength="5" required>
                        </div>
                        <div class="form-group">
                            <label for="cvv">Mã CVV</label>
                            <input type="text" id="cvv" name="cvv" maxlength="4" required>
                        </div>
                    </div>
                    
                    <div class="form-group">
                        <label for="email">Email xác nhận</label>
                        <input type="email" id="email" name="email" required>
                    </div>
                    
                    <div class="form-group">
                        <label for="phone">Số điện thoại</label>
                        <input type="tel" id="phone" name="phone" required>
                    </div>
                </div>

                <!-- Terms and Conditions -->
                <div class="terms-section">
                    <h3 class="section-title">Điều khoản và điều kiện</h3>
                    <div class="terms-checkbox">
                        <input type="checkbox" id="terms" required>
                        <div class="terms-text">
                            Tôi đồng ý với <a href="#">Điều khoản sử dụng</a> và <a href="#">Chính sách bảo mật</a> của Homestay Management
                        </div>
                    </div>
                    <div class="terms-checkbox">
                        <input type="checkbox" id="cancellation" required>
                        <div class="terms-text">
                            Tôi đã đọc và hiểu <a href="#">Chính sách hủy phòng</a> và <a href="#">Điều kiện đặt phòng</a>
                        </div>
                    </div>
                    <div class="terms-checkbox">
                        <input type="checkbox" id="newsletter">
                        <div class="terms-text">
                            Tôi muốn nhận thông tin về ưu đãi và khuyến mãi qua email
                        </div>
                    </div>
                </div>

                <!-- Important Notes -->
                <div class="terms-section">
                    <h3 class="section-title">Lưu ý quan trọng</h3>
                    <ul style="color: #6c757d; font-size: 14px; line-height: 1.6;">
                        <li>• Đặt phòng sẽ được xác nhận ngay sau khi thanh toán thành công</li>
                        <li>• Bạn sẽ nhận được email xác nhận với mã đặt phòng</li>
                        <li>• Có thể hủy phòng miễn phí trong vòng 24 giờ</li>
                        <li>• Vui lòng đến đúng giờ nhận phòng đã đặt</li>
                    </ul>
                </div>

                <!-- QR Code Section (Hidden by default) -->
                <div class="qr-section" id="qrSection">
                    <h3 class="section-title">Thông tin chuyển khoản</h3>
                    <div class="qr-container">
                        <div id="qrcode"></div>
                        <div class="bank-info">
                            <h5><i class="fas fa-university"></i> Thông tin tài khoản</h5>
                            <p><strong>Ngân hàng:</strong> <span id="bank-name">Vietcombank</span></p>
                            <p><strong>Chủ tài khoản:</strong> <span id="account-holder">Nguyễn Văn A</span></p>
                            <p><strong>Số tài khoản:</strong></p>
                            <div class="account-number" id="account-number">1234567890</div>
                            <p><strong>Số tiền:</strong> <span id="payment-amount">3,240,000 VNĐ</span></p>
                            <p><strong>Nội dung:</strong> <span id="payment-content">HM-2025-001234</span></p>
                        </div>
                        <p class="qr-note">Quét mã QR bằng ứng dụng ngân hàng để thanh toán</p>
                        
                        <!-- Test button for debugging -->
                        <button onclick="testQRCode()" style="
                            background: #0071c2; 
                            color: white; 
                            border: none; 
                            padding: 10px 20px; 
                            border-radius: 5px; 
                            margin-top: 15px;
                            cursor: pointer;
                        ">
                            Test QR Code
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Action Section -->
    <div class="action-section">
        <div class="container">
            <div class="action-content">
                <div class="price-match">
                    <i class="fas fa-shield-alt"></i> Chúng Tôi Luôn Khớp Giá!
                </div>
                <button class="confirm-btn" id="confirmBtn" disabled>
                    <i class="fas fa-lock"></i> Xác nhận đặt phòng
                </button>
            </div>
        </div>
    </div>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-content">
                <div class="footer-section">
                    <h3>Về chúng tôi</h3>
                    <ul>
                        <li><a href="#">Giới thiệu</a></li>
                        <li><a href="#">Đội ngũ</a></li>
                        <li><a href="#">Tin tức</a></li>
                        <li><a href="#">Tuyển dụng</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Hỗ trợ</h3>
                    <ul>
                        <li><a href="#">Trung tâm trợ giúp</a></li>
                        <li><a href="#">Liên hệ</a></li>
                        <li><a href="#">Phản hồi</a></li>
                        <li><a href="#">FAQ</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Pháp lý</h3>
                    <ul>
                        <li><a href="#">Điều khoản sử dụng</a></li>
                        <li><a href="#">Chính sách bảo mật</a></li>
                        <li><a href="#">Chính sách cookie</a></li>
                        <li><a href="#">Quyền riêng tư</a></li>
                    </ul>
                </div>
                <div class="footer-section">
                    <h3>Theo dõi</h3>
                    <ul>
                        <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                        <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                        <li><a href="#"><i class="fab fa-instagram"></i> Instagram</a></li>
                        <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2025 Homestay Management. Tất cả quyền được bảo lưu.</p>
            </div>
        </div>
    </footer>

    <script>
        // Payment method selection
        document.querySelectorAll('.payment-option').forEach(option => {
            option.addEventListener('click', function() {
                // Remove selected class from all options
                document.querySelectorAll('.payment-option').forEach(opt => {
                    opt.classList.remove('selected');
                });
                // Add selected class to clicked option
                this.classList.add('selected');
                // Check the radio button
                this.querySelector('input[type="radio"]').checked = true;
                
                // Show/hide QR code section based on payment method
                const qrSection = document.getElementById('qrSection');
                if (this.querySelector('input[type="radio"]').id === 'bank-transfer') {
                    console.log('Bank transfer selected, showing QR section');
                    qrSection.style.display = 'block';
                    // Add a small delay to ensure DOM is ready
                    setTimeout(() => {
                        generateQRCode();
                    }, 100);
                } else {
                    console.log('Other payment method selected, hiding QR section');
                    qrSection.style.display = 'none';
                }
            });
        });

        // Credit card number formatting
        document.getElementById('card-number').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\s/g, '');
            let formattedValue = value.replace(/(\d{4})/g, '$1 ').trim();
            e.target.value = formattedValue;
        });

        // Expiry date formatting
        document.getElementById('expiry').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length >= 2) {
                value = value.substring(0, 2) + '/' + value.substring(2, 4);
            }
            e.target.value = value;
        });

        // CVV formatting
        document.getElementById('cvv').addEventListener('input', function(e) {
            e.target.value = e.target.value.replace(/\D/g, '');
        });

        // Phone number formatting
        document.getElementById('phone').addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.length > 0) {
                if (value.startsWith('84')) {
                    value = '+' + value;
                } else if (value.startsWith('0')) {
                    value = '+84' + value.substring(1);
                } else {
                    value = '+84' + value;
                }
            }
            e.target.value = value;
        });

        // Form validation and button enable/disable
        function validateForm() {
            const requiredFields = document.querySelectorAll('[required]');
            const termsCheckboxes = document.querySelectorAll('#terms, #cancellation');
            const confirmBtn = document.getElementById('confirmBtn');
            
            let isValid = true;
            
            // Check required fields
            requiredFields.forEach(field => {
                if (!field.value.trim()) {
                    isValid = false;
                    field.style.borderColor = '#e31e24';
                } else {
                    field.style.borderColor = '#ddd';
                }
            });
            
            // Check required checkboxes
            termsCheckboxes.forEach(checkbox => {
                if (!checkbox.checked) {
                    isValid = false;
                }
            });
            
            confirmBtn.disabled = !isValid;
            return isValid;
        }

        // Add event listeners for form validation
        document.querySelectorAll('input, select').forEach(field => {
            field.addEventListener('input', validateForm);
            field.addEventListener('change', validateForm);
        });

        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', validateForm);
        });

        // Confirm booking button click
        document.getElementById('confirmBtn').addEventListener('click', function() {
            if (validateForm()) {
                // Show success message
                showSuccessMessage();
            }
        });

        // Show success message
        function showSuccessMessage() {
            const mainContent = document.querySelector('.main-content');
            const actionSection = document.querySelector('.action-section');
            
            mainContent.innerHTML = `
                <div class="success-animation" style="grid-column: 1 / -1;">
                    <div class="success-icon">
                        <i class="fas fa-check-circle"></i>
                    </div>
                    <h1 class="success-title">Đặt phòng thành công!</h1>
                    <p class="success-message">
                        Cảm ơn bạn đã chọn Homestay Management. Đặt phòng của bạn đã được xác nhận và 
                        chúng tôi đã gửi email xác nhận đến địa chỉ email của bạn.
                    </p>
                    
                    <div class="booking-number">
                        <h4>Mã đặt phòng:</h4>
                        <div class="number">HM-2025-001234</div>
                    </div>
                    
                    <div style="text-align: center;">
                        <p style="color: #6c757d; margin-bottom: 20px;">
                            <strong>Thông tin quan trọng:</strong><br>
                            • Vui lòng giữ mã đặt phòng này để tra cứu<br>
                            • Nhân viên sẽ liên hệ để xác nhận thời gian đến<br>
                            • Có thể xem chi tiết đặt phòng trong email xác nhận
                        </p>
                        
                        <button onclick="window.location.href='<%= request.getContextPath() %>/'" 
                                style="background: #0071c2; color: white; border: none; padding: 15px 30px; 
                                       border-radius: 8px; font-size: 16px; cursor: pointer; margin-right: 15px;">
                            <i class="fas fa-home"></i> Về trang chủ
                        </button>
                        
                        <button onclick="window.print()" 
                                style="background: #28a745; color: white; border: none; padding: 15px 30px; 
                                       border-radius: 8px; font-size: 16px; cursor: pointer;">
                            <i class="fas fa-print"></i> In xác nhận
                        </button>
                    </div>
                </div>
            `;
            
            // Update action section
            actionSection.style.display = 'none';
            
            // Scroll to top
            window.scrollTo(0, 0);
        }

        // Initialize form validation
        validateForm();

        // Test QR code generation on page load
        console.log('Page loaded, checking QRCode library...');
        console.log('QRCode available:', typeof QRCode !== 'undefined');
        
        // Test the QR code generation with a simple example
        if (typeof QRCode !== 'undefined') {
            console.log('QRCode library is loaded successfully');
        } else {
            console.log('QRCode library failed to load');
        }

        // Test function for QR code
        window.testQRCode = function() {
            console.log('Test QR Code button clicked');
            const qrContainer = document.getElementById('qrcode');
            if (qrContainer) {
                console.log('Testing QR code generation...');
                generateQRCode();
            } else {
                console.error('QR container not found for testing');
            }
        };

        // Generate QR Code function
        function generateQRCode() {
            const qrContainer = document.getElementById('qrcode');
            if (qrContainer) {
                // Clear previous QR code
                qrContainer.innerHTML = '';
                
                // Generate random bank information
                const banks = [
                    'Vietcombank', 'BIDV', 'Agribank', 'Techcombank', 
                    'MB Bank', 'ACB', 'VPBank', 'TPBank', 'Sacombank', 'HDBank'
                ];
                
                const randomNames = [
                    'Nguyễn Văn A', 'Trần Thị B', 'Lê Văn C', 'Phạm Thị D', 
                    'Hoàng Văn E', 'Vũ Thị F', 'Đặng Văn G', 'Bùi Thị H',
                    'Đỗ Văn I', 'Lý Thị K', 'Hồ Văn L', 'Ngô Thị M'
                ];
                
                const randomAccountNumbers = [
                    '1234567890', '9876543210', '1122334455', '5566778899',
                    '9988776655', '4433221100', '7788990011', '2233445566',
                    '6677889900', '3344556677', '8899001122', '4455667788'
                ];
                
                // Select random values
                const randomBank = banks[Math.floor(Math.random() * banks.length)];
                const randomName = randomNames[Math.floor(Math.random() * randomNames.length)];
                const randomAccount = randomAccountNumbers[Math.floor(Math.random() * randomAccountNumbers.length)];
                
                // Update displayed information
                document.getElementById('bank-name').textContent = randomBank;
                document.getElementById('account-holder').textContent = randomName;
                document.getElementById('account-number').textContent = randomAccount;
                
                // Create payment data for QR code
                const paymentData = {
                    bank: randomBank,
                    accountHolder: randomName,
                    accountNumber: randomAccount,
                    amount: '3,240,000 VNĐ',
                    content: 'HM-2025-001234',
                    bookingNumber: 'HM-2025-001234',
                    homestayName: 'Villa Ocean View Đà Nẵng',
                    checkIn: '15/09/2025',
                    checkOut: '18/09/2025',
                    guests: '2 người lớn',
                    roomType: 'Phòng Deluxe Ocean View',
                    totalPrice: '3,240,000 VNĐ',
                    timestamp: new Date().toISOString()
                };
                
                // Convert to JSON string
                const qrData = JSON.stringify(paymentData, null, 2);
                
                // Try to generate QR code with error handling
                try {
                    if (typeof QRCode !== 'undefined') {
                        // Generate QR code using QRCode library
                        QRCode.toCanvas(qrContainer, qrData, {
                            width: 200,
                            height: 200,
                            margin: 2,
                            color: {
                                dark: '#0071c2',
                                light: '#ffffff'
                            }
                        }, function (error) {
                            if (error) {
                                console.error('Error generating QR code:', error);
                                showFallbackQR(qrContainer, qrData);
                            }
                        });
                    } else {
                        console.log('QRCode library not loaded, using fallback');
                        showFallbackQR(qrContainer, qrData);
                    }
                } catch (error) {
                    console.error('Error in generateQRCode:', error);
                    showFallbackQR(qrContainer, qrData);
                }
            }
        }

        // Fallback QR code display
        function showFallbackQR(container, data) {
            container.innerHTML = `
                <div style="
                    width: 200px; 
                    height: 200px; 
                    background: linear-gradient(45deg, #0071c2, #28a745);
                    border-radius: 10px;
                    display: flex;
                    align-items: center;
                    justify-content: center;
                    color: white;
                    font-weight: bold;
                    text-align: center;
                    margin: 0 auto;
                    box-shadow: 0 4px 15px rgba(0,0,0,0.2);
                ">
                    <div>
                        <i class="fas fa-qrcode" style="font-size: 60px; margin-bottom: 10px; display: block;"></i>
                        <div style="font-size: 14px;">Mã QR</div>
                        <div style="font-size: 12px; margin-top: 5px;">Thanh toán</div>
                    </div>
                </div>
                <div style="
                    background: #f8f9fa; 
                    padding: 15px; 
                    border-radius: 8px; 
                    margin-top: 15px; 
                    text-align: left;
                    font-family: monospace;
                    font-size: 12px;
                    color: #333;
                    max-height: 150px;
                    overflow-y: auto;
                    border: 1px solid #ddd;
                ">
                    <strong>Dữ liệu QR:</strong><br>
                    <span id="qr-data-display"></span>
                </div>
            `;
            
            // Update the QR data display
            const qrDataDisplay = container.querySelector('#qr-data-display');
            if (qrDataDisplay) {
                qrDataDisplay.innerHTML = data.replace(/\n/g, '<br>');
            }
        }
    </script>
</body>
</html>
