<?php

namespace App\Http\Controllers;

use App\Models\Pesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class PesananController extends Controller
{
    public function index()
    {
        $pesanan = Pesanan::with(['pelanggan', 'items', 'admin'])->latest()->paginate(10);
        return view('pesanan.index', compact('pesanan'));
    }
    
    public function updateStatus(Request $request, Pesanan $pesanan)
    {
        $validated = $request->validate([
            'status' => 'required|in:menunggu,pembayaran,dibayar,diproses,selesai,dibatalkan',
        ]);
        
        $newStatus = $validated['status'];
        
        // Handle automatic status changes based on payment method
        if ($request->has('accept_order') && $request->accept_order) {
            if ($pesanan->status === 'menunggu') {
                // For cash payments, go directly to "diproses"
                if ($pesanan->metode_pembayaran === 'tunai') {
                    $newStatus = 'diproses';
                } 
                // For transfer payments, go to "pembayaran" first
                else if ($pesanan->metode_pembayaran === 'transfer') {
                    $newStatus = 'pembayaran';
                }
            }
        }
        
        $pesanan->status = $newStatus;
        $pesanan->id_admin = Auth::user()->id_admin;
        $pesanan->save();
        
        return redirect()->back()->with('success', 'Status pesanan berhasil diperbarui');
    }
    
    public function acceptOrder(Pesanan $pesanan)
    {
        if ($pesanan->status !== 'menunggu') {
            return redirect()->back()->with('error', 'Hanya pesanan dengan status menunggu yang dapat diterima');
        }
        
        // For cash payments, go directly to "diproses"
        if ($pesanan->metode_pembayaran === 'tunai') {
            $pesanan->status = 'diproses';
            $message = 'Pesanan diterima dan sedang diproses';
        } 
        // For transfer payments, go to "pembayaran" first
        else {
            $pesanan->status = 'pembayaran';
            $message = 'Pesanan diterima, menunggu pembayaran dari pelanggan';
        }
        
        $pesanan->id_admin = Auth::user()->id_admin;
        $pesanan->save();
        
        return redirect()->back()->with('success', $message);
    }
}