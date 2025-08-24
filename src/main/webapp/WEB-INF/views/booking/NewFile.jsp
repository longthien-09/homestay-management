<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    Integer homestayId = (Integer) request.getAttribute("homestayId");
    Integer roomId = (Integer) request.getAttribute("roomId");
    String error = (String) request.getAttribute("error");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Đặt phòng</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 20px; }
        .card { max-width: 600px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#667eea,#764ba2); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        .form-row { display: flex; gap: 16px; margin-bottom: 16px; }
        .form-group { flex: 1; }
        label { display: block; font-weight: 600; margin-bottom: 8px; color: #2c3e50; }
        input { width: 100%; padding: 12px 14px; border: 1px solid #e0e6ed; border-radius: 8px; font-size: 14px; }
        .actions { display: flex; justify-content: flex-end; gap: 12px; margin-top: 8px; }
        .btn { padding: 10px 18px; border-radius: 8px; border: none; cursor: pointer; font-weight: 600; }
        .btn-primary { background: #667eea; color: #fff; }
        .btn-secondary { background: #e9ecef; color: #2c3e50; }
        .alert { padding: 12px 14px; border-radius: 8px; margin-bottom: 16px; }
        .alert-error { background: #fdecea; color: #b0302f; border: 1px solid #f5c6cb; }
        .alert-success { background: #e6f4ea; color: #1e7e34; border: 1px solid #c3e6cb; }
        .meta { color: #6c757d; margin: 0 0 8px 0; }
    </style>
    <script>
        function presetMinDates() {
            const today = new Date().toISOString().split('T')[0];
            const ci = document.getElementById('checkIn');
            const co = document.getElementById('checkOut');
            if (ci && !ci.value) ci.value = today;
            if (co && !co.value) co.value = today;
            ci.min = today; co.min = today;
            ci.addEventListener('change', () => { co.min = ci.value; if (co.value < ci.value) co.value = ci.value; });
        }
        document.addEventListener('DOMContentLoaded', presetMinDates);
    </script>
</head>
<body>
    <div class="card">
        <div class="header">
            <h2>🗓️ Đặt phòng</h2>
            <p class="meta">Homestay #<%= homestayId %> • Phòng #<%= roomId %></p>
        </div>
        <div class="content">
            <% if (error != null) { %>
                <div class="alert alert-error"><%= error %></div>
            <% } %>
            <% if (message != null) { %>
                <div class="alert alert-success"><%= message %></div>
            <% } %>
            <form method="post" action="/homestay-management/homestays/<%= homestayId %>/rooms/<%= roomId %>/book">
                <div class="form-row">
                    <div class="form-group">
                        <label for="checkIn">Ngày nhận</label>
                        <input type="date" id="checkIn" name="checkIn" required />
                    </div>
                    <div class="form-group">
                        <label for="checkOut">Ngày trả</label>
                        <input type="date" id="checkOut" name="checkOut" required />
                    </div>
                </div>
                <div class="form-row">
                    <div class="form-group">
                        <label for="quantity">Số lượng phòng</label>
                        <input type="number" id="quantity" name="quantity" min="1" value="1" />
                        <p class="meta">Hiện tại chỉ hỗ trợ đặt 1 phòng/lần.</p>
                    </div>
                </div>
                <div class="actions">
                    <a class="btn btn-secondary" href="/homestay-management/homestays/<%= homestayId %>/rooms">Hủy</a>
                    <button type="submit" class="btn btn-primary">Gửi yêu cầu</button>
                </div>
            </form>
        </div>
    </div>
</body>
</html>