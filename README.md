# Homestay Management System

Hệ thống quản lý homestay sử dụng Java Spring MVC + JSP với dữ liệu thực từ MySQL.

## Tính năng chính

### 1. Tìm kiếm Homestay
- **Tìm kiếm theo địa điểm**: Sử dụng dữ liệu thực từ bảng `homestays`
- **Lọc theo dịch vụ**: Sử dụng dữ liệu thực từ bảng `services`
- **Lọc theo loại phòng và giá**: Sử dụng dữ liệu thực từ bảng `rooms`

### 2. Hiển thị Dịch vụ và Giá
- **Services động**: Hiển thị các dịch vụ thực tế của từng homestay từ bảng `services`
- **Giá phòng thực**: Hiển thị giá thực từ bảng `rooms` thay vì giá cố định
- **Không còn dữ liệu tĩnh**: Thay thế hoàn toàn các tính năng cố định như "Wi-Fi miễn phí", "Bãi đậu xe" và giá "VND 698.000"

### 3. Cấu trúc Cơ sở dữ liệu
```
homestays (id, name, address, phone, email, description, image)
services (id, name, price, description, homestay_id)
rooms (id, room_number, type, price, status, image, description, homestay_id)
users (id, username, password, full_name, email, phone, role, active)
bookings (id, user_id, room_id, check_in, check_out, status, created_at)
payments (id, booking_id, amount, payment_date, method, status)
```

## Cách sử dụng

### 1. Khởi tạo cơ sở dữ liệu
```sql
-- Import file homestay_management.sql vào MySQL
mysql -u root -p < homestay_management.sql
```

### 2. Cấu hình kết nối
- Chỉnh sửa `src/main/resources/db.properties`
- Đảm bảo MySQL chạy trên port 3308

### 3. Chạy ứng dụng
```bash
mvn clean install
mvn spring-boot:run
```

## Thay đổi từ dữ liệu tĩnh sang dữ liệu thực

### Trước đây (Dữ liệu tĩnh):
```jsp
<span class="feature-tag">Wi-Fi miễn phí</span>
<span class="feature-tag">Bãi đậu xe</span>
<span class="feature-tag">Gần biển</span>
```

### Hiện tại (Dữ liệu thực):
```jsp
<% if (homestay.getDescription() != null && homestay.getDescription().contains("Dịch vụ:")) { %>
    <% 
        String desc = homestay.getDescription();
        int serviceIndex = desc.indexOf("Dịch vụ:");
        if (serviceIndex != -1) {
            String services = desc.substring(serviceIndex + 8).trim();
            String[] serviceArray = services.split(", ");
            for (String service : serviceArray) {
                if (!service.trim().isEmpty()) {
    %>
        <span class="feature-tag"><%= service.trim() %></span>
    <% 
                }
            }
        }
    %>
<% } %>
```

## API Endpoints

- `GET /` - Trang chủ với homestay nổi bật
- `GET /homestays` - Danh sách homestay với phân trang
- `GET /search` - Tìm kiếm homestay
- `GET /homestays/{id}` - Chi tiết homestay

## Công nghệ sử dụng

- **Backend**: Java Spring MVC
- **Frontend**: JSP, HTML, CSS, JavaScript
- **Database**: MySQL
- **Build Tool**: Maven