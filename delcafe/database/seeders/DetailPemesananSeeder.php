<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\DetailPemesanan;
use App\Models\Menu;

class DetailPemesananSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // Pesanan 1
        DetailPemesanan::create([
            'id_pemesanan' => 1,
            'id_menu' => 1, // Nasi Goreng Spesial
            'jumlah' => 2,
            'harga_satuan' => 25000,
            'subtotal' => 50000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 1,
            'id_menu' => 6, // Es Teh Manis
            'jumlah' => 1,
            'harga_satuan' => 5000,
            'subtotal' => 5000,
        ]);
        
        // Pesanan 2
        DetailPemesanan::create([
            'id_pemesanan' => 2,
            'id_menu' => 3, // Ayam Bakar
            'jumlah' => 1,
            'harga_satuan' => 35000,
            'subtotal' => 35000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 2,
            'id_menu' => 4, // Sate Ayam
            'jumlah' => 1,
            'harga_satuan' => 20000,
            'subtotal' => 20000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 2,
            'id_menu' => 7, // Es Jeruk
            'jumlah' => 2,
            'harga_satuan' => 5000,
            'subtotal' => 10000,
        ]);
        
        // Pesanan 3
        DetailPemesanan::create([
            'id_pemesanan' => 3,
            'id_menu' => 2, // Mie Goreng Seafood
            'jumlah' => 1,
            'harga_satuan' => 30000,
            'subtotal' => 30000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 3,
            'id_menu' => 9, // Kopi Hitam
            'jumlah' => 1,
            'harga_satuan' => 8000,
            'subtotal' => 8000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 3,
            'id_menu' => 6, // Es Teh Manis
            'jumlah' => 1,
            'harga_satuan' => 5000,
            'subtotal' => 5000,
        ]);
        
        // Pesanan 4
        DetailPemesanan::create([
            'id_pemesanan' => 4,
            'id_menu' => 3, // Ayam Bakar
            'jumlah' => 2,
            'harga_satuan' => 35000,
            'subtotal' => 70000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 4,
            'id_menu' => 6, // Es Teh Manis
            'jumlah' => 1,
            'harga_satuan' => 5000,
            'subtotal' => 5000,
        ]);
        
        // Pesanan 5
        DetailPemesanan::create([
            'id_pemesanan' => 5,
            'id_menu' => 2, // Mie Goreng Seafood
            'jumlah' => 1,
            'harga_satuan' => 30000,
            'subtotal' => 30000,
        ]);
        
        // Pesanan 6
        DetailPemesanan::create([
            'id_pemesanan' => 6,
            'id_menu' => 1, // Nasi Goreng Spesial
            'jumlah' => 1,
            'harga_satuan' => 25000,
            'subtotal' => 25000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 6,
            'id_menu' => 4, // Sate Ayam
            'jumlah' => 1,
            'harga_satuan' => 20000,
            'subtotal' => 20000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 6,
            'id_menu' => 6, // Es Teh Manis
            'jumlah' => 1,
            'harga_satuan' => 5000,
            'subtotal' => 5000,
        ]);
        
        // Pesanan 7
        DetailPemesanan::create([
            'id_pemesanan' => 7,
            'id_menu' => 5, // Gado-gado
            'jumlah' => 1,
            'harga_satuan' => 18000,
            'subtotal' => 18000,
        ]);
        
        DetailPemesanan::create([
            'id_pemesanan' => 7,
            'id_menu' => 2, // Mie Goreng Seafood
            'jumlah' => 1,
            'harga_satuan' => 30000,
            'subtotal' => 30000,
        ]);
    }
}