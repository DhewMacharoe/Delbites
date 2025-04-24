<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class DetailPemesanan extends Model
{
    use HasFactory;

    protected $table = 'detail_pemesanan';
    // Primary key default 'id' tidak perlu didefinisikan

    protected $fillable = [
        'id_pemesanan',
        'id_menu',
        'jumlah',
        'harga_satuan',
        'subtotal',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'jumlah' => 'integer',
        'harga_satuan' => 'integer',
        'subtotal' => 'integer',
    ];

    // Relasi dengan Pemesanan
    public function pemesanan()
    {
        return $this->belongsTo(Pemesanan::class, 'id_pemesanan', 'id');
    }

    // Relasi dengan Menu
    public function menu()
    {
        return $this->belongsTo(Menu::class, 'id_menu', 'id');
    }
}