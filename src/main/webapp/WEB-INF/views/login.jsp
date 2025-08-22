<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .login-container {
            width: 350px; margin: 80px auto; background: #fff; border-radius: 10px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.1); padding: 30px 30px 20px 30px;
        }
        .login-container h2 { text-align: center; margin-bottom: 25px; color: #333; }
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
        .register-link { text-align: center; margin-top: 15px; }
        .error { color: #d8000c; background: #ffd2d2; padding: 8px; border-radius: 5px; margin-bottom: 10px; text-align: center; }
        .message { color: #155724; background: #d4edda; padding: 8px; border-radius: 5px; margin-bottom: 10px; text-align: center; }
    </style>
</head>
<body>
<div class="login-container">
    <h2>Đăng nhập</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("message") != null) { %>
        <div class="message"><%= request.getAttribute("message") %></div>
    <% } %>
    <form method="post" action="login">
        <div class="form-group">
            <label for="username">Tên đăng nhập</label>
            <input type="text" id="username" name="username" required />
        </div>
        <div class="form-group">
            <label for="password">Mật khẩu</label>
            <input type="password" id="password" name="password" required />
        </div>
        <button class="btn" type="submit">Đăng nhập</button>
    </form>
    <div class="register-link">
        Chưa có tài khoản? <a href="register">Đăng ký ngay</a>
    </div>
</div>
</body>
</html>