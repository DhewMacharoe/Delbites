<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;

class MenuSeeder extends Seeder
{
    public function run()
    {
        $menu = [
            // Makanan
            [
                'id_admin' => 1,
                'nama_menu' => 'Nasi Goreng Spesial',
                'kategori' => 'makanan',
                'harga' => 25000,
                'stok' => 50,
                'suhu' => null,
                'deskripsi' => 'Nasi goreng dengan topping ayam dan telur.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Mie Goreng Seafood',
                'kategori' => 'makanan',
                'harga' => 30000,
                'stok' => 40,
                'suhu' => null,
                'deskripsi' => 'Mie goreng dengan aneka seafood segar.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Ayam Bakar',
                'kategori' => 'makanan',
                'harga' => 35000,
                'stok' => 30,
                'suhu' => null,
                'deskripsi' => 'Ayam bakar dengan bumbu rempah khas.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Sate Ayam',
                'kategori' => 'makanan',
                'harga' => 20000,
                'stok' => 60,
                'suhu' => null,
                'deskripsi' => 'Sate ayam dengan bumbu kacang lezat.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Gado-gado',
                'kategori' => 'makanan',
                'harga' => 18000,
                'stok' => 25,
                'suhu' => null,
                'deskripsi' => 'Salad khas Indonesia dengan saus kacang.',
                'gambar' => null,
            ],

            // Minuman
            [
                'id_admin' => 1,
                'nama_menu' => 'Es Teh Manis',
                'kategori' => 'minuman',
                'harga' => 5000,
                'stok' => 100,
                'suhu' => 'dingin',
                'deskripsi' => 'Teh manis yang menyegarkan disajikan dingin.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Es Jeruk',
                'kategori' => 'minuman',
                'harga' => 7000,
                'stok' => 80,
                'suhu' => 'dingin',
                'deskripsi' => 'Minuman jeruk segar dengan es batu.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Jus Alpukat',
                'kategori' => 'minuman',
                'harga' => 15000,
                'stok' => 40,
                'suhu' => 'dingin',
                'deskripsi' => 'Jus alpukat dengan susu kental manis.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Kopi Hitam',
                'kategori' => 'minuman',
                'harga' => 8000,
                'stok' => 70,
                'suhu' => 'panas',
                'deskripsi' => 'Kopi hitam panas tanpa gula.',
                'gambar' => null,
            ],
            [
                'id_admin' => 1,
                'nama_menu' => 'Lemon Tea',
                'kategori' => 'minuman',
                'harga' => 10000,
                'stok' => 60,
                'suhu' => 'dingin',
                'deskripsi' => 'Teh lemon dingin yang menyegarkan.',
                'gambar' => null,
            ],
        ];

        DB::table('menu')->insert($menu);
    }
}