<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="java.util.List, com.homestay.model.Room" %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
%>
<html>
<head>
    <title>Danh sách phòng</title>
</head>
<body>
    <h2>Danh sách phòng</h2>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Số phòng</th>
            <th>Loại</th>
            <th>Giá</th>
            <th>Trạng thái</th>
            <th>Mô tả</th>
            <th>Homestay ID</th>
        </tr>
        <% if (rooms != null) for (Room room : rooms) { %>
            <tr>
                <td><%= room.getId() %></td>
                <td><%= room.getRoomNumber() %></td>
                <td><%= room.getType() %></td>
                <td><%= room.getPrice() %></td>
                <td><%= room.getStatus() %></td>
                <td><%= room.getDescription() %></td>
                <td><%= room.getHomestayId() %></td>
            </tr>
        <% } %>
    </table>
</body>
</html> 