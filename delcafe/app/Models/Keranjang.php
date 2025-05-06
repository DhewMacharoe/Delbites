<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Keranjang extends Model
{
    use HasFactory;
    
    protected $table = 'keranjang';
    
    protected $fillable = [
        'id_pelanggan',
        'id_menu',
        'nama_menu',
        'kategori',
        'jumlah',
        'harga',
        'suhu',     // Added field
        'catatan'   // Added fiel
    ];

    /**
     * Relationship with Pelanggan (Customer)
     */
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan');
    }

    /**
     * Relationship with Menu
     */
    public function menu()
    {
        return $this->belongsTo(Menu::class, 'id_menu');
    }

    /**
     * Get the total price for the item in the cart (harga * jumlah)
     */
    public function totalPrice()
    {
        return $this->harga * $this->jumlah;
    }
}
