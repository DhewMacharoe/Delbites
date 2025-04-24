<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pemesanan extends Model
{
    use HasFactory;

    protected $table = 'pemesanan';
    // Primary key default 'id' tidak perlu didefinisikan

    protected $fillable = [
        'id_pelanggan',
        'admin_id',
        'total_harga',
        'metode_pembayaran',
        'bukti_pembayaran',
        'status',
        'waktu_pemesanan',
        'waktu_pengambilan',
    ];

    protected $casts = [
        'waktu_pemesanan' => 'datetime',
        'waktu_pengambilan' => 'datetime',
        'total_harga' => 'integer',
    ];

    // Relasi dengan Pelanggan
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan', 'id');
    }

    // Relasi dengan Admin
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'admin_id', 'id_admin');
    }

    // Relasi dengan DetailPemesanan
    public function detailPemesanans()
    {
        return $this->hasMany(DetailPemesanan::class, 'id_pemesanan', 'id');
    }
}
