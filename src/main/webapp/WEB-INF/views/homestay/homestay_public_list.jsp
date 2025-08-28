<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Homestay> homestays = (List<Homestay>) request.getAttribute("homestays");
    String filteredByService = (String) request.getAttribute("filteredByService");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        h2 { color: #2c3e50; text-align: center; margin-top: 30px; }
        .homestay-list { 
            display: grid; 
            grid-template-columns: repeat(3, minmax(300px, 1fr)); 
            gap: 25px; 
            margin: 30px auto; 
            max-width: 1100px; 
            padding: 0 20px;
            box-sizing: border-box;
        }
        .homestay-card {
            background: #fff; 
            border-radius: 15px; 
            box-shadow: 0 4px 15px rgba(0,0,0,0.1); 
            padding: 20px; 
            display: flex; 
            flex-direction: column; 
            align-items: center;
            transition: all 0.3s ease;
            border: 1px solid #f0f0f0;
            width: 100%;
            box-sizing: border-box;
            overflow: hidden;
        }
        .homestay-card:hover {
            transform: translateY(-5px);
            box-shadow: 0 8px 25px rgba(0,0,0,0.15);
        }
        .homestay-card img { 
            border-radius: 12px; 
            width: 100%; 
            height: 200px; 
            object-fit: cover;
            margin-bottom: 15px; 
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); 
            cursor: pointer; 
            transition: all 0.3s ease;
            max-width: 100%;
            box-sizing: border-box;
        }
        .homestay-card img:hover { 
            transform: scale(1.05); 
            box-shadow: 0 4px 15px rgba(0,0,0,0.2);
        }
        .homestay-card h3 { 
            margin: 0 0 10px 0; 
            color: #2c3e50; 
            font-size: 1.3em;
            text-align: center;
            font-weight: 600;
        }
        .homestay-card .address { 
            color: #555; 
            font-size: 14px; 
            margin-bottom: 8px; 
            text-align: center;
            line-height: 1.4;
        }
        
        /* Responsive design */
        @media (max-width: 1024px) {
            .homestay-list {
                grid-template-columns: repeat(2, minmax(280px, 1fr));
                max-width: 800px;
                gap: 20px;
            }
        }
        
        @media (max-width: 768px) {
            .homestay-list {
                grid-template-columns: 1fr;
                max-width: 350px;
                gap: 20px;
                padding: 0 15px;
            }
            .homestay-card {
                padding: 15px;
            }
            .homestay-card img {
                height: 180px;
            }
        }
        
        @media (max-width: 480px) {
            .homestay-list {
                padding: 0 10px;
                gap: 15px;
            }
            .homestay-card {
                padding: 12px;
            }
        }
    </style>
</head>
<body>
    <h2>Danh sách Homestay</h2>
    <% if (filteredByService != null && !filteredByService.trim().isEmpty()) { %>
        <div style="text-align: center; margin: 20px 0; padding: 15px; background: #e8f5e8; border-radius: 8px; border: 1px solid #4caf50; color: #2e7d32; max-width: 600px; margin-left: auto; margin-right: auto;">
            <strong>🔍 Đang hiển thị homestay có dịch vụ:</strong> "<%= filteredByService %>"
            <br><small>Kết quả tìm thấy: <%= homestays != null ? homestays.size() : 0 %> homestay</small>
        </div>
    <% } %>
    <div class="homestay-list">
        <% if (homestays != null && !homestays.isEmpty()) for (Homestay h : homestays) { %>
        <div class="homestay-card">
            <a href="/homestay-management/homestays/<%= h.getId() %>">
                <img src="<%= h.getImage() %>" alt="Hình ảnh" />
            </a>
            <h3><%= h.getName() %></h3>
            <div class="address"><b>Địa chỉ:</b> <%= h.getAddress() %></div>
        </div>
        <% } else { %>
        <div style="text-align:center; color:#888; font-size:18px;">Chưa có homestay nào!</div>
        <% } %>
    </div>
    
    <!-- Thêm phân trang -->
    <%@ include file="../partials/pagination.jsp" %>
</body>
<%@ include file="../partials/footer.jsp" %>
</html>
