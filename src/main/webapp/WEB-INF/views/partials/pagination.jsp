<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Lấy các tham số phân trang từ request
    Integer currentPage = (Integer) request.getAttribute("currentPage");
    Integer totalPages = (Integer) request.getAttribute("totalPages");
    Integer pageSize = (Integer) request.getAttribute("pageSize");
    Integer totalItems = (Integer) request.getAttribute("totalItems");
    String serviceFilter = (String) request.getAttribute("filteredByService");
    
    // Nếu không có tham số thì dùng giá trị mặc định
    if (currentPage == null) currentPage = 1;
    if (totalPages == null) totalPages = 1;
    if (pageSize == null) pageSize = 6;
    if (totalItems == null) totalItems = 0;
    
    // Tính toán trang bắt đầu và kết thúc để hiển thị
    int startPage = Math.max(1, currentPage - 2);
    int endPage = Math.min(totalPages, currentPage + 2);
    
    // Tạo URL cơ bản
    String baseUrl = request.getContextPath() + "/homestays";
    if (serviceFilter != null && !serviceFilter.trim().isEmpty()) {
        baseUrl += "?service=" + java.net.URLEncoder.encode(serviceFilter, "UTF-8");
    } else {
        baseUrl += "?";
    }
%>

<style>
.pagination-container {
    display: flex;
    justify-content: center;
    align-items: center;
    margin: 40px 0;
    gap: 10px;
}



.pagination {
    display: flex;
    gap: 5px;
    align-items: center;
}

.pagination a, .pagination span {
    display: inline-block;
    padding: 10px 15px;
    text-decoration: none;
    border: 1px solid #ddd;
    border-radius: 5px;
    color: #333;
    background: #fff;
    transition: all 0.3s ease;
    min-width: 40px;
    text-align: center;
}

.pagination a:hover {
    background: #007bff;
    color: #fff;
    border-color: #007bff;
    transform: translateY(-2px);
    box-shadow: 0 4px 8px rgba(0,123,255,0.3);
}

.pagination .current {
    background: #007bff;
    color: #fff;
    border-color: #007bff;
    font-weight: bold;
}

.pagination .disabled {
    color: #ccc;
    cursor: not-allowed;
    background: #f8f9fa;
}

.pagination .disabled:hover {
    background: #f8f9fa;
    color: #ccc;
    transform: none;
    box-shadow: none;
}



@media (max-width: 768px) {
    .pagination-container {
        flex-direction: column;
        gap: 15px;
    }
    
    .pagination {
        flex-wrap: wrap;
        justify-content: center;
    }
    

}
</style>

<div class="pagination-container">
    <!-- Nút phân trang -->
    <div class="pagination">
        <!-- Nút Trang đầu -->
        <% if (currentPage > 1) { %>
            <a href="<%= baseUrl %>&page=1" title="Trang đầu">
                <i class="fas fa-angle-double-left"></i>
            </a>
        <% } else { %>
            <span class="disabled">
                <i class="fas fa-angle-double-left"></i>
            </span>
        <% } %>
        
        <!-- Nút Trang trước -->
        <% if (currentPage > 1) { %>
            <a href="<%= baseUrl %>&page=<%= currentPage - 1 %>" title="Trang trước">
                <i class="fas fa-angle-left"></i>
            </a>
        <% } else { %>
            <span class="disabled">
                <i class="fas fa-angle-left"></i>
            </span>
        <% } %>
        
        <!-- Các trang số -->
        <% for (int i = startPage; i <= endPage; i++) { %>
            <% if (i == currentPage) { %>
                <span class="current"><%= i %></span>
            <% } else { %>
                <a href="<%= baseUrl %>&page=<%= i %>"><%= i %></a>
            <% } %>
        <% } %>
        
        <!-- Nút Trang sau -->
        <% if (currentPage < totalPages) { %>
            <a href="<%= baseUrl %>&page=<%= currentPage + 1 %>" title="Trang sau">
                <i class="fas fa-angle-right"></i>
            </a>
        <% } else { %>
            <span class="disabled">
                <i class="fas fa-angle-right"></i>
            </span>
        <% } %>
        
        <!-- Nút Trang cuối -->
        <% if (currentPage < totalPages) { %>
            <a href="<%= baseUrl %>&page=<%= totalPages %>" title="Trang cuối">
                <i class="fas fa-angle-double-right"></i>
            </a>
        <% } else { %>
            <span class="disabled">
                <i class="fas fa-angle-double-right"></i>
            </span>
        <% } %>
    </div>
    

</div>

<script>


// Thêm Font Awesome nếu chưa có
if (!document.querySelector('link[href*="font-awesome"]')) {
    const link = document.createElement('link');
    link.rel = 'stylesheet';
    link.href = 'https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/css/all.min.css';
    document.head.appendChild(link);
}
</script>
