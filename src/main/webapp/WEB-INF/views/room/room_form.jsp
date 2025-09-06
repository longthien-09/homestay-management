<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Room" %>
<%
    Room room = (Room) request.getAttribute("room");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
    boolean isEdit = (room != null && room.getId() > 0);
%>
<%@ include file="../partials/header.jsp" %>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Sửa" : "Thêm" %> phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        form { max-width: 400px; margin: 30px auto; background: #f7f7f7; padding: 24px; border-radius: 8px; box-shadow: 0 2px 8px #ccc; }
        label { display: block; margin-top: 12px; font-weight: bold; }
        input, select, textarea { width: 100%; padding: 8px; margin-top: 4px; border: 1px solid #ccc; border-radius: 5px; }
        button { background: #2980b9; color: #fff; border: none; padding: 10px 22px; border-radius: 5px; margin-top: 18px; font-size: 16px; cursor: pointer; font-weight: bold; }
        button:hover { background: #1c5d8c; }
        a { color: #888; margin-left: 18px; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <%! private String nn(String s){ if(s==null) return ""; String t=s.trim(); return "null".equalsIgnoreCase(t)?"":s; } %>
    <h2 style="text-align:center;"><%= isEdit ? "Sửa" : "Thêm" %> phòng cho Homestay #<%= homestayId %></h2>
    <form method="post" action="<%= isEdit ? ("/homestay-management/manager/homestays/" + homestayId + "/rooms/edit") : ("/homestay-management/manager/homestays/" + homestayId + "/rooms/add") %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= room.getId() %>" />
        <% } %>
        <input type="hidden" name="homestayId" value="<%= homestayId %>" />
        <% java.util.List<com.homestay.model.Homestay> homestayOptions = (java.util.List<com.homestay.model.Homestay>) request.getAttribute("homestayOptions"); %>
        <% if (homestayOptions != null && !homestayOptions.isEmpty()) { %>
            <label>Homestay:</label>
            <select name="homestaySelect" onchange="document.querySelector('input[name=homestayId]').value=this.value;">
                <% for (com.homestay.model.Homestay hs : homestayOptions) { %>
                    <option value="<%= hs.getId() %>" <%= hs.getId()==homestayId?"selected":"" %>><%= hs.getName() != null ? hs.getName() : ("Homestay #"+hs.getId()) %></option>
                <% } %>
            </select>
        <% } else { %>
            <div>Homestay: <b>#<%= homestayId %></b></div>
        <% } %>
        <label>Số phòng:</label>
        <input type="text" name="roomNumber" value="<%= room != null ? nn(room.getRoomNumber()) : "" %>" required />
        <label>Loại phòng:</label>
        <input type="text" name="type" value="<%= room != null ? nn(room.getType()) : "" %>" required />
        <label>Giá:</label>
        <input type="number" step="0.01" name="price" value="<%= room != null && room.getPrice() != null ? room.getPrice() : "" %>" required />
        <label>Trạng thái:</label>
        <select name="status">
            <option value="AVAILABLE" <%= room != null && "AVAILABLE".equals(room.getStatus()) ? "selected" : "" %>>Còn trống</option>
            <option value="BOOKED" <%= room != null && "BOOKED".equals(room.getStatus()) ? "selected" : "" %>>Đã đặt</option>
            <option value="MAINTENANCE" <%= room != null && "MAINTENANCE".equals(room.getStatus()) ? "selected" : "" %>>Bảo trì</option>
        </select>
        <label>Mô tả:</label>
        <textarea name="description"><%= room != null ? nn(room.getDescription()) : "" %></textarea>
        <button type="submit">Lưu</button>
        <a href="/homestay-management/manager/homestays/<%= homestayId %>/rooms">Hủy</a>
        <a href="/homestay-management/manager/homestays/<%= homestayId %>/rooms" style="margin-left:10px;display:inline-block;padding:6px 12px;border:1px solid #ddd;border-radius:6px;text-decoration:none;color:#333;background:#f8f9fa">← Quay lại</a>
    </form>
</body>
<%@ include file="../partials/footer.jsp" %>
</html>
