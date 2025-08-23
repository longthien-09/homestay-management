<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%
    List<Homestay> homestays = (List<Homestay>) request.getAttribute("homestays");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; }
        h2 { color: #2c3e50; text-align: center; }
        table { border-collapse: collapse; width: 90%; margin: 20px auto; background: #fff; box-shadow: 0 2px 8px #ccc; border-radius: 8px; overflow: hidden; }
        th, td { padding: 12px 10px; text-align: center; }
        th { background: #3498db; color: #fff; }
        tr:nth-child(even) { background: #f2f2f2; }
        tr:hover { background: #eaf6fb; }
        a { text-decoration: none; color: #2980b9; margin: 0 4px; }
        a:hover { text-decoration: underline; }
        .btn-add { display: inline-block; margin: 20px auto; background: #27ae60; color: #fff; padding: 8px 18px; border-radius: 5px; font-weight: bold; text-align: center; }
        .btn-add:hover { background: #219150; }
        img { border-radius: 6px; max-width: 100px; max-height: 70px; box-shadow: 0 1px 4px #aaa; }
    </style>
</head>
<body>
    <h2>Danh sách Homestay</h2>
    <a class="btn-add" href="/homestay-management/admin/homestays/add">Thêm Homestay mới</a>
    <% if (request.getAttribute("error") != null) { %>
        <div style="color: red; text-align: center; font-weight: bold; margin-bottom: 10px; background: #ffe6e6; padding: 10px; border-radius: 5px;">
            <%= request.getAttribute("error") %>
        </div>
    <% } %>
    <% if (request.getAttribute("success") != null) { %>
        <div style="color: green; text-align: center; font-weight: bold; margin-bottom: 10px; background: #e6ffe6; padding: 10px; border-radius: 5px;">
            <%= request.getAttribute("success") %>
        </div>
    <% } %>
    <table border="1">
        <tr>
            <th>ID</th>
            <th>Tên</th>
            <th>Địa chỉ</th>
            <th>Số phone</th>
            <th>Mô tả</th>
            <th>Hình ảnh</th>
            <th>Hành động</th>
        </tr>
        <% if (homestays != null) for (Homestay h : homestays) { %>
        <tr>
            <td><%= h.getId() %></td>
            <td><%= h.getName() %></td>
            <td><%= h.getAddress() %></td>
            <td><%= h.getPhone() %></td>
            <td><%= h.getDescription() %></td>
            <td><img src="<%= h.getImage() %>" alt="Hình ảnh" /></td>
            <td>
                <a href="/homestay-management/admin/homestays/edit/<%= h.getId() %>">Sửa</a> |
                <a href="/homestay-management/admin/homestays/delete/<%= h.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa?');">Xóa</a>
            </td>
        </tr>
        <% } %>
    </table>
</body>
</html>
