<?php

namespace App\Models;

namespace App\Http\Controllers;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use App\Models\Menu as ModelsMenu;
use App\Models\Pemesanan as ModelsPemesanan;
use App\Models\StokBahan;

class AdminController extends Authenticatable
{
    use  HasFactory, Notifiable;

    protected $table = 'admin';
    protected $primaryKey = 'id_admin';

    /**
     * The attributes that are mass assignable.
     *
     * @var array<int, string>
     */
    protected $fillable = [
        'nama',
        'email',
        'password',
    ];

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var array<int, string>
     */
    protected $hidden = [
        'password',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'password' => 'hashed',
    ];

    // Relasi dengan Menu
    public function menus()
    {
        return $this->hasMany(ModelsMenu::class, 'id_admin', 'id_admin');
    }

    // Relasi dengan Pemesanan
    public function pemesanans()
    {
        return $this->hasMany(ModelsPemesanan::class, 'admin_id', 'id_admin');
    }

    // Relasi dengan StokBahan
    public function stokBahans()
    {
        return $this->hasMany(StokBahan::class, 'id_admin', 'id_admin');
    }
}
