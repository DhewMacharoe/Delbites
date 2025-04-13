<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Menu extends Model
{
    use HasFactory;

    protected $table = 'menu';

    protected $primaryKey = 'menu_id';

    protected $fillable = [
        'admin_id',
        'nama_menu',
        'kategori',
        'harga',
        'stok',
        'gambar',
        'jumlah_terjual',
    ];

    public $timestamps = true;

    public function admin()
    {
        return $this->belongsTo(Admin::class, 'admin_id');
    }
}
