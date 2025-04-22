<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\PesananController;
use App\Http\Controllers\PelangganController;
use App\Http\Controllers\ProdukController;
use App\Http\Controllers\StokController;
use App\Http\Controllers\ReportController;

Route::get('/', function () {
    return redirect('/dashboard');
});


// Pesanan routes (formerly Orders)
Route::get('/pesanan', [PesananController::class, 'index'])->name('pesanan.index');
Route::put('/pesanan/{pesanan}/status', [PesananController::class, 'updateStatus'])->name('pesanan.update.status');
Route::post('/pesanan/{pesanan}/accept', [PesananController::class, 'acceptOrder'])->name('pesanan.accept');
Route::post('/pesanan/{pesanan}/bukti-pembayaran', [PesananController::class, 'uploadPaymentProof'])->name('pesanan.bukti.pembayaran');
require __DIR__ . '/auth.php';
