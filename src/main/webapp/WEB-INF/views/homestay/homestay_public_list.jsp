<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> homestays = (List<Homestay>) request.getAttribute("homestays");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Danh sách Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        h2 { color: #2c3e50; text-align: center; margin-top: 30px; }
        .homestay-list { display: flex; flex-wrap: wrap; justify-content: center; gap: 28px; margin: 30px 0; }
        .homestay-card {
            background: #fff; border-radius: 10px; box-shadow: 0 2px 8px #ccc;
            width: 320px; padding: 18px 18px 14px 18px; display: flex; flex-direction: column; align-items: center;
        }
        .homestay-card img { 
            border-radius: 8px; max-width: 100%; max-height: 180px; 
            margin-bottom: 12px; box-shadow: 0 1px 4px #aaa; 
            cursor: pointer; transition: transform 0.2s ease;
        }
        .homestay-card img:hover { transform: scale(1.05); }
        .homestay-card h3 { margin: 0 0 8px 0; color: #2980b9; }
        .homestay-card .address { color: #555; font-size: 15px; margin-bottom: 6px; }
    </style>
</head>
<body>
    <h2>Danh sách Homestay</h2>
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
</body>
</html>
