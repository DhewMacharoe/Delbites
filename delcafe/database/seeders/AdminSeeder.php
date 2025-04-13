<?php

namespace Database\Seeders;

use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Hash;

class AdminSeeder extends Seeder
{
    public function run(): void
    {
        DB::table('admins')->insert([
            'nama' => 'Admin DelCafe',
            'email' => 'admin@delcafe.com',
            'password' => Hash::make('admin123'),
            'role' => 'owner',
            'no_hp' => '08123456789'
        ]);
    }
}
