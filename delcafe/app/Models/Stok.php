<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Stok extends Model
{
    use HasFactory;

    protected $table = 'stok';

    protected $primaryKey = 'stok_id'; // penting karena default-nya 'id'

    protected $fillable = [
        'nama_barang',
        'jumlah',
        'satuan',
        'admin_id',
    ];

    /**
     * Relasi ke Admin (dari admin_id ke id_admin)
     */
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'admin_id', 'id_admin');
    }
}
