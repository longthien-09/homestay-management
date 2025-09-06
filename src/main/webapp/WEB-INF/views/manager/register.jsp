<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đăng ký Quản lý Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f0f2f5; }
        .box { width: 480px; margin: 60px auto; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,.1); padding: 28px; }
        h2 { text-align:center; margin:0 0 20px; color:#333; }
        .grid { display:grid; grid-template-columns: 1fr 1fr; gap: 14px; }
        .grid .full { grid-column: 1 / 3; }
        label { display:block; margin-bottom:6px; color:#555; }
        input { width:100%; padding:9px 10px; border:1px solid #ccc; border-radius:6px; font-size:15px; }
        .btn { width:100%; background:#198754; color:#fff; border:none; padding:10px; border-radius:6px; font-size:16px; cursor:pointer; margin-top:10px; }
        .btn:hover { background:#157347; }
        .error { color:#d8000c; background:#ffd2d2; padding:8px; border-radius:6px; text-align:center; margin-bottom:10px; }
        .message { color:#155724; background:#d4edda; padding:8px; border-radius:6px; text-align:center; margin-bottom:10px; }
    </style>
</head>
<body>
<div class="box">
    <h2>Đăng ký Quản lý Homestay</h2>
    <% if (request.getAttribute("error") != null) { %>
        <div class="error"><%= request.getAttribute("error") %></div>
    <% } %>
    <% if (request.getAttribute("message") != null) { %>
        <div class="message"><%= request.getAttribute("message") %></div>
    <% } %>
    <form method="post" action="<%= (request.getContextPath() != null ? request.getContextPath() : "") %>/manager/register">
        <div class="grid">
            <div class="full">
                <label for="username">Tên đăng nhập</label>
                <input id="username" name="username" required />
            </div>
            <div>
                <label for="password">Mật khẩu</label>
                <input id="password" type="password" name="password" required />
            </div>
            <div>
                <label for="fullName">Họ và tên</label>
                <input id="fullName" name="fullName" required />
            </div>
            <div>
                <label for="email">Email</label>
                <input id="email" type="email" name="email" required />
            </div>
            <div>
                <label for="phone">Số điện thoại</label>
                <input id="phone" name="phone" required />
            </div>
            <div class="full">
                <label for="homestayName">Tên Homestay</label>
                <input id="homestayName" name="homestayName" required />
            </div>
            <div>
                <label for="address">Địa chỉ</label>
                <input id="address" name="address" />
            </div>
            <div>
                <label for="hsEmail">Email Homestay</label>
                <input id="hsEmail" type="email" name="hsEmail" />
            </div>
            <div>
                <label for="hsPhone">SĐT Homestay</label>
                <input id="hsPhone" name="hsPhone" />
            </div>
        </div>
        <button class="btn" type="submit">Đăng ký quản lý</button>
    </form>
</div>
</body>
</html>
