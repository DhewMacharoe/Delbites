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


Route::get('/menu', [MenuController::class, 'index']);
Route::get('/menu/{id}', [MenuController::class, 'show']);
Route::post('/menu', [MenuController::class, 'store']);
Route::put('/menu/{id}', [MenuController::class, 'update']);
Route::delete('/menu/{id}', [MenuController::class, 'destroy']);
Route::get('/top-menu', [MenuController::class, 'topMenu']);


Route::get('/pelanggan', [PelangganController::class, 'index']);
Route::get('/pelanggan/{id}', [PelangganController::class, 'show']);
Route::post('/pelanggan', [PelangganController::class, 'store']);
Route::put('/pelanggan/{id}', [PelangganController::class, 'update']);
Route::delete('/pelanggan/{id}', [PelangganController::class, 'destroy']);
Route::post('/pelanggan/register', [PelangganController::class, 'registerByUid']);

Route::get('/pemesanan', [PemesananController::class, 'index']);
Route::get('/pemesanan/{id}', [PemesananController::class, 'show']);
Route::post('/pemesanan', [PemesananController::class, 'store']);
Route::put('/pemesanan/{id}', [PemesananController::class, 'update']);
Route::delete('/pemesanan/{id}', [PemesananController::class, 'destroy']);

Route::get('/admin', [AdminController::class, 'index']);
Route::get('/admin/{id}', [AdminController::class, 'show']);
Route::post('/admin', [AdminController::class, 'store']);
Route::put('/admin/{id}', [AdminController::class, 'update']);
Route::delete('/admin/{id}', [AdminController::class, 'destroy']);

Route::get('/keranjang', [KeranjangController::class, 'index']);
Route::get('/keranjang/{id}', [KeranjangController::class, 'show']);
Route::post('/keranjang', [KeranjangController::class, 'store']);
Route::put('/keranjang/{id}', [KeranjangController::class, 'update']);
Route::delete('/keranjang/{id}', [KeranjangController::class, 'destroy']);

Route::get('/detail-pemesanan', [DetailPemesananController::class, 'index']);
Route::post('/detail-pemesanan', [DetailPemesananController::class, 'store']);
Route::get('/detail-pemesanan/{id}', [DetailPemesananController::class, 'show']);
Route::put('/detail-pemesanan/{id}', [DetailPemesananController::class, 'update']);
Route::delete('/detail-pemesanan/{id}', [DetailPemesananController::class, 'destroy']);

Route::middleware('jwt.auth')->group(function () {
    Route::get('/me', [AuthController::class, 'me']);
    Route::post('/logout', [AuthController::class, 'logout']);
});


// Route::middleware('auth:sanctum')->group(function () {
//     Route::post('/pembayaran/create', [PembayaranController::class, 'createTransaction']);
//     Route::get('/pembayaran/status', [PembayaranController::class, 'checkStatus']);
//     Route::get('/pembayaran/{id_pemesanan}', [PembayaranController::class, 'getDetailPembayaran']);
//     Route::post('/pemesanan/create', [PemesananController::class, 'create']);
// });

// Route untuk webhook Midtrans (tidak perlu auth)
Route::post('/midtrans/create-transaction', [MidtransController::class, 'createTransaction']);
Route::get('/midtrans/status/{orderId}', [MidtransController::class, 'checkStatus']);
Route::post('/midtrans/notification', [MidtransController::class, 'handleNotification']);

Route::post('/auth/pelanggan', [PelangganController::class, 'loginAtauRegister']);
Route::post('/auth/pelanggan/manual', [PelangganController::class, 'loginManual']);
