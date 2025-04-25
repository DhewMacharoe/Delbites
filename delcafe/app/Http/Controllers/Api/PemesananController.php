<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pemesanan;
use Illuminate\Http\Request;

class PemesananController extends Controller
{
    public function index()
    {
        return response()->json(Pemesanan::all());
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_pelanggan' => 'required|exists:pelanggan,id',
            'total_harga' => 'required|integer',
            'metode_pembayaran' => 'required|in:tunai,qris,transfer bank',
            'waktu_pemesanan' => 'nullable|date',
            'waktu_pengambilan' => 'nullable|date',
            'status' => 'nullable|in:menunggu,pembayaran,dibayar,diproses,selesai,dibatalkan',
        ]);

        $pemesanan = Pemesanan::create($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Pemesanan berhasil dibuat',
            'data' => $pemesanan
        ], 201);
    }

    public function show(string $id)
    {
        $pemesanan = Pemesanan::find($id);
        if (!$pemesanan) {
            return response()->json(['message' => 'Pemesanan tidak ditemukan'], 404);
        }

        return response()->json($pemesanan);
    }

    public function update(Request $request, string $id)
    {
        $pemesanan = Pemesanan::find($id);
        if (!$pemesanan) {
            return response()->json(['message' => 'Pemesanan tidak ditemukan'], 404);
        }

        $request->validate([
            'total_harga' => 'sometimes|integer',
            'metode_pembayaran' => 'sometimes|in:tunai,qris,transfer bank',
            'status' => 'sometimes|in:menunggu,pembayaran,dibayar,diproses,selesai,dibatalkan',
            'waktu_pemesanan' => 'nullable|date',
            'waktu_pengambilan' => 'nullable|date',
        ]);

        $pemesanan->update($request->all());

        return response()->json([
            'success' => true,
            'message' => 'Pemesanan berhasil diupdate',
            'data' => $pemesanan
        ]);
    }

    public function destroy(string $id)
    {
        $pemesanan = Pemesanan::find($id);
        if (!$pemesanan) {
            return response()->json(['message' => 'Pemesanan tidak ditemukan'], 404);
        }

        $pemesanan->delete();

        return response()->json(['message' => 'Pemesanan berhasil dihapus']);
    }

    public function getByPelanggan(Request $request)
    {
        $request->validate([
            'id_pelanggan' => 'required|integer|exists:pelanggan,id',
        ]);

        $status = $request->query('status');

        $query = Pemesanan::where('id_pelanggan', $request->id_pelanggan);

        if ($status) {
            $query->where('status', $status);
        }

        $pemesanan = $query->orderBy('created_at', 'desc')->get();

        return response()->json([
            'success' => true,
            'data' => $pemesanan
        ]);
    }
}
