<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký tài khoản</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .register-container {
            width: 400px; margin: 60px auto; background: #fff; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px 30px 20px 30px;
        }
        .register-container h2 { text-align: center; margin-bottom: 25px; color: #333; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; margin-bottom: 6px; color: #555; }
        .form-group input {
            width: 100%; padding: 8px 10px; border: 1px solid #ccc; border-radius: 5px;
            font-size: 15px;
        }
        .btn {
            width: 100%; background: #28a745; color: #fff; border: none;
            padding: 10px; border-radius: 5px; font-size: 16px; cursor: pointer;
            transition: background 0.2s;
        }
        .btn:hover { background: #218838; }
        .login-link { text-align: center; margin-top: 15px; }
        .error { color: #d8000c; background: #ffd2d2; padding: 8px; border-radius: 5px; margin-bottom: 10px; text-align: center; }
        .message { color: #155724; background: #d4edda; padding: 8px; border-radius: 5px; margin-bottom: 10px; text-align: center; }
    </style>
</head>
<body>
<div class="register-container">
    <h2>Đăng ký tài khoản</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("message") != null) { %>
        <div class="message"><%= request.getAttribute("message") %></div>
    <% } %>
    <form method="post" action="register">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" required />
        </div>
        <div class="form-group">
            <label for="fullName">Họ và tên</label>
            <input type="text" id="fullName" name="fullName" required />
        </div>
        <div class="form-group">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required />
        </div>
        <div class="form-group">
            <label for="phone">Số điện thoại</label>
            <input type="text" id="phone" name="phone" required />
        </div>
        <button class="btn" type="submit">Đăng ký</button>
    </form>
    <div class="login-link">
        Đã có tài khoản? <a href="login">Đăng nhập</a>
    </div>
</div>
</body>
</html>