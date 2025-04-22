<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    use HasFactory;
    
    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'pelanggan';
    
    protected $fillable = [
        'nama',
        'email',
        'telepon',
        'status',
    ];
    
    /**
     * Get the orders for this customer.
     */
    public function pesanan()
    {
        return $this->hasMany(Pesanan::class, 'id_pelanggan');
    }
}