<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Produk extends Model
{
    use HasFactory;
    
    protected $table = 'produk';
    
    protected $fillable = [
        'nama',
        'deskripsi',
        'harga',
        'stok',
        'gambar',
        'id_admin',
    ];

    protected $casts = [
        'deskripsi' => 'string',  // Pastikan deskripsi diset sebagai string
    ];

    // Menjadikan deskripsi nullable
    public function getDeskripsiAttribute($value)
    {
        return $value ?? '';  // Jika null, akan mengembalikan string kosong
    }

    // Relasi ke Admin
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id_admin');
    }

    // Relasi ke Riwayat Stok
    public function riwayatStok()
    {
        return $this->hasMany(Stok::class, 'id_produk');
    }

    // Relasi ke Item Pesanan
    public function itemPesanan()
    {
        return $this->hasMany(ItemPesanan::class, 'id_produk');
    }
}
