<?php

namespace App\Http\Controllers;

use App\Models\Pelanggan;
use Illuminate\Http\Request;

class PelangganController extends Controller
{
    // Menampilkan daftar pelanggan
    public function index()
    {
        $pelanggan = Pelanggan::latest()->paginate(10); // Mengambil data pelanggan dengan paging
        return view('pelanggan.index', compact('pelanggan')); // Menampilkan view pelanggan.index
    }

    // Mendapatkan detail pelanggan dalam format JSON untuk diambil via AJAX
    public function showDetail(Pelanggan $pelanggan)
    {
        return response()->json($pelanggan); // Mengembalikan data pelanggan dalam format JSON
    }

    // Mencari pelanggan berdasarkan keyword
    public function search(Request $request)
    {
        $keyword = $request->input('keyword'); // Menangkap input keyword dari pencarian
        
        $pelanggan = Pelanggan::where('nama', 'like', "%{$keyword}%")
            ->orWhere('email', 'like', "%{$keyword}%")
            ->orWhere('telepon', 'like', "%{$keyword}%")
            ->paginate(10); // Melakukan pencarian dan pagination
        
        return view('pelanggan.index', compact('pelanggan', 'keyword')); // Mengembalikan view dengan hasil pencarian
    }

    // Menghapus pelanggan
    public function destroy(Pelanggan $pelanggan)
    {
        // Cek apakah pelanggan memiliki pesanan
        if ($pelanggan->pesanan()->count() > 0) {
            return redirect()->route('pelanggan.index')
                ->with('error', 'Pelanggan tidak dapat dihapus karena memiliki pesanan');
        }

        $pelanggan->delete(); // Menghapus data pelanggan
        
        return redirect()->route('pelanggan.index')
            ->with('success', 'Pelanggan berhasil dihapus'); // Kembali dengan pesan sukses
    }
}
