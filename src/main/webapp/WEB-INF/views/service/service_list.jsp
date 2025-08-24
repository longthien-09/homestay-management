<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Service" %>
<%@ include file="../partials/header.jspf" %>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý dịch vụ - Manager</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        .container { max-width: 900px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px #ccc; padding: 32px; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 30px; }
        .btn-add { background: #27ae60; color: #fff; padding: 10px 22px; border-radius: 6px; font-weight: bold; text-decoration: none; margin-bottom: 18px; display: inline-block; }
        .btn-add:hover { background: #219150; }
        table { width: 100%; border-collapse: collapse; margin-top: 18px; }
        th, td { padding: 12px 10px; text-align: center; }
        th { background: #3498db; color: #fff; }
        tr:nth-child(even) { background: #f2f2f2; }
        tr:hover { background: #eaf6fb; }
        .btn { padding: 6px 14px; border-radius: 4px; text-decoration: none; margin: 0 2px; font-weight: 500; }
        .btn-edit { background: #2980b9; color: #fff; }
        .btn-del { background: #c0392b; color: #fff; }
    </style>
</head>
<body>
<div class="container">
    <h2>Quản lý dịch vụ Homestay</h2>
    <a class="btn-add" href="/homestay-management/manager/services/add">+ Thêm dịch vụ mới</a>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Tên dịch vụ</th>
            <th>Giá</th>
            <th>Mô tả</th>
            <th>Hành động</th>
        </tr>
        <% if (services != null && !services.isEmpty()) for (Service s : services) { %>
        <tr>
            <td><%= s.getId() %></td>
            <td><%= s.getName() %></td>
            <td><%= s.getPrice() %></td>
            <td><%= s.getDescription() %></td>
            <td>
                <a class="btn btn-edit" href="/homestay-management/manager/services/edit/<%= s.getId() %>">Sửa</a>
                <a class="btn btn-del" href="/homestay-management/manager/services/delete/<%= s.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?');">Xóa</a>
            </td>
        </tr>
        <% } else { %>
        <tr><td colspan="5" style="color:#888;">Chưa có dịch vụ nào!</td></tr>
        <% } %>
    </table>
</div>
<%@ include file="../partials/footer.jspf" %>
</body>
</html>
