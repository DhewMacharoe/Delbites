<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Pemesanan;
use App\Models\DetailPemesanan;
use App\Models\Pelanggan;
use Barryvdh\DomPDF\Facade\Pdf;

class PesananController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = Pemesanan::with(['pelanggan']);

        // Filter berdasarkan status
        if ($request->has('status') && $request->status != '') {
            $query->where('status', $request->status);
        }

        // Filter berdasarkan metode pembayaran
        if ($request->has('metode_pembayaran') && $request->metode_pembayaran != '') {
            $query->where('metode_pembayaran', $request->metode_pembayaran);
        }

        $pesanan = $query->orderBy('created_at', 'desc')->paginate(10);

        return view('pesanan.index', compact('pesanan'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        //
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        //
    }

    /**
     * Display the specified resource.
     */
    public function show($id)
    {
        $pesanan = Pemesanan::with(['pelanggan', 'detailPemesanans.menu'])->findOrFail($id);
        return response()->json($pesanan);
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        //
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        //
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        //
    }

    /**
     * Cetak struk pesanan
     */
    public function cetakStruk($id)
    {
        $pesanan = Pemesanan::with(['pelanggan', 'detailPemesanans.menu'])->findOrFail($id);

        // Cek status pesanan
        if (!in_array($pesanan->status, ['dibayar', 'diproses', 'selesai'])) {
            return redirect()->back()->with('error', 'Struk hanya dapat dicetak untuk pesanan yang sudah dibayar.');
        }

        $pdf = PDF::loadView('pesanan.struk', compact('pesanan'));
        return $pdf->stream('struk-pesanan-' . $id . '.pdf');
    }

    /**
     * Batalkan pesanan
     */
    public function batalkanPesanan($id)
    {
        $pesanan = Pemesanan::findOrFail($id);

        // Cek status pesanan
        if (in_array($pesanan->status, ['selesai', 'dibatalkan'])) {
            return redirect()->back()->with('error', 'Pesanan yang sudah selesai atau dibatalkan tidak dapat dibatalkan.');
        }

        $pesanan->status = 'dibatalkan';
        $pesanan->save();

        return redirect()->back()->with('success', 'Pesanan berhasil dibatalkan.');
    }
}
