<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Service" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Dịch vụ Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; margin: 0; }
        
        /* Slide bar styles - giống trang chủ */
        .slider-container {
            position: relative;
            width: 100%;
            height: 550px;
            overflow: hidden;
            margin-bottom: 40px;
        }
        
        .slider {
            display: flex;
            width: 1000%;
            height: 100%;
            transition: transform 0.5s ease-in-out;
        }
        
        .slide {
            width: 10%;
            height: 100%;
            position: relative;
            flex-shrink: 0;
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
            padding: 40px;
            text-align: center;
        }
        
        .slide-content h2 {
            margin: 0 0 15px 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        
        .slide-content p {
            margin: 0;
            font-size: 1.2em;
            opacity: 0.9;
        }
        
        .slider-nav {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: rgba(255,255,255,0.8);
            border: none;
            width: 60px;
            height: 60px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 24px;
            transition: all 0.3s ease;
            z-index: 10;
        }
        
        .slider-nav:hover {
            background: rgba(255,255,255,1);
            transform: translateY(-50%) scale(1.1);
        }
        
        .prev { left: 30px; }
        .next { right: 30px; }
        
        .dots {
            position: absolute;
            bottom: 30px;
            left: 50%;
            transform: translateX(-50%);
            display: flex;
            gap: 15px;
        }
        
        .dot {
            width: 15px;
            height: 15px;
            border-radius: 50%;
            background: rgba(255,255,255,0.5);
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .dot.active {
            background: white;
            transform: scale(1.2);
        }
        
        /* Nhóm nút hành động ở góc dưới bên phải */
        .action-buttons {
            position: absolute;
            bottom: 100px;
            right: 40px;
            display: flex;
            flex-direction: column;
            gap: 12px;
            z-index: 10;
            align-items: flex-end;
        }
        .view-all-btn {
            background: linear-gradient(135deg, #667eea, #5a6fd8);
            color: white;
            border: none;
            padding: 15px 30px;
            border-radius: 30px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.3s ease;
            box-shadow: 0 4px 15px rgba(0,0,0,0.3);
        }
        
        .view-all-btn:hover {
            background: linear-gradient(135deg, #5a6fd8, #4a5fc8);
            transform: translateY(-3px);
            box-shadow: 0 6px 20px rgba(0,0,0,0.4);
        }

        /* Modal form đặt dịch vụ */
        .modal-overlay { position:fixed; inset:0; background:rgba(0,0,0,.5); display:none; align-items:center; justify-content:center; z-index:9999; }
        .modal-card { width: 90vw; max-width: 900px; max-height: 85vh; background:#fff; border-radius:12px; overflow:hidden; box-shadow:0 10px 30px rgba(0,0,0,.25); display:flex; flex-direction:column; }
        .modal-header { background:linear-gradient(135deg,#667eea,#20c997); color:#fff; padding:12px 16px; display:flex; align-items:center; justify-content:space-between; }
        .modal-body { flex:1; overflow:auto; }
        #serviceModalContent { padding:0; }
        .modal-close { background:transparent; color:#fff; border:0; font-size:20px; cursor:pointer; }
        
        /* Responsive */
        @media (max-width: 768px) {
            .slider-container {
                height: 400px;
            }
            
            .slide-content h2 {
                font-size: 2em;
            }
            
            .slide-content p {
                font-size: 1em;
            }
            
            .slider-nav {
                width: 50px;
                height: 50px;
                font-size: 20px;
            }
            
            .prev { left: 20px; }
            .next { right: 20px; }
            
            .action-buttons { bottom: 80px; right: 20px; }
            .view-all-btn { padding: 12px 24px; font-size: 14px; }
        }
    </style>
</head>
<body>
    <!-- Slide bar giống trang chủ -->
    <div class="slider-container">
        <div class="slider" id="slider">
            <% if (services != null && !services.isEmpty()) { %>
                <% int index = 1; %>
                <% for (Service s : services) { %>
                    <div class="slide">
                        <% if (index == 1) { %>
                            <!-- Đưa đón -->
                            <img src="https://images.unsplash.com/photo-1570125909232-eb263c188be7?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 2) { %>
                            <!-- Giặt là -->
                            <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 3) { %>
                            <!-- Ăn sáng -->
                            <img src="https://images.unsplash.com/photo-1493770348161-369560ae357d?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 4) { %>
                            <!-- Dọn phòng -->
                            <img src="https://images.unsplash.com/photo-1581578731548-c64695cc6952?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 5) { %>
                            <!-- Bảo vệ -->
                            <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 6) { %>
                            <!-- SPA & Wellness -->
                            <img src="https://images.unsplash.com/photo-1540555700478-4be289fbece2?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 7) { %>
                            <!-- Gym & Fitness -->
                            <img src="https://images.unsplash.com/photo-1571019613454-1cb2f99b2d8b?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 8) { %>
                            <!-- Tour & Guide -->
                            <img src="https://images.unsplash.com/photo-1488646953014-85cb44e25828?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 9) { %>
                            <!-- Massage & Relax -->
                            <img src="https://images.unsplash.com/photo-1540555700478-4be289fbece2?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else if (index == 10) { %>
                            <!-- Free WiFi -->
                            <img src="https://images.unsplash.com/photo-1558618666-fcd25c85cd64?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } else { %>
                            <!-- Fallback cho các dịch vụ khác -->
                            <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="<%= s.getName() %>">
                        <% } %>
                        <div class="slide-content">
                            <h2><%= s.getName() %></h2>
                            <p>Dịch vụ chất lượng cao tại homestay</p>
                        </div>
                    </div>
                    <% index++; %>
                <% } %>
            <% } else { %>
                <!-- Fallback khi không có dịch vụ -->
                <div class="slide">
                    <img src="https://images.unsplash.com/photo-1566073771259-6a8506099945?ixlib=rb-4.0.3&auto=format&fit=crop&w=2070&q=80" alt="Dịch vụ mẫu">
                    <div class="slide-content">
                        <h2>Chưa có dịch vụ nào</h2>
                        <p>Hãy thêm dịch vụ đầu tiên!</p>
                    </div>
                </div>
            <% } %>
        </div>
        
        <button class="slider-nav prev" onclick="changeSlide(-1)">❮</button>
        <button class="slider-nav next" onclick="changeSlide(1)">❯</button>
        
        <div class="dots" id="dotsContainer">
            <% if (services != null && !services.isEmpty()) { %>
                <% for (int i = 0; i < services.size(); i++) { %>
                    <span class="dot <%= i == 0 ? "active" : "" %>" onclick="currentSlide(<%= i + 1 %>)" title="Slide <%= i + 1 %>"></span>
                <% } %>
            <% } else { %>
                <span class="dot active" onclick="currentSlide(1)" title="Slide 1"></span>
            <% } %>
        </div>
        
        <!-- Nút hành động -->
        <div class="action-buttons">
            <button class="view-all-btn" id="viewAllBtn">Xem homestay có dịch vụ này</button>
            <button class="view-all-btn" id="bookServiceBtn" style="background:#20c997; border:none;">Đặt dịch vụ</button>
        </div>
    </div>
    <!-- Modal đặt dịch vụ (load nội dung từ server) -->
    <div class="modal-overlay" id="serviceModal">
        <div class="modal-card">
            <div class="modal-header">
                <div>Đặt dịch vụ</div>
                <button class="modal-close" id="serviceModalClose">✕</button>
            </div>
            <div class="modal-body" id="serviceModalContent"></div>
        </div>
    </div>
<script>
let currentSlideIndex = 0;
const slides = document.querySelectorAll('.slide');
const dots = document.querySelectorAll('.dot');

function showSlide(index) {
    // Cập nhật currentSlideIndex
    currentSlideIndex = index;
    
    // Xử lý vòng lặp
    if (currentSlideIndex >= slides.length) currentSlideIndex = 0;
    if (currentSlideIndex < 0) currentSlideIndex = slides.length - 1;
    
    // Tính toán translateX chính xác
    const translateX = -(currentSlideIndex * 10);
    const slider = document.getElementById('slider');
    slider.style.transform = "translateX(" + translateX + "%)";
    
    // Update dots
    const allDots = document.querySelectorAll('.dot');
    allDots.forEach((dot, i) => {
        dot.classList.toggle('active', i === currentSlideIndex);
    });
    
    console.log('Current slide:', currentSlideIndex, 'TranslateX:', translateX + '%', 'Total slides:', slides.length);
}

function changeSlide(direction) {
    const newIndex = currentSlideIndex + direction;
    showSlide(newIndex);
}

function currentSlide(index) {
    const newIndex = index - 1;
    showSlide(newIndex);
}

// Auto slide every 5 seconds
setInterval(() => {
    changeSlide(1);
}, 5000);

// Event listener cho nút "Xem homestay có dịch vụ này"
document.addEventListener('DOMContentLoaded', function() {
    console.log('DOM loaded, slides count:', slides.length);
    console.log('Dots count:', dots.length);
    
    const viewAllBtn = document.getElementById('viewAllBtn');
    if (viewAllBtn) {
        viewAllBtn.addEventListener('click', function(e) {
            e.preventDefault();
            console.log('View all button clicked!');
            
            // Lấy tên dịch vụ hiện tại
            const currentSlide = slides[currentSlideIndex];
            if (currentSlide) {
                const serviceName = currentSlide.querySelector('.slide-content h2').textContent;
                console.log('Current service:', serviceName);
                
                // Chuyển đến trang homestay có dịch vụ này
                const encodedServiceName = encodeURIComponent(serviceName);
                window.location.href = '<%= request.getContextPath() %>/homestays?service=' + encodedServiceName;
            }
        });
        console.log('View all button event listener added');
    }
    
    // Nút Đặt dịch vụ -> điều hướng giống xem homestay nhưng kèm tham số gợi ý đặt
    const bookServiceBtn = document.getElementById('bookServiceBtn');
    if (bookServiceBtn) {
        bookServiceBtn.addEventListener('click', function(e) {
            e.preventDefault();
            // Mở modal và tải form từ server
            const overlay = document.getElementById('serviceModal');
            const container = document.getElementById('serviceModalContent');
            container.innerHTML = '<div style="padding:16px;">Đang tải...</div>';
            overlay.style.display = 'flex';
            fetch('<%= request.getContextPath() %>/user/services/book', { credentials:'include' })
              .then(r => r.text())
              .then(html => { container.innerHTML = html; })
              .catch(() => { container.innerHTML = '<div style="padding:16px;color:#b0302f;">Không tải được form.</div>'; });
        });
    }

    // Đóng modal
    const serviceModalClose = document.getElementById('serviceModalClose');
    if (serviceModalClose) {
        serviceModalClose.addEventListener('click', function(){
            const overlay = document.getElementById('serviceModal');
            const container = document.getElementById('serviceModalContent');
            container.innerHTML = '';
            overlay.style.display = 'none';
        });
    }

    // Delegate change event for booking select inside modal content
    const modalContainer = document.getElementById('serviceModalContent');
    if (modalContainer) {
        modalContainer.addEventListener('change', function(e){
            const sel = e.target;
            if (sel && sel.tagName === 'SELECT' && sel.name === 'bookingId') {
                const bid = sel.value;
                const url = '<%= request.getContextPath() %>/user/services/book?bookingId=' + encodeURIComponent(bid);
                modalContainer.innerHTML = '<div style="padding:16px;">Đang tải...</div>';
                fetch(url, { credentials: 'include' })
                  .then(r=>r.text()).then(html=>{ modalContainer.innerHTML = html; })
                  .catch(()=>{ modalContainer.innerHTML = '<div style="padding:16px;color:#b0302f;">Không tải được form.</div>'; });
            }
        });
    }

    // Khởi tạo slide đầu tiên
    showSlide(0);
    
    // Debug info
    console.log('Slider initialized with', slides.length, 'slides');
});
</script>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
