<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Pelanggan extends Model
{
    use HasFactory;

    protected $table = 'pelanggan';

    protected $fillable = [
        'nama',
        'telepon',
        'device_id',
    ];
    public function pemesanan()
{
    return $this->hasMany(Pemesanan::class, 'id_pelanggan');
}

}
