<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Homestay, com.homestay.model.Room" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    Room room = (Room) request.getAttribute("room");
    
    // Kiểm tra dữ liệu từ CSDL
    if (homestay == null || room == null) {
        // Nếu không có dữ liệu, redirect về trang chủ
        response.sendRedirect(request.getContextPath() + "/");
        return;
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${homestay.name} - ${room.type} | HomestayPro</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
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
            background: #f8f9fa;
        }

        /* Header */
        .header {
            background: #003580;
            color: white;
            padding: 15px 0;
            position: sticky;
            top: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .header-top {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: white;
            text-decoration: none;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn-login, .btn-register {
            padding: 8px 16px;
            border-radius: 20px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .btn-login {
            border: 1px solid white;
            background: transparent;
            color: white;
        }

        .btn-register {
            background: white;
            color: #003580;
        }

        /* Breadcrumb */
        .breadcrumb {
            background: white;
            padding: 15px 0;
            border-bottom: 1px solid #eee;
        }

        .breadcrumb-container {
            max-width: 1200px;
            margin: 0 auto;
            padding: 0 20px;
        }

        .breadcrumb a {
            color: #0071c2;
            text-decoration: none;
        }

        .breadcrumb a:hover {
            text-decoration: underline;
        }

        /* Main Content */
        .main-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 30px;
        }

        /* Left Column - Room Details */
        .room-details {
            background: white;
            border-radius: 8px;
            padding: 30px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .room-header {
            margin-bottom: 30px;
            padding-bottom: 20px;
            border-bottom: 2px solid #f0f0f0;
        }

        .room-title {
            font-size: 28px;
            font-weight: 700;
            color: #333;
            margin-bottom: 10px;
        }

        .room-location {
            color: #666;
            font-size: 16px;
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 15px;
        }

        .room-rating {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .rating-score {
            background: #0071c2;
            color: white;
            padding: 8px 12px;
            border-radius: 6px;
            font-size: 18px;
            font-weight: 600;
        }

        .rating-text {
            font-size: 16px;
            color: #333;
            font-weight: 500;
        }

        .review-count {
            color: #666;
            font-size: 14px;
        }

        /* Image Gallery */
        .image-gallery {
            margin-bottom: 30px;
        }

        .main-image {
            width: 100%;
            height: 400px;
            border-radius: 12px;
            overflow: hidden;
            margin-bottom: 15px;
        }

        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .thumbnail-grid {
            display: grid;
            grid-template-columns: repeat(4, 1fr);
            gap: 10px;
        }

        .thumbnail {
            height: 80px;
            border-radius: 8px;
            overflow: hidden;
            cursor: pointer;
            transition: transform 0.3s ease;
        }

        .thumbnail:hover {
            transform: scale(1.05);
        }

        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        /* Room Features */
        .room-features {
            margin-bottom: 30px;
        }

        .features-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #333;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 15px;
        }

        .feature-item {
            display: flex;
            align-items: center;
            gap: 10px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
            transition: background 0.3s ease;
        }

        .feature-item:hover {
            background: #e9ecef;
        }

        .feature-icon {
            width: 24px;
            height: 24px;
            color: #0071c2;
        }

        .feature-text {
            font-size: 14px;
            color: #555;
        }

        /* Room Description */
        .room-description {
            margin-bottom: 30px;
        }

        .description-title {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .description-text {
            color: #666;
            line-height: 1.8;
            text-align: justify;
        }

        /* Right Column - Booking */
        .booking-sidebar {
            background: white;
            border-radius: 8px;
            padding: 25px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 140px;
        }

        .price-card {
            border: 2px solid #e9ecef;
            border-radius: 12px;
            padding: 25px;
            margin-bottom: 25px;
        }

        .price-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
        }

        .price-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
        }

        .discount-badge {
            background: #e31e24;
            color: white;
            padding: 6px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .price-details {
            margin-bottom: 20px;
        }

        .original-price {
            text-decoration: line-through;
            color: #999;
            font-size: 18px;
            margin-bottom: 8px;
        }

        .final-price {
            font-size: 32px;
            font-weight: 700;
            color: #e31e24;
            margin-bottom: 8px;
        }

        .price-unit {
            color: #666;
            font-size: 14px;
            margin-bottom: 15px;
        }

        .price-savings {
            color: #e31e24;
            font-size: 14px;
            font-weight: 500;
            margin-bottom: 20px;
            padding: 10px;
            background: #fff5f5;
            border-radius: 8px;
            text-align: center;
        }

        /* Booking Form */
        .booking-form {
            margin-bottom: 25px;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 500;
            color: #333;
            margin-bottom: 8px;
        }

        .form-input {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .form-input:focus {
            outline: none;
            border-color: #0071c2;
            box-shadow: 0 0 0 2px rgba(0, 113, 194, 0.1);
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }

        .book-btn {
            width: 100%;
            background: #0071c2;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .book-btn:hover {
            background: #005a9e;
        }

        /* Room Info */
        .room-info {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
        }

        .info-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .info-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 8px 0;
            border-bottom: 1px solid #e9ecef;
        }

        .info-item:last-child {
            border-bottom: none;
        }

        .info-label {
            color: #666;
            font-size: 14px;
        }

        .info-value {
            color: #333;
            font-weight: 500;
            font-size: 14px;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                grid-template-columns: 1fr;
            }

            .booking-sidebar {
                position: static;
                margin-top: 20px;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .thumbnail-grid {
                grid-template-columns: repeat(2, 1fr);
            }

            .form-row {
                grid-template-columns: 1fr;
            }
        }

        /* Loading Animation */
        .loading {
            text-align: center;
            padding: 40px;
            color: #666;
        }

        .spinner {
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0071c2;
            border-radius: 50%;
            width: 30px;
            height: 30px;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <div class="header-top">
                <a href="${pageContext.request.contextPath}/" class="logo">
                    <i class="fas fa-home"></i> HomestayPro
                </a>
                <div class="header-actions">
                    <a href="${pageContext.request.contextPath}/login" class="btn-login">Đăng nhập</a>
                    <a href="${pageContext.request.contextPath}/register" class="btn-register">Đăng ký</a>
                </div>
            </div>
        </div>
    </header>

    <!-- Breadcrumb -->
    <nav class="breadcrumb">
        <div class="breadcrumb-container">
            <a href="${pageContext.request.contextPath}/">Trang chủ</a> &gt;
            <a href="${pageContext.request.contextPath}/search">Tìm kiếm</a> &gt;
            <span>${homestay.name}</span> &gt;
            <span>${room.type}</span>
        </div>
    </nav>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Left Column - Room Details -->
        <main class="room-details">
            <!-- Room Header -->
            <div class="room-header">
                <h1 class="room-title">${room.type}</h1>
                <div class="room-location">
                    <i class="fas fa-map-marker-alt"></i>
                    ${homestay.address}
                </div>
                <div class="room-rating">
                    <div class="rating-score">9.2</div>
                    <div class="rating-text">Tuyệt hảo</div>
                    <div class="review-count">(156 đánh giá)</div>
                </div>
            </div>

            <!-- Image Gallery -->
            <div class="image-gallery">
                <div class="main-image">
                    <img src="${room.image != null ? room.image : 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80'}" 
                         alt="${room.type}" id="mainImage">
                </div>
                <div class="thumbnail-grid">
                    <div class="thumbnail" onclick="changeMainImage(this)">
                        <img src="${room.image != null ? room.image : 'https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80'}" alt="Ảnh 1">
                    </div>
                    <div class="thumbnail" onclick="changeMainImage(this)">
                        <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2068&q=80" alt="Ảnh 2">
                    </div>
                    <div class="thumbnail" onclick="changeMainImage(this)">
                        <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Ảnh 3">
                    </div>
                    <div class="thumbnail" onclick="changeMainImage(this)">
                        <img src="https://images.unsplash.com/photo-1521783988139-89397d761dce?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Ảnh 4">
                    </div>
                </div>
            </div>

            <!-- Room Features -->
            <div class="room-features">
                <h2 class="features-title">Tiện nghi phòng</h2>
                <div class="features-grid">
                    <div class="feature-item">
                        <i class="fas fa-wifi feature-icon"></i>
                        <span class="feature-text">Wi-Fi miễn phí</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-snowflake feature-icon"></i>
                        <span class="feature-text">Điều hòa</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-tv feature-icon"></i>
                        <span class="feature-text">TV màn hình phẳng</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-bath feature-icon"></i>
                        <span class="feature-text">Phòng tắm riêng</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-umbrella-beach feature-icon"></i>
                        <span class="feature-text">View biển</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-parking feature-icon"></i>
                        <span class="feature-text">Bãi đậu xe</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-utensils feature-icon"></i>
                        <span class="feature-text">Bữa sáng miễn phí</span>
                    </div>
                    <div class="feature-item">
                        <i class="fas fa-concierge-bell feature-icon"></i>
                        <span class="feature-text">Dịch vụ phòng 24/7</span>
                    </div>
                </div>
            </div>

            <!-- Room Description -->
            <div class="room-description">
                <h2 class="description-title">Mô tả phòng</h2>
                <p class="description-text">
                    <c:choose>
                        <c:when test="${not empty room.description}">
                            ${room.description}
                        </c:when>
                        <c:otherwise>
                            Phòng ${room.type} với thiết kế hiện đại, rộng rãi, view tuyệt đẹp. Phòng được trang bị đầy đủ tiện nghi cao cấp: giường king-size, phòng tắm riêng với vòi sen và bồn tắm, ban công rộng rãi, điều hòa, TV màn hình phẳng, tủ lạnh mini, và Wi-Fi miễn phí.
                        </c:otherwise>
                    </c:choose>
                </p>
            </div>
        </main>

        <!-- Right Column - Booking -->
        <aside class="booking-sidebar">
            <!-- Price Card -->
            <div class="price-card">
                <div class="price-header">
                    <div class="price-title">Giá phòng</div>
                    <div class="discount-badge" id="discountBadge">Giảm 25%</div>
                </div>
                <div class="price-details">
                    <div class="original-price" id="originalPrice">VND <fmt:formatNumber value="${room.price}" type="number"/></div>
                    <div class="final-price" id="finalPrice">VND <fmt:formatNumber value="${room.price}" type="number"/></div>
                    <div class="price-unit">/đêm</div>
                    <div class="price-savings" id="priceSavings">Tiết kiệm VND 0</div>
                </div>
            </div>

            <!-- Booking Form -->
            <div class="booking-form">
                <h3 style="margin-bottom: 20px; color: #333;">Đặt phòng</h3>
                <form>
                    <div class="form-row">
                        <div class="form-group">
                            <label class="form-label">Nhận phòng</label>
                            <input type="date" class="form-input" id="checkin" required>
                        </div>
                        <div class="form-group">
                            <label class="form-label">Trả phòng</label>
                            <input type="date" class="form-input" id="checkout" required>
                        </div>
                    </div>
                    <div class="form-group">
                        <label class="form-label">Số khách</label>
                        <select class="form-input" id="guests" required>
                            <option value="1">1 khách</option>
                            <option value="2">2 khách</option>
                            <option value="3">3 khách</option>
                            <option value="4" selected>4 khách</option>
                        </select>
                    </div>
                    <button type="submit" class="book-btn">
                        <i class="fas fa-calendar-check"></i> Đặt phòng ngay
                    </button>
                </form>
            </div>

            <!-- Room Info -->
            <div class="room-info">
                <h3 class="info-title">Thông tin phòng</h3>
                <div class="info-item">
                    <span class="info-label">Số phòng</span>
                    <span class="info-value">${room.roomNumber}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Loại phòng</span>
                    <span class="info-value">${room.type}</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Loại giường</span>
                    <span class="info-value">1 giường King + 1 giường đơn</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Hướng</span>
                    <span class="info-value">Hướng biển</span>
                </div>
                <div class="info-item">
                    <span class="info-label">Tầng</span>
                    <span class="info-value">Tầng 3-5</span>
                </div>
            </div>
        </aside>
    </div>

    <%
        // Lấy giá từ CSDL
        java.math.BigDecimal price = room.getPrice();
        int roomPriceValue = price != null ? price.intValue() : 1500000;
    %>
    <script>
        // Lấy giá từ CSDL
        const roomPrice = <%= roomPriceValue %>;
        
        // Auto discount calculation system
        class DiscountCalculator {
            constructor() {
                this.discountRules = {
                    // Quy tắc giảm giá dựa trên giá
                    priceBased: [
                        { minPrice: 0, maxPrice: 500000, discount: 0.10 },
                        { minPrice: 500000, maxPrice: 1000000, discount: 0.15 },
                        { minPrice: 1000000, maxPrice: 2000000, discount: 0.25 },
                        { minPrice: 2000000, maxPrice: 5000000, discount: 0.30 },
                        { minPrice: 5000000, maxPrice: Infinity, discount: 0.35 }
                    ],
                    // Quy tắc giảm giá theo mùa
                    seasonal: {
                        highSeason: { months: [6, 7, 8, 12, 1, 2], discount: 0.05 },
                        lowSeason: { months: [3, 4, 5, 9, 10, 11], discount: 0.15 }
                    }
                };
            }

            calculateDiscount(basePrice) {
                let totalDiscount = 0;
                
                // Tính giảm giá dựa trên giá
                const priceRule = this.discountRules.priceBased.find(rule => 
                    basePrice >= rule.minPrice && basePrice < rule.maxPrice
                );
                if (priceRule) {
                    totalDiscount += priceRule.discount;
                }

                // Tính giảm giá theo mùa
                const currentMonth = new Date().getMonth() + 1;
                if (this.discountRules.seasonal.highSeason.months.includes(currentMonth)) {
                    totalDiscount += this.discountRules.seasonal.highSeason.discount;
                } else {
                    totalDiscount += this.discountRules.seasonal.lowSeason.discount;
                }

                // Giới hạn giảm giá tối đa 50%
                totalDiscount = Math.min(totalDiscount, 0.50);
                
                return {
                    discountPercent: Math.round(totalDiscount * 100),
                    originalPrice: basePrice,
                    finalPrice: Math.round(basePrice * (1 - totalDiscount)),
                    savings: Math.round(basePrice * totalDiscount)
                };
            }

            getDiscountBadgeColor(discountPercent) {
                if (discountPercent >= 40) return '#d32f2f';
                if (discountPercent >= 25) return '#e31e24';
                if (discountPercent >= 15) return '#f57c00';
                return '#388e3c';
            }

            formatPrice(price) {
                return new Intl.NumberFormat('vi-VN').format(price);
            }
        }

        // Khởi tạo calculator
        const discountCalculator = new DiscountCalculator();

        // Cập nhật giá tự động
        function updateRoomPrice() {
            const basePrice = roomPrice;
            
            const discountData = discountCalculator.calculateDiscount(basePrice);
            
            // Cập nhật giao diện
            document.getElementById('discountBadge').textContent = `Giảm ${discountData.discountPercent}%`;
            document.getElementById('discountBadge').style.background = discountCalculator.getDiscountBadgeColor(discountData.discountPercent);
            document.getElementById('originalPrice').textContent = `VND ${discountCalculator.formatPrice(discountData.originalPrice)}`;
            document.getElementById('finalPrice').textContent = `VND ${discountCalculator.formatPrice(discountData.finalPrice)}`;
            document.getElementById('priceSavings').textContent = `Tiết kiệm VND ${discountCalculator.formatPrice(discountData.savings)}`;
        }

        // Thay đổi ảnh chính
        function changeMainImage(thumbnail) {
            const mainImage = document.getElementById('mainImage');
            const thumbnailImg = thumbnail.querySelector('img');
            mainImage.src = thumbnailImg.src;
            mainImage.alt = thumbnailImg.alt;
        }

        // Set minimum dates for check-in and check-out
        const today = new Date().toISOString().split('T')[0];
        const tomorrow = new Date();
        tomorrow.setDate(tomorrow.getDate() + 1);
        const tomorrowStr = tomorrow.toISOString().split('T')[0];

        document.getElementById('checkin').min = today;
        document.getElementById('checkout').min = tomorrowStr;

        // Update checkout min date when checkin changes
        document.getElementById('checkin').addEventListener('change', function() {
            const checkinDate = new Date(this.value);
            const nextDay = new Date(checkinDate);
            nextDay.setDate(nextDay.getDate() + 1);
            document.getElementById('checkout').min = nextDay.toISOString().split('T')[0];
            
            if (document.getElementById('checkout').value && 
                new Date(document.getElementById('checkout').value) <= checkinDate) {
                document.getElementById('checkout').value = nextDay.toISOString().split('T')[0];
            }
        });

        // Cập nhật giá khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            updateRoomPrice();
        });

        // Form submission
        document.querySelector('form').addEventListener('submit', function(e) {
            e.preventDefault();
            const checkin = document.getElementById('checkin').value;
            const checkout = document.getElementById('checkout').value;
            const guests = document.getElementById('guests').value;
            
            if (!checkin || !checkout) {
                alert('Vui lòng chọn ngày nhận phòng và trả phòng!');
                return;
            }
            
            // Chuyển đến trang booking details với thông tin đã chọn
            const params = new URLSearchParams({
                checkin: checkin,
                checkout: checkout,
                guests: guests
            });
            
            window.location.href = '${pageContext.request.contextPath}/booking/details?' + params.toString();
        });
    </script>
</body>
</html>
