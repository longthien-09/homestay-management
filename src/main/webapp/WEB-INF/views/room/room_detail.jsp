<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Room, com.homestay.model.Homestay" %>
<%
    Room room = (Room) request.getAttribute("room");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
%>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chi tiết phòng <%= room != null ? room.getRoomNumber() : "" %></title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .container {
            max-width: 900px;
            margin: 0 auto;
            background: #fff;
            border-radius: 15px;
            box-shadow: 0 4px 20px rgba(0,0,0,0.1);
            overflow: hidden;
        }
        .header {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
            padding: 30px;
            text-align: center;
        }
        .header h1 {
            margin: 0;
            font-size: 2.5em;
            font-weight: 300;
        }
        .header .subtitle {
            margin: 10px 0 0 0;
            font-size: 1.2em;
            opacity: 0.9;
        }
        .content {
            padding: 30px;
        }
        .image-section {
            text-align: center;
            margin-bottom: 30px;
        }
        .image-section img {
            max-width: 100%;
            max-height: 400px;
            border-radius: 10px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .placeholder-image {
            width: 100%;
            height: 300px;
            background: #f8f9fa;
            border-radius: 10px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #ccc;
            font-size: 4em;
            border: 2px dashed #ddd;
        }
        .info-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
            margin-bottom: 30px;
        }
        .info-item {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            border-left: 4px solid #667eea;
        }
        .info-item h3 {
            margin: 0 0 10px 0;
            color: #667eea;
            font-size: 1.1em;
        }
        .info-item p {
            margin: 0;
            color: #555;
            font-size: 1em;
        }
        .price-section {
            background: linear-gradient(135deg, #27ae60 0%, #2ecc71 100%);
            color: white;
            padding: 25px;
            border-radius: 10px;
            text-align: center;
            margin-bottom: 30px;
        }
        .price-section h3 {
            margin: 0 0 10px 0;
            font-size: 1.3em;
            opacity: 0.9;
        }
        .price-amount {
            font-size: 2.5em;
            font-weight: 600;
            margin: 0;
        }
        .status-section {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
            text-align: center;
        }
        .status-badge {
            display: inline-block;
            padding: 8px 20px;
            border-radius: 25px;
            font-size: 1.1em;
            font-weight: 500;
        }
        .status-available {
            background: #d4edda;
            color: #155724;
        }
        .status-booked {
            background: #f8d7da;
            color: #721c24;
        }
        .status-maintenance {
            background: #fff3cd;
            color: #856404;
        }
        .description {
            background: #f8f9fa;
            padding: 20px;
            border-radius: 10px;
            margin-bottom: 30px;
        }
        .description h3 {
            margin: 0 0 15px 0;
            color: #667eea;
        }
        .description p {
            margin: 0;
            color: #555;
            line-height: 1.6;
        }
        .actions {
            text-align: center;
            padding: 20px;
            border-top: 1px solid #eee;
        }
        .btn {
            display: inline-block;
            padding: 12px 25px;
            margin: 0 10px;
            border-radius: 25px;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        .btn-primary {
            background: #667eea;
            color: white;
        }
        .btn-primary:hover {
            background: #5a6fd8;
            transform: translateY(-2px);
        }
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
        }
        .btn-success {
            background: #27ae60;
            color: white;
        }
        .btn-success:hover {
            background: #219a52;
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1>🏠 Phòng <%= room != null ? room.getRoomNumber() : "" %></h1>
            <p class="subtitle">Homestay #<%= homestayId %></p>
        </div>
        
        <div class="content">
            <div class="image-section">
                <% if (room != null && room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
                    <img src="<%= room.getImage() %>" alt="<%= room.getRoomNumber() %>" />
                <% } else { %>
                    <div class="placeholder-image">🏠</div>
                <% } %>
            </div>
            
            <div class="price-section">
                <h3>💰 Giá phòng</h3>
                <p class="price-amount"><%= formatPrice(room != null ? room.getPrice() : null) %></p>
            </div>
            
            <div class="status-section">
                <h3>📊 Trạng thái</h3>
                <span class="status-badge status-<%= room != null && room.getStatus() != null ? room.getStatus().toLowerCase() : "available" %>">
                    <% if (room != null && "AVAILABLE".equals(room.getStatus())) { %>
                        ✅ Còn trống
                    <% } else if (room != null && "BOOKED".equals(room.getStatus())) { %>
                        ❌ Đã đặt
                    <% } else if (room != null && "MAINTENANCE".equals(room.getStatus())) { %>
                        🔧 Bảo trì
                    <% } else { %>
                        ❓ Không xác định
                    <% } %>
                </span>
            </div>
            
            <div class="info-grid">
                <div class="info-item">
                    <h3>🏷️ Loại phòng</h3>
                    <p><%= room != null && room.getType() != null ? room.getType() : "Chưa cập nhật" %></p>
                </div>
                
                <div class="info-item">
                    <h3>🆔 Mã phòng</h3>
                    <p>#<%= room != null ? room.getId() : "N/A" %></p>
                </div>
                
                <div class="info-item">
                    <h3>🏢 Thuộc Homestay</h3>
                    <p>#<%= homestayId %></p>
                </div>
                
                <div class="info-item">
                    <h3>📅 Ngày tạo</h3>
                    <p>Hôm nay</p>
                </div>
            </div>
            
            <div class="description">
                <h3>📝 Mô tả chi tiết</h3>
                <p><%= room != null && room.getDescription() != null && !room.getDescription().trim().isEmpty() ? room.getDescription() : "Chưa có mô tả chi tiết cho phòng này." %></p>
            </div>
            
            <div class="actions">
                <a href="/homestay-management/homestays/<%= homestayId %>/rooms" class="btn btn-secondary">← Quay lại danh sách phòng</a>
                <a href="/homestay-management/homestays/<%= homestayId %>" class="btn btn-primary">🏠 Xem homestay</a>
                <% if (room != null && "AVAILABLE".equals(room.getStatus())) { %>
                <a href="/homestay-management/homestays/<%= homestayId %>/rooms/<%= room.getId() %>/book" class="btn btn-success">📅 Đặt phòng ngay</a>
                <% } %>
            </div>
        </div>
    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
