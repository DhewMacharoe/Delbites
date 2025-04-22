<?php
// app/Http/Controllers/DashboardController.php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pesanan;
use App\Models\Produk;

class DashboardController extends Controller
{
    public function index()
    {
        // Get total revenue
        $totalRevenue = Pesanan::where('status', 'selesai')
                            ->sum('total_harga');
        
        // Get total orders
        $totalOrders = Pesanan::count();
        
        // Get out of stock products
        $outOfStockCount = Produk::where('stok', 0)->count();
        
        // Get only pending orders (status = menunggu), ordered by oldest first
        $pendingOrders = Pesanan::with(['pelanggan', 'items.produk'])
                            ->where('status', 'menunggu')
                            ->orderBy('created_at', 'asc')
                            ->take(3)
                            ->get();
        
        return view('dashboard.index', compact('totalRevenue', 'totalOrders', 'outOfStockCount', 'pendingOrders'));
    }
}