<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class ItemPesanan extends Model
{
    use HasFactory;
    
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'item_pesanan';
    
    protected $fillable = [
        'id_pesanan',
        'id_produk',
        'jumlah',
        'harga',
    ];
    
    /**
     * Get the order that contains this item.
     */
    public function pesanan()
    {
        return $this->belongsTo(Pesanan::class, 'id_pesanan');
    }
    
    /**
     * Get the product for this order item.
     */
    public function produk()
    {
        return $this->belongsTo(Produk::class, 'id_produk');
    }
}