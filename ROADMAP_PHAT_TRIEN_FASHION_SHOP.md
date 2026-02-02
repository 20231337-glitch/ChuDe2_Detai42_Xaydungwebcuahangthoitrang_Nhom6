# 🗺️ ROADMAP PHÁT TRIỂN WEBSITE FASHION SHOP

## 📌 THÔNG TIN QUAN TRỌNG

**Database:** `fashion_shop_database.sql` (18 bảng đã tạo)  
**Công nghệ:** PHP Thuần + MySQL (XAMPP)  
**Nguyên tắc:** Logic & Workflow 100% đồng nhất với Database  
**Mục tiêu:** Code đơn giản, dễ hiểu, tập trung vào chức năng

---

## 📂 CẤU TRÚC THÚ MỤC DỰ ÁN

```
fashion-shop/
├── config/                      # Cấu hình
│   ├── database.php            # Kết nối MySQL
│   ├── constants.php           # Hằng số (SITE_URL, UPLOAD_PATH...)
│   └── session.php             # Quản lý session
│
├── admin/                       # Quản trị viên
│   ├── auth/                   # Đăng nhập admin
│   ├── dashboard/              # Trang tổng quan
│   ├── categories/             # Quản lý danh mục
│   ├── sizes/                  # Quản lý size
│   ├── colors/                 # Quản lý màu sắc
│   ├── products/               # Quản lý sản phẩm
│   ├── coupons/                # Quản lý mã giảm giá
│   ├── orders/                 # Quản lý đơn hàng
│   ├── customers/              # Quản lý khách hàng
│   ├── reviews/                # Quản lý đánh giá
│   ├── returns/                # Quản lý trả hàng
│   ├── logs/                   # Xem log hoạt động
│   └── includes/               # Header, sidebar, footer admin
│
├── public/                      # Khách hàng
│   ├── auth/                   # Đăng ký, đăng nhập
│   ├── home/                   # Trang chủ
│   ├── products/               # Danh sách & chi tiết sản phẩm
│   ├── cart/                   # Giỏ hàng
│   ├── checkout/               # Thanh toán
│   ├── account/                # Trang cá nhân
│   │   ├── profile.php         # Thông tin cá nhân
│   │   ├── orders.php          # Lịch sử đơn hàng
│   │   ├── wishlist.php        # Sản phẩm yêu thích
│   │   ├── notifications.php   # Thông báo
│   │   └── reviews.php         # Đánh giá của tôi
│   └── includes/               # Header, footer public
│
├── includes/                    # Thư viện dùng chung
│   ├── functions.php           # Hàm tiện ích
│   ├── validation.php          # Validate dữ liệu
│   ├── upload.php              # Xử lý upload ảnh
│   └── pagination.php          # Phân trang
│
├── uploads/                     # Thư mục lưu file
│   ├── products/               # Ảnh sản phẩm
│   ├── reviews/                # Ảnh đánh giá
│   └── returns/                # Ảnh trả hàng
│
├── assets/                      # Tài nguyên tĩnh
│   ├── css/                    # File CSS
│   ├── js/                     # File JavaScript
│   └── images/                 # Logo, banner...
│
├── cron/                        # Các tác vụ tự động
│   ├── cleanup_cart.php        # Xóa giỏ hàng hết hạn
│   ├── auto_cancel_orders.php  # Tự động hủy đơn quá hạn
│   └── expire_coupons.php      # Tắt mã giảm giá hết hạn
│
└── index.php                    # Trang chủ chính
```

---

## 🎯 CÁC GIAI ĐOẠN PHÁT TRIỂN

---

## ⭐ **GIAI ĐOẠN 0: CHUẨN BỊ & THIẾT LẬP MÔI TRƯỜNG**

### Mục tiêu
- Thiết lập môi trường phát triển
- Import database
- Tạo cấu trúc thư mục
- Cấu hình kết nối

### Công việc chi tiết

#### 0.1. Cài đặt XAMPP & Import Database
- ✅ Cài XAMPP
- ✅ Start Apache + MySQL
- ✅ Import file `fashion_shop_database.sql` vào phpMyAdmin
- ✅ Kiểm tra 18 bảng đã tạo thành công
- ✅ Test login với user `admin/123456`

#### 0.2. Tạo cấu trúc thư mục dự án
- ✅ Tạo thư mục gốc: `C:/xampp/htdocs/fashion-shop/`
- ✅ Tạo tất cả thư mục con theo cấu trúc trên

#### 0.3. File cấu hình cơ bản

**File cần tạo:**
- `config/database.php` - Kết nối MySQL
- `config/constants.php` - Định nghĩa hằng số
- `config/session.php` - Khởi tạo session
- `.htaccess` - Rewrite URL (nếu cần)

**Nội dung quan trọng:**
- Database: `fashion_shop`
- Charset: `utf8mb4`
- Timezone: `Asia/Ho_Chi_Minh`

---

## 📊 **GIAI ĐOẠN 1: MODULE AUTHENTICATION (XÁC THỰC)**

### Mục tiêu
- Xây dựng hệ thống đăng nhập/đăng ký
- Phân quyền Admin/Customer
- Quản lý session

### Workflow chuẩn theo Database

#### 1.1. Đăng ký tài khoản (Customer)
**Bảng liên quan:** `users`

**Flow:**
1. Form đăng ký: username, password, fullname, email, phone, address
2. Validate:
   - Username chưa tồn tại (CHECK `users.username UNIQUE`)
   - Email chưa tồn tại (CHECK `users.email UNIQUE`)
3. INSERT vào `users`:
   ```sql
   INSERT INTO users (username, password, fullname, email, phone, address, role, status, created_at)
   VALUES (?, ?, ?, ?, ?, ?, 'customer', 'active', NOW())
   ```
4. Tự động đăng nhập sau khi đăng ký thành công

#### 1.2. Đăng nhập (Admin & Customer)
**Bảng liên quan:** `users`

**Flow:**
1. Form login: username + password
2. Query kiểm tra:
   ```sql
   SELECT * FROM users 
   WHERE username = ? 
   AND password = ? 
   AND status = 'active' 
   AND deleted_at IS NULL
   ```
3. Nếu tìm thấy:
   - Lưu session: `$_SESSION['user_id']`, `$_SESSION['role']`, `$_SESSION['fullname']`
   - UPDATE `last_login`:
     ```sql
     UPDATE users SET last_login = NOW() WHERE user_id = ?
     ```
   - Redirect theo role:
     - `admin` → `/admin/dashboard/`
     - `customer` → `/public/home/`
4. Nếu không tìm thấy: Báo lỗi sai thông tin

#### 1.3. Đăng xuất
**Flow:**
1. Xóa tất cả session: `session_destroy()`
2. Redirect về trang login

#### 1.4. Middleware kiểm tra quyền truy cập

**Các hàm cần tạo:**
- `check_login()` - Kiểm tra đã đăng nhập chưa
- `check_admin()` - Kiểm tra role = 'admin'
- `check_customer()` - Kiểm tra role = 'customer'
- `redirect_if_not_logged_in()` - Chuyển hướng nếu chưa login

**Logic:**
```php
function check_admin() {
    if (!isset($_SESSION['user_id']) || $_SESSION['role'] != 'admin') {
        header('Location: /admin/auth/login.php');
        exit;
    }
}
```

---

## 🏠 **GIAI ĐOẠN 2: TRANG CHỦ & HIỂN THỊ SẢN PHẨM (PUBLIC)**

### Mục tiêu
- Hiển thị sản phẩm nổi bật
- Danh sách sản phẩm có lọc/tìm kiếm
- Chi tiết sản phẩm với biến thể

### 2.1. Trang chủ (Homepage)
**Bảng liên quan:** `products`, `categories`, `product_images`

**Query hiển thị sản phẩm nổi bật:**
```sql
-- Top 8 sản phẩm bán chạy
SELECT p.*, pi.image_url, c.category_name
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.status = 'active' AND p.deleted_at IS NULL
ORDER BY p.sold_count DESC
LIMIT 8;

-- Top 8 sản phẩm mới nhất
ORDER BY p.created_at DESC
LIMIT 8;

-- Top 8 sản phẩm xem nhiều
ORDER BY p.view_count DESC
LIMIT 8;
```

**Hiển thị danh mục:**
```sql
SELECT * FROM categories 
WHERE status = 'active' AND deleted_at IS NULL
ORDER BY category_name;
```

### 2.2. Danh sách sản phẩm (Product Listing)
**Bảng liên quan:** `products`, `categories`, `product_images`, `product_variants`

**Flow:**
1. Lấy tất cả sản phẩm (có phân trang)
2. Lọc theo danh mục (nếu có `?category_id=X`)
3. Tìm kiếm (nếu có `?keyword=abc`)
4. Sắp xếp (giá, tên, mới nhất...)

**Query chuẩn:**
```sql
-- Lọc theo danh mục
SELECT p.*, pi.image_url, c.category_name,
       MIN(pv.stock_quantity) as min_stock
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN product_variants pv ON p.product_id = pv.product_id
WHERE p.status = 'active' 
AND p.deleted_at IS NULL
AND p.category_id = ? -- Nếu có lọc danh mục
GROUP BY p.product_id
ORDER BY p.created_at DESC
LIMIT ?, ?; -- Phân trang
```

**Tìm kiếm Full-text:**
```sql
SELECT p.*, pi.image_url, c.category_name
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.status = 'active' AND p.deleted_at IS NULL
AND MATCH(p.product_name, p.description) AGAINST(? IN NATURAL LANGUAGE MODE)
ORDER BY p.created_at DESC;
```

### 2.3. Chi tiết sản phẩm (Product Detail)
**Bảng liên quan:** `products`, `product_images`, `product_variants`, `sizes`, `colors`, `reviews`

**Flow:**
1. Lấy thông tin sản phẩm theo `product_id`
2. UPDATE view_count:
   ```sql
   UPDATE products SET view_count = view_count + 1 WHERE product_id = ?
   ```
3. Lấy tất cả ảnh của sản phẩm
4. Lấy tất cả biến thể (Size × Color) kèm tồn kho
5. Lấy đánh giá của sản phẩm

**Query chi tiết sản phẩm:**
```sql
SELECT p.*, c.category_name
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE p.product_id = ? AND p.status = 'active' AND p.deleted_at IS NULL;
```

**Query ảnh sản phẩm:**
```sql
SELECT * FROM product_images 
WHERE product_id = ? 
ORDER BY is_primary DESC, display_order ASC;
```

**Query biến thể (QUAN TRỌNG):**
```sql
SELECT pv.*, s.size_name, c.color_name, c.color_code
FROM product_variants pv
JOIN sizes s ON pv.size_id = s.size_id
JOIN colors c ON pv.color_id = c.color_id
WHERE pv.product_id = ?
ORDER BY s.display_order, c.display_order;
```

**Query đánh giá:**
```sql
SELECT r.*, u.fullname, u.email
FROM reviews r
JOIN users u ON r.user_id = u.user_id
WHERE r.product_id = ? AND r.status = 'approved'
ORDER BY r.created_at DESC
LIMIT 10;
```

**Tính rating trung bình:**
```sql
SELECT 
    AVG(rating) as avg_rating,
    COUNT(*) as total_reviews
FROM reviews
WHERE product_id = ? AND status = 'approved';
```

---

## 🛒 **GIAI ĐOẠN 3: GIỎ HÀNG (CART)**

### Mục tiêu
- Thêm sản phẩm vào giỏ (BẮT BUỘC LOGIN)
- Cập nhật số lượng
- Xóa sản phẩm khỏi giỏ
- Hiển thị tổng tiền

### Workflow chuẩn theo Database

#### 3.1. Thêm vào giỏ hàng
**Bảng liên quan:** `cart`, `product_variants`

**Flow:**
1. Kiểm tra đã login chưa → Chưa thì redirect về login
2. Nhận từ form: `variant_id`, `quantity`
3. Validate:
   - Variant tồn tại không?
   - Số lượng > 0?
   - Còn đủ hàng không? (CHECK `product_variants.stock_quantity`)
4. Kiểm tra sản phẩm đã có trong giỏ chưa:
   ```sql
   SELECT * FROM cart 
   WHERE user_id = ? AND variant_id = ?
   ```
5. Nếu đã có → UPDATE quantity:
   ```sql
   UPDATE cart 
   SET quantity = quantity + ?, 
       expires_at = DATE_ADD(NOW(), INTERVAL 30 DAY)
   WHERE user_id = ? AND variant_id = ?
   ```
6. Nếu chưa có → INSERT:
   ```sql
   INSERT INTO cart (user_id, variant_id, quantity, added_at, expires_at)
   VALUES (?, ?, ?, NOW(), DATE_ADD(NOW(), INTERVAL 30 DAY))
   ```

**Ràng buộc quan trọng:**
- UNIQUE KEY `(user_id, variant_id)` → Tự động chống trùng
- CHECK `quantity > 0`

#### 3.2. Xem giỏ hàng
**Bảng liên quan:** `cart`, `product_variants`, `products`, `sizes`, `colors`, `product_images`

**Query lấy giỏ hàng:**
```sql
SELECT 
    c.cart_id,
    c.quantity,
    pv.variant_id,
    pv.stock_quantity,
    p.product_id,
    p.product_name,
    p.slug,
    p.base_price,
    s.size_name,
    col.color_name,
    pi.image_url,
    (p.base_price * c.quantity) as subtotal
FROM cart c
JOIN product_variants pv ON c.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN sizes s ON pv.size_id = s.size_id
JOIN colors col ON pv.color_id = col.color_id
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE c.user_id = ?
ORDER BY c.added_at DESC;
```

**Tính tổng tiền:**
```sql
SELECT SUM(p.base_price * c.quantity) as total_amount
FROM cart c
JOIN product_variants pv ON c.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
WHERE c.user_id = ?;
```

#### 3.3. Cập nhật số lượng
**Flow:**
1. Nhận `cart_id` + `new_quantity`
2. Kiểm tra quyền sở hữu:
   ```sql
   SELECT * FROM cart WHERE cart_id = ? AND user_id = ?
   ```
3. Kiểm tra tồn kho:
   ```sql
   SELECT pv.stock_quantity 
   FROM cart c
   JOIN product_variants pv ON c.variant_id = pv.variant_id
   WHERE c.cart_id = ?
   ```
4. Nếu hợp lệ → UPDATE:
   ```sql
   UPDATE cart 
   SET quantity = ?, expires_at = DATE_ADD(NOW(), INTERVAL 30 DAY)
   WHERE cart_id = ? AND user_id = ?
   ```

#### 3.4. Xóa khỏi giỏ
**Flow:**
1. Nhận `cart_id`
2. Kiểm tra quyền sở hữu
3. DELETE:
   ```sql
   DELETE FROM cart WHERE cart_id = ? AND user_id = ?
   ```

---

## 💳 **GIAI ĐOẠN 4: THANH TOÁN (CHECKOUT)**

### Mục tiêu
- Nhập thông tin giao hàng
- Áp dụng mã giảm giá
- Tạo đơn hàng
- Trừ tồn kho
- Xóa giỏ hàng

### Workflow chuẩn theo Database (QUAN TRỌNG)

#### 4.1. Trang thanh toán
**Bảng liên quan:** `cart`, `products`, `product_variants`, `coupons`

**Flow:**
1. Kiểm tra giỏ hàng có sản phẩm không
2. Hiển thị thông tin giao hàng (lấy từ `users`)
3. Hiển thị danh sách sản phẩm từ giỏ
4. Form nhập mã giảm giá

**Validate mã giảm giá:**
```sql
SELECT * FROM coupons
WHERE coupon_code = ?
AND status = 'active'
AND expiry_date >= CURDATE()
AND (max_uses IS NULL OR used_count < max_uses);
```

**Kiểm tra user đã dùng mã chưa:**
```sql
SELECT COUNT(*) as times_used
FROM coupon_usage
WHERE coupon_id = ? AND user_id = ?;
```

**Logic tính giảm giá:**
```php
if ($coupon['discount_type'] == 'percent') {
    $discount_amount = ($total_amount * $coupon['discount_value']) / 100;
} else {
    $discount_amount = $coupon['discount_value'];
}
$final_amount = $total_amount - $discount_amount;
```

#### 4.2. Tạo đơn hàng (TRANSACTION - QUAN TRỌNG)
**Bảng liên quan:** `orders`, `order_details`, `cart`, `product_variants`, `coupons`, `coupon_usage`, `notifications`

**Flow đầy đủ (BẮT BUỘC dùng TRANSACTION):**

```sql
START TRANSACTION;

-- 1. TẠO ĐƠN HÀNG
INSERT INTO orders (
    user_id, fullname, phone, address, note,
    total_amount, coupon_id, discount_amount, final_amount,
    payment_method, payment_status, order_status, order_date
) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, 'unpaid', 'processing', NOW());

SET @order_id = LAST_INSERT_ID();

-- 2. LẤY DANH SÁCH SẢN PHẨM TRONG GIỎ
SELECT 
    c.variant_id, c.quantity,
    p.product_name, p.base_price,
    s.size_name, col.color_name
FROM cart c
JOIN product_variants pv ON c.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
JOIN sizes s ON pv.size_id = s.size_id
JOIN colors col ON pv.color_id = col.color_id
WHERE c.user_id = ?;

-- 3. KIỂM TRA TỒN KHO (TỪNG SẢN PHẨM)
FOR EACH cart_item:
    SELECT stock_quantity FROM product_variants WHERE variant_id = ?;
    
    IF stock_quantity < cart_item.quantity THEN
        ROLLBACK;
        RETURN "Sản phẩm X không đủ hàng";
    END IF;

-- 4. TẠO CHI TIẾT ĐƠN HÀNG (SNAPSHOT)
FOR EACH cart_item:
    INSERT INTO order_details (
        order_id, variant_id, 
        product_name, size_name, color_name, 
        price, quantity, subtotal
    ) VALUES (
        @order_id, ?, 
        ?, ?, ?, 
        ?, ?, ?
    );

-- 5. TRỪ TỒN KHO
FOR EACH cart_item:
    UPDATE product_variants 
    SET stock_quantity = stock_quantity - ?
    WHERE variant_id = ?;
    
    -- Cập nhật trạng thái nếu hết hàng
    UPDATE product_variants 
    SET status = 'out_of_stock'
    WHERE variant_id = ? AND stock_quantity = 0;

-- 6. TĂNG SỐ LƯỢNG ĐÃ BÁN
UPDATE products p
JOIN order_details od ON p.product_id = (
    SELECT product_id FROM product_variants WHERE variant_id = od.variant_id
)
SET p.sold_count = p.sold_count + od.quantity
WHERE od.order_id = @order_id;

-- 7. CẬP NHẬT MÃ GIẢM GIÁ (NẾU CÓ)
IF coupon_id IS NOT NULL THEN
    UPDATE coupons 
    SET used_count = used_count + 1 
    WHERE coupon_id = ?;
    
    INSERT INTO coupon_usage (coupon_id, user_id, order_id, used_at)
    VALUES (?, ?, @order_id, NOW());
END IF;

-- 8. XÓA GIỎ HÀNG
DELETE FROM cart WHERE user_id = ?;

-- 9. TẠO THÔNG BÁO
INSERT INTO notifications (user_id, type, title, message, link, created_at)
VALUES (
    ?, 'order_update', 
    'Đơn hàng đã được tạo',
    'Đơn hàng #' + @order_id + ' đã được tạo thành công',
    '/account/order_detail.php?id=' + @order_id,
    NOW()
);

COMMIT;
```

**Xử lý lỗi:**
- Nếu BẤT KỲ bước nào lỗi → ROLLBACK toàn bộ
- Thông báo lỗi cụ thể cho user

---

## 📦 **GIAI ĐOẠN 5: QUẢN LÝ ĐƠN HÀNG (CUSTOMER)**

### Mục tiêu
- Xem lịch sử đơn hàng
- Xem chi tiết đơn hàng
- Hủy đơn (nếu đang xử lý)
- Đánh giá sản phẩm (sau khi hoàn thành)

### 5.1. Lịch sử đơn hàng
**Bảng liên quan:** `orders`

**Query:**
```sql
SELECT 
    o.order_id,
    o.order_date,
    o.total_amount,
    o.final_amount,
    o.order_status,
    o.payment_status,
    COUNT(od.detail_id) as total_items
FROM orders o
LEFT JOIN order_details od ON o.order_id = od.order_id
WHERE o.user_id = ?
GROUP BY o.order_id
ORDER BY o.order_date DESC;
```

### 5.2. Chi tiết đơn hàng
**Bảng liên quan:** `orders`, `order_details`, `coupons`

**Kiểm tra quyền sở hữu (QUAN TRỌNG):**
```sql
SELECT * FROM orders 
WHERE order_id = ? AND user_id = ?;
```

**Query chi tiết:**
```sql
SELECT 
    od.*,
    pv.variant_id,
    p.product_id,
    p.slug,
    pi.image_url
FROM order_details od
LEFT JOIN product_variants pv ON od.variant_id = pv.variant_id
LEFT JOIN products p ON pv.product_id = p.product_id
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE od.order_id = ?;
```

### 5.3. Hủy đơn hàng (Customer)
**Flow:**
1. Kiểm tra quyền sở hữu
2. Kiểm tra trạng thái (chỉ hủy được `order_status = 'processing'`)
3. TRANSACTION:
   ```sql
   START TRANSACTION;
   
   -- Hoàn lại tồn kho
   UPDATE product_variants pv
   JOIN order_details od ON pv.variant_id = od.variant_id
   SET pv.stock_quantity = pv.stock_quantity + od.quantity,
       pv.status = 'in_stock'
   WHERE od.order_id = ?;
   
   -- Trừ sold_count
   UPDATE products p
   JOIN order_details od ON p.product_id = (
       SELECT product_id FROM product_variants WHERE variant_id = od.variant_id
   )
   SET p.sold_count = p.sold_count - od.quantity
   WHERE od.order_id = ?;
   
   -- Cập nhật trạng thái đơn
   UPDATE orders 
   SET order_status = 'cancelled',
       cancelled_reason = ?,
       cancelled_by = 'customer',
       cancelled_at = NOW()
   WHERE order_id = ?;
   
   COMMIT;
   ```

---

## ⭐ **GIAI ĐOẠN 6: ĐÁNH GIÁ SẢN PHẨM (REVIEWS)**

### Mục tiêu
- Chỉ khách đã mua mới đánh giá được
- 1 khách chỉ đánh giá 1 lần/sản phẩm/đơn hàng
- Có thể upload ảnh review

### Workflow chuẩn theo Database

#### 6.1. Kiểm tra quyền đánh giá
**Logic:**
1. Đơn hàng phải có `order_status = 'completed'`
2. Đơn hàng phải thuộc về user hiện tại
3. User chưa đánh giá sản phẩm này trong đơn hàng này

**Query kiểm tra:**
```sql
-- Kiểm tra đơn đã hoàn thành và có sản phẩm
SELECT od.*, p.product_name
FROM order_details od
JOIN orders o ON od.order_id = o.order_id
JOIN product_variants pv ON od.variant_id = pv.variant_id
JOIN products p ON pv.product_id = p.product_id
WHERE o.order_id = ?
AND o.user_id = ?
AND o.order_status = 'completed'
AND NOT EXISTS (
    SELECT 1 FROM reviews 
    WHERE product_id = p.product_id 
    AND user_id = ? 
    AND order_id = ?
);
```

#### 6.2. Tạo đánh giá
**Bảng liên quan:** `reviews`, `notifications`

**Flow:**
1. Validate:
   - Rating: 1-5 sao
   - Comment: Không bắt buộc
   - Images: Upload nếu có (JSON array)
2. INSERT review:
   ```sql
   INSERT INTO reviews (
       product_id, user_id, order_id,
       rating, comment, images, status, created_at
   ) VALUES (?, ?, ?, ?, ?, ?, 'pending', NOW());
   ```
3. Tạo thông báo cho admin:
   ```sql
   INSERT INTO notifications (user_id, type, title, message, created_at)
   VALUES (
       1, -- admin_id
       'new_review',
       'Đánh giá mới cần duyệt',
       'Sản phẩm #' + product_id + ' có đánh giá mới từ ' + fullname,
       NOW()
   );
   ```

**Upload ảnh review:**
- Cho phép upload tối đa 5 ảnh
- Lưu dạng JSON: `["img1.jpg", "img2.jpg"]`
- Thư mục: `/uploads/reviews/`

---

## 👤 **GIAI ĐOẠN 7: TRANG CÁ NHÂN (ACCOUNT)**

### 7.1. Thông tin cá nhân
**Bảng liên quan:** `users`

**Query:**
```sql
SELECT * FROM users WHERE user_id = ?;
```

**Cập nhật thông tin:**
```sql
UPDATE users 
SET fullname = ?, email = ?, phone = ?, address = ?
WHERE user_id = ?;
```

### 7.2. Đổi mật khẩu
**Flow:**
1. Nhập mật khẩu cũ
2. Kiểm tra:
   ```sql
   SELECT password FROM users WHERE user_id = ?;
   ```
3. Nếu đúng → UPDATE:
   ```sql
   UPDATE users SET password = ? WHERE user_id = ?;
   ```

### 7.3. Danh sách yêu thích (Wishlist)
**Bảng liên quan:** `wishlists`, `products`, `product_images`

**Query:**
```sql
SELECT w.*, p.product_name, p.slug, p.base_price, pi.image_url
FROM wishlists w
JOIN products p ON w.product_id = p.product_id
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE w.user_id = ?
ORDER BY w.added_at DESC;
```

**Thêm vào wishlist:**
```sql
INSERT INTO wishlists (user_id, product_id, added_at)
VALUES (?, ?, NOW())
ON DUPLICATE KEY UPDATE added_at = NOW();
```

**Xóa khỏi wishlist:**
```sql
DELETE FROM wishlists WHERE user_id = ? AND product_id = ?;
```

### 7.4. Thông báo
**Bảng liên quan:** `notifications`

**Query:**
```sql
SELECT * FROM notifications
WHERE user_id = ?
ORDER BY created_at DESC
LIMIT 20;
```

**Đánh dấu đã đọc:**
```sql
UPDATE notifications 
SET is_read = 1 
WHERE notification_id = ? AND user_id = ?;
```

**Đếm chưa đọc:**
```sql
SELECT COUNT(*) as unread_count
FROM notifications
WHERE user_id = ? AND is_read = 0;
```

---

## 🔧 **GIAI ĐOẠN 8: ADMIN - DASHBOARD & THỐNG KÊ**

### Mục tiêu
- Hiển thị tổng quan hệ thống
- Thống kê doanh thu
- Top sản phẩm bán chạy
- Biểu đồ theo tháng

### 8.1. Thống kê tổng quan
**Các Query cần thiết:**

**Tổng doanh thu:**
```sql
SELECT SUM(final_amount) as total_revenue
FROM orders
WHERE order_status IN ('completed', 'shipping')
AND payment_status = 'paid';
```

**Đơn hàng theo trạng thái:**
```sql
SELECT 
    order_status,
    COUNT(*) as total_orders,
    SUM(final_amount) as total_amount
FROM orders
GROUP BY order_status;
```

**Top 10 sản phẩm bán chạy:**
```sql
SELECT p.product_id, p.product_name, p.sold_count, p.base_price, pi.image_url
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE p.deleted_at IS NULL
ORDER BY p.sold_count DESC
LIMIT 10;
```

**Doanh thu theo tháng (12 tháng gần nhất):**
```sql
SELECT 
    DATE_FORMAT(order_date, '%Y-%m') as month,
    COUNT(*) as total_orders,
    SUM(final_amount) as revenue
FROM orders
WHERE order_status IN ('completed', 'shipping')
AND order_date >= DATE_SUB(NOW(), INTERVAL 12 MONTH)
GROUP BY DATE_FORMAT(order_date, '%Y-%m')
ORDER BY month;
```

**Số lượng khách hàng mới trong tháng:**
```sql
SELECT COUNT(*) as new_customers
FROM users
WHERE role = 'customer'
AND created_at >= DATE_SUB(NOW(), INTERVAL 1 MONTH);
```

---

## 📂 **GIAI ĐOẠN 9: ADMIN - QUẢN LÝ DANH MỤC, SIZE, MÀU SẮC**

### 9.1. Quản lý Danh mục (Categories)
**Bảng liên quan:** `categories`, `admin_logs`

**CRUD cơ bản:**

**List:**
```sql
SELECT * FROM categories 
WHERE deleted_at IS NULL
ORDER BY category_name;
```

**Create:**
```sql
INSERT INTO categories (category_name, slug, description, status, created_at)
VALUES (?, ?, ?, 'active', NOW());

-- Log hoạt động
INSERT INTO admin_logs (admin_id, action, table_name, record_id, new_value, created_at)
VALUES (?, 'CREATE', 'categories', LAST_INSERT_ID(), ?, NOW());
```

**Update:**
```sql
-- Lấy giá trị cũ trước
SELECT * FROM categories WHERE category_id = ?;

-- Update
UPDATE categories 
SET category_name = ?, slug = ?, description = ?, status = ?
WHERE category_id = ?;

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, old_value, new_value, created_at)
VALUES (?, 'UPDATE', 'categories', ?, ?, ?, NOW());
```

**Soft Delete:**
```sql
UPDATE categories 
SET deleted_at = NOW()
WHERE category_id = ?;

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, old_value, created_at)
VALUES (?, 'DELETE', 'categories', ?, ?, NOW());
```

### 9.2. Quản lý Size (Sizes)
**Bảng liên quan:** `sizes`

**Logic tương tự Categories, đơn giản hơn:**
- CRUD: Create, Read, Update, Delete (Hard Delete được vì ít ràng buộc)
- Sắp xếp theo `display_order`

### 9.3. Quản lý Màu sắc (Colors)
**Bảng liên quan:** `colors`

**Logic tương tự Sizes:**
- Có thêm trường `color_code` (Hex color)
- Hiển thị màu preview trong danh sách

---

## 🎁 **GIAI ĐOẠN 10: ADMIN - QUẢN LÝ SẢN PHẨM**

### Mục tiêu
- CRUD sản phẩm
- Upload nhiều ảnh
- Tạo biến thể (Size × Color)
- Quản lý tồn kho từng biến thể

### 10.1. Danh sách sản phẩm (Admin)
**Query:**
```sql
SELECT 
    p.*,
    c.category_name,
    pi.image_url,
    COUNT(DISTINCT pv.variant_id) as total_variants,
    SUM(pv.stock_quantity) as total_stock
FROM products p
LEFT JOIN categories c ON p.category_id = c.category_id
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
LEFT JOIN product_variants pv ON p.product_id = pv.product_id
WHERE p.deleted_at IS NULL
GROUP BY p.product_id
ORDER BY p.created_at DESC;
```

### 10.2. Tạo sản phẩm mới
**Bảng liên quan:** `products`, `product_images`, `product_variants`

**Flow (TRANSACTION):**
```sql
START TRANSACTION;

-- 1. Tạo sản phẩm
INSERT INTO products (
    product_name, slug, category_id, description,
    base_price, status, meta_title, meta_description, meta_keywords,
    created_at
) VALUES (?, ?, ?, ?, ?, 'active', ?, ?, ?, NOW());

SET @product_id = LAST_INSERT_ID();

-- 2. Upload và lưu ảnh
FOR EACH uploaded_image:
    INSERT INTO product_images (product_id, image_url, is_primary, display_order, created_at)
    VALUES (@product_id, ?, ?, ?, NOW());

-- 3. Tạo biến thể (Size × Color)
FOR EACH size IN selected_sizes:
    FOR EACH color IN selected_colors:
        INSERT INTO product_variants (
            product_id, size_id, color_id, 
            stock_quantity, status, created_at
        ) VALUES (
            @product_id, ?, ?, 
            ?, 'in_stock', NOW()
        );

-- 4. Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, new_value, created_at)
VALUES (?, 'CREATE', 'products', @product_id, ?, NOW());

COMMIT;
```

### 10.3. Cập nhật sản phẩm
**Flow tương tự Create, nhưng:**
- Có thể thêm/xóa ảnh
- Có thể thêm/xóa biến thể
- Cập nhật tồn kho từng biến thể

**Query cập nhật tồn kho biến thể:**
```sql
UPDATE product_variants
SET stock_quantity = ?,
    status = CASE 
        WHEN ? > 0 THEN 'in_stock'
        ELSE 'out_of_stock'
    END
WHERE variant_id = ?;
```

### 10.4. Xóa sản phẩm (Soft Delete)
**Flow:**
```sql
-- Soft delete sản phẩm
UPDATE products 
SET deleted_at = NOW()
WHERE product_id = ?;

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, created_at)
VALUES (?, 'DELETE', 'products', ?, NOW());
```

---

## 🎫 **GIAI ĐOẠN 11: ADMIN - QUẢN LÝ MÃ GIẢM GIÁ**

### Mục tiêu
- CRUD mã giảm giá
- Theo dõi lượt sử dụng
- Tự động tắt mã hết hạn

### 11.1. Danh sách mã giảm giá
**Query:**
```sql
SELECT 
    c.*,
    (c.used_count) as times_used,
    CASE 
        WHEN c.expiry_date < CURDATE() THEN 'expired'
        WHEN c.status = 'inactive' THEN 'inactive'
        ELSE 'active'
    END as current_status
FROM coupons c
ORDER BY c.created_at DESC;
```

### 11.2. Tạo mã giảm giá
**Validate:**
- `coupon_code` phải UNIQUE
- `discount_value` > 0
- `expiry_date` phải > ngày hiện tại

**Query:**
```sql
INSERT INTO coupons (
    coupon_code, discount_type, discount_value,
    min_order_value, max_uses, max_uses_per_user,
    expiry_date, status, created_at
) VALUES (?, ?, ?, ?, ?, ?, ?, 'active', NOW());
```

### 11.3. Xem lịch sử sử dụng
**Query:**
```sql
SELECT 
    cu.*,
    u.fullname, u.email,
    o.order_id, o.final_amount,
    o.order_date
FROM coupon_usage cu
JOIN users u ON cu.user_id = u.user_id
JOIN orders o ON cu.order_id = o.order_id
WHERE cu.coupon_id = ?
ORDER BY cu.used_at DESC;
```

---

## 📋 **GIAI ĐOẠN 12: ADMIN - QUẢN LÝ ĐƠN HÀNG**

### Mục tiêu
- Xem danh sách đơn hàng
- Xem chi tiết đơn hàng
- Cập nhật trạng thái đơn
- In hóa đơn

### 12.1. Danh sách đơn hàng
**Query:**
```sql
SELECT 
    o.*,
    u.fullname as customer_name,
    u.email,
    COUNT(od.detail_id) as total_items
FROM orders o
JOIN users u ON o.user_id = u.user_id
LEFT JOIN order_details od ON o.order_id = od.order_id
GROUP BY o.order_id
ORDER BY o.order_date DESC;
```

**Filter theo trạng thái:**
```sql
WHERE o.order_status = ?
```

**Search theo mã đơn/tên khách:**
```sql
WHERE o.order_id LIKE ? OR u.fullname LIKE ?
```

### 12.2. Chi tiết đơn hàng
**Query đầy đủ:**
```sql
-- Thông tin đơn
SELECT o.*, u.fullname, u.email, u.phone, c.coupon_code
FROM orders o
JOIN users u ON o.user_id = u.user_id
LEFT JOIN coupons c ON o.coupon_id = c.coupon_id
WHERE o.order_id = ?;

-- Chi tiết sản phẩm
SELECT od.*, pi.image_url
FROM order_details od
LEFT JOIN product_variants pv ON od.variant_id = pv.variant_id
LEFT JOIN products p ON pv.product_id = p.product_id
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE od.order_id = ?;
```

### 12.3. Cập nhật trạng thái đơn hàng
**Workflow trạng thái:**
1. `processing` → `confirmed` → `shipping` → `completed`
2. Có thể `cancelled` ở bất kỳ bước nào (trừ `completed`)

**Update trạng thái:**
```sql
UPDATE orders 
SET order_status = ?,
    updated_at = NOW()
WHERE order_id = ?;

-- Nếu chuyển sang 'completed'
UPDATE orders 
SET order_status = 'completed',
    payment_status = 'paid',
    updated_at = NOW()
WHERE order_id = ?;

-- Tạo thông báo cho khách
INSERT INTO notifications (user_id, type, title, message, link, created_at)
VALUES (?, 'order_update', 'Đơn hàng đã cập nhật', ?, ?, NOW());

-- Log hoạt động
INSERT INTO admin_logs (admin_id, action, table_name, record_id, old_value, new_value, created_at)
VALUES (?, 'UPDATE', 'orders', ?, ?, ?, NOW());
```

### 12.4. Hủy đơn hàng (Admin)
**Flow (TRANSACTION) - Giống Customer nhưng có thêm lý do:**
```sql
START TRANSACTION;

-- Hoàn tồn kho
UPDATE product_variants pv
JOIN order_details od ON pv.variant_id = od.variant_id
SET pv.stock_quantity = pv.stock_quantity + od.quantity,
    pv.status = 'in_stock'
WHERE od.order_id = ?;

-- Trừ sold_count
UPDATE products p
JOIN order_details od ON p.product_id = (
    SELECT product_id FROM product_variants WHERE variant_id = od.variant_id
)
SET p.sold_count = p.sold_count - od.quantity
WHERE od.order_id = ?;

-- Hoàn lại coupon (nếu có)
IF coupon_id IS NOT NULL THEN
    UPDATE coupons 
    SET used_count = used_count - 1 
    WHERE coupon_id = ?;
    
    DELETE FROM coupon_usage 
    WHERE order_id = ?;
END IF;

-- Cập nhật đơn hàng
UPDATE orders 
SET order_status = 'cancelled',
    cancelled_reason = ?,
    cancelled_by = 'admin',
    cancelled_at = NOW()
WHERE order_id = ?;

-- Thông báo khách hàng
INSERT INTO notifications (user_id, type, title, message, created_at)
VALUES (?, 'order_cancelled', 'Đơn hàng đã bị hủy', ?, NOW());

COMMIT;
```

---

## 👥 **GIAI ĐOẠN 13: ADMIN - QUẢN LÝ KHÁCH HÀNG**

### 13.1. Danh sách khách hàng
**Query:**
```sql
SELECT 
    u.*,
    COUNT(DISTINCT o.order_id) as total_orders,
    SUM(o.final_amount) as total_spent,
    MAX(o.order_date) as last_order_date
FROM users u
LEFT JOIN orders o ON u.user_id = o.user_id
WHERE u.role = 'customer' AND u.deleted_at IS NULL
GROUP BY u.user_id
ORDER BY u.created_at DESC;
```

### 13.2. Chi tiết khách hàng
**Query:**
```sql
-- Thông tin khách
SELECT * FROM users WHERE user_id = ? AND role = 'customer';

-- Lịch sử đơn hàng
SELECT * FROM orders 
WHERE user_id = ? 
ORDER BY order_date DESC 
LIMIT 20;

-- Tổng thống kê
SELECT 
    COUNT(*) as total_orders,
    SUM(final_amount) as total_spent,
    AVG(final_amount) as avg_order_value
FROM orders
WHERE user_id = ? AND order_status = 'completed';
```

### 13.3. Khóa/Mở khóa tài khoản
**Query:**
```sql
UPDATE users 
SET status = ? -- 'active' hoặc 'blocked'
WHERE user_id = ? AND role = 'customer';

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, old_value, new_value, created_at)
VALUES (?, 'UPDATE', 'users', ?, ?, ?, NOW());
```

---

## ⭐ **GIAI ĐOẠN 14: ADMIN - QUẢN LÝ ĐÁNH GIÁ**

### 14.1. Danh sách đánh giá chờ duyệt
**Query:**
```sql
SELECT 
    r.*,
    u.fullname as customer_name,
    p.product_name,
    o.order_id
FROM reviews r
JOIN users u ON r.user_id = u.user_id
JOIN products p ON r.product_id = p.product_id
JOIN orders o ON r.order_id = o.order_id
WHERE r.status = 'pending'
ORDER BY r.created_at DESC;
```

### 14.2. Duyệt/Từ chối đánh giá
**Query:**
```sql
UPDATE reviews 
SET status = ? -- 'approved' hoặc 'rejected'
WHERE review_id = ?;

-- Nếu approved → Thông báo cho khách
IF status = 'approved' THEN
    INSERT INTO notifications (user_id, type, title, message, created_at)
    VALUES (?, 'review_approved', 'Đánh giá đã được duyệt', ?, NOW());
END IF;

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, old_value, new_value, created_at)
VALUES (?, 'UPDATE', 'reviews', ?, ?, ?, NOW());
```

### 14.3. Xóa đánh giá
**Query:**
```sql
DELETE FROM reviews WHERE review_id = ?;

-- Log
INSERT INTO admin_logs (admin_id, action, table_name, record_id, created_at)
VALUES (?, 'DELETE', 'reviews', ?, NOW());
```

---

## 🔄 **GIAI ĐOẠN 15: ADMIN - QUẢN LÝ TRẢ HÀNG**

### 15.1. Danh sách yêu cầu trả hàng
**Query:**
```sql
SELECT 
    r.*,
    u.fullname as customer_name,
    o.order_id,
    o.order_date,
    o.final_amount
FROM order_returns r
JOIN users u ON r.user_id = u.user_id
JOIN orders o ON r.order_id = o.order_id
WHERE r.status = 'pending'
ORDER BY r.created_at DESC;
```

### 15.2. Xử lý yêu cầu trả hàng
**Flow (TRANSACTION):**
```sql
START TRANSACTION;

IF action = 'approve' THEN
    -- 1. Cập nhật trạng thái return
    UPDATE order_returns 
    SET status = 'approved',
        admin_note = ?,
        updated_at = NOW()
    WHERE return_id = ?;
    
    -- 2. Hoàn tồn kho (nếu cần)
    UPDATE product_variants pv
    JOIN order_details od ON pv.variant_id = od.variant_id
    SET pv.stock_quantity = pv.stock_quantity + od.quantity
    WHERE od.order_id = ?;
    
    -- 3. Cập nhật trạng thái đơn hàng
    UPDATE orders 
    SET order_status = 'cancelled'
    WHERE order_id = ?;
    
    -- 4. Thông báo khách hàng
    INSERT INTO notifications (user_id, type, title, message, created_at)
    VALUES (?, 'return_approved', 'Yêu cầu trả hàng đã được chấp nhận', ?, NOW());
    
ELSE -- reject
    UPDATE order_returns 
    SET status = 'rejected',
        admin_note = ?,
        updated_at = NOW()
    WHERE return_id = ?;
    
    INSERT INTO notifications (user_id, type, title, message, created_at)
    VALUES (?, 'return_rejected', 'Yêu cầu trả hàng bị từ chối', ?, NOW());
END IF;

COMMIT;
```

---

## 📊 **GIAI ĐOẠN 16: ADMIN - XEM LOG HOẠT ĐỘNG**

### 16.1. Danh sách log
**Query:**
```sql
SELECT 
    l.*,
    u.fullname as admin_name
FROM admin_logs l
JOIN users u ON l.admin_id = u.user_id
ORDER BY l.created_at DESC
LIMIT 100;
```

**Filter theo bảng:**
```sql
WHERE l.table_name = ?
```

**Filter theo hành động:**
```sql
WHERE l.action = ? -- 'CREATE', 'UPDATE', 'DELETE'
```

**Filter theo admin:**
```sql
WHERE l.admin_id = ?
```

---

## 🔧 **GIAI ĐOẠN 17: CÁC CHỨC NĂNG PHỤ & TỐI ƯU**

### 17.1. Tìm kiếm sản phẩm (Full-text Search)
**Query:**
```sql
SELECT p.*, pi.image_url, c.category_name,
       MATCH(p.product_name, p.description) AGAINST(? IN NATURAL LANGUAGE MODE) as relevance
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
LEFT JOIN categories c ON p.category_id = c.category_id
WHERE MATCH(p.product_name, p.description) AGAINST(? IN NATURAL LANGUAGE MODE)
AND p.status = 'active' AND p.deleted_at IS NULL
ORDER BY relevance DESC, p.sold_count DESC
LIMIT 20;
```

### 17.2. Gợi ý sản phẩm liên quan
**Query:**
```sql
-- Sản phẩm cùng danh mục
SELECT p.*, pi.image_url
FROM products p
LEFT JOIN product_images pi ON p.product_id = pi.product_id AND pi.is_primary = 1
WHERE p.category_id = ?
AND p.product_id != ?
AND p.status = 'active' AND p.deleted_at IS NULL
ORDER BY p.sold_count DESC
LIMIT 8;
```

### 17.3. Phân trang (Pagination)
**Logic:**
```php
$page = isset($_GET['page']) ? (int)$_GET['page'] : 1;
$per_page = 20;
$offset = ($page - 1) * $per_page;

// Query với LIMIT
SELECT * FROM products 
WHERE status = 'active' AND deleted_at IS NULL
ORDER BY created_at DESC
LIMIT $offset, $per_page;

// Đếm tổng số
SELECT COUNT(*) as total FROM products 
WHERE status = 'active' AND deleted_at IS NULL;

// Tính tổng số trang
$total_pages = ceil($total / $per_page);
```

### 17.4. Upload & Resize ảnh
**Flow:**
1. Validate file (jpg, png, gif, webp)
2. Validate size (max 5MB)
3. Tạo tên file unique: `product_id_timestamp_uniqid.ext`
4. Resize nếu > 1200px (giữ tỷ lệ)
5. Move vào `/uploads/products/`
6. Return đường dẫn file

---

## ⏰ **GIAI ĐOẠN 18: CRON JOBS (TÁC VỤ TỰ ĐỘNG)**

### 18.1. Xóa giỏ hàng hết hạn
**File:** `/cron/cleanup_cart.php`

**Query:**
```sql
DELETE FROM cart 
WHERE expires_at < NOW() 
OR (expires_at IS NULL AND added_at < DATE_SUB(NOW(), INTERVAL 30 DAY));
```

**Cron schedule:** Chạy mỗi ngày 2:00 AM
```bash
0 2 * * * php /path/to/cron/cleanup_cart.php
```

### 18.2. Tự động hủy đơn hàng quá hạn
**File:** `/cron/auto_cancel_orders.php`

**Logic:**
- Tìm đơn `order_status = 'processing'` và `payment_status = 'unpaid'`
- Quá 7 ngày kể từ `order_date`
- Hoàn tồn kho
- Hủy đơn

**Query (TRANSACTION):**
```sql
START TRANSACTION;

-- Tìm đơn cần hủy
SELECT order_id FROM orders 
WHERE order_status = 'processing' 
AND payment_status = 'unpaid'
AND order_date < DATE_SUB(NOW(), INTERVAL 7 DAY);

FOR EACH order_id:
    -- Hoàn tồn kho
    UPDATE product_variants pv
    JOIN order_details od ON pv.variant_id = od.variant_id
    SET pv.stock_quantity = pv.stock_quantity + od.quantity
    WHERE od.order_id = ?;
    
    -- Hủy đơn
    UPDATE orders 
    SET order_status = 'cancelled',
        cancelled_reason = 'Tự động hủy do quá thời gian thanh toán',
        cancelled_by = 'system',
        cancelled_at = NOW()
    WHERE order_id = ?;
    
    -- Thông báo khách
    INSERT INTO notifications (user_id, type, title, message, created_at)
    VALUES (?, 'order_auto_cancelled', 'Đơn hàng tự động hủy', ?, NOW());

COMMIT;
```

**Cron schedule:** Chạy mỗi ngày 3:00 AM
```bash
0 3 * * * php /path/to/cron/auto_cancel_orders.php
```

### 18.3. Tắt mã giảm giá hết hạn
**File:** `/cron/expire_coupons.php`

**Query:**
```sql
UPDATE coupons 
SET status = 'inactive' 
WHERE expiry_date < CURDATE() 
AND status = 'active';
```

**Cron schedule:** Chạy mỗi ngày 4:00 AM
```bash
0 4 * * * php /path/to/cron/expire_coupons.php
```

---

## 🎨 **GIAI ĐOẠN 19: GIAO DIỆN (FRONTEND)**

### 19.1. Layout chung
**File cần tạo:**
- `public/includes/header.php` - Header khách hàng
- `public/includes/footer.php` - Footer khách hàng
- `admin/includes/header.php` - Header admin
- `admin/includes/sidebar.php` - Sidebar admin
- `admin/includes/footer.php` - Footer admin

**Header khách (public):**
- Logo
- Menu danh mục
- Tìm kiếm
- Giỏ hàng (hiển thị số lượng)
- Đăng nhập/Tài khoản

**Sidebar admin:**
- Dashboard
- Quản lý danh mục
- Quản lý size/màu
- Quản lý sản phẩm
- Quản lý mã giảm giá
- Quản lý đơn hàng
- Quản lý khách hàng
- Quản lý đánh giá
- Quản lý trả hàng
- Xem log

### 19.2. CSS Framework
**Khuyến nghị:** Bootstrap 5 hoặc Tailwind CSS
- Responsive
- Component có sẵn
- Dễ custom

### 19.3. JavaScript
**Thư viện cần thiết:**
- jQuery (AJAX)
- Chart.js (biểu đồ admin)
- Slick Carousel (slider ảnh)
- Select2 (dropdown đẹp)

---

## 🧪 **GIAI ĐOẠN 20: TESTING & DEBUG**

### 20.1. Test các luồng nghiệp vụ chính

**Luồng 1: Đăng ký → Đăng nhập → Mua hàng**
1. Đăng ký tài khoản mới
2. Đăng nhập
3. Xem sản phẩm → Chọn size/màu
4. Thêm vào giỏ
5. Thanh toán → Áp dụng mã giảm giá
6. Tạo đơn hàng thành công
7. Kiểm tra tồn kho đã giảm
8. Kiểm tra giỏ hàng đã xóa

**Luồng 2: Admin quản lý đơn hàng**
1. Admin login
2. Xem danh sách đơn mới
3. Xem chi tiết đơn
4. Cập nhật trạng thái: processing → confirmed → shipping → completed
5. Khách nhận thông báo mỗi lần cập nhật

**Luồng 3: Đánh giá sản phẩm**
1. Customer đăng nhập
2. Vào lịch sử đơn hàng (status = completed)
3. Đánh giá sản phẩm
4. Admin duyệt đánh giá
5. Hiển thị trên trang chi tiết sản phẩm

**Luồng 4: Hủy đơn & hoàn tồn kho**
1. Customer/Admin hủy đơn
2. Kiểm tra tồn kho đã hoàn lại
3. Kiểm tra sold_count đã giảm
4. Kiểm tra coupon đã hoàn (nếu có)

### 20.2. Test Edge Cases

**Test 1: Đặt hàng vượt tồn kho**
- Thêm vào giỏ: 10 sp
- Tồn kho chỉ còn: 5
- Kết quả mong đợi: Báo lỗi "Không đủ hàng"

**Test 2: 2 người đặt cùng lúc 1 sản phẩm cuối**
- User A đặt (tồn: 1)
- User B đặt (tồn: 1)
- Kết quả: 1 người thành công, 1 người báo hết hàng (nhờ TRANSACTION)

**Test 3: Áp dụng mã giảm giá đã hết lượt**
- Mã chỉ dùng được 1 lần
- User đã dùng rồi
- Kết quả: Báo lỗi "Mã đã được sử dụng"

**Test 4: Đánh giá sản phẩm chưa mua**
- User chưa có đơn hàng nào
- Cố truy cập link đánh giá
- Kết quả: Báo lỗi hoặc redirect

### 20.3. Test Performance

**Query cần tối ưu:**
- Danh sách sản phẩm (có phân trang)
- Tìm kiếm full-text
- Dashboard admin (nhiều query)

**Kiểm tra INDEX:**
```sql
EXPLAIN SELECT * FROM products WHERE category_id = ?;
EXPLAIN SELECT * FROM orders WHERE user_id = ?;
```

---

## 🚀 **GIAI ĐOẠN 21: DEPLOYMENT & BẢO TRÌ**

### 21.1. Checklist trước khi deploy

**Database:**
- ✅ Backup database định kỳ
- ✅ Kiểm tra tất cả FOREIGN KEY
- ✅ Kiểm tra tất cả INDEX

**Code:**
- ✅ Tắt `display_errors` trong production
- ✅ Bật `log_errors`
- ✅ Đổi password admin mặc định
- ✅ Kiểm tra quyền thư mục uploads

**Security (nếu cần):**
- ⚠️ Hash password (đang để plain text)
- ⚠️ Prepared Statement (đang query thẳng)
- ⚠️ CSRF Token
- ⚠️ XSS Protection

### 21.2. Backup & Recovery

**Backup database:**
```bash
# Backup toàn bộ
mysqldump -u root fashion_shop > backup_$(date +%Y%m%d).sql

# Restore
mysql -u root fashion_shop < backup_20260131.sql
```

**Backup files:**
```bash
# Backup thư mục uploads
tar -czf uploads_backup_$(date +%Y%m%d).tar.gz uploads/
```

### 21.3. Monitoring

**Theo dõi:**
- Tốc độ load trang
- Số lượng đơn hàng/ngày
- Tỷ lệ hủy đơn
- Top sản phẩm bán chạy
- Lỗi PHP (check log file)

---

## 📝 **TÓM TẮT WORKFLOW QUAN TRỌNG**

### 🔥 Workflow 1: Tạo đơn hàng (QUAN TRỌNG NHẤT)
```
1. Validate giỏ hàng
2. BEGIN TRANSACTION
3. Tạo đơn hàng (INSERT orders)
4. Kiểm tra tồn kho từng sản phẩm
5. Tạo chi tiết đơn (INSERT order_details - SNAPSHOT)
6. Trừ tồn kho (UPDATE product_variants)
7. Tăng sold_count (UPDATE products)
8. Cập nhật mã giảm giá (nếu có)
9. Xóa giỏ hàng (DELETE cart)
10. Tạo thông báo
11. COMMIT
```

### 🔥 Workflow 2: Hủy đơn hàng
```
1. BEGIN TRANSACTION
2. Hoàn tồn kho (UPDATE product_variants)
3. Giảm sold_count (UPDATE products)
4. Hoàn mã giảm giá (nếu có)
5. Cập nhật trạng thái đơn (UPDATE orders)
6. Tạo thông báo
7. COMMIT
```

### 🔥 Workflow 3: Đánh giá sản phẩm
```
1. Kiểm tra đã mua chưa (order_status = 'completed')
2. Kiểm tra đã đánh giá chưa
3. Upload ảnh (nếu có)
4. INSERT review
5. Tạo thông báo cho admin
```

---

## ✅ CHECKLIST HOÀN THÀNH DỰ ÁN

### Giai đoạn 0-5: Core Features (Khách hàng)
- [ ] 0. Chuẩn bị môi trường & Import DB
- [ ] 1. Module Authentication
- [ ] 2. Trang chủ & Hiển thị sản phẩm
- [ ] 3. Giỏ hàng
- [ ] 4. Thanh toán
- [ ] 5. Quản lý đơn hàng (Customer)

### Giai đoạn 6-7: Extended Features (Khách hàng)
- [ ] 6. Đánh giá sản phẩm
- [ ] 7. Trang cá nhân (Profile, Wishlist, Notifications)

### Giai đoạn 8-14: Admin Features
- [ ] 8. Dashboard & Thống kê
- [ ] 9. Quản lý Danh mục, Size, Màu
- [ ] 10. Quản lý Sản phẩm
- [ ] 11. Quản lý Mã giảm giá
- [ ] 12. Quản lý Đơn hàng
- [ ] 13. Quản lý Khách hàng
- [ ] 14. Quản lý Đánh giá

### Giai đoạn 15-18: Advanced Features
- [ ] 15. Quản lý Trả hàng
- [ ] 16. Xem Log hoạt động
- [ ] 17. Chức năng phụ (Search, Related Products, Pagination)
- [ ] 18. Cron Jobs (Auto cleanup)

### Giai đoạn 19-21: Polish & Deploy
- [ ] 19. Giao diện (Frontend)
- [ ] 20. Testing & Debug
- [ ] 21. Deployment & Bảo trì

---

## 🎯 THỨ TỰ TRIỂN KHAI KHUYẾN NGHỊ

**Tuần 1: Foundation**
- Giai đoạn 0, 1, 2 (Setup + Auth + Product Display)

**Tuần 2: Shopping Flow**
- Giai đoạn 3, 4, 5 (Cart + Checkout + Order Management)

**Tuần 3: Extended Customer Features**
- Giai đoạn 6, 7 (Reviews + Account)

**Tuần 4: Admin Core**
- Giai đoạn 8, 9, 10 (Dashboard + Categories + Products)

**Tuần 5: Admin Extended**
- Giai đoạn 11, 12, 13 (Coupons + Orders + Customers)

**Tuần 6: Advanced & Polish**
- Giai đoạn 14, 15, 16, 17, 18 (Reviews + Returns + Logs + Utils + Cron)

**Tuần 7: UI/UX & Testing**
- Giai đoạn 19, 20 (Frontend + Testing)

**Tuần 8: Deployment**
- Giai đoạn 21 (Deploy + Monitoring)

---

## 📞 LƯU Ý QUAN TRỌNG

### ⚡ Điểm then chốt cần nhớ:

1. **TRANSACTION là BẮT BUỘC** cho:
   - Tạo đơn hàng
   - Hủy đơn hàng
   - Tạo sản phẩm (nếu có nhiều bảng liên quan)

2. **SNAPSHOT dữ liệu** trong `order_details`:
   - Lưu `product_name`, `size_name`, `color_name`, `price`
   - Không JOIN lại để lấy thông tin hiện tại

3. **Kiểm tra quyền sở hữu** trước khi:
   - Xem chi tiết đơn hàng
   - Cập nhật giỏ hàng
   - Hủy đơn hàng

4. **Validate tồn kho** TRƯỚC KHI:
   - Thêm vào giỏ
   - Tạo đơn hàng

5. **Log mọi thao tác quan trọng** của admin vào `admin_logs`

6. **Soft Delete** cho:
   - Users
   - Categories
   - Products

7. **Thông báo khách hàng** khi:
   - Đơn hàng thay đổi trạng thái
   - Đánh giá được duyệt
   - Yêu cầu trả hàng được xử lý

---

**🎉 CHÚC BẠN CODE THÀNH CÔNG! 🎉**

*Tài liệu này được tạo dựa trên `fashion_shop_database.sql`*  
*Đảm bảo 100% đồng nhất với cấu trúc 18 bảng đã thiết kế*
