<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> searchResults = (List<Homestay>) request.getAttribute("searchResults");
    String location = (String) request.getAttribute("location");
    String checkin = (String) request.getAttribute("checkin");
    String checkout = (String) request.getAttribute("checkout");
    String guests = (String) request.getAttribute("guests");
    
    if (searchResults == null) {
        searchResults = new java.util.ArrayList<>();
    }
%>
<!DOCTYPE html>
<html lang="vi">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kết quả tìm kiếm - HomestayPro</title>
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

        /* Search Bar */
        .search-bar {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .search-form {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr 1fr 1fr;
            gap: 15px;
            align-items: end;
        }

        .search-field {
            display: flex;
            flex-direction: column;
        }

        .search-field label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .search-input {
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
        }

        .search-input:focus {
            outline: none;
            border-color: #003580;
        }

        .search-btn {
            background: #0071c2;
            color: white;
            border: none;
            padding: 12px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s ease;
        }

        .search-btn:hover {
            background: #005a9e;
        }

        /* Main Content */
        .main-container {
            max-width: 1200px;
            margin: 20px auto;
            padding: 0 20px;
            display: grid;
            grid-template-columns: 300px 1fr;
            gap: 30px;
        }

        /* Left Sidebar - Filters */
        .filters-sidebar {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 120px;
        }

        .filter-section {
            margin-bottom: 25px;
            padding-bottom: 20px;
            border-bottom: 1px solid #eee;
        }

        .filter-section:last-child {
            border-bottom: none;
        }

        .filter-title {
            font-size: 16px;
            font-weight: 600;
            margin-bottom: 15px;
            color: #333;
        }

        .filter-option {
            display: flex;
            align-items: center;
            margin-bottom: 12px;
            cursor: pointer;
        }

        .filter-option input[type="checkbox"] {
            margin-right: 10px;
            width: 16px;
            height: 16px;
        }

        .filter-option label {
            cursor: pointer;
            font-size: 14px;
            color: #555;
        }

        .filter-count {
            margin-left: auto;
            color: #999;
            font-size: 12px;
        }

        /* Filter Header */
        .filter-header {
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #0071c2;
        }

        .main-filter-title {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin: 0;
        }

        /* Price Range Slider */
        .price-range {
            margin: 15px 0;
        }

        .current-price-range {
            margin-bottom: 15px;
            text-align: center;
        }

        .price-range-text {
            font-size: 16px;
            font-weight: 600;
            color: #0071c2;
            background: #f0f8ff;
            padding: 8px 16px;
            border-radius: 20px;
            display: inline-block;
        }

        .price-slider-container {
            margin: 20px 0;
            position: relative;
        }

        .price-slider {
            width: 100%;
            height: 6px;
            border-radius: 3px;
            background: #e1e5e9;
            outline: none;
            -webkit-appearance: none;
            appearance: none;
        }

        .price-slider::-webkit-slider-thumb {
            -webkit-appearance: none;
            appearance: none;
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #0071c2;
            cursor: pointer;
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .price-slider::-moz-range-thumb {
            width: 20px;
            height: 20px;
            border-radius: 50%;
            background: #0071c2;
            cursor: pointer;
            border: 2px solid white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.2);
        }

        .price-slider-labels {
            display: flex;
            justify-content: space-between;
            margin-top: 8px;
            font-size: 12px;
            color: #666;
        }

        .price-inputs {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
            margin-top: 15px;
        }

        .price-input-group {
            display: flex;
            flex-direction: column;
        }

        .price-input-group label {
            font-size: 12px;
            color: #666;
            margin-bottom: 5px;
            font-weight: 500;
        }

        .price-input {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 6px;
            font-size: 14px;
            transition: border-color 0.3s ease;
        }

        .price-input:focus {
            outline: none;
            border-color: #0071c2;
            box-shadow: 0 0 0 2px rgba(0, 113, 194, 0.1);
        }



        /* Right Side - Results */
        .results-section {
            background: white;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }

        .results-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 20px;
            padding-bottom: 15px;
            border-bottom: 1px solid #eee;
        }

        .results-count {
            font-size: 18px;
            color: #333;
        }

        .sort-dropdown {
            padding: 8px 12px;
            border: 1px solid #ddd;
            border-radius: 4px;
            font-size: 14px;
            background: white;
        }

        /* Homestay Cards */
        .homestay-card {
            display: grid;
            grid-template-columns: 200px 1fr auto;
            gap: 20px;
            padding: 20px 0;
            border-bottom: 1px solid #eee;
            transition: all 0.3s ease;
        }

        .homestay-card:hover {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin: 0 -20px;
        }

        .homestay-image {
            width: 200px;
            height: 150px;
            border-radius: 8px;
            overflow: hidden;
        }

        .homestay-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .homestay-info {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }

        .homestay-name {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 8px;
        }

        .homestay-name a {
            transition: color 0.3s ease;
        }

        .homestay-name a:hover {
            color: #0071c2 !important;
            text-decoration: underline !important;
        }

        .homestay-location {
            color: #666;
            margin-bottom: 8px;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .homestay-features {
            display: flex;
            flex-wrap: wrap;
            gap: 10px;
            margin-bottom: 10px;
        }

        .feature-tag {
            background: #f0f8ff;
            color: #0071c2;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 500;
        }

        /* Mô tả homestay */
        .homestay-description {
            margin-bottom: 12px;
        }

        .description-text {
            color: #555;
            font-size: 14px;
            line-height: 1.5;
            margin: 0;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            text-overflow: ellipsis;
        }

        .description-placeholder {
            color: #999;
            font-style: italic;
        }

        .homestay-description:hover .description-text {
            color: #333;
        }



        .homestay-price {
            text-align: right;
            display: flex;
            flex-direction: column;
            align-items: flex-end;
            justify-content: center;
        }

        .price-amount {
            font-size: 24px;
            font-weight: 600;
            color: #333;
        }

        .price-unit {
            font-size: 14px;
            color: #666;
        }
        
        .price-amount {
            font-size: 18px;
            font-weight: 600;
            color: #333;
            margin-bottom: 5px;
        }

        .discount-badge {
            background: #e31e24;
            color: white;
            padding: 4px 8px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-bottom: 8px;
            display: inline-block;
        }

        .original-price {
            text-decoration: line-through;
            color: #999;
            font-size: 16px;
            margin-bottom: 5px;
        }

        .final-price {
            font-size: 24px;
            font-weight: 600;
            color: #e31e24;
            margin-bottom: 5px;
        }

        .price-savings {
            color: #e31e24;
            font-size: 12px;
            font-weight: 500;
            margin-bottom: 10px;
        }

        .view-btn {
            background: #0071c2;
            color: white;
            border: none;
            padding: 10px 20px;
            border-radius: 4px;
            font-size: 14px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
            text-decoration: none;
            display: inline-block;
            text-align: center;
        }

        .view-btn:hover {
            background: #005a9e;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0,0,0,0.2);
        }



        /* Responsive Design */
        @media (max-width: 768px) {
            .main-container {
                grid-template-columns: 1fr;
            }

            .filters-sidebar {
                position: static;
                margin-bottom: 20px;
            }

            .search-form {
                grid-template-columns: 1fr;
            }

            .homestay-card {
                grid-template-columns: 1fr;
                text-align: center;
            }

            .homestay-image {
                width: 100%;
                height: 200px;
            }

            .homestay-price {
                text-align: center;
                align-items: center;
            }

            .homestay-description {
                text-align: center;
                margin: 15px 0;
            }

            .description-text {
                -webkit-line-clamp: 4;
            }
        }

        /* Animation cho mô tả */
        .homestay-description {
            transition: all 0.3s ease;
        }

        .homestay-card:hover .homestay-description {
            transform: translateY(-2px);
        }

        .description-text {
            transition: color 0.3s ease;
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
                <a href="<%= request.getContextPath() %>/" class="logo">
                    <i class="fas fa-home"></i> HomestayPro
                </a>
                <div class="header-actions">
                    <a href="<%= request.getContextPath() %>/login" class="btn-login">Đăng nhập</a>
                    <a href="<%= request.getContextPath() %>/register" class="btn-register">Đăng ký</a>
                </div>
            </div>
            
            <!-- Search Bar -->
            <div class="search-bar">
                <form class="search-form" method="get" action="<%= request.getContextPath() %>/search">
                    <div class="search-field">
                        <label for="location">Địa điểm</label>
                        <input type="text" id="location" name="location" class="search-input" 
                               value="<%= location != null ? location : "" %>" placeholder="Bạn muốn đi đâu?">
                    </div>
                    <div class="search-field">
                        <label for="checkin">Ngày nhận phòng</label>
                        <input type="date" id="checkin" name="checkin" class="search-input" 
                               value="<%= checkin != null ? checkin : "" %>">
                    </div>
                    <div class="search-field">
                        <label for="checkout">Ngày trả phòng</label>
                        <input type="date" id="checkout" name="checkout" class="search-input" 
                               value="<%= checkout != null ? checkout : "" %>">
                    </div>
                    <div class="search-field">
                        <label for="guests">Khách/Phòng</label>
                        <select id="guests" name="guests" class="search-input">
                            <option value="1" <%= "1".equals(guests) ? "selected" : "" %>>1 khách</option>
                            <option value="2" <%= "2".equals(guests) ? "selected" : "" %>>2 khách</option>
                            <option value="3" <%= "3".equals(guests) ? "selected" : "" %>>3 khách</option>
                            <option value="4" <%= "4".equals(guests) ? "selected" : "" %>>4 khách</option>
                            <option value="5" <%= "5".equals(guests) ? "selected" : "" %>>5+ khách</option>
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
    </header>

    <!-- Main Content -->
    <div class="main-container">
        <!-- Left Sidebar - Filters -->
        <aside class="filters-sidebar">
            <!-- Main Filter Header -->
            <div class="filter-header">
                <h2 class="main-filter-title">Chọn lọc theo:</h2>
                <button type="button" id="clear-filters" class="clear-filters-btn" style="background: none; border: none; color: #003580; font-size: 12px; cursor: pointer; text-decoration: underline; margin-top: 5px;">
                    <i class="fas fa-times"></i> Xóa bộ lọc
                </button>
            </div>

            <!-- Price Range -->
            <div class="filter-section">
                <h3 class="filter-title">Ngân sách của bạn (mỗi đêm)</h3>
                <div class="price-range">
                    <div class="current-price-range">
                        <span class="price-range-text">VND 100.000 - VND 3.000.000+</span>
                    </div>
                    <div class="price-slider-container">
                        <input type="range" class="price-slider" id="priceSlider" min="100000" max="3000000" step="50000" value="3000000">
                        <div class="price-slider-labels">
                            <span>100.000</span>
                            <span>3.000.000+</span>
                        </div>
                    </div>
                    <div class="price-inputs">
                        <div class="price-input-group">
                            <label>Từ</label>
                            <input type="number" class="price-input" id="minPrice" placeholder="100.000" min="100000" max="3000000">
                        </div>
                        <div class="price-input-group">
                            <label>Đến</label>
                            <input type="number" class="price-input" id="maxPrice" placeholder="3.000.000" min="100000" max="3000000">
                        </div>
                    </div>
                </div>
            </div>

            <!-- Property Type -->
            <div class="filter-section">
                <h3 class="filter-title">Loại chỗ nghỉ</h3>
                <div class="filter-option">
                    <input type="checkbox" id="hotel" name="propertyType" value="hotel">
                    <label for="hotel">Khách sạn</label>
                    <span class="filter-count">(45)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="homestay" name="propertyType" value="homestay">
                    <label for="homestay">Homestay</label>
                    <span class="filter-count">(23)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="resort" name="propertyType" value="resort">
                    <label for="resort">Resort</label>
                    <span class="filter-count">(18)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="apartment" name="propertyType" value="apartment">
                    <label for="apartment">Căn hộ</label>
                    <span class="filter-count">(32)</span>
                </div>
            </div>

            <!-- Amenities -->
            <div class="filter-section">
                <h3 class="filter-title">Tiện nghi</h3>
                <div class="filter-option">
                    <input type="checkbox" id="wifi" name="amenities" value="wifi">
                    <label for="wifi">Wi-Fi miễn phí</label>
                    <span class="filter-count">(89)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="parking" name="amenities" value="parking">
                    <label for="parking">Bãi đậu xe</label>
                    <span class="filter-count">(67)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="pool" name="amenities" value="pool">
                    <label for="pool">Hồ bơi</label>
                    <span class="filter-count">(34)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="restaurant" name="amenities" value="restaurant">
                    <label for="restaurant">Nhà hàng</label>
                    <span class="filter-count">(56)</span>
                </div>
                <div class="filter-option">
                    <input type="checkbox" id="reception" name="amenities" value="reception">
                    <label for="reception">Lễ tân 24 giờ</label>
                    <span class="filter-count">(78)</span>
                </div>
            </div>



            <!-- Cancellation Policy -->
            <div class="filter-section">
                <h3 class="filter-title">Chính sách hủy</h3>
                <div class="filter-option">
                    <input type="checkbox" id="free-cancel" name="cancellation" value="free">
                    <label for="free-cancel">Miễn phí hủy</label>
                    <span class="filter-count">(89)</span>
                </div>
            </div>
        </aside>

        <!-- Right Side - Results -->
        <main class="results-section">
            <div class="results-header">
                <div class="results-count">
                    <% if (location != null && !location.isEmpty()) { %>
                        <%= location %> tìm thấy <%= searchResults.size() %> chỗ nghỉ
                    <% } else { %>
                        Tìm thấy <%= searchResults.size() %> chỗ nghỉ
                    <% } %>
                </div>
                <select class="sort-dropdown">
                    <option value="popular">Phổ biến nhất</option>
                    <option value="price-low">Giá thấp nhất</option>
                    <option value="price-high">Giá cao nhất</option>
                    <option value="distance">Gần nhất</option>
                </select>
            </div>

            <!-- Search Results -->
            <% if (searchResults != null && !searchResults.isEmpty()) { %>
                <% for (Homestay homestay : searchResults) { %>
                <div class="homestay-card" 
                     data-amenities="<%= homestay.getDescription() != null && homestay.getDescription().contains("Dịch vụ:") ? 
                         homestay.getDescription().substring(homestay.getDescription().indexOf("Dịch vụ:") + 8).trim().toLowerCase().replaceAll("\\s+", "").replaceAll("[^a-z0-9,]", "") : "" %>"
                     data-property-type="homestay"
                     data-cancellation="free"
                     data-price="<%= homestay.getDescription() != null && homestay.getDescription().contains("Giá:") ? 
                         homestay.getDescription().substring(homestay.getDescription().indexOf("Giá:") + 4).trim().split(" - ")[0].replaceAll("[^0-9]", "") : "0" %>">
                    <div class="homestay-image">
                        <img src="<%= homestay.getImage() != null ? homestay.getImage() : "https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" %>" 
                             alt="<%= homestay.getName() %>">
                    </div>
                    <div class="homestay-info">
                        <div>
                            <h3 class="homestay-name">
                                <a href="<%= request.getContextPath() %>/room/1" style="text-decoration: none; color: inherit;">
                                    <%= homestay.getName() %>
                                </a>
                            </h3>
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
                            
                            <!-- Mô tả homestay -->
                            <div class="homestay-description">
                                <% if (homestay.getDescription() != null && !homestay.getDescription().isEmpty()) { %>
                                    <% 
                                        String desc = homestay.getDescription();
                                        // Tách mô tả chính (phần trước "Dịch vụ:")
                                        String mainDesc = desc;
                                        if (desc.contains("Dịch vụ:")) {
                                            mainDesc = desc.substring(0, desc.indexOf("Dịch vụ:")).trim();
                                        }
                                        if (desc.contains("Giá:")) {
                                            mainDesc = desc.substring(0, desc.indexOf("Giá:")).trim();
                                        }
                                        
                                        // Giới hạn độ dài mô tả để hiển thị đẹp
                                        if (mainDesc.length() > 150) {
                                            mainDesc = mainDesc.substring(0, 150) + "...";
                                        }
                                    %>
                                    <p class="description-text"><%= mainDesc %></p>
                                <% } else { %>
                                    <p class="description-text description-placeholder">Chưa có mô tả chi tiết cho homestay này.</p>
                                <% } %>
                            </div>
                        </div>
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
                                            java.math.BigDecimal maxPrice = new java.math.BigDecimal(prices[1]);
                                            
                                            // Tính toán giảm giá đơn giản (10-20%)
                                            double discountPercent = Math.random() * 10 + 10; // 10-20%
                                            java.math.BigDecimal discountAmount = minPrice.multiply(java.math.BigDecimal.valueOf(discountPercent / 100));
                                            java.math.BigDecimal finalPrice = minPrice.subtract(discountAmount);
                            %>
                                <div class="discount-badge">Giảm <%= String.format("%.0f", discountPercent) %>%</div>
                                <div class="original-price">VND <%= String.format("%,.0f", minPrice) %></div>
                                <div class="final-price">VND <%= String.format("%,.0f", finalPrice) %></div>
                                <div class="price-unit">/đêm</div>
                                <div class="price-savings">Tiết kiệm VND <%= String.format("%,.0f", discountAmount) %></div>
                            <% 
                                        } catch (NumberFormatException e) {
                            %>
                                <div class="price-amount">Từ <%= priceRange %></div>
                                <div class="price-unit">/đêm</div>
                            <% 
                                        }
                                    }
                                }
                            %>
                        <% } else { %>
                            <div class="price-amount">Liên hệ</div>
                            <div class="price-unit">/đêm</div>
                        <% } %>
                        <a href="<%= request.getContextPath() %>/room/1" class="view-btn" style="text-decoration: none; display: inline-block; text-align: center;">Xem chỗ trống</a>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <!-- Thông báo không có kết quả tìm kiếm -->
                <div style="text-align: center; padding: 60px 20px; color: #666;">
                    <i class="fas fa-search" style="font-size: 60px; margin-bottom: 20px; display: block; color: #ccc;"></i>
                    <h2 style="margin-bottom: 15px; color: #333;">Không tìm thấy homestay</h2>
                    <p style="margin-bottom: 30px; font-size: 16px;">
                        <% if (location != null && !location.isEmpty()) { %>
                            Không có homestay nào tại "<strong><%= location %></strong>" phù hợp với tiêu chí tìm kiếm của bạn.
                        <% } else { %>
                            Hiện tại không có homestay nào khả dụng.
                        <% } %>
                    </p>
                    <div style="font-size: 14px; color: #999; margin-bottom: 30px;">
                        <p>💡 Bạn có thể thử:</p>
                        <ul style="list-style: none; padding: 0; margin: 10px 0;">
                            <li>• Tìm kiếm với từ khóa khác</li>
                            <li>• Thay đổi địa điểm</li>
                            <li>• Kiểm tra lại ngày check-in/check-out</li>
                        </ul>
                    </div>
                    <a href="<%= request.getContextPath() %>/" class="btn-primary" style="display: inline-block; padding: 12px 24px; background: #003580; color: white; text-decoration: none; border-radius: 6px; font-weight: 500;">
                        <i class="fas fa-home"></i> Về trang chủ
                    </a>
                </div>
                
                <!-- Demo data khi không có kết quả thực -->
                <div class="homestay-card fade-in-up" data-amenities="wifi,pool,restaurant" data-property-type="homestay" data-cancellation="free" data-price="1500000">
                    <div class="homestay-image">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu 1">
                    </div>
                    <div class="homestay-info">
                        <div>
                            <h3 class="homestay-name">
                                <a href="<%= request.getContextPath() %>/room/1" style="text-decoration: none; color: inherit;">
                                    Homestay Biển Quy Nhơn
                                </a>
                            </h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Quy Nhơn, Bình Định
                            </p>
                            <div class="homestay-features">
                                <span class="feature-tag">Wi-Fi miễn phí</span>
                                <span class="feature-tag">Hồ bơi</span>
                                <span class="feature-tag">Nhà hàng</span>
                            </div>
                            <!-- Mô tả homestay -->
                            <div class="homestay-description">
                                <p class="description-text">Homestay biển xinh đẹp với view biển tuyệt đẹp, không gian thoáng đãng và tiện nghi hiện đại. Nơi lý tưởng để nghỉ dưỡng và tận hưởng không khí biển trong lành.</p>
                            </div>
                        </div>
                    </div>
                    <div class="homestay-price">
                        <div class="discount-badge">Giảm 25%</div>
                        <div class="original-price">VND 698.000</div>
                        <div class="final-price">VND 523.500</div>
                        <div class="price-unit">/đêm</div>
                        <div class="price-savings">Tiết kiệm VND 174.500</div>
                        <a href="<%= request.getContextPath() %>/room/1" class="view-btn" style="text-decoration: none; display: inline-block; text-align: center;">Xem chỗ trống</a>
                    </div>
                </div>
                <div class="homestay-card fade-in-up" data-amenities="wifi,parking,pool,restaurant,reception" data-property-type="resort" data-cancellation="free" data-price="2500000">
                    <div class="homestay-image">
                        <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2068&q=80" alt="Homestay mẫu 2">
                    </div>
                    <div class="homestay-info">
                        <div>
                            <h3 class="homestay-name">
                                <a href="<%= request.getContextPath() %>/room/2" style="text-decoration: none; color: inherit;">
                                    Resort Phố Cổ Quy Nhơn
                                </a>
                            </h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Quy Nhơn, Bình Định
                            </p>
                            <div class="homestay-features">
                                <span class="feature-tag">Wi-Fi miễn phí</span>
                                <span class="feature-tag">Bãi đậu xe</span>
                                <span class="feature-tag">Hồ bơi</span>
                                <span class="feature-tag">Nhà hàng</span>
                                <span class="feature-tag">Lễ tân 24 giờ</span>
                            </div>
                            <!-- Mô tả homestay -->
                            <div class="homestay-description">
                                <p class="description-text">Resort cao cấp với kiến trúc phố cổ độc đáo, kết hợp giữa vẻ đẹp truyền thống và tiện nghi hiện đại. Hồ bơi ngoài trời, spa và nhà hàng phục vụ ẩm thực địa phương.</p>
                            </div>
                        </div>
                    </div>
                    <div class="homestay-price">
                        <div class="discount-badge">Giảm 15%</div>
                        <div class="original-price">VND 1.047.000</div>
                        <div class="final-price">VND 890.000</div>
                        <div class="price-unit">/đêm</div>
                        <div class="price-savings">Tiết kiệm VND 157.000</div>
                        <a href="<%= request.getContextPath() %>/room/2" class="view-btn" style="text-decoration: none; display: inline-block; text-align: center;">Xem chỗ trống</a>
                    </div>
                </div>
                <div class="homestay-card fade-in-up" data-amenities="wifi,parking,pool,restaurant,reception" data-property-type="hotel" data-cancellation="free" data-price="1800000">
                    <div class="homestay-image">
                        <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu 3">
                    </div>
                    <div class="homestay-info">
                        <div>
                            <h3 class="homestay-name">
                                <a href="<%= request.getContextPath() %>/room/3" style="text-decoration: none; color: inherit;">
                                    Khách sạn Biển Xanh
                                </a>
                            </h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Quy Nhơn, Bình Định
                            </p>
                            <div class="homestay-features">
                                <span class="feature-tag">Wi-Fi miễn phí</span>
                                <span class="feature-tag">Bãi đậu xe</span>
                                <span class="feature-tag">Hồ bơi</span>
                                <span class="feature-tag">Nhà hàng</span>
                                <span class="feature-tag">Lễ tân 24 giờ</span>
                                <span class="feature-tag">Gym</span>
                                <span class="feature-tag">Bar</span>
                            </div>
                            <!-- Mô tả homestay -->
                            <div class="homestay-description">
                                <p class="description-text">Khách sạn 4 sao với view biển tuyệt đẹp, phòng nghỉ sang trọng và đầy đủ tiện nghi. Gym hiện đại, bar rooftop và dịch vụ lễ tân 24/7 đáp ứng mọi nhu cầu của khách hàng.</p>
                            </div>
                        </div>
                    </div>
                    <div class="homestay-price">
                        <div class="discount-badge">Giảm 20%</div>
                        <div class="original-price">VND 812.500</div>
                        <div class="final-price">VND 650.000</div>
                        <div class="price-unit">/đêm</div>
                        <div class="price-savings">Tiết kiệm VND 162.500</div>
                        <a href="<%= request.getContextPath() %>/room/3" class="view-btn" style="text-decoration: none; display: inline-block; text-align: center;">Xem chỗ trống</a>
                    </div>
                </div>
                <div class="homestay-card fade-in-up" data-amenities="wifi,parking,pool,restaurant" data-property-type="villa" data-cancellation="free" data-price="3000000">
                    <div class="homestay-image">
                        <img src="https://images.unsplash.com/photo-1521783988139-89397d761dce?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu 4">
                    </div>
                    <div class="homestay-info">
                        <div>
                            <h3 class="homestay-name">
                                <a href="<%= request.getContextPath() %>/room/4" style="text-decoration: none; color: inherit;">
                                    Villa Biển Premium
                                </a>
                            </h3>
                            <p class="homestay-location">
                                <i class="fas fa-map-marker-alt"></i>
                                Quy Nhơn, Bình Định
                            </p>
                            <div class="homestay-features">
                                <span class="feature-tag">Wi-Fi miễn phí</span>
                                <span class="feature-tag">Bãi đậu xe</span>
                                <span class="feature-tag">Hồ bơi</span>
                                <span class="feature-tag">Nhà hàng</span>
                                <span class="feature-tag">Villa riêng biệt</span>
                                <span class="feature-tag">Hồ bơi riêng</span>
                                <span class="feature-tag">Bếp đầy đủ</span>
                            </div>
                            <!-- Mô tả homestay -->
                            <div class="homestay-description">
                                <p class="description-text">Villa cao cấp với thiết kế độc đáo, hồ bơi riêng biệt và bếp đầy đủ tiện nghi. Không gian riêng tư, sang trọng, lý tưởng cho gia đình hoặc nhóm bạn muốn tận hưởng kỳ nghỉ hoàn hảo.</p>
                            </div>
                        </div>
                    </div>
                    <div class="homestay-price">
                        <div class="discount-badge">Giảm 40%</div>
                        <div class="original-price">VND 2.500.000</div>
                        <div class="final-price">VND 1.500.000</div>
                        <div class="price-unit">/đêm</div>
                        <div class="price-savings">Tiết kiệm VND 1.000.000</div>
                        <a href="<%= request.getContextPath() %>/room/4" class="view-btn" style="text-decoration: none; display: inline-block; text-align: center;">Xem chỗ trống</a>
                    </div>
                </div>
                <!-- Thông báo không có kết quả -->
                <div id="no-results-message" style="display:none; text-align:center; padding:40px 0; color:#888;">
                    <i class="fas fa-search" style="font-size:40px; margin-bottom: 20px; display: block;"></i>
                    <h3 style="margin-bottom: 10px; color: #666;">Không tìm thấy homestay phù hợp</h3>
                    <div style="margin-bottom: 20px;">Không có homestay nào thỏa mãn các tiêu chí lọc bạn đã chọn.</div>
                    <div style="font-size: 14px; color: #999;">
                        <p>💡 Gợi ý:</p>
                        <ul style="list-style: none; padding: 0; margin: 10px 0;">
                            <li>• Thử bỏ bớt một số bộ lọc</li>
                            <li>• Mở rộng khoảng giá</li>
                            <li>• Chọn thêm loại tiện nghi</li>
                        </ul>
                    </div>
                </div>
            <% } %>
        </main>
    </div>

    <script>
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

        // Filter functionality
        function filterHomestays() {
            const checkedAmenities = Array.from(document.querySelectorAll('input[name="amenities"]:checked')).map(cb => cb.value);
            const checkedTypes = Array.from(document.querySelectorAll('input[name="propertyType"]:checked')).map(cb => cb.value);
            const checkedCancel = Array.from(document.querySelectorAll('input[name="cancellation"]:checked')).map(cb => cb.value);
            const minPrice = parseInt(document.getElementById('minPrice').value) || 100000;
            const maxPrice = parseInt(document.getElementById('maxPrice').value) || 3000000;

            let visibleCount = 0;
            document.querySelectorAll('.homestay-card').forEach(card => {
                let show = true;

                // Lọc theo tiện nghi
                if (checkedAmenities.length > 0) {
                    const cardAmenities = (card.dataset.amenities || '').split(',').map(a => a.trim());
                    const hasAllAmenities = checkedAmenities.every(amenity => 
                        cardAmenities.some(cardAmenity => 
                            cardAmenity.includes(amenity) || amenity.includes(cardAmenity)
                        )
                    );
                    if (!hasAllAmenities) show = false;
                }

                // Lọc theo loại chỗ nghỉ
                if (checkedTypes.length > 0) {
                    if (!checkedTypes.includes(card.dataset.propertyType)) show = false;
                }

                // Lọc theo chính sách hủy
                if (checkedCancel.length > 0) {
                    if (!checkedCancel.includes(card.dataset.cancellation)) show = false;
                }

                // Lọc theo giá
                const cardPrice = parseInt(card.dataset.price) || 0;
                if (cardPrice > 0 && (cardPrice < minPrice || cardPrice > maxPrice)) {
                    show = false;
                }

                card.style.display = show ? '' : 'none';
                if (show) visibleCount++;
            });

            // Hiện thông báo nếu không có kết quả
            const noResultsMessage = document.getElementById('no-results-message');
            if (noResultsMessage) {
                noResultsMessage.style.display = (visibleCount === 0) ? 'block' : 'none';
            }
            
            // Cập nhật số lượng kết quả hiển thị
            const resultsCount = document.querySelector('.results-count');
            if (resultsCount) {
                const totalResults = document.querySelectorAll('.homestay-card').length;
                if (visibleCount === 0) {
                    resultsCount.textContent = 'Không tìm thấy homestay nào phù hợp với bộ lọc đã chọn';
                } else {
                    resultsCount.textContent = `Hiển thị ${visibleCount} trong tổng số ${totalResults} homestay`;
                }
            }
        }

        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', filterHomestays);
        });

        // Thêm event listener cho price range
        document.getElementById('minPrice').addEventListener('input', filterHomestays);
        document.getElementById('maxPrice').addEventListener('input', filterHomestays);
        document.getElementById('priceSlider').addEventListener('input', filterHomestays);

        // Clear filters functionality
        document.getElementById('clear-filters').addEventListener('click', function() {
            // Uncheck all checkboxes
            document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
                checkbox.checked = false;
            });
            
            // Reset price range
            document.getElementById('minPrice').value = '100000';
            document.getElementById('maxPrice').value = '3000000';
            document.getElementById('priceSlider').value = '3000000';
            
            // Update price range display
            updatePriceRange();
            
            // Re-run filter to show all results
            filterHomestays();
        });

        // Price range slider functionality
        const priceSlider = document.getElementById('priceSlider');
        const minPriceInput = document.getElementById('minPrice');
        const maxPriceInput = document.getElementById('maxPrice');
        const priceRangeText = document.querySelector('.price-range-text');

        function formatPrice(price) {
            return Number(price).toLocaleString('vi-VN');
        }

        function updatePriceRange() {
            const minPrice = minPriceInput.value || 100000;
            const maxPrice = maxPriceInput.value || 3000000;
            try {
                priceRangeText.textContent = `VND ${formatPrice(minPrice)} - VND ${formatPrice(maxPrice)}+`;
            } catch (error) {
                console.error('Error in updatePriceRange:', error);
                priceRangeText.textContent = `VND ${minPrice.toLocaleString('vi-VN')} - VND ${maxPrice.toLocaleString('vi-VN')}+`;
            }
        }

        // Update price range text when inputs change
        minPriceInput.addEventListener('input', updatePriceRange);
        maxPriceInput.addEventListener('input', updatePriceRange);

        // Update slider when inputs change
        minPriceInput.addEventListener('input', function() {
            const min = parseInt(this.value) || 100000;
            const max = parseInt(maxPriceInput.value) || 3000000;
            
            if (min > max) {
                maxPriceInput.value = min;
            }
            updatePriceRange();
        });

        maxPriceInput.addEventListener('input', function() {
            const min = parseInt(minPriceInput.value) || 100000;
            const max = parseInt(this.value) || 3000000;
            
            if (max < min) {
                minPriceInput.value = max;
            }
            updatePriceRange();
        });

        // Update inputs when slider changes
        priceSlider.addEventListener('input', function() {
            const value = parseInt(this.value);
            maxPriceInput.value = value;
            updatePriceRange();
        });

        // Initialize price range
        updatePriceRange();
        
        // Test formatPrice function
        console.log('Testing formatPrice function...');
        console.log('formatPrice(100000):', formatPrice(100000));
        console.log('formatPrice(3000000):', formatPrice(3000000));

        // Sort functionality
        document.querySelector('.sort-dropdown').addEventListener('change', function() {
            const sortValue = this.value;
            // Implement sorting logic here
            console.log('Sort by:', sortValue);
        });

        // Auto discount calculation system
        class DiscountCalculator {
            constructor() {
                this.discountRules = {
                    // Quy tắc giảm giá dựa trên giá
                    priceBased: [
                        { minPrice: 0, maxPrice: 500000, discount: 0.10 },      // 10% cho giá < 500k
                        { minPrice: 500000, maxPrice: 1000000, discount: 0.15 }, // 15% cho giá 500k-1M
                        { minPrice: 1000000, maxPrice: 2000000, discount: 0.20 }, // 20% cho giá 1M-2M
                        { minPrice: 2000000, maxPrice: 5000000, discount: 0.25 }, // 25% cho giá 2M-5M
                        { minPrice: 5000000, maxPrice: Infinity, discount: 0.30 }  // 30% cho giá > 5M
                    ],
                    // Quy tắc giảm giá theo mùa (có thể mở rộng)
                    seasonal: {
                        highSeason: { months: [6, 7, 8, 12, 1, 2], discount: 0.05 },  // Mùa cao điểm: +5%
                        lowSeason: { months: [3, 4, 5, 9, 10, 11], discount: 0.10 }   // Mùa thấp điểm: +10%
                    }
                };
            }

            // Tính toán giảm giá tự động
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

            // Tạo badge giảm giá với màu sắc động
            getDiscountBadgeColor(discountPercent) {
                if (discountPercent >= 40) return '#d32f2f';      // Đỏ đậm cho giảm cao
                if (discountPercent >= 25) return '#e31e24';      // Đỏ cho giảm trung bình
                if (discountPercent >= 15) return '#f57c00';      // Cam cho giảm thấp
                return '#388e3c';                                 // Xanh cho giảm nhỏ
            }

            // Format giá theo định dạng Việt Nam
            formatPrice(price) {
                return new Intl.NumberFormat('vi-VN').format(price);
            }
        }

        // Khởi tạo calculator
        const discountCalculator = new DiscountCalculator();

                        // Cập nhật tất cả homestay cards với giảm giá tự động
        function updateAllHomestayPrices() {
            const homestayCards = document.querySelectorAll('.homestay-card');
            
            homestayCards.forEach((card, index) => {
                const priceSection = card.querySelector('.homestay-price');
                if (!priceSection) return;

                // Tạo giá cơ bản dựa trên index (để tạo sự đa dạng)
                const basePrices = [523500, 890000, 650000, 1500000, 750000, 1200000];
                const basePrice = basePrices[index] || 500000;

                // Tính toán giảm giá
                const discountData = discountCalculator.calculateDiscount(basePrice);

                // Cập nhật giao diện
                priceSection.innerHTML = `
                     <div class="discount-badge" style="background: ${discountCalculator.getDiscountBadgeColor(discountData.discountPercent)}">
                         Giảm ${discountData.discountPercent}%
                     </div>
                     <div class="original-price">VND ${discountCalculator.formatPrice(discountData.originalPrice)}</div>
                     <div class="final-price">VND ${discountCalculator.formatPrice(discountData.finalPrice)}</div>
                     <div class="price-unit">/đêm</div>
                     <div class="price-savings">Tiết kiệm VND ${discountCalculator.formatPrice(discountData.savings)}</div>
                     <a href="<%= request.getContextPath() %>/room/${index + 1}" class="view-btn">Xem chỗ trống</a>
                 `;
            });
        }

        // Cập nhật mô tả homestay demo
        function updateHomestayDescriptions() {
            const homestayCards = document.querySelectorAll('.homestay-card');
            const descriptions = [
                "Homestay biển xinh đẹp với view biển tuyệt đẹp, không gian thoáng đãng và tiện nghi hiện đại. Nơi lý tưởng để nghỉ dưỡng và tận hưởng không khí biển trong lành.",
                "Resort cao cấp với kiến trúc phố cổ độc đáo, kết hợp giữa vẻ đẹp truyền thống và tiện nghi hiện đại. Hồ bơi ngoài trời, spa và nhà hàng phục vụ ẩm thực địa phương.",
                "Khách sạn 4 sao với view biển tuyệt đẹp, phòng nghỉ sang trọng và đầy đủ tiện nghi. Gym hiện đại, bar rooftop và dịch vụ lễ tân 24/7 đáp ứng mọi nhu cầu của khách hàng.",
                "Villa cao cấp với thiết kế độc đáo, hồ bơi riêng biệt và bếp đầy đủ tiện nghi. Không gian riêng tư, sang trọng, lý tưởng cho gia đình hoặc nhóm bạn muốn tận hưởng kỳ nghỉ hoàn hảo."
            ];

            homestayCards.forEach((card, index) => {
                const descriptionSection = card.querySelector('.homestay-description');
                if (descriptionSection && descriptions[index]) {
                    const descriptionText = descriptionSection.querySelector('.description-text');
                    if (descriptionText) {
                        descriptionText.textContent = descriptions[index];
                    }
                }
            });
        }

        // Cập nhật giá khi trang load
        document.addEventListener('DOMContentLoaded', function() {
            updateAllHomestayPrices();
            updateHomestayDescriptions();
        });

        // Cập nhật giá khi filter thay đổi (có thể mở rộng)
        document.querySelectorAll('input[type="checkbox"]').forEach(checkbox => {
            checkbox.addEventListener('change', function() {
                // Có thể thêm logic cập nhật giá dựa trên filter
                console.log('Filter changed:', this.name, this.value, this.checked);
            });
        });

        // Thêm nút refresh giá (để demo)
        const resultsHeader = document.querySelector('.results-header');
        if (resultsHeader) {
            const refreshBtn = document.createElement('button');
            refreshBtn.innerHTML = '<i class="fas fa-sync-alt"></i> Làm mới giá';
            refreshBtn.className = 'refresh-btn';
            refreshBtn.style.cssText = `
                background: #28a745;
                color: white;
                border: none;
                padding: 8px 16px;
                border-radius: 4px;
                font-size: 14px;
                cursor: pointer;
                margin-left: 15px;
                transition: background 0.3s ease;
            `;
            refreshBtn.addEventListener('mouseenter', () => {
                refreshBtn.style.background = '#218838';
            });
            refreshBtn.addEventListener('mouseleave', () => {
                refreshBtn.style.background = '#28a745';
            });
            refreshBtn.addEventListener('click', function() {
                updateAllHomestayPrices();
                updateHomestayDescriptions();
            });
            resultsHeader.appendChild(refreshBtn);
        }
    </script>
</body>
</html>
