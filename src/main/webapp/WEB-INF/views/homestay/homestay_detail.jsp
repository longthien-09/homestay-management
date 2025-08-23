<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Homestay" %>
<%
    Homestay homestay = (Homestay) request.getAttribute("homestay");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= homestay != null ? homestay.getName() : "Chi tiết Homestay" %></title>
    <style>
        body { 
            font-family: Arial, sans-serif; 
            background: #f7f7f7; 
            margin: 0; 
            padding: 20px;
        }
        .container {
            max-width: 800px;
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
        .back-link {
            display: inline-block;
            margin-top: 20px;
            color: #667eea;
            text-decoration: none;
        }
        .back-link:hover {
            text-decoration: underline;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h1><%= homestay != null ? homestay.getName() : "Homestay" %></h1>
        </div>
        
        <div class="content">
            <% if (homestay != null && homestay.getImage() != null && !homestay.getImage().trim().isEmpty()) { %>
            <div class="image-section">
                <img src="<%= homestay.getImage() %>" alt="<%= homestay.getName() %>" />
            </div>
            <% } %>
            
            <div class="info-grid">
                <div class="info-item">
                    <h3>📍 Địa chỉ</h3>
                    <p><%= homestay != null && homestay.getAddress() != null ? homestay.getAddress() : "Chưa cập nhật" %></p>
                </div>
                
                <div class="info-item">
                    <h3>📞 Điện thoại</h3>
                    <p><%= homestay != null && homestay.getPhone() != null ? homestay.getPhone() : "Chưa cập nhật" %></p>
                </div>
                
                <div class="info-item">
                    <h3>✉️ Email</h3>
                    <p><%= homestay != null && homestay.getEmail() != null ? homestay.getEmail() : "Chưa cập nhật" %></p>
                </div>
                
                <div class="info-item">
                    <h3>🆔 Mã số</h3>
                    <p>#<%= homestay != null ? homestay.getId() : "N/A" %></p>
                </div>
            </div>
            
            <div class="description">
                <h3>📝 Mô tả</h3>
                <p><%= homestay != null && homestay.getDescription() != null ? homestay.getDescription() : "Chưa có mô tả chi tiết." %></p>
            </div>
            
            <div class="actions">
                <a href="/homestay-management/homestays" class="btn btn-secondary">← Quay lại danh sách</a>
                <a href="/homestay-management/homestays/<%= homestay.getId() %>/rooms" class="btn btn-primary">🏠 Xem danh sách phòng</a>
                <% if (session.getAttribute("currentUser") != null && "ADMIN".equals(((com.homestay.model.User)session.getAttribute("currentUser")).getRole())) { %>
                <a href="/homestay-management/admin/homestays/edit/<%= homestay.getId() %>" class="btn btn-primary">✏️ Chỉnh sửa</a>
                <% } %>
            </div>
        </div>
    </div>
    
    <div style="text-align: center; margin-top: 20px;">
        <a href="/homestay-management/home" class="back-link">← Về trang chủ</a>
    </div>
</body>
</html>
