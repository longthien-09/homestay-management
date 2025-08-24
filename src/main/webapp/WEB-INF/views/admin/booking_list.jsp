<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*" %>
<%
    List<Map<String,Object>> bookings = (List<Map<String,Object>>) request.getAttribute("bookings");
    Integer homestayId = (Integer) request.getAttribute("homestayId");
    String status = (String) request.getAttribute("status");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý đặt phòng (Admin)</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 20px; }
        .card { max-width: 1100px; margin: 0 auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,0.08); overflow: hidden; }
        .header { background: linear-gradient(135deg,#ff7eb3,#ff758c); color: #fff; padding: 24px; }
        .content { padding: 24px; }
        .filters { display: flex; gap: 12px; margin-bottom: 16px; }
        input, select { padding: 8px 10px; border: 1px solid #e0e6ed; border-radius: 8px; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 10px 8px; border-bottom: 1px solid #eee; text-align: left; }
        th { background: #f1f3f5; font-weight: 700; color: #2c3e50; }
        .badge { padding: 6px 10px; border-radius: 12px; font-size: 12px; font-weight: 700; }
        .badge-PENDING { background: #fff3cd; color: #856404; }
        .badge-CONFIRMED { background: #d4edda; color: #155724; }
        .badge-CANCELLED { background: #f8d7da; color: #721c24; }
        .actions { display: flex; gap: 8px; }
        .btn { padding: 6px 10px; border-radius: 6px; border: none; cursor: pointer; font-weight: 600; }
        .btn-approve { background: #28a745; color: #fff; }
        .btn-reject { background: #dc3545; color: #fff; }
        /* Back link styled like user's page (rounded grey pill) */
        .btn-home {
            display: inline-block;
            padding: 8px 14px;
            background: #e9ecef;
            color: #2b3640;
            border-radius: 999px;
            font-weight: 700;
            text-decoration: none;
            border: 1px solid #dfe3e7;
            box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.03);
            transition: background-color 0.15s ease, color 0.15s ease, box-shadow 0.15s ease;
        }
        .btn-home:hover {
            background: #dfe3e7;
            color: #1f2d3d;
            text-decoration: none;
            box-shadow: inset 0 -1px 0 rgba(0, 0, 0, 0.06);
        }
        /* Place back button on the right at top area only */
        .top-actions { display: flex; justify-content: flex-end; margin-bottom: 12px; }
    </style>
</head>
<body>
<div class="card">
    <div class="header">
        <h2>🛠️ Quản lý đặt phòng</h2>
        <p>lọc theo homestay và trạng thái</p>
    </div>
    <div class="content">
        <div class="top-actions">
            <a href="${pageContext.request.contextPath}/" class="btn btn-home">← Quay lại trang chính</a>
        </div>
        <form method="get" action="/homestay-management/admin/bookings" class="filters">
            <input type="number" name="homestayId" placeholder="Homestay ID" value="<%= homestayId != null ? homestayId : "" %>">
            <select name="status">
                <option value="" <%= (status==null||status.isEmpty())?"selected":"" %>>Tất cả trạng thái</option>
                <option value="PENDING" <%= "PENDING".equals(status)?"selected":"" %>>PENDING</option>
                <option value="CONFIRMED" <%= "CONFIRMED".equals(status)?"selected":"" %>>CONFIRMED</option>
                <option value="CANCELLED" <%= "CANCELLED".equals(status)?"selected":"" %>>CANCELLED</option>
            </select>
            <button type="submit">Lọc</button>
        </form>
        <table>
            <thead>
            <tr>
                <th>#</th>
                <th>Homestay</th>
                <th>Phòng</th>
                <th>Khách</th>
                <th>Nhận</th>
                <th>Trả</th>
                <th>Trạng thái</th>
                <th>Tạo lúc</th>
                <th>Thao tác</th>
            </tr>
            </thead>
            <tbody>
            <% if (bookings != null && !bookings.isEmpty()) { int i=1; for (Map<String,Object> r : bookings) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td>#<%= r.get("homestay_id") %> - <%= r.get("homestay_name") %></td>
                    <td>#<%= r.get("room_id") %> - <%= r.get("room_number") %></td>
                    <td><%= r.get("user_name") %> (@<%= r.get("username") %>)</td>
                    <td><%= r.get("check_in") %></td>
                    <td><%= r.get("check_out") %></td>
                    <td><span class="badge badge-<%= r.get("status") %>"><%= r.get("status") %></span></td>
                    <td><%= r.get("created_at") %></td>
                    <td>
                        <div class="actions">
                            <form method="post" action="/homestay-management/admin/bookings/<%= r.get("id") %>/approve" style="display:inline;">
                                <button class="btn btn-approve" type="submit">Duyệt</button>
                            </form>
                            <form method="post" action="/homestay-management/admin/bookings/<%= r.get("id") %>/reject" style="display:inline;">
                                <button class="btn btn-reject" type="submit">Hủy</button>
                            </form>
                        </div>
                    </td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="9">Không có đặt phòng nào.</td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
</body>
</html>
