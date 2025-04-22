<?php

namespace App\Http\Controllers;

use App\Models\Produk;
use App\Models\Admin; // Untuk relasi dengan Admin
use Illuminate\Http\Request;

class ProdukController extends Controller
{
    /**
     * Tampilkan daftar produk.
     */
    public function index()
    {
        // Ambil data produk beserta relasi admin dan paginasi
        $produk = Produk::with('admin')->paginate(10);

        // Ambil semua admin untuk dipilih pada form tambah produk
        $admins = Admin::all();

        // Kirim data produk dan admin ke view
        return view('produk.index', compact('produk', 'admins'));
    }

    /**
     * Simpan produk baru.
     */
    public function store(Request $request)
    {
        $validated = $request->validate([
            'nama' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'harga' => 'required|numeric',
            'stok' => 'required|integer',
            'gambar' => 'required|image|mimes:jpg,png,jpeg,gif|max:2048', // Validasi gambar
        ]);

        // Menyimpan gambar produk jika ada
        if ($request->hasFile('gambar')) {
            $imagePath = $request->file('gambar')->store('produk_gambar', 'public');
        }

        // Menyimpan data produk ke database
        Produk::create([
            'nama' => $validated['nama'],
            'deskripsi' => $validated['deskripsi'] ?? null, // Mengizinkan null
            'harga' => $validated['harga'],
            'stok' => $validated['stok'],
            'gambar' => $imagePath ?? null, // Menyimpan path gambar
            'id_admin' => auth()->user()->id, // ID Admin di-set otomatis
        ]);

        return redirect()->route('produk.index')->with('success', 'Produk berhasil ditambahkan');
    }

    /**
     * Tampilkan form edit produk.
     */
    public function edit($id)
    {
        $produk = Produk::findOrFail($id);
        $admins = Admin::all(); // Menampilkan semua admin untuk memilih
        return view('produk.edit', compact('produk', 'admins'));
    }

    /**
     * Update data produk.
     */
    public function update(Request $request, $id)
    {
        $request->validate([
            'nama' => 'required|string|max:255',
            'deskripsi' => 'nullable|string',
            'harga' => 'required|numeric',
            'stok' => 'required|numeric',
            'gambar' => 'nullable|image|mimes:jpeg,png,jpg,gif,svg|max:2048',
            'id_admin' => 'required|exists:admins,id_admin',
        ]);

        $produk = Produk::findOrFail($id);
        $produk->nama = $request->nama;
        $produk->deskripsi = $request->deskripsi;
        $produk->harga = $request->harga;
        $produk->stok = $request->stok;
        $produk->id_admin = $request->id_admin;

        if ($request->hasFile('gambar')) {
            $imagePath = $request->file('gambar')->store('produk_gambar', 'public');
            $produk->gambar = $imagePath;
        }

        $produk->save();

        return redirect()->route('produk.index')->with('success', 'Produk berhasil diperbarui');
    }

    /**
     * Hapus produk.
     */
    public function destroy($id)
    {
        $produk = Produk::findOrFail($id);
        $produk->delete();
        return redirect()->route('produk.index')->with('success', 'Produk berhasil dihapus');
    }
}
