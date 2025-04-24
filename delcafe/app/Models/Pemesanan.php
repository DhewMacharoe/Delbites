<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pemesanan extends Model
{
    use HasFactory;

    protected $table = 'pemesanan';
    
    protected $fillable = [
        'id_pelanggan',
        'id_admin',
        'total_harga',
        'metode_pembayaran',
        'status',
        'catatan',
        'waktu_pemesanan',
        'waktu_pengambilan',
    ];

    protected $dates = [
        'waktu_pemesanan',
        'waktu_pengambilan',
    ];

    // Relasi ke Pelanggan
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan');
    }

    // Relasi ke Admin
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin');
    }

    // Relasi ke DetailPemesanan
    public function detailPemesanans()
    {
        return $this->hasMany(DetailPemesanan::class, 'id_pemesanan');
    }
}