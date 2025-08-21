<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.User" %>
<%
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .profile-container {
            width: 450px; margin: 60px auto; background: #fff; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px 30px 20px 30px;
        }
        .profile-container h2 { text-align: center; margin-bottom: 25px; color: #333; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; color: #555; }
        .form-group input {
            width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 5px;
            font-size: 15px;
        }
        .btn {
            width: 100%; background: #007bff; color: #fff; border: none;
            padding: 10px; border-radius: 5px; font-size: 16px; cursor: pointer;
            transition: background 0.2s;
        }
        .btn:hover { background: #0056b3; }
        .message { color: #155724; background: #d4edda; padding: 8px; border-radius: 5px; margin-bottom: 10px; text-align: center; }
    </style>
</head>
<body>
<div class="profile-container">
    <h2>Thông tin cá nhân</h2>
    <% if (request.getAttribute("message") != null) { %>
        <div class="message"><%= request.getAttribute("message") %></div>
    <% } %>
    <form method="post" action="/user/profile">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" value="<%= user.getUsername() %>" readonly />
        </div>
        <div class="form-group">
            <label for="fullName">Họ và tên</label>
            <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() %>" required />
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= user.getEmail() %>" required />
        </div>
        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="text" id="phone" name="phone" value="<%= user.getPhone() %>" required />
        </div>
        <button class="btn" type="submit">Cập nhật</button>
    </form>
</div>
</body>
</html>