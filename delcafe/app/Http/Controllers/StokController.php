<?php
namespace App\Http\Controllers;

use App\Models\Stok;
use App\Models\Produk;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Log;

class StokController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index()
    {
        $stok = Stok::with(['produk', 'admin'])->latest()->paginate(10);
        return view('stok.index', compact('stok'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        $produk = Produk::all();
        return view('stok.create', compact('produk'));
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        // Validasi inputan dari form
        $validated = $request->validate([
            'nama_barang' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'satuan' => 'required|string',
            'tipe' => 'required|in:masuk,keluar',
            'catatan' => 'nullable|string',
        ]);
        
        // Menambahkan id_admin dari user yang sedang login
        $validated['admin_id'] = Auth::user()->id_admin;

        // Menyimpan data stok
        $stok = Stok::create($validated);

        // Cek apakah data berhasil disimpan
        if ($stok) {
            Log::info('Stok berhasil disimpan:', ['stok' => $stok]);
        } else {
            Log::error('Stok gagal disimpan');
        }

        // Lanjutkan dengan pembaruan stok produk
        $produk = Produk::find($request->id_produk);
        if ($request->tipe == 'masuk') {
            $produk->stok += $request->jumlah;
        } else {
            $produk->stok -= $request->jumlah;
            if ($produk->stok < 0) {
                $produk->stok = 0;
            }
        }
        $produk->save();

        return redirect()->route('stok.index')->with('success', 'Stok berhasil diperbarui');
    }

    /**
     * Display the specified resource.
     */
    public function show(Stok $stok)
    {
        return view('stok.show', compact('stok'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(Stok $stok)
    {
        $produk = Produk::all();
        return view('stok.edit', compact('stok', 'produk'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, Stok $stok)
    {
        // Validasi inputan dari form
        $validated = $request->validate([
            'nama_barang' => 'required|string',
            'jumlah' => 'required|integer|min:1',
            'satuan' => 'required|string',
            'tipe' => 'required|in:masuk,keluar',
            'catatan' => 'nullable|string',
        ]);

        // Update admin_id
        $validated['admin_id'] = Auth::user()->id_admin;

        // Get the old stock data
        $oldProdukId = $stok->id_produk;
        $oldJumlah = $stok->jumlah;
        $oldTipe = $stok->tipe;

        // Update the stock entry
        $stok->update($validated);

        // Revert the old stock change
        $oldProduk = Produk::find($oldProdukId);
        if ($oldTipe == 'masuk') {
            $oldProduk->stok -= $oldJumlah;
            if ($oldProduk->stok < 0) {
                $oldProduk->stok = 0;
            }
        } else {
            $oldProduk->stok += $oldJumlah;
        }
        $oldProduk->save();

        // Apply the new stock change
        $newProduk = Produk::find($request->id_produk);
        if ($request->tipe == 'masuk') {
            $newProduk->stok += $request->jumlah;
        } else {
            $newProduk->stok -= $request->jumlah;
            if ($newProduk->stok < 0) {
                $newProduk->stok = 0;
            }
        }
        $newProduk->save();

        return redirect()->route('stok.index')->with('success', 'Stok berhasil diperbarui');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(Stok $stok)
    {
        // Revert the stock change
        $produk = Produk::find($stok->id_produk);
        if ($stok->tipe == 'masuk') {
            $produk->stok -= $stok->jumlah;
            if ($produk->stok < 0) {
                $produk->stok = 0;
            }
        } else {
            $produk->stok += $stok->jumlah;
        }
        $produk->save();

        // Delete the stock entry
        $stok->delete();

        return redirect()->route('stok.index')->with('success', 'Entri stok berhasil dihapus');
    }
}
