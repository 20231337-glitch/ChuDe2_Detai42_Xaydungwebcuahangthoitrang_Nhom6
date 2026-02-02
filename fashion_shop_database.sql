-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Máy chủ: 127.0.0.1
-- Thời gian đã tạo: Th2 01, 2026 lúc 02:22 PM
-- Phiên bản máy phục vụ: 10.4.32-MariaDB
-- Phiên bản PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Cơ sở dữ liệu: `fashion_shop`
--

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `admin_logs`
--

CREATE TABLE `admin_logs` (
  `log_id` int(11) UNSIGNED NOT NULL,
  `admin_id` int(11) UNSIGNED NOT NULL,
  `action` varchar(100) NOT NULL COMMENT 'CREATE, UPDATE, DELETE...',
  `table_name` varchar(100) NOT NULL,
  `record_id` int(11) DEFAULT NULL COMMENT 'ID của bản ghi bị thay đổi',
  `old_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Giá trị cũ' CHECK (json_valid(`old_value`)),
  `new_value` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Giá trị mới' CHECK (json_valid(`new_value`)),
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng nhật ký hoạt động admin';

--
-- Đang đổ dữ liệu cho bảng `admin_logs`
--

INSERT INTO `admin_logs` (`log_id`, `admin_id`, `action`, `table_name`, `record_id`, `old_value`, `new_value`, `ip_address`, `user_agent`, `created_at`) VALUES
(1, 1, 'UPDATE', 'orders', 2, '{\"order_status\": \"processing\"}', '{\"order_status\": \"completed\"}', '192.168.1.1', NULL, '2026-01-24 02:12:39'),
(2, 1, 'CREATE', 'products', 10, NULL, '{\"product_name\": \"Mũ snapback thời trang\", \"base_price\": 120000}', '192.168.1.1', NULL, '2026-01-21 02:12:39'),
(3, 1, 'UPDATE', 'orders', 3, '{\"order_status\": \"processing\"}', '{\"order_status\": \"shipping\"}', '192.168.1.1', NULL, '2026-01-28 02:12:39'),
(4, 1, 'UPDATE', 'orders', 1, '{\"order_status\":\"processing\"}', '{\"order_status\":\"confirmed\",\"note\":\"\"}', NULL, NULL, '2026-02-01 16:10:19'),
(5, 1, 'UPDATE', 'orders', 3, '{\"order_status\":\"shipping\"}', '{\"order_status\":\"completed\",\"note\":\"\"}', NULL, NULL, '2026-02-01 16:10:38'),
(6, 1, 'UPDATE', 'orders', 1, '{\"order_status\":\"confirmed\"}', '{\"order_status\":\"shipping\",\"note\":\"\"}', NULL, NULL, '2026-02-01 16:33:41'),
(7, 1, 'UPDATE', 'orders', 1, '{\"order_status\":\"shipping\"}', '{\"order_status\":\"completed\",\"note\":\"\"}', NULL, NULL, '2026-02-01 16:33:44'),
(8, 1, 'UPDATE', 'orders', 27, '{\"order_status\":\"processing\"}', '{\"order_status\":\"confirmed\",\"note\":\"\"}', NULL, NULL, '2026-02-01 17:04:35'),
(9, 1, 'UPDATE', 'orders', 27, '{\"order_status\":\"confirmed\"}', '{\"order_status\":\"shipping\",\"note\":\"\"}', NULL, NULL, '2026-02-01 17:04:37'),
(10, 1, 'UPDATE', 'orders', 27, '{\"order_status\":\"shipping\"}', '{\"order_status\":\"completed\",\"note\":\"\"}', NULL, NULL, '2026-02-01 17:04:39'),
(11, 1, 'UPDATE', 'coupons', 1, NULL, NULL, NULL, NULL, '2026-02-01 17:05:38');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `cart`
--

CREATE TABLE `cart` (
  `cart_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `variant_id` int(11) UNSIGNED NOT NULL,
  `quantity` int(11) NOT NULL CHECK (`quantity` > 0),
  `added_at` datetime NOT NULL DEFAULT current_timestamp(),
  `expires_at` datetime DEFAULT NULL COMMENT 'Hết hạn sau 30 ngày không hoạt động'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng giỏ hàng';

--
-- Đang đổ dữ liệu cho bảng `cart`
--

INSERT INTO `cart` (`cart_id`, `user_id`, `variant_id`, `quantity`, `added_at`, `expires_at`) VALUES
(73, 1, 22, 3, '2026-02-01 01:23:12', '2026-03-03 05:29:18'),
(74, 1, 16, 12, '2026-02-01 05:23:18', '2026-03-03 05:29:25');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `categories`
--

CREATE TABLE `categories` (
  `category_id` int(11) UNSIGNED NOT NULL,
  `category_name` varchar(100) NOT NULL,
  `slug` varchar(150) NOT NULL COMMENT 'URL thân thiện SEO',
  `description` text DEFAULT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL COMMENT 'Soft delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng danh mục sản phẩm';

--
-- Đang đổ dữ liệu cho bảng `categories`
--

INSERT INTO `categories` (`category_id`, `category_name`, `slug`, `description`, `status`, `created_at`, `deleted_at`) VALUES
(1, 'Áo thun', 'ao-thun', 'Áo thun nam nữ chất lượng cao, đa dạng mẫu mã', 'active', '2026-01-31 02:12:39', NULL),
(2, 'Áo sơ mi', 'ao-so-mi', 'Áo sơ mi công sở, dạo phố thời trang', 'active', '2026-01-31 02:12:39', NULL),
(3, 'Quần jean', 'quan-jean', 'Quần jean nam nữ, nhiều kiểu dáng hiện đại', 'active', '2026-01-31 02:12:39', NULL),
(4, 'Váy', 'vay', 'Váy nữ dự tiệc, dạo phố, công sở', 'active', '2026-01-31 02:12:39', NULL),
(5, 'Phụ kiện', 'phu-kien', 'Túi xách, ví, thắt lưng, mũ...', 'active', '2026-01-31 02:12:39', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `colors`
--

CREATE TABLE `colors` (
  `color_id` int(11) UNSIGNED NOT NULL,
  `color_name` varchar(50) NOT NULL,
  `color_code` varchar(7) DEFAULT NULL COMMENT 'Mã màu HEX: #FFFFFF',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Thứ tự hiển thị'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng màu sắc';

--
-- Đang đổ dữ liệu cho bảng `colors`
--

INSERT INTO `colors` (`color_id`, `color_name`, `color_code`, `display_order`) VALUES
(1, 'Đen', '#000000', 1),
(2, 'Trắng', '#FFFFFF', 2),
(3, 'Đỏ', '#FF0000', 3),
(4, 'Xanh dương', '#0000FF', 4),
(5, 'Xanh lá', '#00FF00', 5),
(6, 'Vàng', '#FFFF00', 6),
(7, 'Hồng', '#FFC0CB', 7),
(8, 'Xám', '#808080', 8),
(9, 'Nâu', '#8B4513', 9),
(10, 'Cam', '#FFA500', 10);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupons`
--

CREATE TABLE `coupons` (
  `coupon_id` int(11) UNSIGNED NOT NULL,
  `coupon_code` varchar(50) NOT NULL,
  `discount_type` enum('percent','fixed') NOT NULL COMMENT 'Giảm % hoặc số tiền cố định',
  `discount_value` decimal(10,2) NOT NULL CHECK (`discount_value` > 0),
  `min_order_value` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Đơn hàng tối thiểu',
  `max_uses` int(11) DEFAULT NULL COMMENT 'Tổng số lần dùng tối đa (NULL = không giới hạn)',
  `max_uses_per_user` int(11) NOT NULL DEFAULT 1 COMMENT '1 user dùng tối đa bao nhiêu lần',
  `used_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Đã dùng bao nhiêu lần',
  `expiry_date` date NOT NULL,
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng mã giảm giá';

--
-- Đang đổ dữ liệu cho bảng `coupons`
--

INSERT INTO `coupons` (`coupon_id`, `coupon_code`, `discount_type`, `discount_value`, `min_order_value`, `max_uses`, `max_uses_per_user`, `used_count`, `expiry_date`, `status`, `created_at`) VALUES
(1, 'SALE10', 'percent', 10.00, 200000.00, 100, 1, 0, '0000-00-00', 'inactive', '2026-01-31 02:12:39'),
(2, 'TET2025', 'fixed', 50000.00, 500000.00, 200, 2, 0, '2026-02-28', 'active', '2026-01-31 02:12:39'),
(3, 'FREESHIP', 'fixed', 30000.00, 300000.00, NULL, 1, 0, '2026-12-31', 'active', '2026-01-31 02:12:39'),
(4, 'NEWMEMBER', 'percent', 15.00, 0.00, NULL, 1, 0, '2026-12-31', 'active', '2026-01-31 02:12:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `coupon_usage`
--

CREATE TABLE `coupon_usage` (
  `usage_id` int(11) UNSIGNED NOT NULL,
  `coupon_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `order_id` int(11) UNSIGNED NOT NULL,
  `used_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng lịch sử sử dụng mã giảm giá';

--
-- Đang đổ dữ liệu cho bảng `coupon_usage`
--

INSERT INTO `coupon_usage` (`usage_id`, `coupon_id`, `user_id`, `order_id`, `used_at`) VALUES
(1, 1, 2, 1, '2026-01-31 02:12:39'),
(2, 2, 4, 3, '2026-01-28 02:12:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `notifications`
--

CREATE TABLE `notifications` (
  `notification_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `type` varchar(50) NOT NULL COMMENT 'order_update, promotion, system...',
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `link` varchar(255) DEFAULT NULL COMMENT 'Link đến trang chi tiết',
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng thông báo cho người dùng';

--
-- Đang đổ dữ liệu cho bảng `notifications`
--

INSERT INTO `notifications` (`notification_id`, `user_id`, `type`, `title`, `message`, `link`, `is_read`, `created_at`) VALUES
(1, 2, 'order_update', 'Đơn hàng đã được tạo', 'Đơn hàng #1 của bạn đã được tạo thành công và đang được xử lý.', '/account/order_detail.php?id=1', 0, '2026-01-31 02:12:39'),
(2, 3, 'order_update', 'Đơn hàng đã hoàn thành', 'Đơn hàng #2 đã được giao thành công. Cảm ơn bạn đã mua hàng!', '/account/order_detail.php?id=2', 1, '2026-01-26 02:12:39'),
(3, 4, 'order_update', 'Đơn hàng đang giao', 'Đơn hàng #3 đang trên đường giao đến bạn.', '/account/order_detail.php?id=3', 0, '2026-01-29 02:12:39'),
(4, 2, 'promotion', 'Mã giảm giá mới', 'Sử dụng mã SALE10 để được giảm 10% cho đơn hàng từ 200K!', '/promotions', 0, '2026-01-31 02:12:39'),
(16, 2, 'order_update', 'Đơn hàng đã được xác nhận', 'Đơn hàng #1 đã được xác nhận và sẽ sớm được giao đến bạn.', '/public/account/order_detail.php?id=1', 0, '2026-02-01 16:10:19'),
(17, 4, 'order_update', 'Đơn hàng đã hoàn thành', 'Đơn hàng #3 đã được giao thành công. Cảm ơn bạn đã mua hàng!', '/public/account/order_detail.php?id=3', 0, '2026-02-01 16:10:38'),
(18, 2, 'order_update', 'Đơn hàng đang được giao', 'Đơn hàng #1 đang trên đường giao đến bạn.', '/public/account/order_detail.php?id=1', 0, '2026-02-01 16:33:41'),
(19, 2, 'order_update', 'Đơn hàng đã hoàn thành', 'Đơn hàng #1 đã được giao thành công. Cảm ơn bạn đã mua hàng!', '/public/account/order_detail.php?id=1', 0, '2026-02-01 16:33:44'),
(20, 5, 'order_update', 'Đơn hàng đã được tạo', 'Đơn hàng #26 đã được tạo thành công và đang được xử lý.', '/fashion-shop/public/account/order_detail.php?id=26', 0, '2026-02-01 17:02:37'),
(21, 5, 'order_update', 'Đơn hàng đã hủy', 'Đơn hàng #26 đã được hủy thành công. Tồn kho và mã giảm giá đã được hoàn lại.', '/fashion-shop/public/account/order_detail.php?id=26', 0, '2026-02-01 17:02:59'),
(22, 5, 'order_update', 'Đơn hàng đã được tạo', 'Đơn hàng #27 đã được tạo thành công và đang được xử lý.', '/fashion-shop/public/account/order_detail.php?id=27', 0, '2026-02-01 17:03:38'),
(23, 5, 'order_update', 'Đơn hàng đã được xác nhận', 'Đơn hàng #27 đã được xác nhận và sẽ sớm được giao đến bạn.', '/public/account/order_detail.php?id=27', 0, '2026-02-01 17:04:35'),
(24, 5, 'order_update', 'Đơn hàng đang được giao', 'Đơn hàng #27 đang trên đường giao đến bạn.', '/public/account/order_detail.php?id=27', 0, '2026-02-01 17:04:37'),
(25, 5, 'order_update', 'Đơn hàng đã hoàn thành', 'Đơn hàng #27 đã được giao thành công. Cảm ơn bạn đã mua hàng!', '/public/account/order_detail.php?id=27', 0, '2026-02-01 17:04:39'),
(26, 5, 'order_update', 'Đơn hàng đã được tạo', 'Đơn hàng #28 đã được tạo thành công và đang được xử lý.', '/fashion-shop/public/account/order_detail.php?id=28', 0, '2026-02-01 19:49:06'),
(27, 5, 'order_update', 'Đơn hàng đã hủy', 'Đơn hàng #28 đã được hủy thành công. Tồn kho và mã giảm giá đã được hoàn lại.', '/fashion-shop/public/account/order_detail.php?id=28', 0, '2026-02-01 20:06:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `orders`
--

CREATE TABLE `orders` (
  `order_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `fullname` varchar(100) NOT NULL,
  `phone` varchar(15) NOT NULL,
  `address` text NOT NULL,
  `note` text DEFAULT NULL COMMENT 'Ghi chú từ khách hàng',
  `total_amount` decimal(10,2) NOT NULL COMMENT 'Tổng tiền trước giảm giá',
  `coupon_id` int(11) UNSIGNED DEFAULT NULL,
  `discount_amount` decimal(10,2) NOT NULL DEFAULT 0.00 COMMENT 'Số tiền được giảm',
  `final_amount` decimal(10,2) NOT NULL COMMENT 'Tổng tiền sau giảm giá',
  `payment_method` enum('COD','Banking') NOT NULL DEFAULT 'COD',
  `payment_status` enum('unpaid','paid') NOT NULL DEFAULT 'unpaid',
  `order_status` enum('processing','confirmed','shipping','completed','cancelled','returned') NOT NULL DEFAULT 'processing',
  `cancelled_reason` text DEFAULT NULL,
  `cancelled_by` enum('customer','admin','system') DEFAULT NULL,
  `cancelled_at` datetime DEFAULT NULL,
  `return_reason` text DEFAULT NULL COMMENT 'Lý do khách hàng yêu cầu hoàn hàng',
  `returned_at` datetime DEFAULT NULL COMMENT 'Thời điểm admin duyệt hoàn hàng',
  `order_date` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng đơn hàng';

--
-- Đang đổ dữ liệu cho bảng `orders`
--

INSERT INTO `orders` (`order_id`, `user_id`, `fullname`, `phone`, `address`, `note`, `total_amount`, `coupon_id`, `discount_amount`, `final_amount`, `payment_method`, `payment_status`, `order_status`, `cancelled_reason`, `cancelled_by`, `cancelled_at`, `return_reason`, `returned_at`, `order_date`, `updated_at`) VALUES
(1, 2, 'Nguyễn Văn A', '0912345678', '123 Nguyễn Trãi, Hà Nội', 'Giao giờ hành chính', 680000.00, 1, 68000.00, 612000.00, 'COD', '', 'completed', NULL, NULL, NULL, NULL, NULL, '2026-01-31 02:12:39', '2026-02-01 16:33:44'),
(2, 3, 'Trần Thị B', '0923456789', '456 Lê Lợi, Hồ Chí Minh', NULL, 1200000.00, NULL, 0.00, 1200000.00, 'Banking', 'paid', 'completed', NULL, NULL, NULL, NULL, NULL, '2026-01-24 02:12:39', NULL),
(3, 4, 'Phạm Văn C', '0934567890', '789 Trần Hưng Đạo, Đà Nẵng', 'Gọi trước khi giao', 450000.00, 2, 50000.00, 400000.00, 'COD', '', 'completed', NULL, NULL, NULL, NULL, NULL, '2026-01-28 02:12:39', '2026-02-01 16:10:38'),
(26, 5, 'Trịnh Hoàng Thành', '0355636882', 'lol123', '', 960000.00, 1, 96000.00, 864000.00, 'COD', 'unpaid', 'cancelled', 'Khách hàng yêu cầu hủy', 'customer', '2026-02-01 17:02:59', NULL, NULL, '2026-02-01 17:02:37', '2026-02-01 17:02:59'),
(27, 5, 'Trịnh Hoàng Thành', '0355636882', 'sssss', '', 150000.00, NULL, 0.00, 150000.00, 'COD', 'paid', 'completed', NULL, NULL, NULL, NULL, NULL, '2026-02-01 17:03:38', '2026-02-01 17:04:39'),
(28, 5, 'Trịnh Hoàng Thành', '0355636882', 'j', '', 180000.00, NULL, 0.00, 180000.00, 'COD', 'unpaid', 'cancelled', 'Khách hàng yêu cầu hủy', 'customer', '2026-02-01 20:06:28', NULL, NULL, '2026-02-01 19:49:06', '2026-02-01 20:06:28');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_details`
--

CREATE TABLE `order_details` (
  `detail_id` int(11) UNSIGNED NOT NULL,
  `order_id` int(11) UNSIGNED NOT NULL,
  `variant_id` int(11) UNSIGNED NOT NULL,
  `product_name` varchar(200) NOT NULL COMMENT 'Snapshot tên sản phẩm',
  `size_name` varchar(10) NOT NULL COMMENT 'Snapshot size',
  `color_name` varchar(50) NOT NULL COMMENT 'Snapshot màu',
  `price` decimal(10,2) NOT NULL COMMENT 'Snapshot giá tại thời điểm đặt',
  `quantity` int(11) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL COMMENT 'price * quantity'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng chi tiết đơn hàng';

--
-- Đang đổ dữ liệu cho bảng `order_details`
--

INSERT INTO `order_details` (`detail_id`, `order_id`, `variant_id`, `product_name`, `size_name`, `color_name`, `price`, `quantity`, `subtotal`) VALUES
(1, 1, 1, 'Áo thun nam basic cotton', 'S', 'Đen', 150000.00, 2, 300000.00),
(2, 1, 25, 'Áo sơ mi nữ trắng', 'M', 'Trắng', 320000.00, 1, 320000.00),
(3, 1, 42, 'Mũ snapback thời trang', 'M', 'Đen', 120000.00, 1, 120000.00),
(4, 2, 16, 'Áo thun nữ form rộng', 'M', 'Trắng', 180000.00, 2, 360000.00),
(5, 2, 38, 'Váy nữ dạ hội', 'M', 'Đỏ', 850000.00, 1, 850000.00),
(6, 3, 28, 'Quần jean nam slimfit', 'M', 'Đen', 450000.00, 1, 450000.00),
(18, 26, 43, 'Quần jean nữ rách gối', 'S', 'Xanh dương', 420000.00, 1, 420000.00),
(19, 26, 16, 'Áo thun nữ form rộng', 'S', 'Trắng', 180000.00, 1, 180000.00),
(20, 26, 19, 'Áo thun nữ form rộng', 'S', 'Hồng', 180000.00, 1, 180000.00),
(21, 26, 22, 'Áo thun nữ form rộng', 'S', 'Xanh dương', 180000.00, 1, 180000.00),
(22, 27, 6, 'Áo thun nam basic cotton', 'S', 'Trắng', 150000.00, 1, 150000.00),
(23, 28, 16, 'Áo thun nữ form rộng', 'S', 'Trắng', 180000.00, 1, 180000.00);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `variant_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `variant_id`, `quantity`, `price`, `created_at`) VALUES
(1, 1, 1, 2, 250000.00, '2026-01-30 21:56:39'),
(2, 2, 2, 1, 750000.00, '2026-01-30 21:56:39'),
(3, 3, 3, 1, 600000.00, '2026-01-30 21:56:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_returns`
--

CREATE TABLE `order_returns` (
  `return_id` int(11) UNSIGNED NOT NULL,
  `order_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `reason` text NOT NULL COMMENT 'Lý do trả hàng',
  `status` enum('pending','approved','rejected','refunded') NOT NULL DEFAULT 'pending',
  `admin_note` text DEFAULT NULL COMMENT 'Ghi chú từ admin',
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Ảnh chụp sản phẩm lỗi' CHECK (json_valid(`images`)),
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng yêu cầu trả hàng';

--
-- Đang đổ dữ liệu cho bảng `order_returns`
--

INSERT INTO `order_returns` (`return_id`, `order_id`, `user_id`, `reason`, `status`, `admin_note`, `images`, `created_at`, `updated_at`) VALUES
(1, 27, 5, 'không đúng mô tả', 'pending', NULL, NULL, '2026-02-01 20:12:48', NULL),
(2, 27, 5, 'd', 'pending', NULL, NULL, '2026-02-01 20:12:56', NULL),
(3, 27, 5, 'aaa', 'pending', NULL, NULL, '2026-02-01 20:19:12', NULL),
(4, 27, 5, 'aaaa', 'pending', NULL, NULL, '2026-02-01 20:21:18', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `order_status_history`
--

CREATE TABLE `order_status_history` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `status` enum('pending','confirmed','shipping','delivered','cancelled') NOT NULL,
  `notes` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Đang đổ dữ liệu cho bảng `order_status_history`
--

INSERT INTO `order_status_history` (`id`, `order_id`, `status`, `notes`, `created_at`) VALUES
(1, 1, 'pending', 'Đơn hàng vừa được tạo', '2026-01-30 21:56:39'),
(2, 2, 'confirmed', 'Đơn hàng đã được xác nhận', '2026-01-30 21:56:39'),
(3, 3, 'shipping', 'Đơn hàng đang được giao', '2026-01-30 21:56:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `products`
--

CREATE TABLE `products` (
  `product_id` int(11) UNSIGNED NOT NULL,
  `product_name` varchar(200) NOT NULL,
  `sale_price` decimal(10,2) DEFAULT 0.00,
  `slug` varchar(250) NOT NULL COMMENT 'SEO: ao-thun-nam-basic',
  `category_id` int(11) UNSIGNED NOT NULL,
  `description` text DEFAULT NULL,
  `base_price` decimal(10,2) NOT NULL CHECK (`base_price` >= 0),
  `view_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Số lượt xem',
  `sold_count` int(11) NOT NULL DEFAULT 0 COMMENT 'Đã bán bao nhiêu',
  `status` enum('active','inactive') NOT NULL DEFAULT 'active',
  `meta_title` varchar(255) DEFAULT NULL COMMENT 'SEO Meta Title',
  `meta_description` text DEFAULT NULL COMMENT 'SEO Meta Description',
  `meta_keywords` varchar(255) DEFAULT NULL COMMENT 'SEO Keywords',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp(),
  `deleted_at` datetime DEFAULT NULL COMMENT 'Soft delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng sản phẩm chính';

--
-- Đang đổ dữ liệu cho bảng `products`
--

INSERT INTO `products` (`product_id`, `product_name`, `sale_price`, `slug`, `category_id`, `description`, `base_price`, `view_count`, `sold_count`, `status`, `meta_title`, `meta_description`, `meta_keywords`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Áo thun nam basic cotton', 150000.00, 'ao-thun-nam-basic-cotton', 1, 'Áo thun nam chất liệu cotton 100%, thoáng mát, thấm hút mồ hôi tốt. Thiết kế đơn giản, phù hợp mọi lứa tuổi.', 150000.00, 152, 21, 'active', 'Áo thun nam basic cotton giá rẻ', NULL, NULL, '2026-01-31 02:12:39', '2026-02-01 17:03:38', NULL),
(2, 'Áo thun nữ form rộng', 180000.00, 'ao-thun-nu-form-rong', 1, 'Áo thun nữ form rộng trendy, chất cotton mềm mại. Dễ phối đồ, phù hợp đi chơi, đi học.', 180000.00, 201, 37, 'active', 'Áo thun nữ form rộng hot trend', NULL, NULL, '2026-01-31 02:12:39', '2026-02-01 20:06:28', NULL),
(3, 'Áo sơ mi nam công sở', 350000.00, 'ao-so-mi-nam-cong-so', 2, 'Áo sơ mi nam cao cấp, chất liệu kate mịn, không nhăn. Lý tưởng cho môi trường công sở.', 350000.00, 80, 12, 'active', 'Áo sơ mi nam công sở chất lượng', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 03:16:09', NULL),
(4, 'Áo sơ mi nữ trắng', 320000.00, 'ao-so-mi-nu-trang', 2, 'Áo sơ mi nữ trắng basic, thiết kế thanh lịch. Phù hợp đi làm, đi học.', 320000.00, 120, 18, 'active', 'Áo sơ mi nữ trắng công sở', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 03:16:09', NULL),
(5, 'Quần jean nam slimfit', 450000.00, 'quan-jean-nam-slimfit', 3, 'Quần jean nam dáng slimfit ôm vừa phải, tôn dáng. Chất jean co giãn nhẹ, thoải mái cả ngày.', 450000.00, 95, 8, 'active', 'Quần jean nam slimfit hot', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 03:16:09', NULL),
(6, 'Quần jean nữ rách gối', 420000.00, 'quan-jean-nu-rach-goi', 3, 'Quần jean nữ rách gối phong cách cá tính. Chất jean dày dặn, bền đẹp.', 420000.00, 110, 15, 'active', 'Quần jean nữ rách gối trendy', NULL, NULL, '2026-01-31 02:12:39', '2026-02-01 17:02:59', NULL),
(7, 'Váy nữ midi hoa', 380000.00, 'vay-nu-midi-hoa', 4, 'Váy midi họa tiết hoa dịu dàng, nữ tính. Chất vải lụa mềm mại, thoáng mát.', 380000.00, 81, 10, 'active', 'Váy nữ midi họa tiết hoa', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 15:20:53', NULL),
(8, 'Váy nữ dạ hội', 850000.00, 'vay-nu-da-hoi', 4, 'Váy dạ hội sang trọng, thiết kế ôm body. Thích hợp cho tiệc cưới, sự kiện.', 850000.00, 180, 25, 'active', 'Váy nữ dạ hội cao cấp', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 03:16:09', NULL),
(9, 'Túi xách nữ da PU', 280000.00, 'tui-xach-nu-da-pu', 5, 'Túi xách nữ chất liệu da PU cao cấp, thiết kế sang trọng. Nhiều ngăn tiện lợi.', 280000.00, 140, 30, 'active', 'Túi xách nữ da PU đẹp', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 03:16:09', NULL),
(10, 'Mũ snapback thời trang', 120000.00, 'mu-snapback-thoi-trang', 5, 'Mũ snapback unisex phong cách street style. Chất vải kaki dày dặn, form đẹp.', 120000.00, 221, 45, 'active', 'Mũ snapback unisex hot trend', NULL, NULL, '2026-01-31 02:12:39', '2026-01-31 15:17:43', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_images`
--

CREATE TABLE `product_images` (
  `image_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `image_url` varchar(255) NOT NULL,
  `is_primary` tinyint(1) NOT NULL DEFAULT 0 COMMENT 'Ảnh chính',
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Thứ tự hiển thị slider',
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng ảnh sản phẩm';

--
-- Đang đổ dữ liệu cho bảng `product_images`
--

INSERT INTO `product_images` (`image_id`, `product_id`, `image_url`, `is_primary`, `display_order`, `created_at`) VALUES
(1, 1, '/uploads/products/ao-thun-nam-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(2, 1, '/uploads/products/ao-thun-nam-2.jpg', 0, 2, '2026-01-31 02:12:39'),
(3, 2, '/uploads/products/ao-thun-nu-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(4, 2, '/uploads/products/ao-thun-nu-2.jpg', 0, 2, '2026-01-31 02:12:39'),
(5, 3, '/uploads/products/ao-so-mi-nam-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(6, 4, '/uploads/products/ao-so-mi-nu-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(7, 5, '/uploads/products/quan-jean-nam-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(8, 6, '/uploads/products/quan-jean-nu-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(9, 7, '/uploads/products/vay-midi-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(10, 8, '/uploads/products/vay-da-hoi-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(11, 9, '/uploads/products/tui-xach-1.jpg', 1, 1, '2026-01-31 02:12:39'),
(12, 10, '/uploads/products/mu-snapback-1.jpg', 1, 1, '2026-01-31 02:12:39');

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `product_variants`
--

CREATE TABLE `product_variants` (
  `variant_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `size_id` int(11) UNSIGNED NOT NULL,
  `color_id` int(11) UNSIGNED NOT NULL,
  `stock_quantity` int(11) NOT NULL DEFAULT 0 CHECK (`stock_quantity` >= 0),
  `status` enum('in_stock','out_of_stock') NOT NULL DEFAULT 'in_stock',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng biến thể sản phẩm (Size x Color)';

--
-- Đang đổ dữ liệu cho bảng `product_variants`
--

INSERT INTO `product_variants` (`variant_id`, `product_id`, `size_id`, `color_id`, `stock_quantity`, `status`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 1, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(2, 1, 2, 1, 80, 'in_stock', '2026-01-31 02:12:39', NULL),
(3, 1, 3, 1, 100, 'in_stock', '2026-01-31 02:12:39', NULL),
(4, 1, 4, 1, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(5, 1, 5, 1, 30, 'in_stock', '2026-01-31 02:12:39', NULL),
(6, 1, 1, 2, 44, 'in_stock', '2026-01-31 02:12:39', '2026-02-01 17:03:38'),
(7, 1, 2, 2, 75, 'in_stock', '2026-01-31 02:12:39', NULL),
(8, 1, 3, 2, 90, 'in_stock', '2026-01-31 02:12:39', NULL),
(9, 1, 4, 2, 55, 'in_stock', '2026-01-31 02:12:39', NULL),
(10, 1, 5, 2, 25, 'in_stock', '2026-01-31 02:12:39', NULL),
(11, 1, 1, 8, 40, 'in_stock', '2026-01-31 02:12:39', NULL),
(12, 1, 2, 8, 70, 'in_stock', '2026-01-31 02:12:39', NULL),
(13, 1, 3, 8, 85, 'in_stock', '2026-01-31 02:12:39', NULL),
(14, 1, 4, 8, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(15, 1, 5, 8, 20, 'in_stock', '2026-01-31 02:12:39', NULL),
(16, 2, 1, 2, 60, 'in_stock', '2026-01-31 02:12:39', '2026-02-01 20:06:28'),
(17, 2, 2, 2, 90, 'in_stock', '2026-01-31 02:12:39', NULL),
(18, 2, 3, 2, 70, 'in_stock', '2026-01-31 02:12:39', NULL),
(19, 2, 1, 7, 55, 'in_stock', '2026-01-31 02:12:39', '2026-02-01 17:02:59'),
(20, 2, 2, 7, 85, 'in_stock', '2026-01-31 02:12:39', NULL),
(21, 2, 3, 7, 65, 'in_stock', '2026-01-31 02:12:39', NULL),
(22, 2, 1, 4, 50, 'in_stock', '2026-01-31 02:12:39', '2026-02-01 17:02:59'),
(23, 2, 2, 4, 80, 'in_stock', '2026-01-31 02:12:39', NULL),
(24, 2, 3, 4, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(25, 3, 2, 2, 40, 'in_stock', '2026-01-31 02:12:39', NULL),
(26, 3, 3, 2, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(27, 3, 4, 2, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(28, 3, 2, 4, 35, 'in_stock', '2026-01-31 02:12:39', NULL),
(29, 3, 3, 4, 55, 'in_stock', '2026-01-31 02:12:39', NULL),
(30, 3, 4, 4, 45, 'in_stock', '2026-01-31 02:12:39', NULL),
(31, 4, 1, 2, 70, 'in_stock', '2026-01-31 02:12:39', NULL),
(32, 4, 2, 2, 100, 'in_stock', '2026-01-31 02:12:39', NULL),
(33, 4, 3, 2, 80, 'in_stock', '2026-01-31 02:12:39', NULL),
(34, 5, 2, 1, 45, 'in_stock', '2026-01-31 02:12:39', NULL),
(35, 5, 3, 1, 65, 'in_stock', '2026-01-31 02:12:39', NULL),
(36, 5, 4, 1, 55, 'in_stock', '2026-01-31 02:12:39', NULL),
(37, 5, 2, 4, 40, 'in_stock', '2026-01-31 02:12:39', NULL),
(38, 5, 3, 4, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(39, 5, 4, 4, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(40, 6, 1, 1, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(41, 6, 2, 1, 75, 'in_stock', '2026-01-31 02:12:39', NULL),
(42, 6, 3, 1, 65, 'in_stock', '2026-01-31 02:12:39', NULL),
(43, 6, 1, 4, 45, 'in_stock', '2026-01-31 02:12:39', '2026-02-01 17:02:59'),
(44, 6, 2, 4, 70, 'in_stock', '2026-01-31 02:12:39', NULL),
(45, 6, 3, 4, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(46, 7, 1, 7, 40, 'in_stock', '2026-01-31 02:12:39', NULL),
(47, 7, 2, 7, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(48, 7, 3, 7, 50, 'in_stock', '2026-01-31 02:12:39', NULL),
(49, 8, 1, 3, 20, 'in_stock', '2026-01-31 02:12:39', NULL),
(50, 8, 2, 3, 30, 'in_stock', '2026-01-31 02:12:39', NULL),
(51, 8, 3, 3, 25, 'in_stock', '2026-01-31 02:12:39', NULL),
(52, 8, 1, 1, 18, 'in_stock', '2026-01-31 02:12:39', NULL),
(53, 8, 2, 1, 28, 'in_stock', '2026-01-31 02:12:39', NULL),
(54, 8, 3, 1, 23, 'in_stock', '2026-01-31 02:12:39', NULL),
(55, 9, 2, 1, 100, 'in_stock', '2026-01-31 02:12:39', NULL),
(56, 9, 2, 9, 80, 'in_stock', '2026-01-31 02:12:39', NULL),
(57, 9, 2, 3, 60, 'in_stock', '2026-01-31 02:12:39', NULL),
(58, 10, 2, 1, 150, 'in_stock', '2026-01-31 02:12:39', NULL),
(59, 10, 2, 2, 120, 'in_stock', '2026-01-31 02:12:39', NULL),
(60, 10, 2, 3, 100, 'in_stock', '2026-01-31 02:12:39', NULL),
(61, 6, 1, 2, 50, 'in_stock', '2026-01-31 16:01:01', NULL),
(62, 6, 2, 2, 75, 'in_stock', '2026-01-31 16:01:01', NULL),
(63, 6, 3, 2, 65, 'in_stock', '2026-01-31 16:01:01', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `reviews`
--

CREATE TABLE `reviews` (
  `review_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `order_id` int(11) UNSIGNED NOT NULL COMMENT 'Đơn hàng đã mua',
  `rating` tinyint(1) NOT NULL CHECK (`rating` between 1 and 5),
  `comment` text DEFAULT NULL,
  `images` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL COMMENT 'Danh sách URL ảnh review' CHECK (json_valid(`images`)),
  `status` enum('pending','approved','rejected') NOT NULL DEFAULT 'pending',
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `updated_at` datetime DEFAULT NULL ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng đánh giá sản phẩm';

--
-- Đang đổ dữ liệu cho bảng `reviews`
--

INSERT INTO `reviews` (`review_id`, `product_id`, `user_id`, `order_id`, `rating`, `comment`, `images`, `status`, `created_at`, `updated_at`) VALUES
(1, 2, 3, 2, 5, 'Áo rất đẹp, chất vải mềm mại. Shop giao hàng nhanh. Sẽ ủng hộ tiếp!', NULL, 'approved', '2026-01-26 02:12:39', NULL),
(2, 8, 3, 2, 4, 'Váy đẹp lắm, mặc vừa vặn. Chỉ có điều màu hơi đậm hơn ảnh một chút.', NULL, 'approved', '2026-01-26 02:12:39', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sessions`
--

CREATE TABLE `sessions` (
  `session_id` varchar(128) NOT NULL,
  `user_id` int(11) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `session_data` text DEFAULT NULL,
  `last_activity` int(11) UNSIGNED NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng quản lý session';

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `sizes`
--

CREATE TABLE `sizes` (
  `size_id` int(11) UNSIGNED NOT NULL,
  `size_name` varchar(10) NOT NULL,
  `display_order` int(11) NOT NULL DEFAULT 0 COMMENT 'Thứ tự hiển thị'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng size sản phẩm';

--
-- Đang đổ dữ liệu cho bảng `sizes`
--

INSERT INTO `sizes` (`size_id`, `size_name`, `display_order`) VALUES
(1, 'S', 1),
(2, 'M', 2),
(3, 'L', 3),
(4, 'XL', 4),
(5, 'XXL', 5);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `users`
--

CREATE TABLE `users` (
  `user_id` int(11) UNSIGNED NOT NULL,
  `username` varchar(50) NOT NULL,
  `password` text NOT NULL COMMENT 'Plain text - không mã hóa theo yêu cầu',
  `fullname` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `phone` varchar(15) DEFAULT NULL,
  `address` text DEFAULT NULL,
  `role` enum('admin','customer') NOT NULL DEFAULT 'customer',
  `status` enum('active','blocked') NOT NULL DEFAULT 'active',
  `last_login` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp(),
  `deleted_at` datetime DEFAULT NULL COMMENT 'Soft delete'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng tài khoản người dùng';

--
-- Đang đổ dữ liệu cho bảng `users`
--

INSERT INTO `users` (`user_id`, `username`, `password`, `fullname`, `email`, `phone`, `address`, `role`, `status`, `last_login`, `created_at`, `deleted_at`) VALUES
(1, 'admin', '123456', 'Administrator', 'admin@fashionshop.com', '0901234567', 'Hà Nội, Việt Nam', 'admin', 'active', '2026-02-01 14:53:43', '2026-01-31 02:12:39', NULL),
(2, 'nguyenvana', '123456', 'Nguyễn Văn A', 'nguyenvana@gmail.com', '0912345678', '123 Nguyễn Trãi, Hà Nội', 'customer', 'active', NULL, '2026-01-31 02:12:39', NULL),
(3, 'tranthib', '123456', 'Trần Thị B', 'tranthib@gmail.com', '0923456789', '456 Lê Lợi, Hồ Chí Minh', 'customer', 'active', NULL, '2026-01-31 02:12:39', NULL),
(4, 'phamvanc', '123456', 'Phạm Văn C', 'phamvanc@gmail.com', '0934567890', '789 Trần Hưng Đạo, Đà Nẵng', 'customer', 'active', NULL, '2026-01-31 02:12:39', NULL),
(5, 'khach1', 'lol123', 'Trịnh Hoàng Thành', 'th6322750@gmail.com', '0355636882', '', 'customer', 'active', NULL, '2026-01-31 15:17:33', NULL);

-- --------------------------------------------------------

--
-- Cấu trúc bảng cho bảng `wishlists`
--

CREATE TABLE `wishlists` (
  `wishlist_id` int(11) UNSIGNED NOT NULL,
  `user_id` int(11) UNSIGNED NOT NULL,
  `product_id` int(11) UNSIGNED NOT NULL,
  `added_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci COMMENT='Bảng sản phẩm yêu thích';

--
-- Đang đổ dữ liệu cho bảng `wishlists`
--

INSERT INTO `wishlists` (`wishlist_id`, `user_id`, `product_id`, `added_at`) VALUES
(1, 2, 5, '2026-01-31 02:12:39'),
(2, 2, 7, '2026-01-31 02:12:39'),
(3, 3, 1, '2026-01-31 02:12:39'),
(4, 3, 9, '2026-01-31 02:12:39'),
(5, 4, 3, '2026-01-31 02:12:39');

--
-- Chỉ mục cho các bảng đã đổ
--

--
-- Chỉ mục cho bảng `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD PRIMARY KEY (`log_id`),
  ADD KEY `idx_admin` (`admin_id`),
  ADD KEY `idx_action` (`action`),
  ADD KEY `idx_table_name` (`table_name`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Chỉ mục cho bảng `cart`
--
ALTER TABLE `cart`
  ADD PRIMARY KEY (`cart_id`),
  ADD UNIQUE KEY `unique_cart_item` (`user_id`,`variant_id`) COMMENT 'Chống trùng sản phẩm trong giỏ',
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_variant` (`variant_id`),
  ADD KEY `idx_expires` (`expires_at`);

--
-- Chỉ mục cho bảng `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`category_id`),
  ADD UNIQUE KEY `unique_category_name` (`category_name`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- Chỉ mục cho bảng `colors`
--
ALTER TABLE `colors`
  ADD PRIMARY KEY (`color_id`),
  ADD UNIQUE KEY `unique_color_name` (`color_name`);

--
-- Chỉ mục cho bảng `coupons`
--
ALTER TABLE `coupons`
  ADD PRIMARY KEY (`coupon_id`),
  ADD UNIQUE KEY `unique_coupon_code` (`coupon_code`),
  ADD KEY `idx_coupon_code` (`coupon_code`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_expiry` (`expiry_date`);

--
-- Chỉ mục cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD PRIMARY KEY (`usage_id`),
  ADD KEY `idx_coupon` (`coupon_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_order` (`order_id`);

--
-- Chỉ mục cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`notification_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_is_read` (`is_read`),
  ADD KEY `idx_created_at` (`created_at`);

--
-- Chỉ mục cho bảng `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`order_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_coupon` (`coupon_id`),
  ADD KEY `idx_order_status` (`order_status`),
  ADD KEY `idx_payment_status` (`payment_status`),
  ADD KEY `idx_order_date` (`order_date`);

--
-- Chỉ mục cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD PRIMARY KEY (`detail_id`),
  ADD KEY `idx_order` (`order_id`),
  ADD KEY `idx_variant` (`variant_id`);

--
-- Chỉ mục cho bảng `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`),
  ADD KEY `idx_variant_id` (`variant_id`);

--
-- Chỉ mục cho bảng `order_returns`
--
ALTER TABLE `order_returns`
  ADD PRIMARY KEY (`return_id`),
  ADD KEY `idx_order` (`order_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `order_status_history`
--
ALTER TABLE `order_status_history`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_order_id` (`order_id`);

--
-- Chỉ mục cho bảng `products`
--
ALTER TABLE `products`
  ADD PRIMARY KEY (`product_id`),
  ADD UNIQUE KEY `unique_slug` (`slug`),
  ADD KEY `idx_category` (`category_id`),
  ADD KEY `idx_slug` (`slug`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_view_count` (`view_count`),
  ADD KEY `idx_sold_count` (`sold_count`),
  ADD KEY `idx_deleted_at` (`deleted_at`);
ALTER TABLE `products` ADD FULLTEXT KEY `ft_product_name` (`product_name`,`description`);

--
-- Chỉ mục cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD PRIMARY KEY (`image_id`),
  ADD KEY `idx_product` (`product_id`),
  ADD KEY `idx_is_primary` (`is_primary`),
  ADD KEY `idx_display_order` (`display_order`);

--
-- Chỉ mục cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD PRIMARY KEY (`variant_id`),
  ADD UNIQUE KEY `unique_variant` (`product_id`,`size_id`,`color_id`) COMMENT 'Chống trùng biến thể',
  ADD KEY `idx_product` (`product_id`),
  ADD KEY `idx_stock` (`stock_quantity`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_size` (`size_id`),
  ADD KEY `idx_color` (`color_id`);

--
-- Chỉ mục cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`review_id`),
  ADD KEY `idx_product` (`product_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_order` (`order_id`),
  ADD KEY `idx_rating` (`rating`),
  ADD KEY `idx_status` (`status`);

--
-- Chỉ mục cho bảng `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`session_id`),
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_last_activity` (`last_activity`);

--
-- Chỉ mục cho bảng `sizes`
--
ALTER TABLE `sizes`
  ADD PRIMARY KEY (`size_id`),
  ADD UNIQUE KEY `unique_size_name` (`size_name`);

--
-- Chỉ mục cho bảng `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`user_id`),
  ADD UNIQUE KEY `unique_username` (`username`),
  ADD UNIQUE KEY `unique_email` (`email`),
  ADD KEY `idx_email` (`email`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_deleted_at` (`deleted_at`);

--
-- Chỉ mục cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD PRIMARY KEY (`wishlist_id`),
  ADD UNIQUE KEY `unique_wishlist` (`user_id`,`product_id`) COMMENT 'Chống trùng sản phẩm yêu thích',
  ADD KEY `idx_user` (`user_id`),
  ADD KEY `idx_product` (`product_id`);

--
-- AUTO_INCREMENT cho các bảng đã đổ
--

--
-- AUTO_INCREMENT cho bảng `admin_logs`
--
ALTER TABLE `admin_logs`
  MODIFY `log_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT cho bảng `cart`
--
ALTER TABLE `cart`
  MODIFY `cart_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=77;

--
-- AUTO_INCREMENT cho bảng `categories`
--
ALTER TABLE `categories`
  MODIFY `category_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `colors`
--
ALTER TABLE `colors`
  MODIFY `color_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `coupons`
--
ALTER TABLE `coupons`
  MODIFY `coupon_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  MODIFY `usage_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `notifications`
--
ALTER TABLE `notifications`
  MODIFY `notification_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=28;

--
-- AUTO_INCREMENT cho bảng `orders`
--
ALTER TABLE `orders`
  MODIFY `order_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT cho bảng `order_details`
--
ALTER TABLE `order_details`
  MODIFY `detail_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=24;

--
-- AUTO_INCREMENT cho bảng `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `order_returns`
--
ALTER TABLE `order_returns`
  MODIFY `return_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT cho bảng `order_status_history`
--
ALTER TABLE `order_status_history`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT cho bảng `products`
--
ALTER TABLE `products`
  MODIFY `product_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT cho bảng `product_images`
--
ALTER TABLE `product_images`
  MODIFY `image_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  MODIFY `variant_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=64;

--
-- AUTO_INCREMENT cho bảng `reviews`
--
ALTER TABLE `reviews`
  MODIFY `review_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT cho bảng `sizes`
--
ALTER TABLE `sizes`
  MODIFY `size_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `users`
--
ALTER TABLE `users`
  MODIFY `user_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  MODIFY `wishlist_id` int(11) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Các ràng buộc cho các bảng đã đổ
--

--
-- Các ràng buộc cho bảng `admin_logs`
--
ALTER TABLE `admin_logs`
  ADD CONSTRAINT `fk_admin_logs_admin` FOREIGN KEY (`admin_id`) REFERENCES `users` (`user_id`);

--
-- Các ràng buộc cho bảng `cart`
--
ALTER TABLE `cart`
  ADD CONSTRAINT `fk_cart_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_cart_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`);

--
-- Các ràng buộc cho bảng `coupon_usage`
--
ALTER TABLE `coupon_usage`
  ADD CONSTRAINT `fk_coupon_usage_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`coupon_id`),
  ADD CONSTRAINT `fk_coupon_usage_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `fk_coupon_usage_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Các ràng buộc cho bảng `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `fk_notifications_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `fk_orders_coupon` FOREIGN KEY (`coupon_id`) REFERENCES `coupons` (`coupon_id`),
  ADD CONSTRAINT `fk_orders_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Các ràng buộc cho bảng `order_details`
--
ALTER TABLE `order_details`
  ADD CONSTRAINT `fk_order_details_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_order_details_variant` FOREIGN KEY (`variant_id`) REFERENCES `product_variants` (`variant_id`);

--
-- Các ràng buộc cho bảng `order_returns`
--
ALTER TABLE `order_returns`
  ADD CONSTRAINT `fk_returns_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `fk_returns_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Các ràng buộc cho bảng `products`
--
ALTER TABLE `products`
  ADD CONSTRAINT `fk_products_category` FOREIGN KEY (`category_id`) REFERENCES `categories` (`category_id`);

--
-- Các ràng buộc cho bảng `product_images`
--
ALTER TABLE `product_images`
  ADD CONSTRAINT `fk_product_images_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE;

--
-- Các ràng buộc cho bảng `product_variants`
--
ALTER TABLE `product_variants`
  ADD CONSTRAINT `fk_variants_color` FOREIGN KEY (`color_id`) REFERENCES `colors` (`color_id`),
  ADD CONSTRAINT `fk_variants_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_variants_size` FOREIGN KEY (`size_id`) REFERENCES `sizes` (`size_id`);

--
-- Các ràng buộc cho bảng `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `fk_reviews_order` FOREIGN KEY (`order_id`) REFERENCES `orders` (`order_id`),
  ADD CONSTRAINT `fk_reviews_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`),
  ADD CONSTRAINT `fk_reviews_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`);

--
-- Các ràng buộc cho bảng `wishlists`
--
ALTER TABLE `wishlists`
  ADD CONSTRAINT `fk_wishlist_product` FOREIGN KEY (`product_id`) REFERENCES `products` (`product_id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`user_id`) REFERENCES `users` (`user_id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
