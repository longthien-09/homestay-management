<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> featuredHomestays = (List<Homestay>) request.getAttribute("featuredHomestays");
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>HomestayPro - Khám phá homestay tuyệt vời</title>
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
        }

        /* Header */
        .header {
            background: #fff;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            z-index: 1000;
        }

        .header-container {
            max-width: 1200px;
            margin: 0 auto;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 15px 20px;
        }

        .logo {
            font-size: 24px;
            font-weight: bold;
            color: #e31e24;
            text-decoration: none;
        }

        .nav-menu {
            display: flex;
            list-style: none;
            gap: 30px;
        }

        .nav-menu a {
            text-decoration: none;
            color: #333;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        .nav-menu a:hover {
            color: #e31e24;
        }

        .header-actions {
            display: flex;
            gap: 15px;
            align-items: center;
        }

        .btn-login {
            padding: 10px 20px;
            border: 1px solid #e31e24;
            background: transparent;
            color: #e31e24;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-login:hover {
            background: #e31e24;
            color: white;
        }

        .btn-register {
            padding: 10px 20px;
            background: #e31e24;
            color: white;
            border: none;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-register:hover {
            background: #c41e24;
            transform: translateY(-2px);
        }

        /* Hero Section */
        .hero {
            margin-top: 80px;
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 80px 20px;
            text-align: center;
        }
        
        .hero-content {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .hero h1 {
            font-size: 3.5em;
            margin-bottom: 20px;
            font-weight: 300;
        }

        .hero p {
            font-size: 1.3em;
            margin-bottom: 50px;
            opacity: 0.9;
        }

        /* Search Form */
        .search-container {
            background: white;
            border-radius: 20px;
            padding: 40px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            max-width: 1000px;
            margin: 0 auto;
        }

        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 1fr;
            gap: 20px;
            align-items: end;
        }
        
        .search-field {
            display: flex;
            flex-direction: column;
        }

        .search-field label {
            font-size: 14px;
            color: #666;
            margin-bottom: 8px;
            font-weight: 500;
        }

        .search-input {
            padding: 15px;
            border: 2px solid #e1e5e9;
            border-radius: 10px;
            font-size: 16px;
            transition: border-color 0.3s ease;
        }

        .search-input:focus {
            outline: none;
            border-color: #e31e24;
        }

        .search-input::placeholder {
            color: #999;
        }
        
        .search-btn {
            background: #e31e24;
            color: white;
            border: none;
            padding: 17px 30px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .search-btn:hover {
            background: #c41e24;
            transform: translateY(-2px);
        }
        
        /* Features Section */
        .features {
            padding: 80px 20px;
            background: #f8f9fa;
        }
        
        .features-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 60px;
        }
        
        .section-title h2 {
            font-size: 2.5em;
            color: #333;
            margin-bottom: 15px;
            font-weight: 300;
        }
        
        .section-title p {
            font-size: 1.2em;
            color: #666;
        }

        .features-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
            gap: 40px;
        }

        .feature-card {
            background: white;
            padding: 40px 30px;
            border-radius: 15px;
            text-align: center;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }

        .feature-card:hover {
            transform: translateY(-10px);
        }

        .feature-icon {
            width: 80px;
            height: 80px;
            background: linear-gradient(135deg, #667eea, #764ba2);
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            margin: 0 auto 25px;
            color: white;
            font-size: 30px;
        }

        .feature-card h3 {
            font-size: 1.5em;
            margin-bottom: 15px;
            color: #333;
        }

        .feature-card p {
            color: #666;
            line-height: 1.6;
        }

        /* Homestay Section */
        .homestay-section {
            padding: 80px 20px;
            background: white;
        }

        .homestay-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .homestay-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 50px;
        }
        
        .homestay-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 10px 30px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .homestay-card:hover {
            transform: translateY(-10px);
            box-shadow: 0 20px 40px rgba(0,0,0,0.15);
        }
        
        .homestay-image {
            width: 100%;
            height: 250px;
            overflow: hidden;
            position: relative;
        }
        
        .homestay-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .homestay-card:hover .homestay-image img {
            transform: scale(1.1);
        }

        .homestay-badge {
            position: absolute;
            top: 15px;
            left: 15px;
            background: #e31e24;
            color: white;
            padding: 5px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }
        
        .homestay-info {
            padding: 25px;
        }
        
        .homestay-name {
            font-size: 1.4em;
            margin-bottom: 10px;
            color: #333;
            font-weight: 600;
        }
        
        .homestay-location {
            color: #666;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .homestay-features {
            margin-bottom: 15px;
        }
        
        .feature-tag {
            display: inline-block;
            background: #f8f9fa;
            color: #495057;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            margin-right: 8px;
            margin-bottom: 5px;
            border: 1px solid #e9ecef;
        }
        
        .homestay-rating {
            display: flex;
            align-items: center;
            gap: 5px;
            margin-bottom: 15px;
        }

        .stars {
            color: #ffc107;
        }

        .rating-text {
            color: #666;
            font-size: 14px;
        }

        .homestay-price {
            font-size: 1.3em;
            color: #e31e24;
            font-weight: 600;
            margin-bottom: 15px;
        }

        .price-unit {
            font-size: 14px;
            color: #666;
            font-weight: normal;
        }

        .view-details-btn {
            display: inline-block;
            background: #e31e24;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            width: 100%;
            text-align: center;
        }
        
        .view-details-btn:hover {
            background: #c41e24;
            transform: translateY(-2px);
        }
        
        .view-all-container {
            text-align: center;
        }
        
        .view-all-btn {
            display: inline-block;
            background: transparent;
            color: #e31e24;
            border: 2px solid #e31e24;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
        }
        
        .view-all-btn:hover {
            background: #e31e24;
            color: white;
            transform: translateY(-2px);
        }
        
        /* Footer */
        .footer {
            background: #1a1a1a;
            color: white;
            padding: 60px 20px 30px;
        }

        .footer-container {
            max-width: 1200px;
            margin: 0 auto;
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
            gap: 40px;
        }

        .footer-section h3 {
            margin-bottom: 20px;
            color: #e31e24;
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
            color: #e31e24;
        }

        .footer-bottom {
            text-align: center;
            margin-top: 40px;
            padding-top: 20px;
            border-top: 1px solid #333;
            color: #999;
        }

        /* Responsive Design */
        @media (max-width: 768px) {
            .nav-menu {
                display: none;
            }

            .search-form {
                grid-template-columns: 1fr;
            }

            .hero h1 {
                font-size: 2.5em;
            }

            .features-grid {
                grid-template-columns: 1fr;
            }

            .homestay-grid {
                grid-template-columns: 1fr;
            }
        }

        /* Animation */
        @keyframes fadeInUp {
            from {
                opacity: 0;
                transform: translateY(30px);
            }
            to {
                opacity: 1;
                transform: translateY(0);
            }
        }

        .fade-in-up {
            animation: fadeInUp 0.6s ease-out;
        }
    </style>
</head>
<body>
    <!-- Header -->
    <header class="header">
        <div class="header-container">
            <a href="<%= request.getContextPath() %>/" class="logo">
                <i class="fas fa-home"></i> HomestayPro
            </a>
            <nav>
                <ul class="nav-menu">
                    <li><a href="<%= request.getContextPath() %>/homestays">Khám phá</a></li>
                    <li><a href="#about">Về chúng tôi</a></li>
                    <li><a href="#contact">Liên hệ</a></li>
                    <li><a href="#help">Trợ giúp</a></li>
                </ul>
            </nav>
            <div class="header-actions">
                <a href="<%= request.getContextPath() %>/login" class="btn-login">Đăng nhập</a>
                <a href="<%= request.getContextPath() %>/register" class="btn-register">Đăng ký</a>
            </div>
        </div>
    </header>

    <!-- Hero Section -->
    <section class="hero">
        <div class="hero-content">
            <h1>Khám phá homestay tuyệt vời</h1>
            <p>Trải nghiệm nghỉ dưỡng độc đáo với không gian ấm cúng và dịch vụ chất lượng</p>
            
            <!-- Search Form -->
            <div class="search-container">
                <form class="search-form" method="get" action="<%= request.getContextPath() %>/search">
                    <div class="search-field">
                        <label for="location">Địa điểm</label>
                        <input type="text" id="location" name="location" class="search-input" placeholder="Bạn muốn đi đâu?">
                    </div>
                    <div class="search-field">
                        <label for="checkin">Check-in</label>
                        <input type="date" id="checkin" name="checkin" class="search-input">
                    </div>
                    <div class="search-field">
                        <label for="checkout">Check-out</label>
                        <input type="date" id="checkout" name="checkout" class="search-input">
                    </div>
                    <div class="search-field">
                        <label for="guests">Khách</label>
                        <select id="guests" name="guests" class="search-input">
                            <option value="1">1 khách</option>
                            <option value="2">2 khách</option>
                            <option value="3">3 khách</option>
                            <option value="4">4 khách</option>
                            <option value="5">5+ khách</option>
                        </select>
                    </div>
                    <div class="search-field">
                        <button type="submit" class="search-btn">
                            <i class="fas fa-search"></i> Tìm kiếm
                        </button>
                    </div>
                </form>
            </div>
                </div>
    </section>

    <!-- Features Section -->
    <section class="features">
        <div class="features-container">
            <div class="section-title">
                <h2>Tại sao chọn chúng tôi?</h2>
                <p>Những lý do khiến chúng tôi trở thành lựa chọn hàng đầu</p>
            </div>
            <div class="features-grid">
                <div class="feature-card fade-in-up">
                    <div class="feature-icon">
                        <i class="fas fa-shield-alt"></i>
                    </div>
                    <h3>An toàn & Bảo mật</h3>
                    <p>Đảm bảo thông tin cá nhân và thanh toán của bạn được bảo vệ tuyệt đối</p>
                </div>
                <div class="feature-card fade-in-up">
                    <div class="feature-icon">
                        <i class="fas fa-star"></i>
            </div>
                    <h3>Chất lượng cao</h3>
                    <p>Chỉ cung cấp những homestay đã được kiểm định chất lượng nghiêm ngặt</p>
                </div>
                <div class="feature-card fade-in-up">
                    <div class="feature-icon">
                        <i class="fas fa-headset"></i>
            </div>
                    <h3>Hỗ trợ 24/7</h3>
                    <p>Đội ngũ hỗ trợ khách hàng luôn sẵn sàng giúp đỡ bạn mọi lúc</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Homestay Section -->
    <section class="homestay-section">
    <div class="homestay-container">
        <div class="section-title">
                <h2>Homestay Nổi Bật</h2>
                <p>Khám phá những homestay đẹp và ấm cúng tại các địa điểm hấp dẫn</p>
        </div>
            
        <div class="homestay-grid">
            <% if (featuredHomestays != null && !featuredHomestays.isEmpty()) { %>
                <% for (Homestay homestay : featuredHomestays) { %>
                    <div class="homestay-card fade-in-up">
                        <div class="homestay-image">
                            <img src="<%= homestay.getImage() != null ? homestay.getImage() : "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" %>" 
                                 alt="<%= homestay.getName() %>">
                            <div class="homestay-badge">Nổi bật</div>
                        </div>
                    <div class="homestay-info">
                        <h3 class="homestay-name"><%= homestay.getName() %></h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                <%= homestay.getAddress() != null ? homestay.getAddress() : "Chưa cập nhật" %>
                            </p>
                            <div class="homestay-features">
                                <% if (homestay.getDescription() != null && homestay.getDescription().contains("Dịch vụ:")) { %>
                                    <% 
                                        String desc = homestay.getDescription();
                                        int serviceIndex = desc.indexOf("Dịch vụ:");
                                        if (serviceIndex != -1) {
                                            String services = desc.substring(serviceIndex + 8).trim();
                                            String[] serviceArray = services.split(", ");
                                            for (String service : serviceArray) {
                                                if (!service.trim().isEmpty()) {
                                    %>
                                        <span class="feature-tag"><%= service.trim() %></span>
                                    <% 
                                                }
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    <span class="feature-tag">Chưa cập nhật</span>
                                <% } %>
                            </div>
                            <div class="homestay-rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="rating-text">Chưa có đánh giá</span>
                            </div>
                            <div class="homestay-price">
                                <% if (homestay.getDescription() != null && homestay.getDescription().contains("Giá:")) { %>
                                    <% 
                                        String desc = homestay.getDescription();
                                        int priceIndex = desc.indexOf("Giá:");
                                        if (priceIndex != -1) {
                                            String priceRange = desc.substring(priceIndex + 4).trim();
                                            String[] prices = priceRange.split(" - ");
                                            if (prices.length >= 2) {
                                                try {
                                                    java.math.BigDecimal minPrice = new java.math.BigDecimal(prices[0]);
                                                    String formattedPrice = String.format("%,.0f", minPrice);
                            %>
                                    Từ <%= formattedPrice %>đ <span class="price-unit">/đêm</span>
                            <% 
                                                } catch (NumberFormatException e) {
                            %>
                                    Từ <%= priceRange %> <span class="price-unit">/đêm</span>
                            <% 
                                                }
                                            }
                                        }
                                    %>
                                <% } else { %>
                                    Liên hệ <span class="price-unit">/đêm</span>
                                <% } %>
                            </div>
                            <a href="<%= request.getContextPath() %>/homestays/<%= homestay.getId() %>" class="view-details-btn">
                                Xem chi tiết
                            </a>
                        </div>
                </div>
                <% } %>
            <% } else { %>
                <!-- Fallback khi không có homestay nào -->
                    <div class="homestay-card fade-in-up">
                        <div class="homestay-image">
                            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu">
                            <div class="homestay-badge">Mới</div>
                        </div>
                        <div class="homestay-info">
                            <h3 class="homestay-name">Homestay Mẫu</h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Hà Nội, Việt Nam
                            </p>
                            <div class="homestay-rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="rating-text">Chưa có đánh giá</span>
                            </div>
                            <div class="homestay-price">
                                Liên hệ <span class="price-unit">/đêm</span>
                            </div>
                            <a href="#" class="view-details-btn">Xem chi tiết</a>
                        </div>
                    </div>
                    
                    <div class="homestay-card fade-in-up">
                        <div class="homestay-image">
                            <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2068&q=80" alt="Homestay mẫu 2">
                            <div class="homestay-badge">Phổ biến</div>
                        </div>
                        <div class="homestay-info">
                            <h3 class="homestay-name">Homestay Phố Cổ</h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Hà Nội, Việt Nam
                            </p>
                            <div class="homestay-rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="rating-text">Chưa có đánh giá</span>
                            </div>
                            <div class="homestay-price">
                                Liên hệ <span class="price-unit">/đêm</span>
                            </div>
                            <a href="#" class="view-details-btn">Xem chi tiết</a>
                        </div>
                    </div>
                    
                    <div class="homestay-card fade-in-up">
                    <div class="homestay-image">
                            <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu 3">
                            <div class="homestay-badge">Giảm giá</div>
            </div>
                    <div class="homestay-info">
                            <h3 class="homestay-name">Homestay Sapa</h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Sapa, Lào Cai
                            </p>
                            <div class="homestay-rating">
                                <div class="stars">
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                    <i class="fas fa-star"></i>
                                </div>
                                <span class="rating-text">4.8 (156 đánh giá)</span>
                            </div>
                            <div class="homestay-price">
                                Từ 400.000đ <span class="price-unit">/đêm</span>
                            </div>
                            <a href="#" class="view-details-btn">Xem chi tiết</a>
            </div>
            </div>
            <% } %>
        </div>
            
        <div class="view-all-container">
                <a href="<%= request.getContextPath() %>/homestays" class="view-all-btn">
                    Xem tất cả Homestay
                </a>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-container">
            <div class="footer-section">
                <h3>Về HomestayPro</h3>
                <ul>
                    <li><a href="#">Giới thiệu</a></li>
                    <li><a href="#">Tuyển dụng</a></li>
                    <li><a href="#">Báo chí</a></li>
                    <li><a href="#">Blog</a></li>
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
                <h3>Kết nối</h3>
                <ul>
                    <li><a href="#"><i class="fab fa-facebook"></i> Facebook</a></li>
                    <li><a href="#"><i class="fab fa-twitter"></i> Twitter</a></li>
                    <li><a href="#"><i class="fab fa-instagram"></i> Instagram</a></li>
                    <li><a href="#"><i class="fab fa-youtube"></i> YouTube</a></li>
                </ul>
        </div>
        </div>
        <div class="footer-bottom">
            <p>&copy; 2024 HomestayPro. Tất cả quyền được bảo lưu.</p>
    </div>
    </footer>
    
    <script>
        // Smooth scrolling for navigation links
        document.querySelectorAll('a[href^="#"]').forEach(anchor => {
            anchor.addEventListener('click', function (e) {
                e.preventDefault();
                const target = document.querySelector(this.getAttribute('href'));
                if (target) {
                    target.scrollIntoView({
                        behavior: 'smooth',
                        block: 'start'
                    });
                }
            });
        });

        // Add fade-in animation to elements when they come into view
        const observerOptions = {
            threshold: 0.1,
            rootMargin: '0px 0px -50px 0px'
        };

        const observer = new IntersectionObserver((entries) => {
            entries.forEach(entry => {
                if (entry.isIntersecting) {
                    entry.target.classList.add('fade-in-up');
                }
            });
        }, observerOptions);

        // Observe all feature cards and homestay cards
        document.querySelectorAll('.feature-card, .homestay-card').forEach(card => {
            observer.observe(card);
        });

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
            
            // If checkout date is before new checkin date, update it
            if (document.getElementById('checkout').value && 
                new Date(document.getElementById('checkout').value) <= checkinDate) {
                document.getElementById('checkout').value = nextDay.toISOString().split('T')[0];
            }
        });

        // Header scroll effect
        window.addEventListener('scroll', function() {
            const header = document.querySelector('.header');
            if (window.scrollY > 100) {
                header.style.background = 'rgba(255, 255, 255, 0.95)';
                header.style.backdropFilter = 'blur(10px)';
            } else {
                header.style.background = '#fff';
                header.style.backdropFilter = 'none';
            }
        });
    </script>
</body>
</html>
