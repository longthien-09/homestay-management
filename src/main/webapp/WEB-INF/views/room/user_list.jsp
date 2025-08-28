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
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách phòng - Homestay #<%= homestayId %></title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .container { max-width: 1200px; margin: 20px auto; }
        .hero {
            background: radial-gradient(1200px 400px at 10% -10%, rgba(102,126,234,.35), transparent),
                        radial-gradient(1000px 500px at 110% -20%, rgba(116,75,160,.25), transparent),
                        linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color:#fff; border-radius:18px; padding:32px 28px; box-shadow:0 8px 24px rgba(102,126,234,.25);
        }
        .header { display:flex; align-items:center; justify-content:space-between; }
        .header h1 { margin:0; font-size:2.2em; font-weight:700; letter-spacing:.3px; }
        .header .subtitle { opacity:.92; margin-top:6px; }
        .content { padding: 22px 4px; }
        .room-grid { display:grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap:22px; margin-top:18px; }
        .room-card { background:#fff; border-radius:14px; overflow:hidden; box-shadow:0 6px 20px rgba(0,0,0,0.08); transition:.25s; border:1px solid #eef0f5; }
        .room-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 10px 30px rgba(0,0,0,0.15);
        }
        .room-image { width:100%; height:200px; overflow:hidden; background:#f8f9fa; }
        .room-image img {
            width: 100%;
            height: 100%;
            object-fit: cover;
            transition: transform 0.3s ease;
        }
        .room-card:hover .room-image img {
            transform: scale(1.05);
        }
        .room-info { padding: 18px; }
        .room-number { color:#2c3e50; font-size:1.25em; margin:0 0 6px 0; font-weight:700; }
        .room-type { color:#667eea; font-size:1em; margin:0 0 6px 0; font-weight:600; }
        .room-price { color:#1aae6a; font-size:1.2em; margin: 2px 0 8px 0; font-weight:700; }
        .room-status {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 0.9em;
            font-weight: 500;
            margin-bottom: 10px;
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
        .room-description { color:#6b7785; font-size:.95em; line-height:1.55; margin:0; min-height: 44px; }
        .actions { text-align:center; padding:20px 8px; }
        .btn {
            display: inline-block;
            padding: 10px 22px;
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
        .no-rooms {
            text-align: center;
            padding: 60px 20px;
            color: #7f8c8d;
            font-size: 1.2em;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="hero">
            <div class="header">
                <div>
                    <h1>🏠 Danh sách phòng</h1>
                    <div class="subtitle">Homestay #<%= homestayId %></div>
                </div>
                <div>
                    <a href="/homestay-management/homestays/<%= homestayId %>" class="btn btn-secondary">← Quay lại</a>
                </div>
            </div>
        </div>
        
        <div class="content">
            <% if (rooms != null && !rooms.isEmpty()) { %>
                <div class="room-grid">
                    <% for (Room room : rooms) { %>
                        <div class="room-card" style="cursor: pointer;" onclick="window.location.href='/homestay-management/homestays/<%= homestayId %>/rooms/<%= room.getId() %>'">
                            <div class="room-image">
                                <% if (room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
                                    <img src="<%= room.getImage() %>" alt="<%= room.getRoomNumber() %>" />
                                <% } else { %>
                                    <div style="display: flex; align-items: center; justify-content: center; height: 100%; color: #ccc; font-size: 3em;">🏠</div>
                                <% } %>
                            </div>
                            <div class="room-info">
                                <h3 class="room-number"><%= room.getRoomNumber() %></h3>
                                <p class="room-type"><%= room.getType() %></p>
                                <p class="room-price"><%= formatPrice(room.getPrice()) %> / đêm</p>
                                <span class="room-status status-<%= room.getStatus() != null ? room.getStatus().toLowerCase() : "available" %>">
                                    <% if ("AVAILABLE".equals(room.getStatus())) { %>
                                        ✅ Còn trống
                                    <% } else if ("BOOKED".equals(room.getStatus())) { %>
                                        ❌ Đã đặt
                                    <% } else if ("MAINTENANCE".equals(room.getStatus())) { %>
                                        🔧 Bảo trì
                                    <% } else { %>
                                        ❓ Không xác định
                                    <% } %>
                                </span>
                                <% if (room.getDescription() != null && !room.getDescription().trim().isEmpty()) { %>
                                    <p class="room-description"><%= room.getDescription() %></p>
                                <% } %>
                            </div>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="no-rooms">
                    <h3>📭 Chưa có phòng nào</h3>
                    <p>Homestay này chưa có phòng nào được thêm vào.</p>
                </div>
            <% } %>
            
            <div class="actions">
                <a href="/homestay-management/homestays" class="btn btn-primary">🏠 Xem tất cả homestay</a>
            </div>
        </div>
    </div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
