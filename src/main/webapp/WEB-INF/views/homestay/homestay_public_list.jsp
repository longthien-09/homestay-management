<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.homestay.model.Homestay" %>
<%@ include file="../partials/header.jsp" %>
<%
    List<Homestay> homestays = (List<Homestay>) request.getAttribute("homestays");
    String filteredByService = (String) request.getAttribute("filteredByService");
%>
<html>
<head>
    <meta charset="UTF-8">
    <title>Kết quả tìm kiếm</title>
    <style>
        /* Booking-style top search bar */
        .topbar { position: sticky; top: 0; z-index: 50; background:#003580; padding:16px 0; }
        .topbar-inner { max-width:1200px; margin:0 auto; padding:0 16px; }
        .search-wrap { background:#fff; border:2px solid #febb02; border-radius:12px; display:grid; grid-template-columns: 1.2fr 1fr 1fr 1fr 160px; gap:8px; padding:10px; align-items:center; }
        .search-item { display:flex; align-items:center; gap:10px; padding:10px 12px; border-radius:10px; border:1px solid #e5e7eb; }
        .search-item input { border:none; outline:none; width:100%; font-size:14px; }
        .search-btn { background:#0071c2; color:#fff; border:none; border-radius:10px; padding:12px 16px; font-weight:700; cursor:pointer; }
        .search-btn:hover { background:#005da0; }
        body { font-family: Arial, sans-serif; background:#f5f6fa; margin:0; }
        .page { max-width:1200px; margin:24px auto; display:grid; grid-template-columns: 300px 1fr; gap:24px; padding:0 16px; }
        .sidebar { background:#fff; border:1px solid #e5e7eb; border-radius:10px; padding:16px; position:sticky; top:80px; height:max-content; }
        .filter-title { font-weight:700; margin:0 0 12px 0; color:#1f2937; }
        .filter-group { margin-bottom:16px; }
        .filter-group label { display:block; font-size:14px; color:#374151; margin-bottom:6px; }
        .filter-input, .filter-select { width:100%; padding:10px 12px; border:1px solid #e5e7eb; border-radius:8px; box-sizing:border-box; }
        .filter-actions { display:flex; gap:8px; }
        .btn { padding:10px 14px; border-radius:8px; border:1px solid #e5e7eb; cursor:pointer; background:#fff; }
        .btn-primary { background:#0d6efd; color:#fff; border-color:#0d6efd; }
        .results { display:flex; flex-direction:column; gap:16px; }
        .result-card { background:#fff; border:1px solid #e5e7eb; border-radius:12px; display:grid; grid-template-columns: 240px 1fr 180px; gap:16px; padding:12px; align-items:stretch; }
        .thumb { width:240px; height:180px; overflow:hidden; border-radius:10px; }
        .thumb img { width:100%; height:100%; object-fit:cover; }
        .result-body { padding:4px 0; }
        .result-title { margin:0 0 6px 0; font-size:18px; color:#111827; }
        .result-address { color:#6b7280; font-size:13px; margin-bottom:10px; }
        .tags { display:flex; flex-wrap:wrap; gap:6px; }
        .tag { background:#eef2ff; color:#3730a3; padding:6px 10px; border-radius:999px; font-size:12px; }
        .price-box { background:#f9fafb; border:1px solid #e5e7eb; border-radius:10px; padding:12px; text-align:right; display:flex; flex-direction:column; justify-content:space-between; }
        .price { font-size:20px; font-weight:800; color:#111827; }
        .tax-note { color:#6b7280; font-size:12px; }
        .btn-book { background:#0d6efd; color:#fff; border:none; padding:10px 12px; border-radius:8px; cursor:pointer; }
        .toolbar { display:flex; justify-content:space-between; align-items:center; margin-bottom:12px; color:#374151; }
        @media (max-width: 1024px) { .page { grid-template-columns: 1fr; } .result-card { grid-template-columns: 1fr; } .thumb { width:100%; height:200px; } .price-box { text-align:left; } }
        /* Booking-like dual range styles */
        .budget-wrap { margin-bottom: 0; }
        .histogram { height:60px; display:flex; align-items:flex-end; gap:3px; margin:6px 0 10px 0; }
        .histogram .bar { width:6px; background:#e5e7eb; border-radius:2px; }
        /* Dual range presented as one slider */
        .dual-range { position:relative; height:28px; }
        .dual-range .range-track { position:absolute; left:0; right:0; top:50%; transform:translateY(-50%); height:8px; border-radius:999px; background:#e5e7eb; }
        input[type=range] { -webkit-appearance:none; appearance:none; position:absolute; left:0; right:0; top:0; width:100%; height:28px; background:transparent; outline:none; pointer-events:auto; }
        input[type=range]::-webkit-slider-thumb { -webkit-appearance:none; appearance:none; width:18px; height:18px; background:#0d6efd; border-radius:50%; border:2px solid #fff; box-shadow:0 0 0 1px #0d6efd; cursor:pointer; }
        input[type=range]::-moz-range-thumb { width:18px; height:18px; background:#0d6efd; border:2px solid #fff; border-radius:50%; cursor:pointer; }
    </style>
</head>
<body>
    <!-- Top booking-like search bar -->
    <div class="topbar">
        <div class="topbar-inner">
            <form class="search-wrap" method="get" action="<%= request.getContextPath() %>/homestays">
                <div class="search-item">
                    <span>🏨</span>
                    <input type="text" name="q" placeholder="Bạn muốn đi đâu?" value="<%= request.getAttribute("q") != null ? request.getAttribute("q") : "" %>">
                </div>
                <div class="search-item">
                    <span>📅</span>
                    <input type="date" name="checkin" min="<%= java.time.LocalDate.now() %>" value="<%= request.getAttribute("checkin") != null ? request.getAttribute("checkin") : "" %>">
                </div>
                <div class="search-item">
                    <span>📅</span>
                    <input type="date" name="checkout" min="<%= java.time.LocalDate.now().plusDays(1) %>" value="<%= request.getAttribute("checkout") != null ? request.getAttribute("checkout") : "" %>">
                </div>
                <div class="search-item">
                    <span>🛏️</span>
                    <select name="roomType" style="border:none; outline:none; width:100%; font-size:14px;">
                        <%
                            String rt = (String) request.getAttribute("roomType");
                            String[][] types = new String[][]{
                                {"", "Tất cả loại phòng"},
                                {"đơn", "Phòng đơn"},
                                {"đôi", "Phòng đôi"},
                                {"hai giường", "Phòng hai giường"},
                                {"gia đình", "Phòng gia đình"},
                                {"studio", "Studio"},
                                {"căn hộ", "Căn hộ"}
                            };
                            for (String[] it : types) {
                        %>
                        <option value="<%= it[0] %>" <%= (rt != null && rt.equalsIgnoreCase(it[0])) ? "selected" : "" %>><%= it[1] %></option>
                        <% } %>
                    </select>
                </div>
                <!-- Removed guests input as requested -->
                <button class="search-btn" type="submit">Search</button>
            </form>
        </div>
    </div>

    <div class="page">
        <!-- Sidebar filters -->
        <aside class="sidebar">
            <form id="filters" method="get" action="<%= request.getContextPath() %>/homestays">
                <div class="filter-group">
                    <h3 class="filter-title">Bộ lọc</h3>
                </div>
                <div class="filter-group budget-wrap">
                    <label>Ngân sách (mỗi đêm)</label>
                    <div style="font-size:13px; color:#111827; margin:6px 0 10px 0;">
                        <span id="priceRangeText">VND 0 – VND 0</span>
                    </div>
                    <!-- Mini histogram -->
                    <div class="histogram" id="hist">
                        <!-- bars will be injected -->
                    </div>
                    <div class="dual-range">
                        <div class="range-track" id="track"></div>
                        <input id="rangeMin" type="range" min="100000" max="3000000" step="50000" value="100000" oninput="updatePriceRange(false)" onchange="updatePriceRange(true)">
                        <input id="rangeMax" type="range" min="100000" max="3000000" step="50000" value="3000000" oninput="updatePriceRange(false)" onchange="updatePriceRange(true)">
                    </div>
                    <!-- Hidden real inputs submitted to server -->
                    <input type="hidden" name="min" id="minInput" value="<%= request.getAttribute("min") != null ? request.getAttribute("min") : "" %>">
                    <input type="hidden" name="max" id="maxInput" value="<%= request.getAttribute("max") != null ? request.getAttribute("max") : "" %>
                </div>
                <div class="filter-group">
                    <label>Dịch vụ</label>
                    <div style="border:1px solid #e5e7eb; border-radius:8px; padding:8px;">
                        <%
                            com.homestay.service.CategoryService categoryService = (com.homestay.service.CategoryService)
                                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("categoryService");
                            com.homestay.service.ServiceService serviceService = (com.homestay.service.ServiceService)
                                org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("serviceService");
                            java.util.List<com.homestay.model.Category> categories = categoryService.getAll();
                            java.util.Map<Integer, java.util.List<com.homestay.model.Service>> grouped = serviceService.groupServicesByCategory();
                            java.util.Set<String> selected = new java.util.HashSet<>();
                            Object selObj = request.getAttribute("selectedServices");
                            if (selObj instanceof java.util.List) {
                                for (Object o : (java.util.List) selObj) if (o != null) selected.add(o.toString());
                            }
                            // Render theo nhóm danh mục, nhóm -1 là "Khác"
                            java.util.List<Integer> order = new java.util.ArrayList<>();
                            if (categories != null) for (com.homestay.model.Category c : categories) order.add(c.getId());
                            if (!grouped.isEmpty() && grouped.containsKey(-1)) order.add(-1);
                            for (Integer cid : order) {
                                String catName = "Khác";
                                if (cid != -1 && categories != null) {
                                    for (com.homestay.model.Category c : categories) if (c.getId() == cid) { catName = c.getName(); break; }
                                }
                        %>
                        <div style="margin:6px 0; font-weight:700; color:#111827; font-size:14px;"> <%= catName %> </div>
                        <%
                                java.util.List<com.homestay.model.Service> list = grouped.get(cid);
                                // Deduplicate by service name per category (tránh lặp do mỗi homestay một bản ghi)
                                java.util.Set<String> rendered = new java.util.HashSet<>();
                                if (list != null) for (com.homestay.model.Service s : list) {
                                    String name = s.getName(); if (name == null || name.trim().isEmpty()) continue;
                                    if (rendered.contains(name)) continue; rendered.add(name);
                        %>
                        <label style="display:flex; align-items:center; gap:8px; font-size:14px; color:#374151; padding:4px 0;">
                            <input type="checkbox" name="services" value="<%= name %>" <%= selected.contains(name) ? "checked" : "" %> onchange="this.form.submit()"/> <%= name %>
                        </label>
                        <% } } %>
                    </div>
                </div>
                <!-- Auto-submit on change; bỏ nút Áp dụng/Xóa lọc -->
            </form>
        </aside>

        <!-- Results -->
        <section>
            <div class="toolbar">
                <div>
                    <% int total = (request.getAttribute("totalItems") != null) ? (Integer) request.getAttribute("totalItems") : (homestays != null ? homestays.size() : 0); %>
                    <strong><%= total %></strong> chỗ nghỉ phù hợp
                </div>
                <div>
                    <!-- Placeholder sort -->
                    <select class="filter-select" disabled>
                        <option>Sắp xếp: Gợi ý hàng đầu</option>
                    </select>
                </div>
        </div>

            <div class="results">
                <% if (homestays != null && !homestays.isEmpty()) { for (Homestay h : homestays) { %>
                <div class="result-card">
                    <a class="thumb" href="<%= request.getContextPath() %>/homestays/<%= h.getId() %>">
                        <img src="<%= h.getImage() %>" alt="<%= h.getName() %>">
                    </a>
                    <div class="result-body">
                        <h3 class="result-title"><a href="<%= request.getContextPath() %>/homestays/<%= h.getId() %>" style="color:#0d6efd; text-decoration:none;"> <%= h.getName() %></a></h3>
                        <div class="result-address">📍 <%= (h.getAddress() != null) ? h.getAddress() : "Địa chỉ đang cập nhật" %></div>
                        
                        <!-- Room Details from Database -->
                        <div class="room-details" style="margin:8px 0; font-size:13px; color:#6b7280;">
                            <%
                                com.homestay.service.RoomService roomService = (com.homestay.service.RoomService)
                                    org.springframework.web.context.ContextLoader.getCurrentWebApplicationContext().getBean("roomService");
                                java.util.List<com.homestay.model.Room> _rooms = roomService.getRoomsByHomestayId(h.getId());
                                if (_rooms != null && !_rooms.isEmpty()) {
                                    com.homestay.model.Room firstRoom = _rooms.get(0);
                            %>
                            <div style="font-weight:600; color:#111827; margin-bottom:4px;"><%= firstRoom.getType() %></div>
                            <div style="margin:4px 0; color:#6b7280;">
                                <% if (firstRoom.getDescription() != null && !firstRoom.getDescription().trim().isEmpty()) { %>
                                    <%= firstRoom.getDescription() %>
                                <% } else { %>
                                    Phòng thoải mái với đầy đủ tiện nghi
                                <% } %>
                            </div>
                            <% } else { %>
                            <div style="font-weight:600; color:#111827; margin-bottom:4px;">Studio Apartment</div>
                            <div style="margin:4px 0; color:#6b7280;">Phòng thoải mái với đầy đủ tiện nghi</div>
    <% } %>
                        </div>
                        
                        <div style="color:#4b5563; font-size:14px; margin:8px 0 12px 0; line-height:1.5; max-width:90%;">
                            <%= (h.getDescription() != null && !h.getDescription().trim().isEmpty()) ? h.getDescription() : "Chỗ nghỉ thoải mái với đầy đủ tiện nghi, vị trí thuận tiện." %>
                        </div>
                        <div class="tags">
                            <span class="tag">Miễn phí hủy</span>
                            <span class="tag">Thanh toán tại chỗ</span>
                            <span class="tag">Ưu đãi hôm nay</span>
                        </div>
                    </div>
                    <div class="price-box">
                        <div>
                            <%
                                // Reuse the roomService and _rooms from above
                                java.math.BigDecimal minPrice = null;
                                if (_rooms != null) {
                                    for (com.homestay.model.Room r : _rooms) {
                                        if (r.getPrice() == null) continue;
                                        if (minPrice == null || r.getPrice().compareTo(minPrice) < 0) minPrice = r.getPrice();
                                    }
                                }
                            %>
                            <%
                                String __priceText;
                                if (minPrice != null) {
                                    java.text.NumberFormat __nf = java.text.NumberFormat.getInstance(new java.util.Locale("vi", "VN"));
                                    __nf.setMaximumFractionDigits(0);
                                    __nf.setMinimumFractionDigits(0);
                                    __priceText = "Từ " + __nf.format(minPrice) + " đ/đêm";
                                } else {
                                    __priceText = "Giá sẽ hiển thị khi chọn ngày";
                                }
                            %>
                            <div class="price"><%= __priceText %></div>
                            <div class="tax-note">Đã bao gồm thuế và phí</div>
                        </div>
                        <a href="<%= request.getContextPath() %>/homestays/<%= h.getId() %>" class="btn-book">Xem chỗ trống</a>
                    </div>
        </div>
                <% } } else { %>
                <div style="padding:24px; background:#fff; border:1px solid #e5e7eb; border-radius:12px;">Không tìm thấy kết quả phù hợp. Hãy thử đổi bộ lọc.</div>
        <% } %>
    </div>
    
    <%@ include file="../partials/pagination.jsp" %>
        </section>
    </div>
    <script>
    (function(){
        var fmt = new Intl.NumberFormat('vi-VN', { maximumFractionDigits: 0 });
        var minServer = parseInt('<%= request.getAttribute("min") != null ? request.getAttribute("min") : "100000" %>') || 100000;
        var maxServer = parseInt('<%= request.getAttribute("max") != null ? request.getAttribute("max") : "3000000" %>') || 3000000;
        var rmin = document.getElementById('rangeMin');
        var rmax = document.getElementById('rangeMax');
        var t = document.getElementById('priceRangeText');
        var minInput = document.getElementById('minInput');
        var maxInput = document.getElementById('maxInput');
        var hist = document.getElementById('hist');
        // draw simple histogram placeholders
        if (hist) {
            var bars = 40;
            for (var i=0;i<bars;i++) {
                var b = document.createElement('div');
                b.className = 'bar';
                // random height look
                b.style.height = (10 + Math.random()*50) + 'px';
                hist.appendChild(b);
            }
        }
        function recolorTrack(a, b){
            var track = document.getElementById('track');
            var min = parseInt(rmin.min), max = parseInt(rmin.max);
            var left = ((a - min) / (max - min)) * 100;
            var right = ((b - min) / (max - min)) * 100;
            if (track) track.style.background = 'linear-gradient(90deg, #e5e7eb ' + left + '%, #0d6efd ' + left + '%, #0d6efd ' + right + '%, #e5e7eb ' + right + '%)';
        }
        function clamp(){
            var a = parseInt(rmin.value); var b = parseInt(rmax.value);
            if (a > b) { var tmp = a; a = b; b = tmp; rmin.value = a; rmax.value = b; }
            t.textContent = 'VND ' + fmt.format(a) + ' – VND ' + fmt.format(b) + (b >= 3000000 ? '+' : '');
            minInput.value = a; maxInput.value = b;
            recolorTrack(a, b);
            // ensure the handle being moved stays on top to allow dragging when overlapped
            if ((b - a) < 100000) {
                rmin.style.zIndex = 5; rmax.style.zIndex = 4;
            } else {
                rmin.style.zIndex = 4; rmax.style.zIndex = 5;
            }
        }
        // put active slider on top when user grabs it
        rmin.addEventListener('pointerdown', function(){ rmin.style.zIndex = 6; rmax.style.zIndex = 5; });
        rmax.addEventListener('pointerdown', function(){ rmax.style.zIndex = 6; rmin.style.zIndex = 5; });
        window.updatePriceRange = function(submit){ clamp(); if (submit) document.getElementById('filters').submit(); };
        // initialize from server
        rmin.value = Math.max(100000, Math.min(3000000, minServer));
        rmax.value = Math.max(100000, Math.min(3000000, maxServer));
        clamp();
    })();
    
    // Cập nhật min date cho checkout khi chọn checkin
    document.querySelector('input[name="checkin"]').addEventListener('change', function() {
        const checkinDate = new Date(this.value);
        const checkoutInput = document.querySelector('input[name="checkout"]');
        const tomorrow = new Date(checkinDate);
        tomorrow.setDate(tomorrow.getDate() + 1);
        checkoutInput.min = tomorrow.toISOString().split('T')[0];
        
        // Nếu checkout hiện tại <= checkin, reset checkout
        if (checkoutInput.value && checkoutInput.value <= this.value) {
            checkoutInput.value = '';
        }
    });
    </script>
</body>
<%@ include file="../partials/footer.jsp" %>
</html>
