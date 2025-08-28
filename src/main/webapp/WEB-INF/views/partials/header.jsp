<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.homestay.model.User" %>
<%
    String ctx = request.getContextPath();
    User currentUser = (User) session.getAttribute("currentUser");
%>
<style>
html, body { margin:0; padding:0; }
/* Header cố định, luôn sát mép trên và nằm trên mọi nội dung */
.site-header { display:flex; align-items:center; justify-content:space-between; padding:14px 22px; background:#0d6efd; color:#fff; box-shadow:0 2px 8px rgba(0,0,0,.08); position:fixed; top:0; left:0; right:0; z-index:10000; width:100%; box-sizing:border-box; }
.brand { font-weight:700; font-size:20px; letter-spacing:.2px; }
.menu-center { display:flex; gap:18px; align-items:center; margin:0 auto; }
.menu-center a { color:#fff; text-decoration:none; padding:8px 14px; border-radius:6px; transition:.15s; font-weight:500; font-size:1.08em; }
.menu-center a:hover { background:rgba(255,255,255,.16); }
.header-right { display:flex; align-items:center; gap:16px; }
.cta { background:#ffc107; color:#212529 !important; font-weight:600; border-radius:6px; padding:8px 14px; text-decoration:none; margin-right:8px; }
.user-dropdown { position:relative; display:inline-block; }
.user-btn { background:rgba(255,255,255,.16); color:#fff; border:none; border-radius:999px; padding:8px 18px; font-weight:600; font-size:1.08em; cursor:pointer; display:flex; align-items:center; gap:8px; }
.user-btn i { font-size:1.1em; }
.dropdown-content { display:none; position:absolute; right:0; background:#fff; min-width:180px; box-shadow:0 2px 12px rgba(0,0,0,0.12); border-radius:10px; z-index:999; margin-top:8px; }
.dropdown-content a { color:#222; padding:12px 18px; text-decoration:none; display:block; border-bottom:1px solid #f1f1f1; font-weight:500; }
.dropdown-content a:last-child { border-bottom:none; }
.dropdown-content a:hover { background:#f4f6fb; color:#0d6efd; }
.user-dropdown.open .dropdown-content { display:block; }
@media (max-width: 900px) {
    .site-header { flex-direction:column; align-items:stretch; padding:10px 4vw; }
    .menu-center { justify-content:center; gap:10px; }
    .header-right { flex-direction:column; gap:8px; align-items:flex-end; }
}
</style>
<header class="site-header">
    <div class="brand"><a href="<%= (currentUser != null && "MANAGER".equals(currentUser.getRole())) ? (ctx+"/manager/dashboard") : (ctx+"/home") %>" style="color:#fff; text-decoration:none;">Homestay Management</a></div>
    <nav class="menu-center">
        <a href="<%= (currentUser != null && "MANAGER".equals(currentUser.getRole())) ? (ctx+"/manager/dashboard") : (ctx+"/home") %>">Trang chủ</a>
        <% if (currentUser == null || !"MANAGER".equals(currentUser.getRole())) { %>
            <a href="<%=ctx%>/homestays">Homestays</a>
            <a href="<%=ctx%>/services">Services</a>
        <% } %>
    </nav>
    <div class="header-right">
        <a class="cta" href="<%=ctx%>/manager/register">Đăng ký quản lý homestay</a>
        <% if (currentUser == null) { %>
            <a href="<%=ctx%>/login">Đăng nhập</a>
            <a href="<%=ctx%>/register">Đăng ký</a>
        <% } else { %>
            <div class="user-dropdown" id="userDropdown">
                <button class="user-btn" id="userDropdownBtn" type="button">
                    <i class="fa-solid fa-user"></i>
                    <%= currentUser.getFullName() != null ? currentUser.getFullName() : currentUser.getUsername() %>
                    <i class="fa-solid fa-caret-down"></i>
                </button>
                <div class="dropdown-content">
                    <a href="<%=ctx%>/user/profile"><i class="fa-regular fa-id-card"></i> Trang cá nhân</a>
                    <% if ("USER".equals(currentUser.getRole())) { %>
                        <a href="<%=ctx%>/user/bookings"><i class="fa-solid fa-clock-rotate-left"></i> Lịch sử đặt vé</a>
                        <a href="<%=ctx%>/user/payments"><i class="fa-solid fa-money-check-dollar"></i> Lịch sử thanh toán</a>
                    <% } %>
                    <a href="<%=ctx%>/logout"><i class="fa-solid fa-right-from-bracket"></i> Đăng xuất</a>
                </div>
            </div>
        <% } %>
    </div>
</header>
<div style="height:60px;"></div>
<script src="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.2/js/all.min.js"></script>
<script>
// Dropdown user menu fix
(function() {
  var dropdown = document.getElementById('userDropdown');
  var btn = document.getElementById('userDropdownBtn');
  if (dropdown && btn) {
    btn.addEventListener('click', function(e) {
      e.stopPropagation();
      dropdown.classList.toggle('open');
    });
    // Đóng dropdown khi click ra ngoài
    document.addEventListener('click', function(e) {
      if (!dropdown.contains(e.target)) dropdown.classList.remove('open');
    });
    // Đóng dropdown khi tab đi chỗ khác
    btn.addEventListener('blur', function() {
      setTimeout(function() { dropdown.classList.remove('open'); }, 200);
    });
  }
})();
</script>
