<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.User" %>
<%
    List<User> users = (List<User>) request.getAttribute("users");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý người dùng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .container { width: 900px; margin: 40px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px; }
        h2 { text-align: center; color: #333; }
        table { width: 100%; border-collapse: collapse; margin-top: 20px; }
        th, td { padding: 10px; border: 1px solid #ddd; text-align: center; }
        th { background: #007bff; color: #fff; }
        tr:nth-child(even) { background: #f9f9f9; }
        .btn {
            padding: 6px 16px; border: none; border-radius: 5px; color: #fff; cursor: pointer;
        }
        .btn-lock { background: #dc3545; }
        .btn-unlock { background: #28a745; }
    </style>
</head>
<body>
<div class="container">
    <h2>Quản lý người dùng</h2>
    <table>
        <tr>
            <th>ID</th>
            <th>Tên đăng nhập</th>
            <th>Họ tên</th>
            <th>Email</th>
            <th>SĐT</th>
            <th>Role</th>
            <th>Homestay ID</th>
            <th>Trạng thái</th>
            <th>Hành động</th>
        </tr>
        <% if (users != null) for (User user : users) { %>
        <tr>
            <td><%= user.getId() %></td>
            <td><%= user.getUsername() %></td>
            <td><%= user.getFullName() %></td>
            <td><%= user.getEmail() %></td>
            <td><%= user.getPhone() %></td>
            <td><%= user.getRole() %></td>
            <td><%= user.getHomestayId() %></td>
            <td><%= user.isActive() ? "Hoạt động" : "Đã khóa" %></td>
            <td>
                <form method="post" action="/user/setActive" style="display:inline;">
                    <input type="hidden" name="id" value="<%= user.getId() %>" />
                    <input type="hidden" name="active" value="<%= !user.isActive() %>" />
                    <% if (user.isActive()) { %>
                        <button class="btn btn-lock" type="submit">Khóa</button>
                    <% } else { %>
                        <button class="btn btn-unlock" type="submit">Mở</button>
                    <% } %>
                </form>
            </td>
        </tr>
        <% } %>
    </table>
</div>
</body>
</html>