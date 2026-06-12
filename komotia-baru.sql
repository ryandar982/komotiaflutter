-- ================================================================
-- DATABASE: komotia
-- Deskripsi: E-commerce pertanian (pupuk, bibit, dll)
-- Alur: User → Cart → Checkout → Transaction → Payment → Review
-- Target: TiDB Serverless (MySQL 8.0 compatible)
-- ================================================================

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- ================================================================
-- 1. TABEL USERS
-- Menyimpan data pengguna (admin, penjual, pembeli)
-- ================================================================
DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `id_user` int NOT NULL AUTO_INCREMENT,
  `nama` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL COMMENT 'WAJIB di-hash di sisi backend (bcrypt/argon2)',
  `no_telp` varchar(20) DEFAULT NULL,
  `alamat` text DEFAULT NULL,
  `foto_profil` varchar(255) DEFAULT NULL COMMENT 'URL/path foto profil untuk dashboard',
  `role` enum('admin','penjual','pembeli') DEFAULT 'pembeli',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_user`),
  UNIQUE KEY `uq_email` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data users
INSERT INTO `users` (`id_user`, `nama`, `email`, `password`, `no_telp`, `alamat`, `foto_profil`, `role`, `created_at`) VALUES
  (1, 'Admin', 'admin@gmail.com', '$2b$10$placeholder_hash_admin', '08123456789', 'Jakarta', NULL, 'admin', '2026-03-05 18:17:25'),
  (2, 'Surti', 'surti@gmail.com', '$2b$10$placeholder_hash_surti', '081333505650', 'Munchen', NULL, 'penjual', '2026-03-06 20:02:03'),
  (3, 'Kurnia Mega', 'kurniamega@gmail.com', '$2b$10$placeholder_hash_kurnia', '081333506505', 'Gresik', NULL, 'pembeli', '2026-03-18 19:23:21'),
  (4, 'Ryandar', 'ryandaraf@gmail.com', '$2b$10$placeholder_hash_ryan', '081333506505', 'Surabaya', NULL, 'pembeli', '2026-04-25 13:21:27'),
  (5, 'Kelompok 3', 'kelompok3@gmail.com', '$2b$10$placeholder_hash_k3', '081333506505', 'Munchen', NULL, 'pembeli', '2026-04-25 15:02:00'),
  (6, 'Reyhan', 'reyhan@gmail.com', '$2b$10$placeholder_hash_reyhan', '081234567890', 'Jl Jojoran Unair', NULL, 'pembeli', '2026-04-28 08:04:41'),
  (7, 'Bang Doel', 'bangdoel@gmail.com', '$2b$10$placeholder_hash_doel', '081234234234', 'Surabaya', NULL, 'pembeli', '2026-05-22 06:41:39');


-- ================================================================
-- 2. TABEL CATEGORIES
-- Kategori produk (unik, tidak boleh duplikat)
-- ================================================================
DROP TABLE IF EXISTS `categories`;
CREATE TABLE IF NOT EXISTS `categories` (
  `id_category` int NOT NULL AUTO_INCREMENT,
  `nama_category` varchar(100) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_category`),
  UNIQUE KEY `uq_nama_category` (`nama_category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data categories (duplikat 'SAHMASHEH' sudah dibersihkan)
INSERT INTO `categories` (`id_category`, `nama_category`, `deskripsi`) VALUES
  (1, 'Pupuk', 'Berbagai jenis pupuk untuk pertanian'),
  (2, 'Pupuk Organik', 'Pupuk berbahan organik alami'),
  (3, 'Bibit', 'Bibit tanaman dan benih'),
  (4, 'Elektronik', 'Produk-produk elektronik seperti HP, laptop, dll'),
  (5, 'Alat Pertanian', 'Peralatan dan perlengkapan pertanian');


-- ================================================================
-- 3. TABEL PRODUCTS
-- Produk yang dijual oleh penjual
-- PERBAIKAN: Hapus kolom redundan `price` (int) dan `category` (varchar)
--            Gunakan `harga` (decimal) dan relasi FK `id_category`
-- ================================================================
DROP TABLE IF EXISTS `products`;
CREATE TABLE IF NOT EXISTS `products` (
  `id_product` int NOT NULL AUTO_INCREMENT,
  `nama_product` varchar(150) NOT NULL,
  `deskripsi` text DEFAULT NULL,
  `harga` decimal(15,2) NOT NULL COMMENT 'Harga satuan dalam Rupiah',
  `stok` int DEFAULT 0,
  `satuan` varchar(50) DEFAULT NULL COMMENT 'Kg, Liter, Karung, Pcs, dll',
  `gambar` varchar(255) DEFAULT NULL,
  `id_user` int NOT NULL COMMENT 'FK ke penjual yang menjual produk ini',
  `id_category` int NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_product`),
  CONSTRAINT `chk_harga_positif` CHECK (`harga` >= 0),
  CONSTRAINT `chk_stok_positif` CHECK (`stok` >= 0),
  KEY `idx_product_user` (`id_user`),
  KEY `idx_product_category` (`id_category`),
  CONSTRAINT `fk_product_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_product_category` FOREIGN KEY (`id_category`) REFERENCES `categories` (`id_category`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data products (kolom `price` dan `category` varchar dihapus)
INSERT INTO `products` (`id_product`, `nama_product`, `deskripsi`, `harga`, `stok`, `satuan`, `gambar`, `id_user`, `id_category`, `created_at`) VALUES
  (1, 'Pupuk Organik Mulyorejo', 'Pupuk organik ramah lingkungan', 25000.00, 2513, 'Kg', 'default.jpg', 2, 2, '2026-04-25 08:42:21'),
  (2, 'Bibit Jagung Kering 1 Karung', 'Bibit jagung kualitas unggul', 213323.00, 213, 'Karung', 'default.jpg', 2, 3, '2026-04-25 08:43:02'),
  (3, 'Pupuk Komotia', 'Pupuk khusus produksi Komotia', 21000.00, 500, 'Liter', 'default.jpg', 2, 1, '2026-05-22 08:31:30');


-- ================================================================
-- 4. TABEL CARTS
-- Keranjang belanja user (1 user = 1 cart aktif)
-- ================================================================
DROP TABLE IF EXISTS `carts`;
CREATE TABLE IF NOT EXISTS `carts` (
  `id_cart` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `status` enum('aktif','checkout') DEFAULT 'aktif' COMMENT 'aktif = masih bisa diisi, checkout = sudah jadi transaksi',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cart`),
  KEY `idx_cart_user` (`id_user`),
  CONSTRAINT `fk_cart_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data carts
INSERT INTO `carts` (`id_cart`, `id_user`, `status`, `created_at`) VALUES
  (1, 3, 'checkout', '2026-03-10 14:54:50'),
  (2, 3, 'aktif', '2026-04-01 10:00:00'),
  (3, 4, 'aktif', '2026-04-25 14:00:00');


-- ================================================================
-- 5. TABEL CART_DETAILS
-- Item-item dalam keranjang belanja
-- ================================================================
DROP TABLE IF EXISTS `cart_details`;
CREATE TABLE IF NOT EXISTS `cart_details` (
  `id_cart_detail` int NOT NULL AUTO_INCREMENT,
  `id_cart` int NOT NULL,
  `id_product` int NOT NULL,
  `jumlah` int NOT NULL DEFAULT 1,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_cart_detail`),
  CONSTRAINT `chk_jumlah_cart_positif` CHECK (`jumlah` > 0),
  UNIQUE KEY `uq_cart_product` (`id_cart`, `id_product`) COMMENT 'Satu produk hanya 1 entry per cart, jumlah di-update',
  KEY `idx_cartdetail_product` (`id_product`),
  CONSTRAINT `fk_cartdetail_cart` FOREIGN KEY (`id_cart`) REFERENCES `carts` (`id_cart`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_cartdetail_product` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data cart_details
INSERT INTO `cart_details` (`id_cart_detail`, `id_cart`, `id_product`, `jumlah`) VALUES
  (1, 2, 1, 5),
  (2, 2, 3, 2),
  (3, 3, 2, 1);


-- ================================================================
-- 6. TABEL TRANSACTIONS
-- Transaksi pembelian (dibuat saat checkout dari cart)
-- PERBAIKAN: Tambah `id_cart` untuk tracking asal, enum `dikemas`
-- ================================================================
DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `id_transaction` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL COMMENT 'Pembeli',
  `id_cart` int DEFAULT NULL COMMENT 'Cart asal transaksi (opsional, untuk tracking)',
  `tanggal_transaksi` datetime DEFAULT CURRENT_TIMESTAMP,
  `total_harga` decimal(15,2) NOT NULL,
  `status` enum('pending','dibayar','dikemas','dikirim','selesai','dibatalkan') DEFAULT 'pending',
  `alamat_pengiriman` text DEFAULT NULL,
  `metode_pembayaran` varchar(50) DEFAULT NULL COMMENT 'transfer_bank, gopay, ovo, dana, cod',
  `catatan` text DEFAULT NULL COMMENT 'Catatan dari pembeli',
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_transaction`),
  KEY `idx_transaction_user` (`id_user`),
  KEY `idx_transaction_status` (`status`),
  KEY `idx_transaction_tanggal` (`tanggal_transaksi`),
  CONSTRAINT `fk_transaction_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_transaction_cart` FOREIGN KEY (`id_cart`) REFERENCES `carts` (`id_cart`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data transactions
INSERT INTO `transactions` (`id_transaction`, `id_user`, `id_cart`, `tanggal_transaksi`, `total_harga`, `status`, `alamat_pengiriman`, `metode_pembayaran`, `catatan`) VALUES
  (1, 3, 1, '2026-03-10 20:33:42', 150000.00, 'selesai', 'Jl. Merdeka No. 10, Gresik', 'transfer_bank', NULL),
  (2, 3, NULL, '2026-03-10 20:34:03', 130000.00, 'selesai', 'Jl. Merdeka No. 10, Gresik', 'gopay', 'Tolong packing rapi ya'),
  (3, 4, NULL, '2026-04-26 10:54:03', 213323.00, 'pending', 'Jl. Airlangga No. 5, Surabaya', 'transfer_bank', NULL);


-- ================================================================
-- 7. TABEL TRANSACTION_DETAILS
-- Detail item per transaksi (snapshot harga saat beli)
-- ================================================================
DROP TABLE IF EXISTS `transaction_details`;
CREATE TABLE IF NOT EXISTS `transaction_details` (
  `id_detail` int NOT NULL AUTO_INCREMENT,
  `id_transaction` int NOT NULL,
  `id_product` int NOT NULL,
  `jumlah` int NOT NULL,
  `harga_satuan` decimal(15,2) NOT NULL COMMENT 'Snapshot harga saat transaksi dibuat',
  `subtotal` decimal(15,2) NOT NULL COMMENT 'jumlah × harga_satuan',
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_detail`),
  CONSTRAINT `chk_jumlah_td_positif` CHECK (`jumlah` > 0),
  CONSTRAINT `chk_harga_satuan_positif` CHECK (`harga_satuan` >= 0),
  CONSTRAINT `chk_subtotal_positif` CHECK (`subtotal` >= 0),
  UNIQUE KEY `uq_transaction_product` (`id_transaction`, `id_product`),
  KEY `idx_detail_product` (`id_product`),
  CONSTRAINT `fk_detail_transaction` FOREIGN KEY (`id_transaction`) REFERENCES `transactions` (`id_transaction`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_detail_product` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data transaction_details
INSERT INTO `transaction_details` (`id_detail`, `id_transaction`, `id_product`, `jumlah`, `harga_satuan`, `subtotal`) VALUES
  (1, 1, 1, 6, 25000.00, 150000.00),
  (2, 2, 3, 5, 21000.00, 105000.00),
  (3, 2, 1, 1, 25000.00, 25000.00),
  (4, 3, 2, 1, 213323.00, 213323.00);


-- ================================================================
-- 8. TABEL PAYMENTS
-- Pembayaran & verifikasi oleh admin
-- ================================================================
DROP TABLE IF EXISTS `payments`;
CREATE TABLE IF NOT EXISTS `payments` (
  `id_payment` int NOT NULL AUTO_INCREMENT,
  `id_transaction` int NOT NULL,
  `tanggal_bayar` datetime DEFAULT CURRENT_TIMESTAMP,
  `jumlah_bayar` decimal(15,2) NOT NULL,
  `bukti_transfer` varchar(255) DEFAULT NULL COMMENT 'URL/path file bukti transfer',
  `status_verifikasi` enum('menunggu','diterima','ditolak') DEFAULT 'menunggu',
  `catatan_admin` text DEFAULT NULL COMMENT 'Catatan dari admin saat verifikasi',
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_payment`),
  UNIQUE KEY `uq_payment_transaction` (`id_transaction`) COMMENT '1 transaksi = 1 pembayaran',
  KEY `idx_payment_status` (`status_verifikasi`),
  CONSTRAINT `fk_payment_transaction` FOREIGN KEY (`id_transaction`) REFERENCES `transactions` (`id_transaction`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data payments
INSERT INTO `payments` (`id_payment`, `id_transaction`, `tanggal_bayar`, `jumlah_bayar`, `bukti_transfer`, `status_verifikasi`, `catatan_admin`) VALUES
  (1, 1, '2026-03-10 21:00:00', 150000.00, 'bukti_tf_001.jpg', 'diterima', 'Pembayaran sudah dikonfirmasi'),
  (2, 2, '2026-03-10 21:30:00', 130000.00, 'bukti_tf_002.jpg', 'diterima', NULL),
  (3, 3, '2026-04-26 11:00:00', 213323.00, 'bukti_tf_003.jpg', 'menunggu', NULL);


-- ================================================================
-- 9. TABEL REVIEWS
-- Ulasan produk oleh pembeli (hanya setelah transaksi selesai)
-- ================================================================
DROP TABLE IF EXISTS `reviews`;
CREATE TABLE IF NOT EXISTS `reviews` (
  `id_review` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `id_product` int NOT NULL,
  `id_transaction` int DEFAULT NULL COMMENT 'Transaksi terkait (memastikan user benar-benar membeli)',
  `rating` int NOT NULL COMMENT 'Skala 1-5 bintang',
  `komentar` text DEFAULT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_review`),
  CONSTRAINT `chk_rating_range` CHECK (`rating` BETWEEN 1 AND 5),
  UNIQUE KEY `uq_user_product_review` (`id_user`, `id_product`) COMMENT 'Satu user hanya bisa review 1x per produk',
  KEY `idx_review_product` (`id_product`),
  CONSTRAINT `fk_review_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_product` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_review_transaction` FOREIGN KEY (`id_transaction`) REFERENCES `transactions` (`id_transaction`) ON DELETE SET NULL ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data reviews (user 3 sudah beli dan transaksi selesai)
INSERT INTO `reviews` (`id_review`, `id_user`, `id_product`, `id_transaction`, `rating`, `komentar`) VALUES
  (1, 3, 1, 1, 5, 'Pupuk organik berkualitas, tanaman jadi subur!'),
  (2, 3, 3, 2, 4, 'Pupuk bagus, pengiriman cepat');


-- ================================================================
-- 10. TABEL WISHLISTS (BARU)
-- Daftar produk favorit user untuk dashboard
-- ================================================================
DROP TABLE IF EXISTS `wishlists`;
CREATE TABLE IF NOT EXISTS `wishlists` (
  `id_wishlist` int NOT NULL AUTO_INCREMENT,
  `id_user` int NOT NULL,
  `id_product` int NOT NULL,
  `created_at` timestamp DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id_wishlist`),
  UNIQUE KEY `uq_user_product_wishlist` (`id_user`, `id_product`) COMMENT 'Tidak bisa wishlist produk yang sama 2x',
  KEY `idx_wishlist_product` (`id_product`),
  CONSTRAINT `fk_wishlist_user` FOREIGN KEY (`id_user`) REFERENCES `users` (`id_user`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `fk_wishlist_product` FOREIGN KEY (`id_product`) REFERENCES `products` (`id_product`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Sample data wishlists
INSERT INTO `wishlists` (`id_wishlist`, `id_user`, `id_product`) VALUES
  (1, 4, 1),
  (2, 4, 3),
  (3, 5, 2);


-- ================================================================
-- 11. VIEWS UNTUK DASHBOARD USER
-- ================================================================

-- View: Ringkasan dashboard user (total transaksi, total belanja, status)
DROP VIEW IF EXISTS `v_user_dashboard`;
CREATE VIEW `v_user_dashboard` AS
SELECT 
  u.id_user,
  u.nama,
  u.email,
  u.foto_profil,
  u.no_telp,
  u.alamat,
  u.role,
  COUNT(DISTINCT t.id_transaction) AS total_transaksi,
  COALESCE(SUM(CASE WHEN t.status = 'selesai' THEN t.total_harga ELSE 0 END), 0) AS total_belanja,
  COUNT(DISTINCT CASE WHEN t.status = 'pending' THEN t.id_transaction END) AS transaksi_pending,
  COUNT(DISTINCT CASE WHEN t.status = 'dibayar' THEN t.id_transaction END) AS transaksi_dibayar,
  COUNT(DISTINCT CASE WHEN t.status = 'dikemas' THEN t.id_transaction END) AS transaksi_dikemas,
  COUNT(DISTINCT CASE WHEN t.status = 'dikirim' THEN t.id_transaction END) AS transaksi_dikirim,
  COUNT(DISTINCT CASE WHEN t.status = 'selesai' THEN t.id_transaction END) AS transaksi_selesai,
  COUNT(DISTINCT CASE WHEN t.status = 'dibatalkan' THEN t.id_transaction END) AS transaksi_dibatalkan,
  (SELECT COUNT(*) FROM wishlists w WHERE w.id_user = u.id_user) AS total_wishlist
FROM users u
LEFT JOIN transactions t ON u.id_user = t.id_user
GROUP BY u.id_user, u.nama, u.email, u.foto_profil, u.no_telp, u.alamat, u.role;


-- View: Detail transaksi lengkap (join semua tabel terkait)
DROP VIEW IF EXISTS `v_transaction_detail`;
CREATE VIEW `v_transaction_detail` AS
SELECT 
  t.id_transaction,
  t.tanggal_transaksi,
  t.total_harga,
  t.status AS status_transaksi,
  t.alamat_pengiriman,
  t.metode_pembayaran,
  t.catatan,
  u.id_user,
  u.nama AS nama_pembeli,
  u.email AS email_pembeli,
  td.id_detail,
  td.id_product,
  p.nama_product,
  p.gambar AS gambar_product,
  td.jumlah,
  td.harga_satuan,
  td.subtotal,
  c.id_category,
  c.nama_category,
  py.id_payment,
  py.tanggal_bayar,
  py.jumlah_bayar,
  py.bukti_transfer,
  py.status_verifikasi AS status_pembayaran,
  py.catatan_admin
FROM transactions t
JOIN users u ON t.id_user = u.id_user
JOIN transaction_details td ON t.id_transaction = td.id_transaction
JOIN products p ON td.id_product = p.id_product
JOIN categories c ON p.id_category = c.id_category
LEFT JOIN payments py ON t.id_transaction = py.id_transaction;


-- View: Ringkasan produk dengan rata-rata rating
DROP VIEW IF EXISTS `v_product_summary`;
CREATE VIEW `v_product_summary` AS
SELECT 
  p.id_product,
  p.nama_product,
  p.deskripsi,
  p.harga,
  p.stok,
  p.satuan,
  p.gambar,
  c.nama_category,
  u.nama AS nama_penjual,
  COALESCE(AVG(r.rating), 0) AS rata_rata_rating,
  COUNT(r.id_review) AS jumlah_review,
  COALESCE(SUM(td.jumlah), 0) AS total_terjual
FROM products p
JOIN categories c ON p.id_category = c.id_category
JOIN users u ON p.id_user = u.id_user
LEFT JOIN reviews r ON p.id_product = r.id_product
LEFT JOIN transaction_details td ON p.id_product = td.id_product
LEFT JOIN transactions t ON td.id_transaction = t.id_transaction AND t.status = 'selesai'
GROUP BY p.id_product, p.nama_product, p.deskripsi, p.harga, p.stok, 
         p.satuan, p.gambar, c.nama_category, u.nama;


-- ================================================================
-- RESTORE SESSION VARIABLES
-- ================================================================
/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
