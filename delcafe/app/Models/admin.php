<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
// use Laravel\Sanctum\HasApiTokens; //~scantum

class Admin extends Authenticatable
{
    // use HasApiTokens, HasFactory, Notifiable;  //~scantum
    use HasFactory, Notifiable;

    /**
     * The table associated with the model.
     *
     * @var string
     */
    protected $table = 'admin';

    /**
     * The primary key for the model.
     *
     * @var string
     */
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
        'remember_token',
    ];

    /**
     * The attributes that should be cast.
     *
     * @var array<string, string>
     */
    protected $casts = [
        'email_verified_at' => 'datetime',
        'password' => 'hashed',
    ];

    /**
     * Get the products created by this admin.
     */
    public function produk()
    {
        return $this->hasMany(Produk::class, 'id_admin', 'id_admin');
    }

    /**
     * Get the stock entries managed by this admin.
     */
    public function stok()
    {
        return $this->hasMany(Stok::class, 'id_admin', 'id_admin');
    }

    /**
     * Get the orders managed by this admin.
     */
    public function pesanan()
    {
        return $this->hasMany(Pesanan::class, 'id_admin', 'id_admin');
    }
}