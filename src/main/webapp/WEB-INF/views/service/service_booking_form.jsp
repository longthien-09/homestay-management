<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.* , com.homestay.model.Service" %>
<%
    List<Map<String,Object>> bookings = (List<Map<String,Object>>) request.getAttribute("bookings");
    List<Service> services = (List<Service>) request.getAttribute("services");
    Integer selectedBookingId = (Integer) request.getAttribute("selectedBookingId");
    String error = (String) request.getAttribute("error");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Chọn dịch vụ</title>
    <style>
        body { font-family: Arial, sans-serif; background:#fff; margin:0; }
        .wrap { padding:16px; }
        .alert { padding:10px 12px; border-radius:8px; margin-bottom:12px; background:#fdecea; color:#b0302f; border:1px solid #f5c6cb; }
        .grid { display:grid; grid-template-columns: repeat(auto-fit,minmax(220px,1fr)); gap:10px; }
        .service-item { display:flex; align-items:center; gap:8px; padding:10px; background:#f8f9fa; border:1px solid #e9ecef; border-radius:8px; }
        .actions { display:flex; justify-content:flex-end; gap:8px; margin-top:12px; }
        .btn { padding:10px 16px; border-radius:8px; border:none; cursor:pointer; font-weight:600; }
        .btn-primary { background:#667eea; color:#fff; }
        .btn-secondary { background:#e9ecef; color:#2c3e50; }
        select { padding:8px; }
    </style>
</head>
<body>
<div class="wrap">
    <% if (error != null) { %>
        <div class="alert"><%= error %></div>
    <% } %>
    <form method="post" action="<%= request.getContextPath() %>/user/services/book">
        <label>Booking:</label>
        <select name="bookingId">
            <% if (bookings != null) for (Map<String,Object> b : bookings) { Integer bid=(Integer)b.get("booking_id"); %>
                <option value="<%= bid %>" <%= bid.equals(selectedBookingId)?"selected":"" %>>#<%= bid %> - <%= b.get("homestay_name") %></option>
            <% } %>
        </select>
        <div style="height:10px"></div>
        <div class="grid">
            <% if (services != null) for (Service s : services) { %>
                <label class="service-item">
                    <input type="checkbox" name="serviceIds" value="<%= s.getId() %>" />
                    <span><b><%= s.getName() %></b> - <%= s.getPrice() != null ? s.getPrice() : "" %></span>
                </label>
            <% } %>
        </div>
        <div class="actions">
            <button type="submit" class="btn btn-primary">Thêm vào booking</button>
        </div>
    </form>
</div>
</body>
</html>

<script>
(function(){
  var select = document.querySelector('select[name="bookingId"]');
  if (!select) return;
  select.addEventListener('change', function(){
    var bid = this.value;
    var container = document.getElementById('serviceModalContent');
    if (!container) container = window.parent && window.parent.document.getElementById('serviceModalContent');
    if (!container) return;
    var url = '<%= request.getContextPath() %>/user/services/book?bookingId=' + encodeURIComponent(bid);
    fetch(url, { credentials: 'include' })
      .then(function(r){ return r.text(); })
      .then(function(html){ container.innerHTML = html; })
      .catch(function(){ /* ignore */ });
  });
})();
</script>


