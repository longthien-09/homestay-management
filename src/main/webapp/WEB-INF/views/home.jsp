<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> featuredHomestays = (List<Homestay>) request.getAttribute("featuredHomestays");
%>
<%@ include file="partials/header.jsp" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Homestay Management - Trang chủ</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; margin: 0; }
        
        /* Slide bar styles */
        .slider-container {
            position: relative;
            width: 100%;
            height: 400px;
            overflow: hidden;
            margin-bottom: 40px;
        }
        
        .slider {
            display: flex;
            width: 400%;
            height: 100%;
            transition: transform 0.5s ease-in-out;
        }
        
        .slide {
            width: 25%;
            height: 100%;
            position: relative;
        }
        
        .slide img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .slide-content {
            position: absolute;
            bottom: 0;
            left: 0;
            right: 0;
            background: linear-gradient(transparent, rgba(0,0,0,0.7));
            color: white;
            padding: 30px;
            text-align: center;
        }
        
        .slide-content h2 {
            margin: 0 0 10px 0;
            font-size: 2em;
            font-weight: 300;
        }
        
        .slide-content p {
            margin: 0;
            font-size: 1.1em;
            opacity: 0.9;
        }
        
        .slider-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.8);
            border: none;
            width: 50px;
            height: 50px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s ease;
        }
        
        .slider-nav:hover {
            background: rgba(255,255,255,1);
            transform: translateY(-50%) scale(1.1);
        }
        
        .prev { left: 20px; }
        .next { right: 20px; }
        
        .dots {
            position: absolute;
            bottom: 20px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 10px;
        }
        
        .dot {
            width: 12px;
            height: 12px;
            border-radius: 50%;
            background: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .dot.active {
            background: white;
            transform: scale(1.2);
        }
        

        
        /* Search bar styles */
        .search-section {
            background: #1a1a1a;
            padding: 40px 20px;
            margin-bottom: 40px;
            text-align: center;
        }
        
        .search-container {
            max-width: 800px;
            margin: 0 auto;
        }
        
        .search-form {
            background: #2a2a2a;
            border-radius: 15px;
            padding: 30px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.3);
        }
        
        .location-search {
            position: relative;
            margin-bottom: 25px;
        }
        
        .location-input {
            width: 100%;
            padding: 18px 20px 18px 50px;
            background: #333;
            border: 1px solid #444;
            border-radius: 10px;
            color: white;
            font-size: 16px;
            outline: none;
        }
        
        .location-input::placeholder {
            color: #aaa;
        }
        
        .search-icon {
            position: absolute;
            left: 20px;
            top: 50%;
            transform: translateY(-50%);
            color: #aaa;
            font-size: 18px;
        }
        
        .search-details {
            display: grid;
            grid-template-columns: 1fr 1fr 1fr;
            gap: 20px;
            margin-bottom: 25px;
        }
        
        .search-field {
            position: relative;
            background: #333;
            border: 1px solid #444;
            border-radius: 10px;
            padding: 18px 20px;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .search-field:hover {
            border-color: #667eea;
        }
        
        .field-icon {
            color: #aaa;
            margin-right: 10px;
            font-size: 16px;
        }
        
        .field-content {
            color: white;
            font-size: 14px;
        }
        
        .field-label {
            color: #aaa;
            font-size: 12px;
            margin-top: 5px;
        }
        
        .add-flight {
            text-align: left;
            margin-bottom: 25px;
        }
        
        .add-flight a {
            color: #667eea;
            text-decoration: none;
            font-size: 14px;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: color 0.3s ease;
        }
        
        .add-flight a:hover {
            color: #5a6fd8;
        }
        
        .search-btn {
            width: 100%;
            background: #667eea;
            color: white;
            border: none;
            padding: 20px;
            border-radius: 10px;
            font-size: 18px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .search-btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        
        /* Dropdown styles */
        .room-type-dropdown {
            position: absolute;
            top: 100%;
            left: 0;
            right: 0;
            background: #333;
            border: 1px solid #444;
            border-radius: 10px;
            margin-top: 5px;
            z-index: 1000;
            box-shadow: 0 5px 15px rgba(0,0,0,0.3);
        }
        
        .dropdown-item {
            padding: 15px 20px;
            color: white;
            cursor: pointer;
            border-bottom: 1px solid #444;
            transition: background 0.3s ease;
        }
        
        .dropdown-item:last-child {
            border-bottom: none;
        }
        
        .dropdown-item:hover {
            background: #444;
        }
        
        .search-field {
            position: relative;
        }
        
        .date-input {
            position: static;
            width: 100%;
            height: auto;
            opacity: 1;
            cursor: pointer;
            z-index: auto;
            font-size: 16px; /* Prevent zoom on mobile */
            margin-top: 8px;
            background: #fff;
            color: #222;
            border: 1px solid #e5e7eb;
            border-radius: 8px;
            padding: 10px 12px;
            box-sizing: border-box;
        }
        
        .search-field {
            cursor: pointer;
        }
        
        .search-field:hover {
            border-color: #667eea;
            background: #3a3a3a;
        }
        
        /* Homestay list styles */
        .homestay-section {
            padding: 60px 20px;
            background: #f8f9fa;
        }
        
        .homestay-container {
            max-width: 1200px;
            margin: 0 auto;
        }
        
        .section-title {
            text-align: center;
            margin-bottom: 50px;
        }
        
        .section-title h2 {
            color: #2c3e50;
            font-size: 2.5em;
            margin-bottom: 15px;
            font-weight: 300;
        }
        
        .section-title p {
            color: #7f8c8d;
            font-size: 1.2em;
            margin: 0;
        }
        
        .homestay-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(350px, 1fr));
            gap: 30px;
            margin-bottom: 40px;
        }
        
        .homestay-card {
            background: white;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 5px 20px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
            cursor: pointer;
        }
        
        .homestay-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        
        .homestay-image {
            width: 100%;
            height: 200px;
            overflow: hidden;
        }
        
        .homestay-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        
        .homestay-card:hover .homestay-image img {
            transform: scale(1.05);
        }
        
        .homestay-info {
            padding: 25px;
        }
        
        .homestay-name {
            color: #2c3e50;
            font-size: 1.4em;
            margin: 0 0 10px 0;
            font-weight: 600;
        }
        
        .homestay-address {
            color: #7f8c8d;
            font-size: 1em;
            margin: 0 0 15px 0;
            display: flex;
            align-items: center;
            gap: 8px;
        }
        
        .homestay-address::before {
            content: "📍";
            font-size: 1.2em;
        }
        
        .view-more-btn {
            display: inline-block;
            background: #667eea;
            color: white;
            padding: 12px 25px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        
        .view-more-btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        
        .view-all-container {
            text-align: center;
            margin-top: 40px;
        }
        
        .view-all-btn {
            display: inline-block;
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
            padding: 15px 40px;
            border-radius: 30px;
            text-decoration: none;
            font-weight: 600;
            font-size: 1.1em;
            transition: all 0.3s ease;
        }
        
        .view-all-btn:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }
        
        .container {
            max-width: 900px; margin: 40px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 40px 30px 30px 30px;
        }
        h1 { text-align: center; color: #007bff; margin-bottom: 20px; }
        .intro { text-align: center; font-size: 20px; color: #333; margin-bottom: 30px; }
        .features { display: flex; flex-wrap: wrap; justify-content: space-around; }
        .feature {
            width: 260px; background: #f8f9fa; border-radius: 8px; box-shadow: 0 1px 4px rgba(0,0,0,0.07);
            margin: 15px; padding: 22px 18px; text-align: center;
        }
        .feature h3 { color: #007bff; margin-bottom: 10px; }
        .feature p { color: #555; }
    </style>
</head>
<body>
    <!-- Slide bar -->
    <div class="slider-container">
        <div class="slider" id="slider">
            <div class="slide">
                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Homestay 1">
                <div class="slide-content">
                    <h2>Chào mừng đến với Homestay</h2>
                    <p>Trải nghiệm nghỉ dưỡng tuyệt vời với không gian ấm cúng</p>
                </div>
            </div>
            <div class="slide">
                <img src="https://images.unsplash.com/photo-1571896349842-33c89424de2d?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2068&q=80" alt="Homestay 2">
                <div class="slide-content">
                    <h2>Không gian thoải mái</h2>
                    <p>Thiết kế hiện đại với đầy đủ tiện nghi</p>
                </div>
            </div>
            <div class="slide">
                <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Homestay 3">
                <div class="slide-content">
                    <h2>Vị trí thuận tiện</h2>
                    <p>Gần trung tâm thành phố, dễ dàng di chuyển</p>
                </div>
            </div>
            <div class="slide">
                <img src="https://images.unsplash.com/photo-1551632811-561732d1e306?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Homestay 4">
                <div class="slide-content">
                    <h2>Dịch vụ chất lượng</h2>
                    <p>Cam kết mang đến trải nghiệm tốt nhất cho khách hàng</p>
                </div>
            </div>
        </div>
        
        <button class="slider-nav prev" onclick="changeSlide(-1)">❮</button>
        <button class="slider-nav next" onclick="changeSlide(1)">❯</button>
        
        <div class="dots">
            <span class="dot active" onclick="currentSlide(1)"></span>
            <span class="dot" onclick="currentSlide(2)"></span>
            <span class="dot" onclick="currentSlide(3)"></span>
            <span class="dot" onclick="currentSlide(4)"></span>
        </div>
    </div>

    <!-- Hero Search Section (Booking/Agoda style) -->
    <div class="search-section" style="background: linear-gradient(180deg, #0d6efd 0%, #002b6b 100%); padding: 60px 20px;">
        <div class="search-container" style="max-width: 1100px;">
            <form class="search-form" method="get" action="<%= request.getContextPath() %>/homestays" style="background:#fff;">
                <!-- Destination -->
                <div class="location-search" style="margin-bottom:18px;">
                    <span class="search-icon" style="color:#667eea;">🔎</span>
                    <input type="text" class="location-input" name="q" placeholder="Bạn muốn đi đâu? (địa điểm, tên homestay...)" style="background:#fff; color:#222; border:1px solid #e5e7eb;">
                </div>

                <!-- Dates -->
                <div class="search-details" style="grid-template-columns: 1fr 1fr 1fr 1fr;">
                    <div class="search-field" id="checkin-field">
                        <div class="field-content">
                            <div><span class="field-icon">📅</span>Ngày nhận phòng</div>
                            <div class="field-label"><span id="checkin-date">Chọn ngày</span> · <span id="checkin-day">--</span></div>
                        </div>
                        <input id="checkin-input" class="date-input" type="date" name="checkin" min="<%= java.time.LocalDate.now() %>" onchange="updateCheckinDate(this.value)">
                    </div>
                    <div class="search-field" id="checkout-field">
                        <div class="field-content">
                            <div><span class="field-icon">📅</span>Ngày trả phòng</div>
                            <div class="field-label"><span id="checkout-date">Chọn ngày</span> · <span id="checkout-day">--</span></div>
                        </div>
                        <input id="checkout-input" class="date-input" type="date" name="checkout" min="<%= java.time.LocalDate.now().plusDays(1) %>" onchange="updateCheckoutDate(this.value)">
                    </div>
                    <div class="search-field">
                        <div class="field-content">
                            <div><span class="field-icon">🛏️</span>Loại phòng</div>
                            <div class="field-label">
                                <select name="roomType" style="width:100%; padding:10px 12px; border-radius:8px; border:1px solid #e5e7eb;">
                                    <option value="">Tất cả loại phòng</option>
                                    <option value="đơn">Phòng đơn</option>
                                    <option value="đôi">Phòng đôi</option>
                                    <option value="hai giường">Phòng hai giường</option>
                                    <option value="gia đình">Phòng gia đình</option>
                                    <option value="studio">Studio</option>
                                    <option value="căn hộ">Căn hộ</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    <div>
                        <button type="submit" class="search-btn" style="height:100%">Tìm chỗ ở</button>
                    </div>
                </div>
            </form>
        </div>
    </div>

<div class="homestay-section">
    <div class="homestay-container">
        <div class="section-title">
            <h2>Các Homestay Nổi Bật</h2>
            <p>Khám phá các homestay đẹp và ấm cúng tại các địa điểm hấp dẫn</p>
        </div>
        <div class="homestay-grid">
            <% if (featuredHomestays != null && !featuredHomestays.isEmpty()) { %>
                <% for (Homestay homestay : featuredHomestays) { %>
                <div class="homestay-card">
                    <a href="/homestay-management/homestays/<%= homestay.getId() %>">
                        <div class="homestay-image">
                            <img src="<%= homestay.getImage() %>" alt="<%= homestay.getName() %>">
                        </div>
                    </a>
                    <div class="homestay-info">
                        <h3 class="homestay-name"><%= homestay.getName() %></h3>
                        <p class="homestay-address">Địa chỉ: <%= homestay.getAddress() != null ? homestay.getAddress() : "Chưa cập nhật" %></p>
                        <a href="/homestay-management/homestays/<%= homestay.getId() %>" class="view-more-btn">Xem chi tiết</a>
                    </div>
                </div>
                <% } %>
            <% } else { %>
                <!-- Fallback khi không có homestay nào -->
                <div class="homestay-card">
                    <div class="homestay-image">
                        <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="Homestay mẫu">
            </div>
                    <div class="homestay-info">
                        <h3 class="homestay-name">Chưa có homestay</h3>
                        <p class="homestay-address">Hãy thêm homestay đầu tiên!</p>
            </div>
            </div>
            <% } %>
        </div>
        <div class="view-all-container">
            <a href="<%= request.getContextPath() %>/homestays" class="view-all-btn">Xem tất cả Homestay</a>
        </div>
        </div>
    </div>
    
    <script>
let currentSlideIndex = 0;
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.dot');

function showSlide(index) {

    if (index >= slides.length) currentSlideIndex = 0;
    else if (index < 0) currentSlideIndex = slides.length - 1;
    else currentSlideIndex = index;

    document.getElementById('slider').style.transform = "translateX(-" + currentSlideIndex * 25 + "%)";
    
    // Update dots
    dots.forEach((dot, i) => {
        dot.classList.toggle('active', i === currentSlideIndex);
    });
}

function changeSlide(direction) {
    currentSlideIndex += direction;
    showSlide(currentSlideIndex);
}

function currentSlide(index) {
    currentSlideIndex = index - 1;
    showSlide(currentSlideIndex);
}

// Auto slide every 5 seconds
setInterval(() => {
    changeSlide(1);
}, 5000);

// Enable opening native date pickers when clicking the fields
document.addEventListener('DOMContentLoaded', function() {
    var ciField = document.getElementById('checkin-field');
    var coField = document.getElementById('checkout-field');
    var ciInput = document.getElementById('checkin-input');
    var coInput = document.getElementById('checkout-input');

    function openPicker(input) {
        try {
            if (input && typeof input.showPicker === 'function') {
                input.showPicker();
                return;
            }
        } catch (e) {}
        if (input) {
            input.focus();
            input.click();
        }
    }

    if (ciField && ciInput) {
        ciField.addEventListener('click', function(e) {
            e.preventDefault();
            openPicker(ciInput);
        });
    }
    if (coField && coInput) {
        coField.addEventListener('click', function(e) {
            e.preventDefault();
            openPicker(coInput);
        });
    }
});

// Add click event listeners to date fields
/* document.addEventListener('DOMContentLoaded', function() {
    const checkinField = document.querySelector('.search-field:first-child');
    const checkoutField = document.querySelector('.search-field:nth-child(2)');
    
    if (checkinField) {
        checkinField.addEventListener('click', function(e) {
            e.preventDefault();
            const input = document.getElementById('checkin-input');
            if (input) {
                input.click();
            }
        });
    }
    
    if (checkoutField) {
        checkoutField.addEventListener('click', function(e) {
            e.preventDefault();
            const input = document.getElementById('checkout-input');
            if (input) {
                input.click();
            }
        });
    }
    
    console.log('Date picker event listeners added');
    
    // Test function
    window.testDatePicker = function() {
        console.log('Testing date picker...');
        const checkinInput = document.getElementById('checkin-input');
        const checkoutInput = document.getElementById('checkout-input');
        console.log('Checkin input:', checkinInput);
        console.log('Checkout input:', checkoutInput);
        
        if (checkinInput) {
            checkinInput.click();
        }
    };
}); */
        
function updateCheckinDate(dateString) {
    const date = new Date(dateString);
    const dayNames = ['Chủ nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
    const monthNames = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    
    const day = date.getDate();
    const month = monthNames[date.getMonth()];
    const year = date.getFullYear();
    const dayName = dayNames[date.getDay()];
    
    document.getElementById('checkin-date').textContent = `${day} tháng ${month} ${year}`;
    document.getElementById('checkin-day').textContent = dayName;
    
    // Cập nhật min date của checkout để phải sau checkin
    const checkoutInput = document.getElementById('checkout-input');
    const tomorrow = new Date(date);
    tomorrow.setDate(tomorrow.getDate() + 1);
    checkoutInput.min = tomorrow.toISOString().split('T')[0];
    
    // Nếu checkout hiện tại < checkin, reset checkout
    if (checkoutInput.value && checkoutInput.value <= dateString) {
        checkoutInput.value = '';
        document.getElementById('checkout-date').textContent = 'Chọn ngày';
        document.getElementById('checkout-day').textContent = '--';
    }
}

function updateCheckoutDate(dateString) {
    const date = new Date(dateString);
    const dayNames = ['Chủ nhật', 'Thứ Hai', 'Thứ Ba', 'Thứ Tư', 'Thứ Năm', 'Thứ Sáu', 'Thứ Bảy'];
    const monthNames = ['1', '2', '3', '4', '5', '6', '7', '8', '9', '10', '11', '12'];
    
    const day = date.getDate();
    const month = monthNames[date.getMonth()];
    const year = date.getFullYear();
    const dayName = dayNames[date.getDay()];
    
    document.getElementById('checkout-date').textContent = `${day} tháng ${month} ${year}`;
    document.getElementById('checkout-day').textContent = dayName;
}

// Room type dropdown functions
function toggleRoomTypeDropdown() {
    const dropdown = document.getElementById('room-type-dropdown');
    dropdown.style.display = dropdown.style.display === 'none' ? 'block' : 'none';
}

function selectRoomType(type) {
    document.getElementById('room-type-text').textContent = type;
    document.getElementById('room-type-dropdown').style.display = 'none';
}

// Close dropdown when clicking outside
/* document.addEventListener('click', function(event) {
    const dropdown = document.getElementById('room-type-dropdown');
    const roomTypeField = document.querySelector('.search-field:last-child');
    
    if (!roomTypeField.contains(event.target)) {
        dropdown.style.display = 'none';
    }
        }); */
    </script>

<%@ include file="partials/footer.jsp" %>
</body>
</html>
