<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../partials/header.jspf" %>
<%@ page import="com.homestay.model.User" %>
<%
    User user = (User) request.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Thông tin cá nhân - Homestay Management</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; margin: 0; }
        .profile-container {
            max-width: 500px; margin: 40px auto; background: #fff; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px;
        }
        .profile-container h2 { text-align: center; margin-bottom: 25px; color: #333; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; color: #555; font-weight: 500; }
        .form-group input {
            width: 100%; padding: 10px 12px; border: 1px solid #ddd; border-radius: 6px;
            font-size: 15px; box-sizing: border-box;
        }
        .form-group input:focus {
            outline: none; border-color: #0d6efd; box-shadow: 0 0 0 2px rgba(13, 110, 253, 0.25);
        }
        .form-group input[readonly] {
            background-color: #f8f9fa; color: #6c757d;
        }
        .btn {
            width: 100%; background: #0d6efd; color: #fff; border: none;
            padding: 12px; border-radius: 6px; font-size: 16px; cursor: pointer;
            transition: background 0.2s; font-weight: 500;
        }
        .btn:hover { background: #0b5ed7; }
        .message { 
            color: #155724; background: #d1e7dd; padding: 12px; border-radius: 6px; 
            margin-bottom: 20px; text-align: center; border: 1px solid #badbcc;
        }
        .user-info {
            background: #f8f9fa; padding: 15px; border-radius: 6px; margin-bottom: 20px;
            border-left: 4px solid #0d6efd;
        }
        .user-info p { margin: 5px 0; color: #555; }
        .user-info strong { color: #333; }
    </style>
</head>
<body>
<div class="profile-container">
    <h2>Thông tin cá nhân</h2>
    
    <% if (request.getAttribute("message") != null) { %>
        <div class="message"><%= request.getAttribute("message") %></div>
    <% } %>
    
    <div class="user-info">
        <p><strong>Vai trò:</strong> <%= user.getRole() != null ? user.getRole() : "N/A" %></p>
        <% if (user.getHomestayId() != null && user.getHomestayId() > 0) { %>
            <p><strong>Homestay ID:</strong> <%= user.getHomestayId() %></p>
        <% } else { %>
            <p><strong>Homestay ID:</strong> Chưa được gán</p>
        <% } %>
        <p><strong>Trạng thái:</strong> <%= user.isActive() ? "Hoạt động" : "Đã khóa" %></p>
    </div>
    
    <form method="post" action="<%=request.getContextPath()%>/user/profile">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" value="<%= user.getUsername() != null ? user.getUsername() : "" %>" readonly />
        </div>
        <div class="form-group">
            <label for="fullName">Họ và tên</label>
            <input type="text" id="fullName" name="fullName" value="<%= user.getFullName() != null ? user.getFullName() : "" %>" required />
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" value="<%= user.getEmail() != null ? user.getEmail() : "" %>" required />
        </div>
        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="text" id="phone" name="phone" value="<%= user.getPhone() != null ? user.getPhone() : "" %>" required />
        </div>
        <button class="btn" type="submit">Cập nhật thông tin</button>
    </form>
</div>
<%@ include file="../partials/footer.jspf" %>
</body>
</html>
