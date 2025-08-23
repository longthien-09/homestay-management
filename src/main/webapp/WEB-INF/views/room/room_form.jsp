<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.homestay.model.Room" %>
<%
    Room room = (Room) request.getAttribute("room");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
    boolean isEdit = (room != null && room.getId() > 0);
%>
<html>
<head>
    <title><%= isEdit ? "Sửa" : "Thêm" %> phòng</title>
    <style>
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
    <h2 style="text-align:center;"><%= isEdit ? "Sửa" : "Thêm" %> phòng cho Homestay #<%= homestayId %></h2>
    <form method="post" action="<%= isEdit ? ("/homestay-management/admin/homestays/" + homestayId + "/rooms/edit") : ("/homestay-management/admin/homestays/" + homestayId + "/rooms/add") %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= room.getId() %>" />
        <% } %>
        <input type="hidden" name="homestayId" value="<%= homestayId %>" />
        <label>Số phòng:</label>
        <input type="text" name="roomNumber" value="<%= room != null ? room.getRoomNumber() : "" %>" required />
        <label>Loại phòng:</label>
        <input type="text" name="type" value="<%= room != null ? room.getType() : "" %>" required />
        <label>Giá:</label>
        <input type="number" step="0.01" name="price" value="<%= room != null && room.getPrice() != null ? room.getPrice() : "" %>" required />
        <label>Trạng thái:</label>
        <select name="status">
            <option value="AVAILABLE" <%= room != null && "AVAILABLE".equals(room.getStatus()) ? "selected" : "" %>>Còn trống</option>
            <option value="BOOKED" <%= room != null && "BOOKED".equals(room.getStatus()) ? "selected" : "" %>>Đã đặt</option>
            <option value="MAINTENANCE" <%= room != null && "MAINTENANCE".equals(room.getStatus()) ? "selected" : "" %>>Bảo trì</option>
        </select>
        <label>Mô tả:</label>
        <textarea name="description"><%= room != null ? room.getDescription() : "" %></textarea>
        <label>Link hình ảnh:</label>
        <input type="text" name="image" value="<%= room != null ? room.getImage() : "" %>" placeholder="https://example.com/image.jpg" />
        <% if (room != null && room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
            <div style="margin-top: 5px; font-size: 12px; color: #666;">
                Ảnh hiện tại: <a href="<%= room.getImage() %>" target="_blank">Xem ảnh</a>
            </div>
        <% } %>
        <button type="submit">Lưu</button>
        <a href="/homestay-management/admin/homestays/<%= homestayId %>/rooms">Hủy</a>
    </form>
</body>
</html>
