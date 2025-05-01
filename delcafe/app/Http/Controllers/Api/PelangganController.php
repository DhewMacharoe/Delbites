<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;

class PelangganController extends Controller
{
    public function index()
    {
        return response()->json(Pelanggan::all());
    }

    public function show($id)
    {
        $pelanggan = Pelanggan::find($id);
        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }
        return response()->json($pelanggan);
    }

    public function store(Request $request)
    {
        $request->validate([
            'nama' => 'required|string',
            'telepon' => 'required|string',
        ]);
    
        // Cek apakah pelanggan sudah ada berdasarkan nomor telepon
        $existing = Pelanggan::where('telepon', $request->telepon)->first();
    
        if ($existing) {
            // Jika sudah ada, kembalikan datanya tanpa buat baru
            return response()->json([
                'id' => $existing->id,
                'nama' => $existing->nama,
                'telepon' => $existing->telepon,
                'message' => 'Pelanggan sudah terdaftar',
            ], 200);
        }
    
        // Jika belum ada, buat pelanggan baru
        $pelanggan = Pelanggan::create([
            'nama' => $request->nama,
            'telepon' => $request->telepon,
        ]);
    
        return response()->json([
            'id' => $pelanggan->id,
            'nama' => $pelanggan->nama,
            'telepon' => $pelanggan->telepon,
            'message' => 'Pelanggan berhasil dibuat',
        ], 201);
    }
    
    

    public function update(Request $request, $id)
    {
        $pelanggan = Pelanggan::find($id);
        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        $pelanggan->update([
            'nama' => $request->nama ?? $pelanggan->nama,
            'telepon' => $request->telepon ?? $pelanggan->telepon,
        ]);

        return response()->json($pelanggan);
    }

    public function destroy($id)
    {
        $pelanggan = Pelanggan::find($id);
        if (!$pelanggan) {
            return response()->json(['message' => 'Pelanggan tidak ditemukan'], 404);
        }

        $pelanggan->delete();
        return response()->json(['message' => 'Pelanggan berhasil dihapus']);
    }
}
