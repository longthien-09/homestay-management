<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Service, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Service> services = (List<Service>) request.getAttribute("services");
    List<Homestay> homestayOptions = (List<Homestay>) request.getAttribute("homestayOptions");
    Integer homestayId = (request.getAttribute("homestayId") != null) ? (Integer) request.getAttribute("homestayId") : null;
    
    // Lấy tất cả dịch vụ có sẵn từ database (sẽ được truyền từ controller)
    List<Service> allAvailableServices = (List<Service>) request.getAttribute("allAvailableServices");
    if (allAvailableServices == null) allAvailableServices = new java.util.ArrayList<>();
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Quản lý dịch vụ - Manager</title>
    <style>
        body { font-family: Arial, sans-serif; background: #f6f8fb; margin: 0; padding: 0; }
        .container { max-width: 1200px; margin: 22px auto; background: #fff; border-radius: 12px; box-shadow: 0 8px 24px rgba(0,0,0,.06); overflow: hidden; }
        .header { display: flex; align-items: center; justify-content: space-between; padding: 18px 20px; background: linear-gradient(135deg, #667eea, #764ba2); color: #fff; }
        .header h2 { margin: 0; font-weight: 700; }
        .homestay-selector { display: flex; align-items: center; gap: 12px; }
        .homestay-selector label { font-weight: 600; }
        .homestay-selector select { padding: 8px 12px; border: 1px solid rgba(255,255,255,0.3); border-radius: 8px; background: rgba(255,255,255,0.1); color: white; min-width: 200px; }
        .homestay-selector select option { background: #667eea; color: white; }
        
        .content { padding: 24px; }
        .section-title { font-size: 1.3em; font-weight: 600; color: #2c3e50; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        
        .services-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(300px, 1fr)); gap: 20px; margin-bottom: 30px; }
        .service-card { background: white; border: 2px solid #e9ecef; border-radius: 12px; padding: 20px; transition: all 0.3s ease; position: relative; }
        .service-card:hover { transform: translateY(-2px); box-shadow: 0 8px 20px rgba(0,0,0,0.1); }
        .service-card.selected { border-color: #667eea; background: linear-gradient(135deg, #f8f9ff, #f0f4ff); }
        .service-card.selected::before { content: "✓"; position: absolute; top: -8px; right: -8px; background: #667eea; color: white; width: 24px; height: 24px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: bold; font-size: 14px; }
        
        .service-name { font-size: 1.2em; font-weight: 600; color: #2c3e50; margin-bottom: 8px; }
        .service-price { font-size: 1.1em; font-weight: 700; color: #27ae60; margin-bottom: 12px; }
        .service-description { color: #6c757d; line-height: 1.5; margin-bottom: 16px; }
        .service-actions { display: flex; gap: 10px; }
        
        .btn { padding: 8px 16px; border-radius: 6px; text-decoration: none; font-weight: 600; font-size: 0.9em; transition: all 0.2s; border: none; cursor: pointer; }
        .btn-primary { background: #667eea; color: white; }
        .btn-primary:hover { background: #5a6fd8; }
        .btn-secondary { background: #6c757d; color: white; }
        .btn-secondary:hover { background: #5a6268; }
        .btn-success { background: #27ae60; color: white; }
        .btn-success:hover { background: #219150; }
        
        .current-services { background: #f8f9fa; padding: 20px; border-radius: 12px; margin-top: 30px; }
        .current-services h3 { margin: 0 0 20px 0; color: #2c3e50; }
        .current-services-table { width: 100%; border-collapse: collapse; }
        .current-services-table th, .current-services-table td { padding: 12px; text-align: left; border-bottom: 1px solid #e9ecef; }
        .current-services-table th { background: #e9ecef; font-weight: 600; color: #2c3e50; }
        
        .no-services { text-align: center; padding: 40px; color: #6c757d; }
        .no-services i { font-size: 3em; margin-bottom: 20px; color: #dee2e6; }
        
        @media (max-width: 768px) {
            .services-grid { grid-template-columns: 1fr; }
            .header { flex-direction: column; gap: 15px; align-items: stretch; }
        }
    </style>
</head>
<body>
<div class="container">
        <div class="header">
            <h2>🔧 Quản lý dịch vụ Homestay</h2>
            <div style="display: flex; align-items: center; gap: 20px;">
                <div class="homestay-selector">
                    <label for="hsSelect">Chọn Homestay:</label>
                    <select id="hsSelect">
                    <% if (homestayOptions != null) {
                           for (Homestay h : homestayOptions) { %>
                        <option value="<%= h.getId() %>" <%= (homestayId != null && homestayId == h.getId()) ? "selected" : "" %>><%= h.getName() != null ? h.getName() : ("#"+h.getId()) %></option>
                    <%   }
                       }
                    %>
                </select>
                </div>
                <a href="/homestay-management/manager/services/add" class="btn btn-success" style="text-decoration: none;">
                    ➕ Thêm dịch vụ mới
                </a>
            </div>
        </div>
        
        <div class="content">
            <div class="section-title">
                <i class="fa-solid fa-list-check" style="color: #667eea;"></i>
                Chọn dịch vụ cho homestay
            </div>
            
            <div class="services-grid">
                <% if (allAvailableServices != null && !allAvailableServices.isEmpty()) {
                       for (Service service : allAvailableServices) {
                           boolean isSelected = services != null && services.stream().anyMatch(s -> s.getName().equals(service.getName()));
                %>
                    <div class="service-card <%= isSelected ? "selected" : "" %>" data-service-id="<%= service.getId() %>" data-service-name="<%= service.getName() %>" data-service-price="<%= service.getPrice() %>" data-service-description="<%= service.getDescription() %>">
                        <div class="service-name"><%= service.getName() %></div>
                        <div class="service-price"><%= String.format("%,.0f₫", service.getPrice().doubleValue()) %></div>
                        <div class="service-description"><%= service.getDescription() %></div>
                        <div class="service-actions">
                            <% if (isSelected) { %>
                                <button class="btn btn-secondary" onclick="removeService('<%= service.getName() %>')">
                                    <i class="fa-solid fa-times"></i> Bỏ chọn
                                </button>
                            <% } else { %>
                                <button class="btn btn-success" onclick="addService('<%= service.getName() %>', '<%= service.getPrice() %>', '<%= service.getDescription() %>')">
                                    <i class="fa-solid fa-plus"></i> Thêm vào homestay
                                </button>
                            <% } %>
                        </div>
                    </div>
                <%   }
                   } else { %>
                    <div class="no-services">
                        <i class="fa-solid fa-cog"></i>
                        <h3>Không có dịch vụ nào</h3>
                        <p>Chưa có dịch vụ mẫu nào trong hệ thống.</p>
                    </div>
                <% } %>
            </div>
            
            <!-- Dịch vụ hiện tại của homestay -->
            <div class="current-services">
                <h3><i class="fa-solid fa-check-circle" style="color: #27ae60;"></i> Dịch vụ hiện tại của homestay</h3>
                <% if (services != null && !services.isEmpty()) { %>
                    <table class="current-services-table">
                        <thead>
                            <tr>
            <th>Tên dịch vụ</th>
            <th>Giá</th>
            <th>Mô tả</th>
            <th>Hành động</th>
        </tr>
                        </thead>
                        <tbody>
                            <% for (Service s : services) { %>
        <tr>
            <td><%= s.getName() %></td>
                                    <td><%= String.format("%,.0f₫", s.getPrice().doubleValue()) %></td>
            <td><%= s.getDescription() %></td>
            <td>
                                        <a class="btn btn-primary" href="/homestay-management/manager/services/edit/<%= s.getId() %>">
                                            <i class="fa-solid fa-edit"></i> Sửa
                                        </a>
                                        <a class="btn btn-secondary" href="/homestay-management/manager/services/delete/<%= s.getId() %>" onclick="return confirm('Bạn có chắc muốn xóa dịch vụ này?');">
                                            <i class="fa-solid fa-trash"></i> Xóa
                                        </a>
            </td>
        </tr>
                            <% } %>
                        </tbody>
                    </table>
        <% } else { %>
                    <div class="no-services">
                        <i class="fa-solid fa-info-circle"></i>
                        <p>Homestay này chưa có dịch vụ nào. Hãy chọn dịch vụ từ danh sách bên trên!</p>
                    </div>
        <% } %>
            </div>
        </div>
</div>
    
<script>
        // Xử lý thay đổi homestay
        document.getElementById('hsSelect').addEventListener('change', function() {
    var id = this.value;
    if (!id) return;
            window.location.href = '/homestay-management/manager/services?homestayId=' + id;
        });
        
        // Thêm dịch vụ vào homestay
        function addService(name, price, description) {
            if (confirm('Bạn có muốn thêm dịch vụ "' + name + '" vào homestay này?')) {
                // Gọi API để thêm dịch vụ
                var homestayId = document.getElementById('hsSelect').value;
                var formData = new FormData();
                formData.append('name', name);
                formData.append('price', price);
                formData.append('description', description);
                formData.append('homestayId', homestayId);
                
                fetch('/homestay-management/manager/services/add', {
                    method: 'POST',
                    body: formData
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi thêm dịch vụ!');
                    }
                }).catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi thêm dịch vụ!');
                });
            }
        }
        
        // Bỏ chọn dịch vụ (chỉ bỏ khỏi homestay, không xóa khỏi database)
        function removeService(name) {
            if (confirm('Bạn có muốn bỏ chọn dịch vụ "' + name + '" khỏi homestay này?')) {
                // Gọi API để bỏ chọn dịch vụ
                var homestayId = document.getElementById('hsSelect').value;
                
                fetch('/homestay-management/manager/services/delete-by-name', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'name=' + encodeURIComponent(name) + '&homestayId=' + homestayId
                }).then(response => {
                    if (response.ok) {
                        location.reload();
                    } else {
                        alert('Có lỗi xảy ra khi bỏ chọn dịch vụ!');
                    }
                }).catch(error => {
                    console.error('Error:', error);
                    alert('Có lỗi xảy ra khi bỏ chọn dịch vụ!');
                });
            }
        }
</script>
    
<%@ include file="../partials/footer.jsp" %>
</body>
</html>
