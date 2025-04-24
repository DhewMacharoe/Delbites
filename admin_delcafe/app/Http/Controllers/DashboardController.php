<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pemesanan;
use App\Models\Menu;
use App\Models\Pelanggan;
use App\Models\StokBahan;
use App\Models\DetailPemesanan;

class DashboardController extends Controller
{
    /**
     * Menampilkan halaman dashboard
     */
    public function index()
    {
        // Mengambil data untuk ditampilkan di dashboard
        $totalPesanan = Pemesanan::count();
        $totalPelanggan = Pelanggan::count();
        $totalMenu = Menu::count();
        $totalStok = StokBahan::count();
        
        // Pesanan terbaru (FIFO - First In First Out)
        $pesananTerbaru = Pemesanan::with(['pelanggan'])
            ->orderBy('created_at', 'asc') // Urutkan dari yang paling lama
            ->limit(5)
            ->get();
            
        // Menu terlaris
        $menuTerlaris = Menu::orderBy('stok_terjual', 'desc')
            ->limit(5)
            ->get();
            
        return view('dashboard.index', compact(
            'totalPesanan', 
            'totalPelanggan', 
            'totalMenu', 
            'totalStok', 
            'pesananTerbaru', 
            'menuTerlaris'
        ));
    }
    
    /**
     * Mendapatkan detail pesanan untuk modal
     */
    public function getDetailPesanan($id)
    {
        $pesanan = Pemesanan::with(['pelanggan', 'detailPemesanans.menu'])
            ->findOrFail($id);
            
        return response()->json([
            'pesanan' => $pesanan,
            'details' => $pesanan->detailPemesanans,
        ]);
    }
}