-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3307
-- Generation Time: May 15, 2025 at 05:28 PM
-- Server version: 10.4.27-MariaDB
-- PHP Version: 8.2.0

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `delcafeorigin`
--

-- --------------------------------------------------------

--
-- Table structure for table `admin`
--

CREATE TABLE `admin` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `email` varchar(255) NOT NULL,
  `foto` varchar(255) DEFAULT NULL,
  `password` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `admin`
--

INSERT INTO `admin` (`id`, `nama`, `email`, `foto`, `password`, `created_at`, `updated_at`) VALUES
(1, 'Admin DelBites', 'admin@delbites.com', NULL, '$2y$12$PO.7b.5yGzFu1z/g4j7mHe/z9D9Hqqil653AdwrSwB3BaE53rB5MK', '2025-05-15 07:45:18', '2025-05-15 07:45:18'),
(2, 'Manager DelBites', ' ', NULL, '$2y$12$N30CZBhynDHV5/5sNkt2rO0bYhPK61kciOmaFuXq7e0lIlop8HJc6', '2025-05-15 07:45:19', '2025-05-15 07:45:19');

-- --------------------------------------------------------

--
-- Table structure for table `cache`
--

CREATE TABLE `cache` (
  `key` varchar(255) NOT NULL,
  `value` mediumtext NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `cache_locks`
--

CREATE TABLE `cache_locks` (
  `key` varchar(255) NOT NULL,
  `owner` varchar(255) NOT NULL,
  `expiration` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `detail_pemesanan`
--

CREATE TABLE `detail_pemesanan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_pemesanan` bigint(20) UNSIGNED NOT NULL,
  `id_menu` bigint(20) UNSIGNED NOT NULL,
  `jumlah` int(11) NOT NULL,
  `harga_satuan` int(11) NOT NULL,
  `rating` decimal(3,2) DEFAULT NULL,
  `subtotal` int(11) NOT NULL,
  `catatan` varchar(255) DEFAULT NULL,
  `suhu` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `jobs`
--

CREATE TABLE `jobs` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `queue` varchar(255) NOT NULL,
  `payload` longtext NOT NULL,
  `attempts` tinyint(3) UNSIGNED NOT NULL,
  `reserved_at` int(10) UNSIGNED DEFAULT NULL,
  `available_at` int(10) UNSIGNED NOT NULL,
  `created_at` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `keranjang`
--

CREATE TABLE `keranjang` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_pelanggan` bigint(20) UNSIGNED NOT NULL,
  `id_menu` bigint(20) UNSIGNED NOT NULL,
  `nama_menu` varchar(255) NOT NULL,
  `kategori` enum('makanan','minuman') DEFAULT NULL,
  `jumlah` int(11) NOT NULL DEFAULT 1,
  `harga` decimal(10,2) NOT NULL,
  `catatan` varchar(255) DEFAULT NULL,
  `suhu` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `laporan`
--

CREATE TABLE `laporan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `report_date` date NOT NULL,
  `total_income` decimal(12,2) NOT NULL DEFAULT 0.00,
  `total_orders` int(11) NOT NULL DEFAULT 0,
  `status` varchar(255) NOT NULL DEFAULT 'generated',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `menu`
--

CREATE TABLE `menu` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama_menu` varchar(255) NOT NULL,
  `kategori` enum('makanan','minuman') NOT NULL,
  `suhu` enum('panas','dingin') DEFAULT NULL,
  `harga` decimal(10,2) NOT NULL,
  `stok` int(11) NOT NULL DEFAULT 0,
  `gambar` varchar(255) DEFAULT NULL,
  `deskripsi` varchar(255) DEFAULT NULL,
  `rating` decimal(3,2) NOT NULL DEFAULT 0.00,
  `id_admin` bigint(20) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu`
--

INSERT INTO `menu` (`id`, `nama_menu`, `kategori`, `suhu`, `harga`, `stok`, `gambar`, `deskripsi`, `rating`, `id_admin`, `created_at`, `updated_at`) VALUES
(1, 'Bakwan Goreng', 'makanan', NULL, '10000.00', 1, 'menu/1747303140_bakwan.jpeg', 'Bakwan goreng renyah yang terbuat dari sayuran segar dan tepung gurih.', '0.00', 1, '2025-04-30 01:53:47', '2025-04-30 14:37:47'),
(2, 'Tempe Goreng', 'makanan', NULL, '10000.00', 1, 'menu/1747303478_tempe.jpeg', 'Tempe yang digoreng garing dengan balutan tepung berbumbu khas.', '0.00', 1, '2025-04-30 02:05:39', '2025-04-30 14:43:16'),
(3, 'Nugget Goreng', 'makanan', NULL, '15000.00', 1, 'menu/1747303289_gget.jpeg', 'Nugget ayam renyah dengan rasa gurih dan tekstur lembut.', '0.00', 1, '2025-04-30 02:31:47', '2025-04-30 14:40:18'),
(4, 'Gabin Fla', 'makanan', NULL, '10000.00', 1, 'menu/1747303212_gabin.jpeg', 'Gabin fla lezat dengan isian krim manis, cocok untuk camilan ringan.', '0.00', 1, '2025-04-30 02:32:25', '2025-04-30 14:39:09'),
(5, 'Dadar Gulung', 'makanan', NULL, '10000.00', 1, 'menu/1747303190_dadar.jpeg', 'Kue dadar gulung dengan isi kelapa parut manis yang legit dan lembut.', '0.00', 1, '2025-04-30 02:32:57', '2025-04-30 14:38:37'),
(6, 'Kentang Goreng', 'makanan', NULL, '10000.00', 1, 'menu/1747303221_kentang.jpeg', 'Kentang goreng renyah dengan bumbu gurih, favorit untuk teman santai.', '0.00', 1, '2025-04-30 02:34:43', '2025-04-30 14:39:40'),
(7, 'Burger', 'makanan', NULL, '13000.00', 1, 'menu/1747303154_burger.jpeg', 'Burger klasik dengan daging sapi juicy, selada segar, dan saus spesial.', '0.00', 1, '2025-04-30 02:36:00', '2025-04-30 14:38:04'),
(8, 'Pisang Kulit Lumpia', 'makanan', NULL, '10000.00', 1, 'menu/1747303304_pkl.jpeg', 'Pisang dibungkus kulit lumpia renyah dan digoreng hingga keemasan.', '0.00', 1, '2025-04-30 02:38:24', '2025-04-30 14:37:25'),
(9, 'Pisang Nugget', 'makanan', NULL, '10000.00', 1, 'menu/1747303323_Pisang_cokelat.jpeg', 'Pisang nugget manis dengan lapisan tepung renyah, cocok sebagai cemilan.', '0.00', 1, '2025-04-30 02:38:54', '2025-04-30 14:40:03'),
(10, 'Dimsum', 'makanan', NULL, '15000.00', 1, 'menu/1747303201_dimsum.jpeg', 'Dimsum kukus dengan isian ayam dan udang yang lembut dan gurih.', '0.00', 1, '2025-04-30 02:39:53', '2025-04-30 14:38:54'),
(11, 'Salad Buah', 'makanan', NULL, '15000.00', 1, 'menu/1747303381_slad.jpeg', 'Campuran buah segar dengan saus yoghurt manis dan sedikit mint.', '0.00', 1, '2025-04-30 02:40:36', '2025-04-30 14:40:39'),
(12, 'Roti Isi Ayam', 'makanan', NULL, '15000.00', 1, 'menu/1747303390_Roti_isi_ayam.jpeg', 'Roti lembut isi daging ayam berbumbu yang gurih dan nikmat.', '0.00', 2, '2025-04-30 14:41:21', '2025-04-30 14:41:21'),
(13, 'Risol', 'makanan', NULL, '10000.00', 1, 'menu/1747303334_risol.jpeg', 'Risol isi sayur dan daging dengan kulit renyah dan gurih.', '0.00', 2, '2025-04-30 14:41:45', '2025-04-30 14:41:45'),
(14, 'Sosis Goreng', 'makanan', NULL, '15000.00', 1, 'menu/1747303411_sosis.jpeg', 'Sosis ayam digoreng hingga kecoklatan, nikmat untuk cemilan.', '0.00', 2, '2025-04-30 14:42:20', '2025-04-30 14:42:20'),
(15, 'Roti Bakar', 'makanan', NULL, '10000.00', 1, 'menu/1747303346_roti_bakar.jpeg', 'Roti bakar dengan olesan mentega dan selai manis, sarapan sempurna.', '0.00', 2, '2025-04-30 14:44:31', '2025-04-30 14:44:31'),
(16, 'Tahu Goreng', 'makanan', NULL, '10000.00', 1, 'menu/1747303423_tahu.jpeg', 'Tahu putih yang digoreng hingga keemasan, garing di luar lembut di dalam.', '0.00', 2, '2025-04-30 14:48:22', '2025-04-30 14:48:22'),
(17, 'kopi Hitam', 'minuman', 'dingin', '5000.00', 1, 'menu/1747303232_kopi.jpeg', 'Kopi hitam segar disajikan dingin, penuh aroma dan rasa kuat.', '0.00', 2, '2025-04-30 14:54:34', '2025-04-30 14:54:34'),
(18, 'Kopi Susu', 'minuman', 'dingin', '7000.00', 1, 'menu/1747303247_kopsu.jpeg', 'Kopi susu dingin dengan campuran susu segar, pas untuk penyuka kopi manis.', '0.00', 2, '2025-04-30 14:55:09', '2025-04-30 14:55:09'),
(19, 'Lemon Tea', 'minuman', 'dingin', '8000.00', 1, 'menu/1747303263_lemon.jpeg', 'Teh lemon dingin yang menyegarkan dengan rasa asam manis alami.', '0.00', 2, '2025-04-30 14:56:29', '2025-04-30 14:56:29'),
(20, 'Teh Tarik', 'minuman', 'dingin', '8000.00', 1, 'menu/1747303460_tarik.jpeg', 'Teh tarik dingin dengan busa lembut dan rasa manis khas.', '0.00', 2, '2025-04-30 14:58:04', '2025-04-30 14:58:04'),
(21, 'Soda Gembira', 'minuman', 'dingin', '8000.00', 1, 'menu/1747303400_soda.jpeg', 'Minuman soda segar dengan campuran sirup manis dan susu kental manis.', '0.00', 2, '2025-04-30 15:00:10', '2025-04-30 15:00:10'),
(22, 'Cokelat', 'minuman', 'dingin', '8000.00', 1, 'menu/1747303180_cokpasnas.jpg', 'Minuman cokelat dingin yang kaya rasa dan creamy.', '0.00', 2, '2025-04-30 15:01:59', '2025-04-30 15:01:59'),
(23, 'Teh Manis', 'minuman', 'dingin', '7000.00', 1, 'menu/1747303445_mansi.jpeg', 'Teh manis dingin yang menyegarkan dengan rasa gula yang pas.', '0.00', 2, '2025-04-30 15:05:18', '2025-04-30 15:08:42'),
(24, 'Cappucino', 'minuman', 'dingin', '8000.00', 1, 'menu/1747303170_capucino.jpeg', 'Cappuccino dingin dengan busa susu lembut dan aroma kopi yang kuat.', '0.00', 2, '2025-04-30 15:05:56', '2025-04-30 15:05:56');

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(413, '2025_04_08_034311_create_sessions_table', 1),
(414, '2025_04_22_074444_create_admin_table', 1),
(415, '2025_04_22_074500_create_menu_table', 1),
(416, '2025_04_22_074520_create_pelanggan_table', 1),
(417, '2025_04_22_074530_create_pemesanan_table', 1),
(418, '2025_04_22_074540_create_laporan_table', 1),
(419, '2025_04_22_074548_create_stok_bahan_table', 1),
(420, '2025_04_22_084659_create_keranjang_table', 1),
(421, '2025_04_22_155723_create_detail_pemesanan_table', 1),
(422, '2025_04_29_030405_create_pembayaran_table', 1),
(423, '2025_05_05_025858_add_foto_to_admin_table', 1),
(424, '2025_05_05_044205_create_notifications_table', 1),
(425, '2025_05_06_014043_add_is_read_to_notifications_table', 1),
(426, '2025_05_06_225017_remove_stok_terjual_from_menus_table', 1),
(427, '2025_05_12_054512_create_rating_table', 1),
(428, '2025_05_12_140712_create_notifikasi_table', 1),
(429, '2025_05_15_045356_create_cache_table', 1),
(430, '2025_05_15_064935_create_jobs_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `message` varchar(255) NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `notifikasi`
--

CREATE TABLE `notifikasi` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `judul` varchar(255) NOT NULL,
  `pesan` text NOT NULL,
  `is_read` tinyint(1) NOT NULL DEFAULT 0,
  `dibuat_untuk` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pelanggan`
--

CREATE TABLE `pelanggan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `nama` varchar(255) NOT NULL,
  `telepon` varchar(255) DEFAULT NULL,
  `device_id` varchar(255) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `pelanggan`
--

INSERT INTO `pelanggan` (`id`, `nama`, `telepon`, `device_id`, `created_at`, `updated_at`) VALUES
(6, 'nico', '085356104314', 'tp1a.220624.014', '2025-05-15 08:26:24', '2025-05-15 08:26:24');

-- --------------------------------------------------------

--
-- Table structure for table `pembayaran`
--

CREATE TABLE `pembayaran` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_pemesanan` bigint(20) UNSIGNED NOT NULL,
  `order_id` varchar(255) NOT NULL,
  `gross_amount` decimal(10,2) NOT NULL,
  `payment_type` varchar(255) DEFAULT NULL,
  `transaction_id` varchar(255) DEFAULT NULL,
  `transaction_status` varchar(255) NOT NULL,
  `transaction_time` datetime DEFAULT NULL,
  `snap_token` text DEFAULT NULL,
  `pdf_url` varchar(255) DEFAULT NULL,
  `payment_code` varchar(255) DEFAULT NULL,
  `bank` varchar(255) DEFAULT NULL,
  `va_number` varchar(255) DEFAULT NULL,
  `qr_code_url` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `pemesanan`
--

CREATE TABLE `pemesanan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_pelanggan` bigint(20) UNSIGNED NOT NULL,
  `admin_id` bigint(20) UNSIGNED DEFAULT NULL,
  `total_harga` decimal(10,2) NOT NULL,
  `metode_pembayaran` varchar(255) NOT NULL DEFAULT 'tunai',
  `bukti_pembayaran` varchar(255) DEFAULT NULL,
  `status` enum('menunggu','pembayaran','dibayar','diproses','selesai','dibatalkan') NOT NULL DEFAULT 'menunggu',
  `waktu_pemesanan` datetime DEFAULT NULL,
  `waktu_pengambilan` datetime DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ratings`
--

CREATE TABLE `ratings` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_menu` bigint(20) UNSIGNED NOT NULL,
  `id_pelanggan` bigint(20) UNSIGNED NOT NULL,
  `rating` tinyint(4) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) NOT NULL,
  `user_id` bigint(20) UNSIGNED DEFAULT NULL,
  `ip_address` varchar(45) DEFAULT NULL,
  `user_agent` text DEFAULT NULL,
  `payload` longtext NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `stok_bahan`
--

CREATE TABLE `stok_bahan` (
  `id` bigint(20) UNSIGNED NOT NULL,
  `id_admin` bigint(20) UNSIGNED DEFAULT NULL,
  `nama_bahan` varchar(255) NOT NULL,
  `jumlah` int(11) NOT NULL,
  `satuan` enum('kg','liter','pcs','tandan','dus') NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `stok_bahan`
--

INSERT INTO `stok_bahan` (`id`, `id_admin`, `nama_bahan`, `jumlah`, `satuan`, `created_at`, `updated_at`) VALUES
(1, 1, 'Beras', 50, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(2, 1, 'Minyak Goreng', 20, 'liter', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(3, 1, 'Ayam', 30, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(4, 1, 'Telur', 100, 'pcs', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(5, 1, 'Gula', 25, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(6, 1, 'Teh', 10, 'dus', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(7, 1, 'Kopi', 15, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(8, 1, 'Jeruk', 20, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(9, 1, 'Alpukat', 15, 'kg', '2025-05-15 07:45:19', '2025-05-15 07:45:19'),
(10, 1, 'Pisang', 5, 'tandan', '2025-05-15 07:45:19', '2025-05-15 07:45:19');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `admin`
--
ALTER TABLE `admin`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `admin_email_unique` (`email`);

--
-- Indexes for table `cache`
--
ALTER TABLE `cache`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `cache_locks`
--
ALTER TABLE `cache_locks`
  ADD PRIMARY KEY (`key`);

--
-- Indexes for table `detail_pemesanan`
--
ALTER TABLE `detail_pemesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `detail_pemesanan_id_pemesanan_foreign` (`id_pemesanan`),
  ADD KEY `detail_pemesanan_id_menu_foreign` (`id_menu`);

--
-- Indexes for table `jobs`
--
ALTER TABLE `jobs`
  ADD PRIMARY KEY (`id`),
  ADD KEY `jobs_queue_index` (`queue`);

--
-- Indexes for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD PRIMARY KEY (`id`),
  ADD KEY `keranjang_id_pelanggan_foreign` (`id_pelanggan`),
  ADD KEY `keranjang_id_menu_foreign` (`id_menu`);

--
-- Indexes for table `laporan`
--
ALTER TABLE `laporan`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `menu`
--
ALTER TABLE `menu`
  ADD PRIMARY KEY (`id`),
  ADD KEY `menu_id_admin_foreign` (`id_admin`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifikasi`
--
ALTER TABLE `notifikasi`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `pelanggan`
--
ALTER TABLE `pelanggan`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pelanggan_device_id_unique` (`device_id`);

--
-- Indexes for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `pembayaran_order_id_unique` (`order_id`),
  ADD KEY `pembayaran_id_pemesanan_foreign` (`id_pemesanan`);

--
-- Indexes for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pemesanan_id_pelanggan_foreign` (`id_pelanggan`),
  ADD KEY `pemesanan_admin_id_foreign` (`admin_id`);

--
-- Indexes for table `ratings`
--
ALTER TABLE `ratings`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `ratings_id_menu_id_pelanggan_unique` (`id_menu`,`id_pelanggan`),
  ADD KEY `ratings_id_pelanggan_foreign` (`id_pelanggan`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sessions_user_id_index` (`user_id`),
  ADD KEY `sessions_last_activity_index` (`last_activity`);

--
-- Indexes for table `stok_bahan`
--
ALTER TABLE `stok_bahan`
  ADD PRIMARY KEY (`id`),
  ADD KEY `stok_bahan_id_admin_foreign` (`id_admin`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `admin`
--
ALTER TABLE `admin`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `detail_pemesanan`
--
ALTER TABLE `detail_pemesanan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `jobs`
--
ALTER TABLE `jobs`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `keranjang`
--
ALTER TABLE `keranjang`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `laporan`
--
ALTER TABLE `laporan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `menu`
--
ALTER TABLE `menu`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=25;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=431;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notifikasi`
--
ALTER TABLE `notifikasi`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pelanggan`
--
ALTER TABLE `pelanggan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `pembayaran`
--
ALTER TABLE `pembayaran`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `pemesanan`
--
ALTER TABLE `pemesanan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ratings`
--
ALTER TABLE `ratings`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `stok_bahan`
--
ALTER TABLE `stok_bahan`
  MODIFY `id` bigint(20) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `detail_pemesanan`
--
ALTER TABLE `detail_pemesanan`
  ADD CONSTRAINT `detail_pemesanan_id_menu_foreign` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `detail_pemesanan_id_pemesanan_foreign` FOREIGN KEY (`id_pemesanan`) REFERENCES `pemesanan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `keranjang`
--
ALTER TABLE `keranjang`
  ADD CONSTRAINT `keranjang_id_menu_foreign` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `keranjang_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu`
--
ALTER TABLE `menu`
  ADD CONSTRAINT `menu_id_admin_foreign` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE SET NULL;

--
-- Constraints for table `pembayaran`
--
ALTER TABLE `pembayaran`
  ADD CONSTRAINT `pembayaran_id_pemesanan_foreign` FOREIGN KEY (`id_pemesanan`) REFERENCES `pemesanan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `pemesanan`
--
ALTER TABLE `pemesanan`
  ADD CONSTRAINT `pemesanan_admin_id_foreign` FOREIGN KEY (`admin_id`) REFERENCES `admin` (`id`) ON DELETE SET NULL,
  ADD CONSTRAINT `pemesanan_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`);

--
-- Constraints for table `ratings`
--
ALTER TABLE `ratings`
  ADD CONSTRAINT `ratings_id_menu_foreign` FOREIGN KEY (`id_menu`) REFERENCES `menu` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `ratings_id_pelanggan_foreign` FOREIGN KEY (`id_pelanggan`) REFERENCES `pelanggan` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `stok_bahan`
--
ALTER TABLE `stok_bahan`
  ADD CONSTRAINT `stok_bahan_id_admin_foreign` FOREIGN KEY (`id_admin`) REFERENCES `admin` (`id`) ON DELETE SET NULL;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
