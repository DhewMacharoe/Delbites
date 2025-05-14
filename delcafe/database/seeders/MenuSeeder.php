<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MenuSeeder extends Seeder
{
    public function run()
    {
        $menus = [
            ['id' => 1, 'nama_menu' => 'Bakwan Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 100, 'gambar' => 'menu/1746074267_bakwan.jpeg', 'stok' => 1, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 08:53:47', 'updated_at' => '2025-04-30 21:37:47'],
            ['id' => 2, 'nama_menu' => 'Tempe Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 35, 'gambar' => 'menu/1746074596_tempe.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:05:39', 'updated_at' => '2025-04-30 21:43:16'],
            ['id' => 4, 'nama_menu' => 'Nugget Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 15000.00, 'stok' => 15, 'gambar' => 'menu/1746074418_gget.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:31:47', 'updated_at' => '2025-04-30 21:40:18'],
            ['id' => 5, 'nama_menu' => 'Gabin Fla', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 10, 'gambar' => 'menu/1746074349_gabin.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:32:25', 'updated_at' => '2025-04-30 21:39:09'],
            ['id' => 6, 'nama_menu' => 'Dadar Gulung', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 20, 'gambar' => 'menu/1746074317_dadar.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:32:57', 'updated_at' => '2025-04-30 21:38:37'],
            ['id' => 7, 'nama_menu' => 'Kentang Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 40, 'gambar' => 'menu/1746074380_kentang.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:34:43', 'updated_at' => '2025-04-30 21:39:40'],
            ['id' => 8, 'nama_menu' => 'Burger', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 13000.00, 'stok' => 10, 'gambar' => 'menu/1746074284_burger.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:36:00', 'updated_at' => '2025-04-30 21:38:04'],
            ['id' => 9, 'nama_menu' => 'Pisang Kulit Lumpia', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 20, 'gambar' => 'menu/1746074245_pkl.jpeg', 'stok' => 1, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:38:24', 'updated_at' => '2025-04-30 21:37:25'],
            ['id' => 10, 'nama_menu' => 'Pisang Nugget', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 25, 'gambar' => 'menu/1746074403_Pisang_cokelat.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:38:54', 'updated_at' => '2025-04-30 21:40:03'],
            ['id' => 11, 'nama_menu' => 'Dimsum', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 15000.00, 'stok' => 10, 'gambar' => 'menu/1746074334_dimsum.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:39:53', 'updated_at' => '2025-04-30 21:38:54'],
            ['id' => 12, 'nama_menu' => 'Salad Buah', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 15000.00, 'stok' => 20, 'gambar' => 'menu/1746074439_slad.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 1, 'created_at' => '2025-04-30 09:40:36', 'updated_at' => '2025-04-30 21:40:39'],
            ['id' => 13, 'nama_menu' => 'Roti Isi Ayam', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 15000.00, 'stok' => 25, 'gambar' => 'menu/1746074481_Roti_isi_ayam.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:41:21', 'updated_at' => '2025-04-30 21:41:21'],
            ['id' => 14, 'nama_menu' => 'Risol', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 35, 'gambar' => 'menu/1746074505_risol.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:41:45', 'updated_at' => '2025-04-30 21:41:45'],
            ['id' => 15, 'nama_menu' => 'Sosis Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 15000.00, 'stok' => 30, 'gambar' => 'menu/1746074540_sosis.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:42:20', 'updated_at' => '2025-04-30 21:42:20'],
            ['id' => 16, 'nama_menu' => 'Roti Bakar', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 20, 'gambar' => 'menu/1746074671_roti_bakar.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:44:31', 'updated_at' => '2025-04-30 21:44:31'],
            ['id' => 18, 'nama_menu' => 'Tahu Goreng', 'kategori' => 'makanan', 'suhu' => null, 'harga' => 10000.00, 'stok' => 20, 'gambar' => 'menu/1746074902_tahu.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:48:22', 'updated_at' => '2025-04-30 21:48:22'],
            ['id' => 19, 'nama_menu' => 'kopi Hitam', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 5000.00, 'stok' => 15, 'gambar' => 'menu/1746075274_kopi.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:54:34', 'updated_at' => '2025-04-30 21:54:34'],
            ['id' => 20, 'nama_menu' => 'Kopi Susu', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 7000.00, 'stok' => 16, 'gambar' => 'menu/1746075309_kopsu.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:55:09', 'updated_at' => '2025-04-30 21:55:09'],
            ['id' => 21, 'nama_menu' => 'Lemon Tea', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 8000.00, 'stok' => 15, 'gambar' => 'menu/1746075389_lemon.jpeg', 'stok' => 1, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:56:29', 'updated_at' => '2025-04-30 21:56:29'],
            ['id' => 22, 'nama_menu' => 'Teh Tarik', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 8000.00, 'stok' => 40, 'gambar' => 'menu/1746075484_tarik.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 21:58:04', 'updated_at' => '2025-04-30 21:58:04'],
            ['id' => 23, 'nama_menu' => 'Soda Gembira', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 8000.00, 'stok' => 13, 'gambar' => 'menu/1746075610_soda.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 22:00:10', 'updated_at' => '2025-04-30 22:00:10'],
            ['id' => 24, 'nama_menu' => 'Cokelat', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 8000.00, 'stok' => 10, 'gambar' => 'menu/1746075719_cokpasnas.jpg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 22:01:59', 'updated_at' => '2025-04-30 22:01:59'],
            ['id' => 25, 'nama_menu' => 'Teh Manis', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 7000.00, 'stok' => 10, 'gambar' => 'menu/1746075918_mansi.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 22:05:18', 'updated_at' => '2025-04-30 22:08:42'],
            ['id' => 26, 'nama_menu' => 'Cappucino', 'kategori' => 'minuman', 'suhu' => 'dingin', 'harga' => 8000.00, 'stok' => 10, 'gambar' => 'menu/1746075956_capucino.jpeg', 'stok' => 0, 'deskripsi' => '', 'rating' => 0, 'id_admin' => 2, 'created_at' => '2025-04-30 22:05:56', 'updated_at' => '2025-04-30 22:05:56'],
        ];

        DB::table('menu')->insert($menus);
    }
}