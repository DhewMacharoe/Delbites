<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Pemesanan;
use Carbon\Carbon;

class PemesananSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $pemesanan = [
            [
                'id_pelanggan' => 1,
                'admin_id' => 1,
                'total_harga' => 55000,
                'metode_pembayaran' => 'tunai',
                'status' => 'selesai',
                'waktu_pemesanan' => Carbon::now()->subDays(5),
                'waktu_pengambilan' => Carbon::now()->subDays(5)->addHours(1),
            ],
            [
                'id_pelanggan' => 2,
                'admin_id' => 1,
                'total_harga' => 65000,
                'metode_pembayaran' => 'qris',
                'status' => 'selesai',
                'waktu_pemesanan' => Carbon::now()->subDays(4),
                'waktu_pengambilan' => Carbon::now()->subDays(4)->addHours(1),
            ],
            [
                'id_pelanggan' => 3,
                'admin_id' => 1,
                'total_harga' => 40000,
                'metode_pembayaran' => 'transfer bank',
                'status' => 'diproses',
                'waktu_pemesanan' => Carbon::now()->subDays(3),
                'waktu_pengambilan' => Carbon::now()->subDays(3)->addHours(1),
            ],
            [
                'id_pelanggan' => 4,
                'admin_id' => 1,
                'total_harga' => 75000,
                'metode_pembayaran' => 'tunai',
                'status' => 'dibayar',
                'waktu_pemesanan' => Carbon::now()->subDays(2),
                'waktu_pengambilan' => Carbon::now()->subDays(2)->addHours(1),
            ],
            [
                'id_pelanggan' => 1,
                'admin_id' => 1,
                'total_harga' => 30000,
                'metode_pembayaran' => 'qris',
                'status' => 'menunggu',
                'waktu_pemesanan' => Carbon::now()->subDays(1),
                'waktu_pengambilan' => Carbon::now()->subDays(1)->addHours(1),
            ],
            [
                'id_pelanggan' => 2,
                'admin_id' => 1,
                'total_harga' => 50000,
                'metode_pembayaran' => 'transfer bank',
                'status' => 'pembayaran',
                'waktu_pemesanan' => Carbon::now(),
                'waktu_pengambilan' => Carbon::now()->addHours(1),
            ],
            [
                'id_pelanggan' => 3,
                'admin_id' => 1,
                'total_harga' => 45000,
                'metode_pembayaran' => 'tunai',
                'status' => 'dibatalkan',
                'waktu_pemesanan' => Carbon::now()->subDays(6),
                'waktu_pengambilan' => Carbon::now()->subDays(6)->addHours(1),
            ],
        ];
        
        foreach ($pemesanan as $p) {
            Pemesanan::create($p);
        }
    }
}