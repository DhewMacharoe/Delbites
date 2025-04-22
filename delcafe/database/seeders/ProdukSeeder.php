<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Produk;
use App\Models\Admin;

class ProdukSeeder extends Seeder
{
    public function run(): void
    {
        $admin = Admin::first(); // Asumsi hanya ada 1 admin

        $produk = [
            [
                'nama' => 'Nasi Goreng',
                'deskripsi' => 'Nasi goreng spesial dengan telur dan ayam',
                'harga' => 25000,
                'stok' => 100,
                'id_admin' => $admin->id,
            ],
            [
                'nama' => 'Ayam Bakar',
                'deskripsi' => 'Ayam bakar dengan bumbu spesial',
                'harga' => 35000,
                'stok' => 50,
                'id_admin' => $admin->id,
            ],
        ];

        foreach ($produk as $data) {
            Produk::create($data);
        }
    }
}
