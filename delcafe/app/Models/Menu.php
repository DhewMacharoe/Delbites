<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $table = 'menu';

    protected $fillable = [
        'id_admin',
        'nama_menu',
        'kategori',
        'harga',
        'stok',
        'gambar',
        'stok_terjual',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'harga' => 'integer',
        'stok' => 'integer',
        'stok_terjual' => 'integer',
    ];

    // Relasi dengan Admin
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id');
    }

    // Relasi dengan DetailPemesanan
    public function detailPemesanans()
    {
        return $this->hasMany(DetailPemesanan::class, 'id_menu', 'id');
    }
}
