<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Homestay" %>
<%@ page import="com.homestay.model.Room" %>
<%@ page import="com.homestay.model.Service" %>
<%@ page import="java.util.List" %>
<%@ page import="java.math.BigDecimal" %>
<%@ include file="../partials/header.jsp" %>
<%
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<com.homestay.model.HomestayImage> images = (List<com.homestay.model.HomestayImage>) request.getAttribute("images");
    BigDecimal minPrice = (BigDecimal) request.getAttribute("minPrice");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= homestay != null ? homestay.getName() : "Chi tiết Homestay" %></title>
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
        
        /* Header Section */
        .property-header {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .property-header-top {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
        }
        
        .property-info {
            flex: 1;
        }
        

        
        .property-title {
            font-size: 28px;
            font-weight: 600;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .property-address {
            color: #666;
            font-size: 16px;
            margin-bottom: 12px;
        }
        

        
        /* Image Gallery */
        .image-gallery {
            display: grid;
            grid-template-columns: 2fr 1fr 1fr;
            grid-template-rows: 1fr 1fr;
            gap: 8px;
            height: 400px;
            margin-bottom: 24px;
            border-radius: 12px;
            overflow: hidden;
        }
        
        .main-image {
            grid-row: 1 / 3;
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 18px;
        }
        
        .main-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .thumbnail {
            background: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #666;
            font-size: 14px;
            cursor: pointer;
            transition: opacity 0.3s;
        }
        
        .thumbnail:hover {
            opacity: 0.8;
        }
        
        .thumbnail img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .more-photos {
            background: rgba(0,0,0,0.7);
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
        }
        
        /* Main Content Layout */
        .main-content {
            display: grid;
            grid-template-columns: 2fr 1fr;
            gap: 24px;
        }
        
        .content-left {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .content-right {
            background: white;
            border-radius: 12px;
            padding: 24px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            height: fit-content;
            position: sticky;
            top: 20px;
        }
        
        /* Tabs */
        .tabs {
            display: flex;
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 24px;
        }
        
        .tab {
            padding: 12px 24px;
            cursor: pointer;
            border-bottom: 2px solid transparent;
            font-weight: 500;
            color: #666;
            transition: all 0.3s;
        }
        
        .tab.active {
            color: #003580;
            border-bottom-color: #003580;
        }
        
        .tab:hover {
            color: #003580;
        }
        
        .tab-content {
            display: none;
        }
        
        .tab-content.active {
            display: block;
        }
        
        /* Property Highlights */
        .highlights {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 24px;
        }
        
        .highlight-item {
            display: flex;
            align-items: center;
            gap: 8px;
            margin-bottom: 8px;
        }
        
        .highlight-item:last-child {
            margin-bottom: 0;
        }
        
        .highlight-icon {
            width: 20px;
            height: 20px;
            background: #003580;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 12px;
        }
        
        /* Description */
        .description {
            margin-bottom: 24px;
        }
        
        .description h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 12px;
            color: #1a1a1a;
        }
        
        .description p {
            color: #666;
            line-height: 1.7;
        }
        
        /* Facilities */
        .facilities {
            margin-bottom: 24px;
        }
        
        .facilities h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #1a1a1a;
        }
        
        .facilities-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
            gap: 12px;
        }
        
        .facility-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
        }
        
        .facility-icon {
            width: 16px;
            height: 16px;
            background: #003580;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 10px;
        }
        
        /* Booking Sidebar */
        .booking-card {
            background: #f8f9fa;
            border-radius: 8px;
            padding: 20px;
            margin-bottom: 20px;
        }
        
        .price-display {
            font-size: 24px;
            font-weight: 700;
            color: #1a1a1a;
            margin-bottom: 8px;
        }
        
        .price-note {
            color: #666;
            font-size: 14px;
            margin-bottom: 20px;
        }
        
        .booking-form {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .form-group {
            display: flex;
            flex-direction: column;
        }
        
        .form-group label {
            font-size: 14px;
            font-weight: 500;
            color: #1a1a1a;
            margin-bottom: 4px;
        }
        
        .form-group input, .form-group select {
            padding: 12px;
            border: 1px solid #d1d5db;
            border-radius: 6px;
            font-size: 14px;
        }
        
        .form-group input:focus, .form-group select:focus {
            outline: none;
            border-color: #003580;
            box-shadow: 0 0 0 3px rgba(0, 53, 128, 0.1);
        }
        
        .reserve-btn {
            background: #003580;
            color: white;
            border: none;
            padding: 16px;
            border-radius: 6px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.3s;
        }
        
        .reserve-btn:hover {
            background: #002966;
        }
        
        .book-now-btn {
            background: #ff6b35;
            color: white;
            border: none;
            padding: 16px 24px;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s;
            width: 100%;
            margin-bottom: 8px;
        }
        
        .book-now-btn:hover {
            background: #e55a2b;
            transform: translateY(-1px);
            box-shadow: 0 4px 12px rgba(255, 107, 53, 0.3);
        }
        
        .book-now-note {
            font-size: 12px;
            color: #666;
            text-align: center;
            margin: 0;
        }
        
        /* Rooms Section */
        .rooms-section {
            margin-bottom: 24px;
        }
        
        .rooms-section h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 16px;
            color: #1a1a1a;
        }
        
        .room-card {
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 16px;
            margin-bottom: 12px;
        }
        
        .room-header {
            display: flex;
            justify-content: between;
            align-items: center;
            margin-bottom: 8px;
        }
        
        .room-type {
            font-size: 16px;
            font-weight: 600;
            color: #1a1a1a;
        }
        
        .room-price {
            font-size: 18px;
            font-weight: 700;
            color: #003580;
        }
        
        .room-description {
            color: #666;
            font-size: 14px;
            margin-bottom: 8px;
        }
        
        .room-amenities {
            display: flex;
            flex-wrap: wrap;
            gap: 8px;
        }
        
        .amenity-tag {
            background: #f3f4f6;
            color: #374151;
            padding: 4px 8px;
            border-radius: 4px;
            font-size: 12px;
        }
        
        /* Responsive */
        @media (max-width: 768px) {
            .main-content {
                grid-template-columns: 1fr;
            }
            
            .image-gallery {
                grid-template-columns: 1fr;
                grid-template-rows: 200px 100px 100px;
                height: auto;
            }
            
            .main-image {
                grid-row: 1;
            }
            
            .tabs {
                flex-wrap: wrap;
            }
            
            .tab {
                padding: 8px 16px;
                font-size: 14px;
            }
            
            .property-header-top {
                flex-direction: column;
                gap: 16px;
            }
            
            .property-actions {
                margin-left: 0;
                justify-content: center;
            }
            
            .similar-grid {
                grid-template-columns: 1fr;
            }
            
            .facilities-grid {
                grid-template-columns: 1fr;
            }
        }
        
        /* Utility Classes */
        .text-center { text-align: center; }
        .mb-16 { margin-bottom: 16px; }
        .mb-24 { margin-bottom: 24px; }
        .text-gray { color: #666; }
        .text-primary { color: #003580; }
        .font-semibold { font-weight: 600; }
        .font-bold { font-weight: 700; }
        .hidden-during-lightbox { display: none !important; }

        /* Lightbox nav buttons */
        .lb-nav {
            position: absolute; top: 50%; transform: translateY(-50%);
            background: rgba(255,255,255,0.85); color: #111;
            border: none; width: 44px; height: 44px; border-radius: 999px;
            display: flex; align-items: center; justify-content: center;
            font-size: 20px; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.25);
        }
        .lb-prev { left: 16px; }
        .lb-next { right: 16px; }
        .lb-nav:hover { background: #fff; }

        /* Thumbnail strip in lightbox: single row, hidden scrollbar */
        .thumb-strip { overflow-x: auto; white-space: nowrap; max-width: 1200px; width: 100%; }
        .thumb-strip::-webkit-scrollbar { display: none; }
        .thumb-strip { -ms-overflow-style: none; scrollbar-width: none; }
        .lb-thumb { height: 88px; border-radius: 6px; cursor: pointer; margin-right: 8px; border: 2px solid transparent; }
        .lb-thumb.active { border-color: #3b82f6; }
    </style>
</head>
<body>
    <!-- Top booking-like search bar on detail page -->
    <div style="position:sticky; top:0; z-index:50; background:#003580; padding:16px 0;">
        <div style="max-width:1200px; margin:0 auto; padding:0 16px;">
            <form method="get" action="<%= request.getContextPath() %>/homestays" style="background:#fff; border:2px solid #febb02; border-radius:12px; display:grid; grid-template-columns: 1.2fr 1fr 1fr 1fr 160px; gap:8px; padding:10px; align-items:center;">
                <div style="display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; border:1px solid #e5e7eb;">
                    <span>🏨</span>
                    <input type="text" name="q" placeholder="Bạn muốn đi đâu?" value="<%= request.getAttribute("q") != null ? request.getAttribute("q") : (homestay!=null?homestay.getAddress():"") %>" style="border:none; outline:none; width:100%; font-size:14px;">
                </div>
                <div style="display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; border:1px solid #e5e7eb;">
                    <span>📅</span>
                    <input type="date" name="checkin" min="<%= java.time.LocalDate.now() %>" value="<%= request.getAttribute("checkin") != null ? request.getAttribute("checkin") : "" %>" style="border:none; outline:none; width:100%; font-size:14px;">
                </div>
                <div style="display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; border:1px solid #e5e7eb;">
                    <span>📅</span>
                    <input type="date" name="checkout" min="<%= java.time.LocalDate.now().plusDays(1) %>" value="<%= request.getAttribute("checkout") != null ? request.getAttribute("checkout") : "" %>" style="border:none; outline:none; width:100%; font-size:14px;">
                </div>
                <div style="display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; border:1px solid #e5e7eb;">
                    <span>🛏️</span>
                    <select name="roomType" style="border:none; outline:none; width:100%; font-size:14px;">
                        <%
                            String rt2 = (String) request.getAttribute("roomType");
                            String[][] types2 = new String[][]{
                                {"", "Tất cả loại phòng"},
                                {"đơn", "Phòng đơn"},
                                {"đôi", "Phòng đôi"},
                                {"hai giường", "Phòng hai giường"},
                                {"gia đình", "Phòng gia đình"},
                                {"studio", "Studio"},
                                {"căn hộ", "Căn hộ"}
                            };
                            for (String[] it : types2) {
                        %>
                        <option value="<%= it[0] %>" <%= (rt2 != null && rt2.equalsIgnoreCase(it[0])) ? "selected" : "" %>><%= it[1] %></option>
                        <% } %>
                    </select>
                </div>
                <button type="submit" style="background:#0071c2; color:#fff; border:none; border-radius:10px; padding:12px 16px; font-weight:700; cursor:pointer;">Search</button>
            </form>
        </div>

        <!-- Lightbox Modal -->
        <div id="photoModal" style="display:none; position:fixed; inset:0; background:rgba(0,0,0,0.9); z-index:9999;">
            <div style="position:absolute; top:12px; right:16px; color:#fff; font-size:26px; cursor:pointer;" onclick="closePhotos()">✕</div>
            <div style="position:absolute; top:60px; left:0; right:0; bottom:0; display:flex; flex-direction:column; align-items:center;">
                <div style="max-width:1200px; width:100%; padding:0 16px;">
                    <button class="lb-nav lb-prev" onclick="prevPhoto()">‹</button>
                    <img id="modalMain" src="" style="width:100%; max-height:70vh; object-fit:contain; border-radius:8px;" />
                    <button class="lb-nav lb-next" onclick="nextPhoto()">›</button>
                </div>
                <div id="thumbStrip" class="thumb-strip" style="padding:12px 16px;">
                    <% if (images != null && !images.isEmpty()) { int idx=0; for (com.homestay.model.HomestayImage im : images) { String src = request.getContextPath() + "/" + im.getFilePath(); %>
                        <img src="<%= src %>" class="lb-thumb" data-index="<%= idx++ %>" onclick="setModalMain('<%= src %>', <%= idx-1 %>)" />
                    <% } } %>
                </div>
            </div>
        </div>
    </div>
    <div class="container">
        <!-- Property Header -->
        <div class="property-header">
            <div class="property-header-top">
                <div class="property-info">
                    <h1 class="property-title"><%= homestay != null ? homestay.getName() : "Homestay" %></h1>
                    <div class="property-address">
                        📍 <%= homestay != null && homestay.getAddress() != null ? homestay.getAddress() : "Chưa cập nhật địa chỉ" %>
                    </div>
                </div>               
            </div>
        </div>
        
        <!-- Image Gallery -->
        <div class="image-gallery">
            <div class="main-image">
                <% if (images != null && !images.isEmpty()) { %>
                    <img src="<%= request.getContextPath() + "/" + images.get(0).getFilePath() %>" alt="<%= homestay.getName() %>" id="mainImage" style="cursor:pointer" onclick="openLightboxAt(0)">
                <% } else if (homestay != null && homestay.getImage() != null && !homestay.getImage().trim().isEmpty()) { %>
                    <img src="<%= homestay.getImage() %>" alt="<%= homestay.getName() %>" id="mainImage" style="cursor:pointer" onclick="openLightboxAt(0)">
                <% } else { %>
                    <span>Hình ảnh chính</span>
                <% } %>
            </div>
            <%-- Render tối đa 3 thumbnail tiếp theo --%>
            <% if (images != null && images.size() > 1) { 
                   int limit = Math.min(images.size(), 5);
                   for (int i = 1; i < limit - 1; i++) { com.homestay.model.HomestayImage im = images.get(i); String thumbSrc = request.getContextPath() + "/" + im.getFilePath(); %>
                <div class="thumbnail" onclick="openLightboxAt(<%= i %>)" style="cursor:pointer">
                    <img src="<%= thumbSrc %>" alt="thumb"/>
                </div>
            <% } %>
            <% if (images.size() >= 5) { %>
                <div class="more-photos" onclick="showAllPhotos()">+<%= images.size() - 4 %> ảnh</div>
            <% } else { %>
                <div class="thumbnail" onclick="changeMainImage(this)"><span>Phòng tắm</span></div>
                <div class="thumbnail" onclick="changeMainImage(this)"><span>Khu vực chung</span></div>
            <% } } else { %>
                <div class="thumbnail"><span>Phòng ngủ</span></div>
                <div class="thumbnail"><span>Phòng tắm</span></div>
                <div class="thumbnail"><span>Khu vực chung</span></div>
                <div class="more-photos">+11 ảnh</div>
            <% } %>
        </div>

        <!-- Main Content -->
        <div class="main-content">
            <!-- Left Content -->
            <div class="content-left">
                <!-- Tabs -->
                <div class="tabs">
                    <div class="tab active" onclick="showTab('overview')">Tổng quan</div>                  
                </div>
                
                <!-- Tab Content -->
                <div id="overview" class="tab-content active">
                    <!-- Description -->
                    <div class="description">
                        <h3>Về homestay này</h3>
                        <p>
                            <%= homestay != null && homestay.getDescription() != null ? homestay.getDescription() : "Vị trí ven biển tuyệt vời với bãi biển riêng, tầm nhìn ra vườn, và chỗ ở thoải mái với điều hòa, sân thượng, bếp nhỏ, phòng tắm riêng với vòi sen, máy giặt và WiFi miễn phí." %>
                        </p>
                    </div>

                    <!-- Most Popular Facilities -->
                    <div class="facilities">
                        <h3>Tiện ích</h3>
                        <div class="facilities-grid">
                            <% 
                                boolean hasFree = false;
                                if (services != null && !services.isEmpty()) { 
                                    for (Service service : services) { 
                                        java.math.BigDecimal p = service.getPrice();
                                        if (p == null || p.compareTo(java.math.BigDecimal.ZERO) == 0) {
                            %>
                                <div class="facility-item">
                                    <div class="facility-icon">✓</div>
                                    <span><%= service.getName() %></span>
                                </div>
                            <%          hasFree = true; 
                                        }
                                    }
                                }
                                if (!hasFree) { 
                            %>
                                <div class="text-gray">Chưa có tiện ích miễn phí.</div>
                            <% } %>
                        </div>
                    </div>
                </div>               
            </div>

            <!-- Right Sidebar -->
            <div class="content-right">
                <div class="booking-card">
                    <div class="price-display">
                        <% if (minPrice != null && minPrice.compareTo(BigDecimal.ZERO) > 0) { %>
                            <%
                                java.text.NumberFormat formatter = java.text.NumberFormat.getNumberInstance(new java.util.Locale("vi", "VN"));
                                formatter.setMinimumFractionDigits(0);
                                formatter.setMaximumFractionDigits(0);
                            %>
                            Từ <%= formatter.format(minPrice) %> đ/đêm
                        <% } else { %>
                            Liên hệ để biết giá
                        <% } %>
                    </div>
                    <div class="price-note">Đã bao gồm thuế và phí</div>
                    <div id="discount-info" class="price-note" style="display:none; color:#065f46; background:#ecfdf5; padding:8px; border-radius:6px; margin-top:8px;">
                        <!-- filled by script -->
                    </div>
                    
                    <div class="booking-form">
                        <div class="form-group">
                            <label>Ngày nhận phòng</label>
                            <input type="date" name="checkin" id="booking-checkin" min="<%= java.time.LocalDate.now() %>" required>
                        </div>
                        <div class="form-group">
                            <label>Ngày trả phòng</label>
                            <input type="date" name="checkout" id="booking-checkout" min="<%= java.time.LocalDate.now().plusDays(1) %>" required>
                        </div>
                        <div class="form-group">
                            <label>Loại phòng</label>
                            <select name="roomType" id="booking-roomType">
                                <option value="">Tất cả loại phòng</option>
                                <%-- Lấy loại phòng từ danh sách rooms của homestay --%>
                                <%
                                    java.util.Set<String> _types = new java.util.LinkedHashSet<>();
                                    if (rooms != null) {
                                        for (Room r : rooms) {
                                            if (r.getType() != null && !r.getType().trim().isEmpty()) {
                                                _types.add(r.getType());
                                            }
                                        }
                                    }
                                    for (String t : _types) {
                                %>
                                    <option value="<%= t %>"><%= t %></option>
                                <% } %>
                            </select>
                        </div>
                    </div>
                    
                    <!-- Book Now Button -->
                    <div class="book-now-section" style="margin-top: 16px;">
                        <button class="book-now-btn" 
                                onclick="bookNow()"
                                data-homestay-id="<%= homestay != null ? homestay.getId() : "" %>"
                                data-context-path="<%= request.getContextPath() %>">
                            🏨 Đặt ngay
                        </button>
                        <p class="book-now-note">Đặt ngay để đảm bảo phòng tốt nhất</p>
                    </div>
                </div>
                
                <!-- Contact Info -->
                <div class="contact-info">
                    <h4>Thông tin liên hệ</h4>
                    <% if (homestay != null && homestay.getPhone() != null) { %>
                        <p><strong>Điện thoại:</strong> <%= homestay.getPhone() %></p>
                    <% } %>
                    <% if (homestay != null && homestay.getEmail() != null) { %>
                        <p><strong>Email:</strong> <%= homestay.getEmail() %></p>
                    <% } %>
                </div>
                </div>
            </div>
            
        <!-- Questions & Answers Section -->
        <div class="qa-section">
            <div class="qa-header">
                <h3>Câu hỏi thường gặp về <%= homestay != null ? homestay.getName() : "Homestay" %></h3>
            </div>
            <div class="qa-list">
                <div class="qa-item">
                    <div class="qa-question" onclick="toggleQA(this)">
                        <span>Có bữa sáng không?</span>
                        <span class="qa-toggle">+</span>
                    </div>
                    <div class="qa-answer">
                        <p>Có, homestay cung cấp dịch vụ bữa sáng miễn phí cho khách lưu trú.</p>
                    </div>
                </div>
                <div class="qa-item">
                    <div class="qa-question" onclick="toggleQA(this)">
                        <span>Có chỗ đỗ xe không?</span>
                        <span class="qa-toggle">+</span>
                    </div>
                    <div class="qa-answer">
                        <p>Có, homestay có bãi đỗ xe riêng miễn phí cho khách.</p>
                    </div>
                </div>
                <div class="qa-item">
                    <div class="qa-question" onclick="toggleQA(this)">
                        <span>Giờ nhận phòng và trả phòng?</span>
                        <span class="qa-toggle">+</span>
                    </div>
                    <div class="qa-answer">
                        <p>Nhận phòng: 14:00, Trả phòng: 12:00</p>
                    </div>
                </div>
                <div class="qa-item">
                    <div class="qa-question" onclick="toggleQA(this)">
                        <span>Có WiFi miễn phí không?</span>
                        <span class="qa-toggle">+</span>
                    </div>
                    <div class="qa-answer">
                        <p>Có, WiFi miễn phí có sẵn trong toàn bộ homestay.</p>
                    </div>
                </div>
            </div>
            </div>                  
    </div>
    
    <script>
        // Build full image list from DB for lightbox navigation
        window.ALL_IMAGES = (function(){
            var list = [];
            try {
                <% if (images != null && !images.isEmpty()) { for (com.homestay.model.HomestayImage im : images) { %>
                    list.push('<%= (request.getContextPath() + "/" + im.getFilePath()).replace("'","\\'") %>');
                <% } } else if (homestay != null && homestay.getImage() != null) { %>
                    list.push('<%= homestay.getImage().replace("'","\\'") %>');
                <% } %>
            } catch(e) {}
            return list;
        })();
        function showTab(tabName) {
            // Hide all tab contents
            const tabContents = document.querySelectorAll('.tab-content');
            tabContents.forEach(content => content.classList.remove('active'));
            
            // Remove active class from all tabs
            const tabs = document.querySelectorAll('.tab');
            tabs.forEach(tab => tab.classList.remove('active'));
            
            // Show selected tab content
            document.getElementById(tabName).classList.add('active');
            
            // Add active class to clicked tab
            event.target.classList.add('active');
        }
        
        function changeMainImageSrc(src) {
            var main = document.getElementById('mainImage');
            if (main) main.src = src;
        }
        
        function openLightboxAt(index){
            var modal = document.getElementById('photoModal');
            var main = document.getElementById('modalMain');
            // prepare gallery list if not ready
            if (!window.__gallery || !window.__gallery.length) {
                window.__gallery = (window.ALL_IMAGES && window.ALL_IMAGES.length) ? window.ALL_IMAGES.slice() : [];
            }
            window.__galleryIndex = Math.max(0, Math.min(index || 0, window.__gallery.length - 1));
            if (main && window.__gallery.length) main.src = window.__gallery[window.__galleryIndex];
            if (modal) modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
            try {
                var header = document.querySelector('header, .site-header, .navbar');
                var footer = document.querySelector('footer, .site-footer');
                if (header) header.classList.add('hidden-during-lightbox');
                if (footer) footer.classList.add('hidden-during-lightbox');
            } catch(e) {}
            // sync thumbs
            setModalMain(window.__gallery[window.__galleryIndex], window.__galleryIndex);
        }

        function showAllPhotos() {
            var modal = document.getElementById('photoModal');
            var main = document.getElementById('modalMain');
            // default to current main image
            var current = document.getElementById('mainImage');
            if (current && main) main.src = current.src;
            if (modal) modal.style.display = 'block';
            document.body.style.overflow = 'hidden';
            // Hide header/footer while viewing photos
            try {
                var header = document.querySelector('header, .site-header, .navbar');
                var footer = document.querySelector('footer, .site-footer');
                if (header) header.classList.add('hidden-during-lightbox');
                if (footer) footer.classList.add('hidden-during-lightbox');
            } catch(e) {}

            // prepare index for navigation
            try {
                window.__gallery = (window.ALL_IMAGES && window.ALL_IMAGES.length) ? window.ALL_IMAGES.slice() : [];
                var cur = main.src;
                var idx = window.__gallery.indexOf(cur);
                window.__galleryIndex = (idx >= 0) ? idx : 0;
            } catch(e) { window.__gallery = []; window.__galleryIndex = 0; }
            setModalMain(window.__gallery[window.__galleryIndex], window.__galleryIndex);
        }

        function closePhotos(){
            var modal = document.getElementById('photoModal');
            if (modal) modal.style.display = 'none';
            document.body.style.overflow = '';
            // Restore header/footer
            try {
                var header = document.querySelector('header, .site-header, .navbar');
                var footer = document.querySelector('footer, .site-footer');
                if (header) header.classList.remove('hidden-during-lightbox');
                if (footer) footer.classList.remove('hidden-during-lightbox');
            } catch(e) {}
        }

        function setModalMain(src, index){
            var main = document.getElementById('modalMain');
            if (main) main.src = src;
            if (window.__gallery && window.__gallery.length) {
                var idx = (typeof index === 'number') ? index : window.__gallery.indexOf(src);
                if (idx >= 0) window.__galleryIndex = idx;
            }
            // highlight active thumb
            try {
                var thumbs = document.querySelectorAll('#thumbStrip .lb-thumb');
                thumbs.forEach(function(t){ t.classList.remove('active'); });
                if (typeof window.__galleryIndex === 'number' && thumbs[window.__galleryIndex]) {
                    thumbs[window.__galleryIndex].classList.add('active');
                }
                // auto-scroll thumbnail strip to keep active in view
                var strip = document.getElementById('thumbStrip');
                var active = thumbs[window.__galleryIndex];
                if (strip && active) {
                    var left = active.offsetLeft - 16;
                    var right = left + active.offsetWidth + 32;
                    if (left < strip.scrollLeft) strip.scrollLeft = left;
                    else if (right > strip.scrollLeft + strip.clientWidth) strip.scrollLeft = right - strip.clientWidth;
                }
            } catch(e) {}
        }

        function nextPhoto(){
            if (!window.__gallery || !window.__gallery.length) return;
            window.__galleryIndex = (window.__galleryIndex + 1) % window.__gallery.length;
            setModalMain(window.__gallery[window.__galleryIndex], window.__galleryIndex);
        }

        function prevPhoto(){
            if (!window.__gallery || !window.__gallery.length) return;
            window.__galleryIndex = (window.__galleryIndex - 1 + window.__gallery.length) % window.__gallery.length;
            setModalMain(window.__gallery[window.__galleryIndex], window.__galleryIndex);
        }
        
        function bookNow() {
            // Redirect to booking page or show booking modal
            // Prefer values from booking sidebar inputs
            const checkin = (document.getElementById('booking-checkin') && document.getElementById('booking-checkin').value) || document.querySelector('input[name="checkin"]').value;
            const checkout = (document.getElementById('booking-checkout') && document.getElementById('booking-checkout').value) || document.querySelector('input[name="checkout"]').value;
            const roomType = document.getElementById('booking-roomType') ? document.getElementById('booking-roomType').value : '';
            
            if (!checkin || !checkout) {
                alert('Vui lòng chọn ngày nhận phòng và trả phòng trước!');
                return;
            }
            
            // Redirect to random available room chooser
            const button = event.target;
            const homestayId = button.getAttribute('data-homestay-id');
            const contextPath = button.getAttribute('data-context-path');
            let url = contextPath + '/homestays/' + homestayId + '/book-random?checkin=' + checkin + '&checkout=' + checkout;
            if (roomType) {
                url += '&roomType=' + encodeURIComponent(roomType);
            }
            window.location.href = url;
        }
        
        // Show automatic discount info on detail page
        function updateDiscountInfo(){
            var ciInput = document.getElementById('booking-checkin');
            var coInput = document.getElementById('booking-checkout');
            if(!ciInput || !coInput) return;
            var ci = ciInput.value; var co = coInput.value;
            var info = document.getElementById('discount-info');
            if(!ci || !co){ if(info) info.style.display='none'; return; }
            try {
                var ciDate = new Date(ci);
                var coDate = new Date(co);
                var nights = Math.round((coDate - ciDate) / (1000*60*60*24));
                if (isNaN(nights) || nights <= 0) { if(info) info.style.display='none'; return; }
                var percent = 0;
                if (nights >= 7) percent = 15; else if (nights >= 3) percent = 10;
                if (percent > 0) {
                    // estimate total using minPrice if available (inject as number literal)
                    var minPrice = Number('<%= (minPrice != null ? minPrice.toPlainString() : "0") %>');
                    var total = 0;
                    try { total = Number(minPrice) * nights * (100 - percent) / 100; } catch(e) { total = 0; }
                    var fmt = new Intl.NumberFormat('vi-VN', { maximumFractionDigits: 0 });
                    info.textContent = 'Giảm giá tự động ' + percent + '% cho ' + nights + ' đêm' + (total>0 ? ' · Ước tính còn ' + fmt.format(total) + ' đ' : '');
                    info.style.display = 'block';
                } else {
                    info.style.display = 'none';
                }
            } catch(e){ if(info) info.style.display='none'; }
        }
        document.addEventListener('DOMContentLoaded', function(){
            var ci = document.getElementById('booking-checkin');
            var co = document.getElementById('booking-checkout');
            if (ci) ci.addEventListener('change', updateDiscountInfo);
            if (co) co.addEventListener('change', updateDiscountInfo);
            updateDiscountInfo();
        });
        
        function toggleQA(element) {
            const qaItem = element.closest('.qa-item');
            const answer = qaItem.querySelector('.qa-answer');
            const toggle = element.querySelector('.qa-toggle');
            
            if (answer.classList.contains('active')) {
                answer.classList.remove('active');
                qaItem.classList.remove('active');
                toggle.textContent = '+';
            } else {
                // Close all other Q&A items
                document.querySelectorAll('.qa-item.active').forEach(item => {
                    item.classList.remove('active');
                    item.querySelector('.qa-answer').classList.remove('active');
                    item.querySelector('.qa-toggle').textContent = '+';
                });
                
                // Open current item
                answer.classList.add('active');
                qaItem.classList.add('active');
                toggle.textContent = '−';
            }
        }
    </script>

    <style>
        /* Additional styles for reviews */
        .rating-item {
            display: flex;
            align-items: center;
            gap: 12px;
            margin-bottom: 8px;
        }
        
        .rating-item span:first-child {
            min-width: 100px;
            font-size: 14px;
        }
        
        .rating-bar {
            flex: 1;
            height: 8px;
            background: #e5e7eb;
            border-radius: 4px;
            overflow: hidden;
        }
        
        .rating-fill {
            height: 100%;
            background: #003580;
            transition: width 0.3s;
        }
        
        .rating-item span:last-child {
            min-width: 30px;
            text-align: right;
            font-weight: 600;
        }
        
        .review-item {
            margin-bottom: 16px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }
        
        .reviewer {
            font-weight: 600;
            color: #003580;
            margin-bottom: 4px;
        }
        
        .review-text {
            color: #666;
            font-style: italic;
        }
        
        .contact-info {
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e5e7eb;
        }
        
        .contact-info h4 {
            margin-bottom: 12px;
            color: #1a1a1a;
        }
        
        .contact-info p {
            margin-bottom: 8px;
            font-size: 14px;
        }
        
        /* Q&A Section */
        .qa-section {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin: 24px 0;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
        }
        
        .qa-header h3 {
            font-size: 20px;
            font-weight: 600;
            margin-bottom: 20px;
            color: #1a1a1a;
        }
        
        .qa-item {
            border-bottom: 1px solid #e5e7eb;
            margin-bottom: 16px;
        }
        
        .qa-item:last-child {
            border-bottom: none;
            margin-bottom: 0;
        }
        
        .qa-question {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 16px 0;
            cursor: pointer;
            font-weight: 500;
            color: #1a1a1a;
        }
        
        .qa-question:hover {
            color: #003580;
        }
        
        .qa-toggle {
            font-size: 18px;
            font-weight: bold;
            color: #003580;
            transition: transform 0.3s;
        }
        
        .qa-answer {
            display: none;
            padding: 0 0 16px 0;
            color: #666;
            line-height: 1.6;
        }
        
        .qa-answer.active {
            display: block;
        }
        
        .qa-item.active .qa-toggle {
            transform: rotate(45deg);
        }       
        
    </style>

    <!-- Quy tắc chung (Booking-style) -->
    <div class="qa-section" style="margin-top: 0;">
        <div class="qa-header" style="max-width:1200px; margin:0 auto 12px;">
            <h3>Quy tắc chung</h3>
        </div>
        <div class="rules">
            <div class="rules-row">
                <div class="rules-label">Nhận phòng</div>
                <div class="rules-content">Từ 14:00</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Trả phòng</div>
                <div class="rules-content">Đến 12:00</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Hủy/Thanh toán</div>
                <div class="rules-content">Chính sách hủy và thanh toán có thể khác nhau tùy loại phòng. Vui lòng kiểm tra điều kiện khi chọn phòng của bạn.</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Trẻ em & Giường</div>
                <div class="rules-content">
                    - Tất cả trẻ em đều được chào đón.<br/>
                    - Nôi/cũi và giường phụ tùy tình trạng sẵn có. Phụ phí có thể áp dụng.
                </div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Hút thuốc</div>
                <div class="rules-content">Không hút thuốc trong phòng.</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Thú cưng</div>
                <div class="rules-content">Vui lòng liên hệ trước khi đặt.</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Tiệc/Sự kiện</div>
                <div class="rules-content">Không tổ chức tiệc/sự kiện lớn.</div>
            </div>
            <div class="rules-row">
                <div class="rules-label">Yên lặng</div>
                <div class="rules-content">Giờ yên lặng từ 22:00 – 06:00.</div>
            </div>
        </div>
        <style>
            .rules { border:1px solid #e5e7eb; border-radius:8px; overflow:hidden; background:#fff; max-width:1200px; margin:0 auto; }
            .rules-row { display:grid; grid-template-columns: 220px 1fr; gap:16px; padding:12px 16px; border-top:1px solid #e5e7eb; }
            .rules-row:first-child { border-top:none; }
            .rules-label { color:#374151; font-weight:600; }
            .rules-content { color:#4b5563; line-height:1.7; }
            @media (max-width: 640px){ .rules-row { grid-template-columns: 1fr; } }
        </style>
    </div>
    
    <script>
    // Cập nhật min date cho checkout khi chọn checkin (top search bar)
    document.querySelector('input[name="checkin"]').addEventListener('change', function() {
        const checkinDate = new Date(this.value);
        const checkoutInput = document.querySelector('input[name="checkout"]');
        const tomorrow = new Date(checkinDate);
        tomorrow.setDate(tomorrow.getDate() + 1);
        checkoutInput.min = tomorrow.toISOString().split('T')[0];
        
        // Nếu checkout hiện tại <= checkin, reset checkout
        if (checkoutInput.value && checkoutInput.value <= this.value) {
            checkoutInput.value = '';
        }
    });
    
    // Cập nhật min date cho checkout khi chọn checkin (booking form)
    document.getElementById('booking-checkin').addEventListener('change', function() {
        const checkinDate = new Date(this.value);
        const checkoutInput = document.getElementById('booking-checkout');
        const tomorrow = new Date(checkinDate);
        tomorrow.setDate(tomorrow.getDate() + 1);
        checkoutInput.min = tomorrow.toISOString().split('T')[0];
        
        // Nếu checkout hiện tại <= checkin, reset checkout
        if (checkoutInput.value && checkoutInput.value <= this.value) {
            checkoutInput.value = '';
        }
        
        // Cập nhật thông tin giảm giá
        updateDiscountInfo();
    });
    
    // Cập nhật thông tin giảm giá khi thay đổi checkout
    document.getElementById('booking-checkout').addEventListener('change', function() {
        updateDiscountInfo();
    });
    </script>
    
    <%@ include file="../partials/footer.jsp" %>
</body>
</html>