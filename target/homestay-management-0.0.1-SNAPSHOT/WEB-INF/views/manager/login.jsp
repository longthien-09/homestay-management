<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng nhập Quản lý Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .box { width: 380px; margin: 80px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,.1); padding: 28px; }
        h2 { text-align:center; margin:0 0 20px; color:#333; }
        .group { margin-bottom:16px; }
        label { display:block; margin-bottom:6px; color:#555; }
        input { width:100%; padding:9px 10px; border:1px solid #ccc; border-radius:6px; font-size:15px; }
        .btn { width:100%; background:#0d6efd; color:#fff; border:none; padding:10px; border-radius:6px; font-size:16px; cursor:pointer; }
        .btn:hover { background:#0b5ed7; }
        .error { color:#d8000c; background:#ffd2d2; padding:8px; border-radius:6px; text-align:center; margin-bottom:10px; }
        .hint { text-align:center; margin-top:12px; }
    </style>
</head>
<body>
<div class="box">
    <h2>Đăng nhập Quản lý Homestay</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <form method="post" action="<%=request.getContextPath()%>/homestay-manager/login">
        <div class="group">
            <label for="username">Tên đăng nhập</label>
            <input id="username" name="username" required />
        </div>
        <div class="group">
            <label for="password">Mật khẩu</label>
            <input id="password" type="password" name="password" required />
        </div>
        <button class="btn" type="submit">Đăng nhập</button>
    </form>
    <div class="hint">
        Chưa có tài khoản quản lý? <a href="<%=request.getContextPath()%>/homestay-manager/register">Đăng ký</a>
    </div>
</div>
</body>
</html>
