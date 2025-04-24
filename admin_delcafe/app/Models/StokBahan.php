<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class StokBahan extends Model
{
    use HasFactory;

    protected $table = 'stok_bahan';
    // Primary key default 'id' tidak perlu didefinisikan

    protected $fillable = [
        'id_admin',
        'nama_bahan',
        'jumlah',
        'satuan',
    ];

    // Relasi dengan Admin
    public function admin()
    {
        return $this->belongsTo(Admin::class, 'id_admin', 'id_admin');
    }
}