<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.homestay.model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
%>
<html>
<head>
    <title>Quản lý phòng - Admin</title>
    <style>
        .btn { padding: 4px 10px; border-radius: 4px; text-decoration: none; margin: 0 2px; }
        .btn-add { background: #27ae60; color: #fff; }
        .btn-edit { background: #2980b9; color: #fff; }
        .btn-del { background: #c0392b; color: #fff; }
    </style>
</head>
<body>
    <h2>Quản lý phòng cho Homestay #<%= homestayId %></h2>
    <a class="btn btn-add" href="/homestay-management/admin/homestays/<%= homestayId %>/rooms/add">Thêm phòng mới</a>
    <table border="1" cellpadding="6" style="margin-top:10px;">
        <tr>
            <th>ID</th>
            <th>Số phòng</th>
            <th>Loại</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Mô tả</th>
            <th>Hình ảnh</th>
            <th>Hành động</th>
        </tr>
        <% if (rooms != null) for (Room room : rooms) { %>
            <tr>
                <td><%= room.getId() %></td>
                <td><%= room.getRoomNumber() %></td>
                <td><%= room.getType() %></td>
                <td><%= room.getPrice() %></td>
                <td><%= room.getStatus() %></td>
                <td><%= room.getDescription() %></td>
                <td>
                    <% if (room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
                        <img src="<%= room.getImage() %>" alt="Ảnh phòng" style="max-width:80px; max-height:60px; border-radius:6px; box-shadow:0 1px 4px #aaa;" />
                    <% } else { %>
                        <span style="color:#aaa;">(Không có ảnh)</span>
                    <% } %>
                </td>
                <td>
                    <a class="btn btn-edit" href="/homestay-management/admin/homestays/<%= homestayId %>/rooms/edit/<%= room.getId() %>">Sửa</a>
                    <a class="btn btn-del" href="/homestay-management/admin/homestays/<%= homestayId %>/rooms/delete/<%= room.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa phòng này?');">Xóa</a>
                </td>
            </tr>
        <% } %>
    </table>
</body>
</html> 