<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use App\Models\Pelanggan;
use Illuminate\Support\Facades\Hash;

class PelangganSeeder extends Seeder
{
    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        $pelanggan = [
            [
                'nama' => 'Budi Santoso',
                'telepon' => '081234567890',
                'password' => Hash::make('password'),
                'status' => 'aktif',
            ],
            [
                'nama' => 'Siti Rahayu',
                'telepon' => '082345678901',
                'password' => Hash::make('password'),
                'status' => 'aktif',
            ],
            [
                'nama' => 'Ahmad Hidayat',
                'telepon' => '083456789012',
                'password' => Hash::make('password'),
                'status' => 'aktif',
            ],
            [
                'nama' => 'Dewi Lestari',
                'telepon' => '084567890123',
                'password' => Hash::make('password'),
                'status' => 'aktif',
            ],
            [
                'nama' => 'Eko Prasetyo',
                'telepon' => '085678901234',
                'password' => Hash::make('password'),
                'status' => 'nonaktif',
            ],
        ];
        
        foreach ($pelanggan as $p) {
            Pelanggan::create($p);
        }
    }
}