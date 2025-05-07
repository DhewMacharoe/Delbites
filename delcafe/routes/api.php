<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\MenuController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\Api\PemesananController;
use App\Http\Controllers\Api\PelangganController;
use App\Http\Controllers\AdminController;
use App\Http\Controllers\KeranjangController;
use App\Http\Controllers\MidtransController;
use App\Http\Controllers\DetailPemesananController;


// Menu
Route::get('/menu', [MenuController::class, 'index']);
Route::get('/menu/{id}', [MenuController::class, 'show']);
Route::post('/menu', [MenuController::class, 'store']);
Route::put('/menu/{id}', [MenuController::class, 'update']);
Route::delete('/menu/{id}', [MenuController::class, 'destroy']);
Route::get('/menu/top', [MenuController::class, 'topMenu']); // gunakan hanya ini

// Pelanggan
Route::get('/pelanggan', [PelangganController::class, 'index']);
Route::get('/pelanggan/{id}', [PelangganController::class, 'show']);
Route::post('/pelanggan', [PelangganController::class, 'store']);
Route::put('/pelanggan/{id}', [PelangganController::class, 'update']);
Route::delete('/pelanggan/{id}', [PelangganController::class, 'destroy']);
Route::post('/pelanggan/register', [PelangganController::class, 'registerByUid']);

// Pemesanan
Route::get('/pemesanan', [PemesananController::class, 'index']);
Route::get('/pemesanan/{id}', [PemesananController::class, 'show']);
Route::post('/pemesanan', [PemesananController::class, 'store']);
Route::put('/pemesanan/{id}', [PemesananController::class, 'update']);
Route::delete('/pemesanan/{id}', [PemesananController::class, 'destroy']);

// Admin
Route::get('/admin', [AdminController::class, 'index']);
Route::get('/admin/{id}', [AdminController::class, 'show']);
Route::post('/admin', [AdminController::class, 'store']);
Route::put('/admin/{id}', [AdminController::class, 'update']);
Route::delete('/admin/{id}', [AdminController::class, 'destroy']);

// Keranjang
Route::get('/keranjang', [KeranjangController::class, 'index']);
Route::get('/keranjang/{id}', [KeranjangController::class, 'show']);
Route::post('/keranjang', [KeranjangController::class, 'store']);
Route::put('/keranjang/{id}', [KeranjangController::class, 'update']);
Route::delete('/keranjang/{id}', [KeranjangController::class, 'destroy']);
Route::post('/keranjang/checkout/{id_pelanggan}', [KeranjangController::class, 'checkout']);
Route::get('/keranjang/pelanggan/{id_pelanggan}', [KeranjangController::class, 'getByPelanggan']);

// Detail Pemesanan
Route::get('/detail-pemesanan', [DetailPemesananController::class, 'index']);
Route::post('/detail-pemesanan', [DetailPemesananController::class, 'store']);
Route::get('/detail-pemesanan/{id}', [DetailPemesananController::class, 'show']);
Route::put('/detail-pemesanan/{id}', [DetailPemesananController::class, 'update']);
Route::delete('/detail-pemesanan/{id}', [DetailPemesananController::class, 'destroy']);

// Auth Pelanggan
Route::post('/auth/pelanggan', [PelangganController::class, 'loginAtauRegister']);
Route::post('/auth/pelanggan/manual', [PelangganController::class, 'loginManual']);

// Middleware JWT
Route::middleware('jwt.auth')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
});

// Midtrans
Route::post('/midtrans/create-transaction', [MidtransController::class, 'createTransaction']);
Route::get('/midtrans/status/{orderId}', [MidtransController::class, 'checkStatus']);
Route::post('/midtrans/notification', [MidtransController::class, 'handleNotification']);
