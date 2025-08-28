<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.Service, java.util.List, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    Service service = (Service) request.getAttribute("service");
    boolean isEdit = (service != null && service.getId() > 0);
%>
<%! private String nn(String s){ if(s==null) return ""; String t=s.trim(); return "null".equalsIgnoreCase(t)?"":s; } %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title><%= isEdit ? "Sửa dịch vụ" : "Thêm dịch vụ mới" %></title>
    <style>
        body { font-family: Arial, sans-serif; background: #f7f7f7; margin: 0; padding: 0; }
        .form-container { max-width: 420px; margin: 40px auto; background: #fff; border-radius: 12px; box-shadow: 0 2px 12px #ccc; padding: 32px; }
        h2 { color: #2c3e50; text-align: center; margin-bottom: 24px; }
        label { display: block; margin-top: 14px; font-weight: bold; color: #34495e; }
        input, textarea { width: 100%; padding: 8px; margin-top: 4px; border: 1px solid #ccc; border-radius: 5px; font-size: 15px; background: #f9f9f9; }
        textarea { min-height: 60px; resize: vertical; }
        button { background: #2980b9; color: #fff; border: none; padding: 10px 22px; border-radius: 5px; margin-top: 18px; font-size: 16px; cursor: pointer; font-weight: bold; }
        button:hover { background: #1c5d8c; }
        a { color: #888; margin-left: 18px; text-decoration: none; }
        a:hover { text-decoration: underline; }
    </style>
</head>
<body>
<div class="form-container">
    <h2><%= isEdit ? "Sửa dịch vụ" : "Thêm dịch vụ mới" %></h2>
    <form method="post" action="<%= isEdit ? "/homestay-management/manager/services/edit" : "/homestay-management/manager/services/add" %>">
        <% if (isEdit) { %>
            <input type="hidden" name="id" value="<%= service.getId() %>" />
        <% } %>
        <label>Homestay:</label>
        <%
            List<Homestay> homestayOptions = (List<Homestay>) request.getAttribute("homestayOptions");
            Integer selectedHsId = (service != null && service.getHomestayId() > 0) ? service.getHomestayId() : null;
        %>
        <select name="homestayId" <%= (homestayOptions != null && homestayOptions.size() > 1) ? "" : "disabled" %> style="width:100%; padding:8px; border:1px solid #ccc; border-radius:5px; background:#f9f9f9;">
            <% if (homestayOptions != null) {
                   for (Homestay h : homestayOptions) { %>
                <option value="<%= h.getId() %>" <%= (selectedHsId != null && selectedHsId == h.getId()) ? "selected" : "" %>><%= h.getName() != null ? h.getName() : ("#"+h.getId()) %></option>
            <%   }
               }
            %>
        </select>
        <% if (homestayOptions != null && homestayOptions.size() == 1) { %>
            <input type="hidden" name="homestayId" value="<%= homestayOptions.get(0).getId() %>">
        <% } %>
        <label>Tên dịch vụ:</label>
        <input type="text" name="name" value="<%= service != null ? nn(service.getName()) : "" %>" required />
        <label>Giá:</label>
        <input type="number" step="0.01" name="price" value="<%= service != null && service.getPrice() != null ? service.getPrice() : "" %>" required />
        <label>Mô tả:</label>
        <textarea name="description" required><%= service != null ? nn(service.getDescription()) : "" %></textarea>
        <button type="submit">Lưu</button>
        <a href="/homestay-management/manager/services">Hủy</a>
        <a href="/homestay-management/manager/services" style="margin-left:10px;display:inline-block;padding:6px 12px;border:1px solid #ddd;border-radius:6px;text-decoration:none;color:#333;background:#f8f9fa">← Quay lại</a>
    </form>
</div>
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
