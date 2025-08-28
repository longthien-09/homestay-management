<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Room, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%! private String formatPrice(java.math.BigDecimal price) { 
    if (price == null) return "0₫";
    return String.format("%,.0f₫", price.doubleValue()).replace(",", ".");
} %>
<%
    List<Room> rooms = (List<Room>) request.getAttribute("rooms");
    int homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : 0;
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .container { max-width: 1100px; margin: 22px auto; background:#fff; border-radius:12px; box-shadow:0 8px 24px rgba(0,0,0,.06); overflow:hidden; }
        .header { display:flex; align-items:center; justify-content:space-between; padding:18px 20px; background:linear-gradient(135deg,#667eea,#764ba2); color:#fff; }
        .header h2 { margin:0; font-weight:700; }
        .actions-top a { text-decoration:none; padding:8px 14px; border-radius:8px; color:#fff; background:#27ae60; box-shadow:0 2px 8px rgba(39,174,96,.3); }
        table { width:100%; border-collapse: collapse; }
        th, td { padding:12px 10px; border-bottom:1px solid #eef0f5; text-align:left; }
        th { background:#f8f9fc; font-weight:700; color:#2c3e50; }
        tr:hover { background:#fafbff; }
        .status { padding:4px 10px; border-radius:999px; font-size:.86em; font-weight:700; }
        .status-AVAILABLE { background:#d4edda; color:#155724; }
        .status-BOOKED { background:#f8d7da; color:#721c24; }
        .status-MAINTENANCE { background:#fff3cd; color:#856404; }
        .btn { padding:8px 12px; border-radius:8px; text-decoration:none; margin:0 4px; display:inline-block; font-weight:600; }
        .btn-edit { background:#2980b9; color:#fff; }
        .btn-del { background:#c0392b; color:#fff; }
        .thumb { max-width:90px; max-height:60px; border-radius:8px; box-shadow:0 1px 4px rgba(0,0,0,.12); }
    </style>
</head>
<body>
    <div class="container">
        <div class="header">
            <h2>Quản lý phòng • Homestay #<%= homestayId %><% if (request.getAttribute("homestayName") != null) { %> - <%= request.getAttribute("homestayName") %><% } %></h2>
            <div class="actions-top">
                <a href="/homestay-management/manager/homestays/<%= homestayId %>/rooms/add">+ Thêm phòng mới</a>
            </div>
        </div>
        <div style="display:flex; justify-content:space-between; align-items:center; padding:14px 20px; border-bottom:1px solid #eef0f5;">
            <div style="display:flex; align-items:center; gap:10px;">
                <label for="hsSelect" style="font-weight:600; color:#2c3e50;">Chọn homestay:</label>
                <select id="hsSelect" style="padding:8px 10px; border:1px solid #dce1eb; border-radius:8px; min-width:260px;">
                    <%
                        List<Homestay> homestayOptions = (List<Homestay>) request.getAttribute("homestayOptions");
                        if (homestayOptions != null) {
                            for (Homestay h : homestayOptions) {
                    %>
                        <option value="<%= h.getId() %>" <%= (h.getId() == homestayId) ? "selected" : "" %>><%= h.getName() != null ? h.getName() : ("#"+h.getId()) %></option>
                    <%
                            }
                        }
                    %>
                </select>
            </div>
        </div>
        <table>
            <tr>
                <th>#</th>
                <th>Tên homestay</th>
                <th>Số phòng</th>
                <th>Loại</th>
                <th>Giá</th>
                <th>Trạng thái</th>
                <th>Mô tả</th>
                <th>Hình</th>
                <th>Hành động</th>
            </tr>
            <% if (rooms != null) for (Room room : rooms) { %>
                <tr>
                    <td><%= room.getId() %></td>
                    <td class="hs-name"><%= request.getAttribute("homestayName") != null ? (String)request.getAttribute("homestayName") : ("#"+homestayId) %></td>
                    <td><%= room.getRoomNumber() %></td>
                    <td><%= room.getType() %></td>
                    <td><%= formatPrice(room.getPrice()) %></td>
                    <td><span class="status status-<%= room.getStatus() %>"><%= room.getStatus() %></span></td>
                    <td><%= room.getDescription() != null ? room.getDescription() : "" %></td>
                    <td>
                        <% if (room.getImage() != null && !room.getImage().trim().isEmpty()) { %>
                            <img src="<%= room.getImage() %>" alt="Ảnh phòng" class="thumb" />
                        <% } else { %>
                            <span style="color:#aaa;">(Không có ảnh)</span>
                        <% } %>
                    </td>
                    <td>
                        <a class="btn btn-edit" href="/homestay-management/manager/homestays/<%= homestayId %>/rooms/edit/<%= room.getId() %>">Sửa</a>
                        <a class="btn btn-del" href="/homestay-management/manager/homestays/<%= homestayId %>/rooms/delete/<%= room.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa phòng này?');">Xóa</a>
                    </td>
                </tr>
            <% } %>
        </table>
    </div>
    <script>
    (function(){
        var sel = document.getElementById('hsSelect');
        if (!sel) return;
        sel.addEventListener('change', function(){
            var id = this.value;
            if (!id) return;
            window.location.href = '/homestay-management/manager/homestays/' + id + '/rooms';
        });
    })();
    </script>
</body>
<%@ include file="../partials/footer.jsp" %>
</html> 