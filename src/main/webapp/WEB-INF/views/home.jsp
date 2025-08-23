<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> featuredHomestays = (List<Homestay>) request.getAttribute("featuredHomestays");
%>
<%@ include file="partials/header.jspf" %>
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
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            padding: 40px 20px;
            margin-bottom: 40px;
            text-align: center;
        }
        
        .search-container {
            max-width: 600px;
            margin: 0 auto;
        }
        
        .search-title {
            color: white;
            margin-bottom: 30px;
        }
        
        .search-title h2 {
            margin: 0 0 10px 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        
        .search-title p {
            margin: 0;
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .search-form {
            background: white;
            border-radius: 50px;
            padding: 20px;
            box-shadow: 0 10px 30px rgba(0,0,0,0.2);
            display: flex;
            gap: 15px;
            align-items: center;
            justify-content: center;
        }
        
        .search-input {
            flex: 1;
            padding: 15px 20px;
            border: 2px solid #e9ecef;
            border-radius: 25px;
            font-size: 16px;
            outline: none;
            transition: border-color 0.3s ease;
        }
        
        .search-input:focus {
            border-color: #667eea;
        }
        
        .search-btn {
            background: #667eea;
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 25px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            min-width: 120px;
        }
        
        .search-btn:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
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
                <img src="https://images.unsplash.com/photo-1521783988139-89397d761dce?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2025&q=80" alt="Homestay 3">
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

<div class="search-section">
    <div class="search-container">
        <form action="search.jsp" method="GET" class="search-form">
            <input type="text" name="address" class="search-input" placeholder="Nhập thông tin homestay..." required>
            <button type="submit" class="search-btn">Tìm kiếm</button>
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
                            <% if (homestay.getImage() != null && !homestay.getImage().trim().isEmpty()) { %>
                                <img src="<%= homestay.getImage() %>" alt="<%= homestay.getName() %>">
                            <% } else { %>
                                <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D&auto=format&fit=crop&w=2070&q=80" alt="<%= homestay.getName() %>">
                            <% } %>
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
            <a href="homestay-list.jsp" class="view-all-btn">Xem tất cả Homestay</a>
        </div>
    </div>
</div>

<script>
let currentSlideIndex = 0;
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.dot');

function showSlide(index) {
    if (index >= slides.length) currentSlideIndex = 0;
    if (index < 0) currentSlideIndex = slides.length - 1;
    
    document.getElementById('slider').style.transform = `translateX(-${currentSlideIndex * 25}%)`;
    
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
</script>

<%@ include file="partials/footer.jspf" %>
</body>
</html>
