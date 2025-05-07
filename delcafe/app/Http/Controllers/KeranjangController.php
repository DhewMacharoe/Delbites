<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Keranjang;
use App\Models\Pemesanan;
use App\Models\DetailPemesanan;
use Carbon\Carbon;

class KeranjangController extends Controller
{
    // Menampilkan semua data keranjang dengan relasi
    public function index()
    {
        $keranjangs = Keranjang::with(['pelanggan', 'menu'])->get();
        return response()->json($keranjangs);
    }

    // Menampilkan satu item keranjang berdasarkan ID
    public function show($id)
    {
        $keranjang = Keranjang::with(['pelanggan', 'menu'])->findOrFail($id);
        return response()->json($keranjang);
    }

public function store(Request $request)
{
    $validated = $request->validate([
        'id_pelanggan' => 'required|exists:pelanggan,id',
        'id_menu' => 'required|exists:menu,id',
        'nama_menu' => 'required|string|max:255',
        'kategori' => 'required|in:makanan,minuman',
        'harga' => 'required|numeric|min:0',
        'jumlah' => 'required|integer|min:1',
        'suhu' => 'nullable|string|max:20',
        'catatan' => 'nullable|string|max:255',
    ]);

    // Cek apakah item sudah ada di keranjang
    $existingItem = Keranjang::where('id_pelanggan', $validated['id_pelanggan'])
        ->where('id_menu', $validated['id_menu'])
        ->when($validated['kategori'] == 'minuman', function ($query) use ($validated) {
            return $query->where('suhu', $validated['suhu']);
        })
        ->first();

    if ($existingItem) {
        $existingItem->increment('jumlah', $validated['jumlah']);
        return response()->json([
            'message' => 'Jumlah item berhasil ditambah',
            'data' => $existingItem
        ], 200);
    }

    $keranjang = Keranjang::create($validated);
    
    return response()->json([
        'message' => 'Item berhasil ditambahkan ke keranjang',
        'data' => $keranjang
    ], 201);
}


    // Mengupdate item keranjang berdasarkan ID
    public function update(Request $request, $id)
    {
        $keranjang = Keranjang::findOrFail($id);

        $validated = $request->validate([
            'id_pelanggan' => 'sometimes|exists:pelanggan,id',
            'id_menu' => 'sometimes|exists:menu,id',
            'nama_menu' => 'sometimes|string|max:50',
            'kategori' => 'sometimes|in:makanan,minuman',
            'harga' => 'sometimes|numeric|min:0',
            'jumlah' => 'sometimes|integer|min:1',
            'suhu' => 'nullable|string|max:20',
            'catatan' => 'nullable|string|max:255',
        ]);

        $keranjang->update($validated);
        return response()->json($keranjang);
    }

    // Menghapus satu item keranjang berdasarkan ID
    public function destroy($id)
    {
        $keranjang = Keranjang::findOrFail($id);
        $keranjang->delete();

        return response()->json(['message' => 'Item berhasil dihapus dari keranjang']);
    }

    // Menghapus semua item keranjang berdasarkan ID pelanggan
    public function clearCart($id_pelanggan)
    {
        Keranjang::where('id_pelanggan', $id_pelanggan)->delete();
        return response()->json(['message' => 'Seluruh keranjang telah dikosongkan']);
    }


    /**
     * Get cart items for a specific customer.
     */
    public function getCartByCustomer($id_pelanggan)
    {
        $keranjangs = Keranjang::where('id_pelanggan', $id_pelanggan)
            ->with('menu')
            ->get();


        return response()->json($keranjangs);
    }

    public function checkout($id_pelanggan)
    {
        // Ambil semua isi keranjang berdasarkan id_pelanggan
        $keranjangs = Keranjang::where('id_pelanggan', $id_pelanggan)->get();

        if ($keranjangs->isEmpty()) {
            return response()->json(['message' => 'Keranjang kosong'], 400);
        }

        // Hitung total harga
        $totalHarga = $keranjangs->sum(function ($item) {
            return $item->harga * $item->jumlah;
        });

        // Buat pemesanan
        $pemesanan = Pemesanan::create([
            'id_pelanggan' => $id_pelanggan,
            'total_harga' => $totalHarga,
            'status' => 'menunggu',
            'waktu_pemesanan' => Carbon::now(),
        ]);

        // Simpan ke detail_pemesanan
        foreach ($keranjangs as $item) {
            DetailPemesanan::create([
                'id_pemesanan' => $pemesanan->id,
                'id_menu' => $item->id_menu,
                'jumlah' => $item->jumlah,
                'harga_satuan' => $item->harga,
                'subtotal' => $item->harga * $item->jumlah,
            ]);
        }

        // Kosongkan keranjang
        Keranjang::where('id_pelanggan', $id_pelanggan)->delete();

        return response()->json([
            'message' => 'Pemesanan berhasil dibuat',
            'pemesanan' => $pemesanan
        ], 201);
    }
    // Tambahkan method baru untuk mendapatkan keranjang berdasarkan pelanggan
    public function getByPelanggan($id_pelanggan)
    {
        $keranjang = Keranjang::where('id_pelanggan', $id_pelanggan)
            ->with('menu')
            ->get();

        return response()->json($keranjang);
    }
}
