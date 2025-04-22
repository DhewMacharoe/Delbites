<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Pesanan;
use App\Models\ItemPesanan;
use App\Models\Admin;

class PesananSeeder extends Seeder
{
    public function run(): void
    {
        $admin = Admin::first();

        $pesanan = [
            [
                'id_pelanggan' => 1,
                'total_harga' => 75000,
                'status' => 'menunggu',
                'metode_pembayaran' => 'tunai',
                'id_admin' => $admin->id,
                'items' => [
                    ['id_produk' => 1, 'jumlah' => 2, 'harga' => 25000],
                    ['id_produk' => 2, 'jumlah' => 1, 'harga' => 25000],
                ],
            ],
            [
                'id_pelanggan' => 2,
                'total_harga' => 65000,
                'status' => 'dibayar',
                'metode_pembayaran' => 'transfer',
                'id_admin' => $admin->id,
                'items' => [
                    ['id_produk' => 2, 'jumlah' => 1, 'harga' => 35000],
                    ['id_produk' => 1, 'jumlah' => 1, 'harga' => 25000],
                ],
            ],
        ];

        foreach ($pesanan as $data) {
            $items = $data['items'];
            unset($data['items']);

            $order = Pesanan::create($data);

            foreach ($items as $item) {
                ItemPesanan::create([
                    'id_pesanan' => $order->id,
                    'id_produk' => $item['id_produk'],
                    'jumlah' => $item['jumlah'],
                    'harga' => $item['harga'],
                ]);
            }
        }
    }
}
