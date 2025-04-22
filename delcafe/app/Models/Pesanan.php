<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pesanan extends Model
{
    use HasFactory;
    
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'pesanan';
    
    protected $fillable = [
        'id_pelanggan',
        'total_harga',
        'status',
        'metode_pembayaran',
        'catatan',
        'bukti_pembayaran',
        'id_admin',
    ];
    
    /**
     * Get the customer who placed this order.
     */
    public function pelanggan()
    {
        return $this->belongsTo(Pelanggan::class, 'id_pelanggan');
    }
    
    /**
     * Get the admin who managed this order.
     */
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id_admin');
    }
    
    /**
     * Get the items for this order.
     */
    public function items()
    {
        return $this->hasMany(ItemPesanan::class, 'id_pesanan');
    }
}