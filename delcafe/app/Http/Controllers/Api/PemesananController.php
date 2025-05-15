<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pemesanan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Log;
use App\Models\DetailPemesanan;

class PemesananController extends Controller
{
    public function index()
    {
        return response()->json(Pemesanan::with('detailPemesanan')->get());
    }
    public function store(Request $request)
    {
        Log::info('Incoming request:', $request->all());

        $request->validate([
            'id_pelanggan' => 'required|exists:pelanggan,id',
            'admin_id' => 'nullable|integer',
            'total_harga' => 'required|integer',
            'metode_pembayaran' => 'required|in:tunai,qris,transfer bank',
            'waktu_pemesanan' => 'nullable|date',
            'waktu_pengambilan' => 'nullable|date',
            'status' => 'nullable|in:menunggu,pembayaran,dibayar,diproses,selesai,dibatalkan',
            'detail_pemesanan' => 'required|array|min:1',
            'detail_pemesanan.*.id_menu' => 'required|exists:menu,id',
            'detail_pemesanan.*.jumlah' => 'required|integer|min:1',
            'detail_pemesanan.*.harga_satuan' => 'required|integer|min:0',
            'detail_pemesanan.*.subtotal' => 'required|integer|min:0',
            'detail_pemesanan.*.suhu' => 'nullable|string|max:20',
            'detail_pemesanan.*.catatan' => 'nullable|string|max:255',

        ]);

        try {
            DB::beginTransaction();

            $pemesanan = Pemesanan::create([
                'id_pelanggan' => $request->id_pelanggan,
                'admin_id' => $request->admin_id,
                'total_harga' => $request->total_harga,
                'metode_pembayaran' => $request->metode_pembayaran,
                'status' => $request->status ?? 'menunggu',
                'waktu_pemesanan' => now(),
                'waktu_pengambilan' => $request->waktu_pengambilan,
            ]);
            foreach ($request->detail_pemesanan as $item) {
                $pemesanan->detailPemesanan()->create([
                    'id_menu' => $item['id_menu'],
                    'jumlah' => $item['jumlah'],
                    'harga_satuan' => $item['harga_satuan'],
                    'subtotal' => $item['subtotal'],
                    'catatan' => $item['catatan'] ?? null, // ✅ tambahkan ini
                    'suhu' => $item['suhu'] ?? null,
                ]);
            }

            DB::commit();
            return response()->json([
                'success' => true,
                'message' => 'Pemesanan dan detail berhasil disimpan',
                'data' => $pemesanan->load('detailPemesanan')
            ], 201);
        } catch (\Exception $e) {
            DB::rollBack();
            Log::error('Pemesanan gagal: ' . $e->getMessage());
            return response()->json([
                'success' => false,
                'message' => 'Gagal menyimpan: ' . $e->getMessage()
            ], 500);
        }
    }

    public function show(string $id)
    {
        $pemesanan = Pemesanan::with('detailPemesanan')->find($id);
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
        $request->validate(['total_harga' => 'sometimes|integer', 'metode_pembayaran' => 'sometimes|in:tunai,qris,transfer bank', 'status' => 'sometimes|in:menunggu,pembayaran,dibayar,diproses,selesai,dibatalkan', 'waktu_pemesanan' => 'nullable|date', 'waktu_pengambilan' => 'nullable|date',]);
        $pemesanan->update($request->all());
        return response()->json(['success' => true, 'message' => 'Pemesanan berhasil diupdate', 'data' => $pemesanan]);
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
    public function getByPelanggan($id, Request $request)
    {
        $status = $request->query('status');

        $query = Pemesanan::with(['detailPemesanan.menu'])
            ->where('id_pelanggan', $id);

        if ($status) {
            $query->where('status', $status);
        }

        $pesanan = $query->orderBy('created_at', 'desc')->paginate(10);

        return response()->json($pesanan);
    }

    public function beriRating(Request $request, $id)
    {
        $request->validate([
            'rating' => 'required|numeric|min:1|max:5'
        ]);

        $detail = \App\Models\DetailPemesanan::findOrFail($id);
        $detail->rating = $request->rating;
        $detail->save();

        return response()->json(['message' => 'Rating disimpan']);
    }
}
