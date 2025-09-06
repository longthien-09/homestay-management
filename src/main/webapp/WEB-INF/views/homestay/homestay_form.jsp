<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    Homestay homestay = (Homestay) request.getAttribute("homestay");
    boolean isEdit = (homestay != null && homestay.getId() > 0);
%>
<%! private String nn(String s){ if(s==null) return ""; String t=s.trim(); return "null".equalsIgnoreCase(t)?"":s; } %>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Sửa" : "Thêm" %> Homestay</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        h2 { color: #2c3e50; text-align: center; }
        form { background: #fff; max-width: 420px; margin: 30px auto; padding: 28px 32px 20px 32px; border-radius: 10px; box-shadow: 0 2px 10px #ccc; }
        label { display: block; margin-top: 12px; font-weight: bold; color: #34495e; }
        input[type="text"], textarea, input[type="file"] { width: 100%; padding: 8px; margin-top: 4px; border: 1px solid #ccc; border-radius: 5px; font-size: 15px; background: #f9f9f9; }
        textarea { min-height: 60px; resize: vertical; }
        button { background: #2980b9; color: #fff; border: none; padding: 10px 22px; border-radius: 5px; margin-top: 18px; font-size: 16px; cursor: pointer; font-weight: bold; }
        button:hover { background: #1c5d8c; }
        a { color: #888; margin-left: 18px; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
    <h2><%= isEdit ? "Sửa" : "Thêm" %> Homestay</h2>
    <form method="post" enctype="multipart/form-data" action="<%= isEdit ? "../edit" : "/homestay-management/manager/homestays/add" %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= homestay.getId() %>" />
        <% } %>
        <label>Tên:</label>
        <input type="text" name="name" value="<%= homestay != null ? nn(homestay.getName()) : "" %>" required/>
        <label>Địa chỉ:</label>
        <input type="text" name="address" value="<%= homestay != null ? nn(homestay.getAddress()) : "" %>" required/>
        <label>Mô tả:</label>
        <textarea name="description" required><%= homestay != null ? nn(homestay.getDescription()) : "" %></textarea>
        <label>Hình ảnh đại diện:</label>
        <input type="file" name="imageFile" accept="image/*" />
        <% if (homestay != null && homestay.getImage() != null && !homestay.getImage().trim().isEmpty()) { %>
            <div style="margin-top: 5px; font-size: 12px; color: #666;">
                Ảnh hiện tại: <a href="<%= nn(homestay.getImage()) %>" target="_blank">Xem ảnh</a>
            </div>
        <% } %>
        <label>Ảnh gallery (có thể chọn nhiều):</label>
        <input type="file" name="galleryFiles" accept="image/*" multiple />
        <div style="font-size:12px;color:#666;margin-top:4px">Các ảnh này sẽ hiển thị ở gallery trang chi tiết.</div>
        
        <label>Email:</label>
        <input type="email" name="email" value="<%= homestay != null ? nn(homestay.getEmail()) : "" %>" placeholder="example@email.com" />
        <label>Số điện thoại:</label>
        <input type="text" name="phone" value="<%= homestay != null ? nn(homestay.getPhone()) : "" %>" required/>
        <button type="submit">Lưu</button>
        <a href="../homestays">Hủy</a>
        <a href="/homestay-management/manager/homestays" style="margin-left:10px;display:inline-block;padding:6px 12px;border:1px solid #ddd;border-radius:6px;text-decoration:none;color:#333;background:#f8f9fa">← Quay lại</a>
    </form>
</body>
<%@ include file="../partials/footer.jsp" %>
</html>
