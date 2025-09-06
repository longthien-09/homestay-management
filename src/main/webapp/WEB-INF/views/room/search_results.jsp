<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Room" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
    String homestayName = (String) request.getAttribute("homestayName");
    String checkInDate = (String) request.getAttribute("checkInDate");
    String checkOutDate = (String) request.getAttribute("checkOutDate");
    String roomType = (String) request.getAttribute("roomType");
    String maxPrice = (String) request.getAttribute("maxPrice");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm phòng trống</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .container { max-width: 1200px; margin: 22px auto; background:#fff; border-radius:12px; box-shadow:0 8px 24px rgba(0,0,0,.06); overflow:hidden; }
        .header { display:flex; align-items:center; justify-content:space-between; padding:18px 20px; background:linear-gradient(135deg,#667eea,#764ba2); color:#fff; }
        .header h2 { margin:0; font-weight:700; }
        .back-btn { text-decoration:none; padding:8px 14px; border-radius:8px; color:#fff; background:#6c757d; transition: background 0.2s; }
        .back-btn:hover { background: #5a6268; }
        
        .search-summary { background: #e8f4fd; padding: 20px; margin: 20px; border-radius: 12px; border-left: 4px solid #17a2b8; }
        .search-summary h3 { margin: 0 0 15px 0; color: #2c3e50; font-size: 1.2em; }
        .search-criteria { display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 15px; }
        .criteria-item { background: white; padding: 12px; border-radius: 8px; border: 1px solid #dce1eb; }
        .criteria-label { font-weight: 600; color: #2c3e50; margin-bottom: 5px; }
        .criteria-value { color: #667eea; font-weight: 600; }
        
        .results-header { padding: 20px; border-bottom: 1px solid #eef0f5; }
        .results-count { font-size: 1.1em; color: #2c3e50; }
        .results-count .count { color: #667eea; font-weight: 700; }
        
        .rooms-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 20px; padding: 20px; }
        .room-card { background: white; border-radius: 12px; padding: 20px; border: 1px solid #e9ecef; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: transform 0.2s, box-shadow 0.2s; }
        .room-card:hover { transform: translateY(-2px); box-shadow: 0 4px 16px rgba(0,0,0,0.12); }
        .room-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; }
        .room-number { font-size: 1.3em; font-weight: 700; color: #2c3e50; }
        .room-type { background: #667eea; color: white; padding: 4px 12px; border-radius: 20px; font-size: 0.85em; font-weight: 600; }
        .room-price { font-size: 1.4em; font-weight: 700; color: #27ae60; margin: 15px 0; }
        .room-description { color: #6c757d; margin-bottom: 15px; line-height: 1.5; }
        .room-image { width: 100%; height: 150px; object-fit: cover; border-radius: 8px; margin-bottom: 15px; }
        .room-actions { display: flex; gap: 10px; }
        .btn { padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 0.9em; transition: all 0.2s; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5a6fd8; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        
        .no-results { text-align: center; padding: 60px 20px; color: #6c757d; }
        .no-results i { font-size: 3em; margin-bottom: 20px; color: #dee2e6; }
        
        @media (max-width: 768px) {
            .rooms-grid { grid-template-columns: 1fr; }
            .search-criteria { grid-template-columns: 1fr; }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>🔍 Kết quả tìm kiếm phòng trống</h2>
            <a href="/homestay-management/manager/dashboard" class="back-btn">
                <i class="fa-solid fa-arrow-left"></i> Quay lại Dashboard
            </a>
        </div>
        
        <!-- Tóm tắt tìm kiếm -->
        <div class="search-summary">
            <h3><i class="fa-solid fa-info-circle"></i> Tiêu chí tìm kiếm</h3>
            <div class="search-criteria">
                <div class="criteria-item">
                    <div class="criteria-label">Homestay:</div>
                    <div class="criteria-value"><%= homestayName != null ? homestayName : "Homestay #" + homestayId %></div>
                </div>
                <div class="criteria-item">
                    <div class="criteria-label">Ngày nhận phòng:</div>
                    <div class="criteria-value"><%= checkInDate %></div>
                </div>
                <div class="criteria-item">
                    <div class="criteria-label">Ngày trả phòng:</div>
                    <div class="criteria-value"><%= checkOutDate %></div>
                </div>
                <% if (roomType != null && !roomType.isEmpty()) { %>
                <div class="criteria-item">
                    <div class="criteria-label">Loại phòng:</div>
                    <div class="criteria-value"><%= roomType %></div>
                </div>
                <% } %>
                <% if (maxPrice != null && !maxPrice.isEmpty()) { %>
                <div class="criteria-item">
                    <div class="criteria-label">Giá tối đa:</div>
                    <div class="criteria-value"><%= String.format("%,.0f₫", Double.parseDouble(maxPrice)) %></div>
                </div>
                <% } %>
            </div>
        </div>
        
        <!-- Header kết quả -->
        <div class="results-header">
            <div class="results-count">
                Tìm thấy <span class="count"><%= rooms != null ? rooms.size() : 0 %></span> phòng trống phù hợp
            </div>
        </div>
        
        <!-- Danh sách phòng -->
        <% if (rooms != null && !rooms.isEmpty()) { %>
            <div class="rooms-grid">
                <% for (Room room : rooms) { %>
                    <div class="room-card">
                        <div class="room-header">
                            <div class="room-number"><%= room.getRoomNumber() %></div>
                            <div class="room-type"><%= room.getType() %></div>
                        </div>
                        
                        <% if (room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
                            <img src="<%= room.getImage() %>" alt="Ảnh phòng <%= room.getRoomNumber() %>" class="room-image" />
                        <% } else { %>
                            <div style="width: 100%; height: 150px; background: #f8f9fa; border-radius: 8px; margin-bottom: 15px; display: flex; align-items: center; justify-content: center; color: #6c757d;">
                                <i class="fa-solid fa-image" style="font-size: 2em;"></i>
                            </div>
                        <% } %>
                        
                        <div class="room-price"><%= formatPrice(room.getPrice()) %></div>
                        
                        <% if (room.getDescription() != null && !room.getDescription().trim().isEmpty()) { %>
                            <div class="room-description"><%= room.getDescription() %></div>
                        <% } %>
                        
                        <div class="room-actions">
                            <a href="/homestay-management/manager/homestays/<%= homestayId %>/rooms/edit/<%= room.getId() %>" class="btn btn-primary">
                                <i class="fa-solid fa-edit"></i> Sửa phòng
                            </a>
                            <a href="/homestay-management/manager/homestays/<%= homestayId %>/rooms" class="btn btn-secondary">
                                <i class="fa-solid fa-list"></i> Xem tất cả
                            </a>
                        </div>
                    </div>
                <% } %>
            </div>
        <% } else { %>
            <div class="no-results">
                <i class="fa-solid fa-search"></i>
                <h3>Không tìm thấy phòng trống nào</h3>
                <p>Không có phòng nào phù hợp với tiêu chí tìm kiếm của bạn.</p>
                <p>Hãy thử thay đổi các tiêu chí hoặc chọn khoảng thời gian khác.</p>
                <a href="/homestay-management/manager/dashboard" class="btn btn-primary" style="margin-top: 20px; display: inline-block;">
                    <i class="fa-solid fa-search"></i> Tìm kiếm lại
                </a>
            </div>
        <% } %>
    </div>
</body>
<%@ include file="../partials/footer.jsp" %>
</html>
