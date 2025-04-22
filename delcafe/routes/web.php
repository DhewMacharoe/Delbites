<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\DashboardController;
use App\Http\Controllers\PesananController;
use App\Http\Controllers\PelangganController;
use App\Http\Controllers\ProdukController;
use App\Http\Controllers\StokController;
use App\Http\Controllers\ReportController;
use App\Http\Controllers\AuthController;

Route::get('/', function () {
    return redirect('/dashboard');
});

Route::middleware(['web', 'auth'])->group(function () {
    Route::get('/dashboard', [DashboardController::class, 'index'])->name('dashboard');

    // Pesanan routes (formerly Orders)
    Route::get('/pesanan', [PesananController::class, 'index'])->name('pesanan.index');
    Route::put('/pesanan/{pesanan}/status', [PesananController::class, 'updateStatus'])->name('pesanan.update.status');
    Route::post('/pesanan/{pesanan}/accept', [PesananController::class, 'acceptOrder'])->name('pesanan.accept');
    Route::post('/pesanan/{pesanan}/bukti-pembayaran', [PesananController::class, 'uploadPaymentProof'])->name('pesanan.bukti.pembayaran');


    Route::prefix('admin/pelanggan')->name('pelanggan.')->group(function () {
        Route::get('/', [PelangganController::class, 'index'])->name('index'); // Menampilkan daftar pelanggan
        Route::get('detail/{pelanggan}', [PelangganController::class, 'showDetail'])->name('detail'); // Menampilkan detail pelanggan via AJAX
        Route::get('search', [PelangganController::class, 'search'])->name('search'); // Mencari pelanggan
        Route::delete('{pelanggan}', [PelangganController::class, 'destroy'])->name('destroy'); // Menghapus pelanggan
    });

    // Produk routes (formerly Products)
    Route::resource('produk', ProdukController::class);

    // Stok routes (formerly Stocks)
    Route::resource('stok', StokController::class);

    // Reports routes (keep in English for now, or translate if needed)
    Route::get('/reports', [ReportController::class, 'index'])->name('reports.index');
    Route::get('/reports/export-pdf', [ReportController::class, 'exportPdf'])->name('reports.export.pdf');
    Route::get('/reports/export-excel', [ReportController::class, 'exportExcel'])->name('reports.export.excel');
    Route::get('/reports/receipt/{pesanan}', [ReportController::class, 'receipt'])->name('reports.receipt');
});

Route::get('/login', [AuthController::class, 'showLoginForm'])->name('login');
Route::post('/login', [AuthController::class, 'loginWeb']);
Route::post('/logout', [AuthController::class, 'logoutWeb'])->name('logout');

Route::get('/register', [AuthController::class, 'showRegisterForm'])->name('register');
Route::post('/register', [AuthController::class, 'register']);
require __DIR__ . '/api.php';
