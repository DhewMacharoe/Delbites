<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Pelanggan;

class PelangganSeeder extends Seeder
{
    public function run(): void
    {
        $pelanggan = [
            [
                'nama' => 'Budi Santoso',
                'email' => 'budi@example.com',
                'telepon' => '081234567890',
                'status' => 'aktif',
            ],
            [
                'nama' => 'Siti Rahayu',
                'email' => 'siti@example.com',
                'telepon' => '081234567891',
                'status' => 'aktif',
            ],
        ];

        foreach ($pelanggan as $data) {
            Pelanggan::create($data);
        }
    }
}
