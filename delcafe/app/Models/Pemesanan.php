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
        'bukti_pembayaran',
        'status',
        // 'catatan',
        'waktu_pemesanan',
        'waktu_pengambilan',
    ];

    protected $dates = [
        'waktu_pemesanan',
        'waktu_pengambilan',
    ];

    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan');
    }

    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin');
    }

    public function detailPemesanans()
    {
        return $this->hasMany(DetailPemesanan::class, 'id_pemesanan');
    }
}
