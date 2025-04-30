<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Pelanggan;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;

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
            'telepon' => 'nullable|string',
            'password' => 'required|string|min:6',
            'status' => 'in:aktif,nonaktif',
        ]);

        $pelanggan = Pelanggan::create([
            'nama' => $request->nama,
            'telepon' => $request->telepon,
            'password' => Hash::make($request->password),
            'status' => $request->status ?? 'aktif',
        ]);

        return response()->json($pelanggan, 201);
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
            'status' => $request->status ?? $pelanggan->status,
            'password' => $request->password
                ? Hash::make($request->password)
                : $pelanggan->password,
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

    public function loginAtauRegister(Request $request)
    {
        $noHp = $request->no_hp;
        $nama = $request->nama;

        if (!$noHp) {
            return response()->json(['error' => 'Nomor HP wajib diisi'], 400);
        }

        $pelanggan = \App\Models\Pelanggan::firstOrCreate(
            ['no_hp' => $noHp],
            [
                'nama' => $nama ?? 'Pelanggan',
                'password' => Hash::make('12345678'), // default password
                'status' => 'aktif',
            ]
        );

        return response()->json([
            'id_pelanggan' => $pelanggan->id,
            'nama' => $pelanggan->nama,
            'no_hp' => $pelanggan->no_hp,
        ]);
    }
    public function loginManual(Request $request)
    {
        $request->validate([
            'no_hp' => 'required',
            'password' => 'required',
        ]);

        $pelanggan = \App\Models\Pelanggan::where('no_hp', $request->no_hp)->first();

        if (!$pelanggan || !Hash::check($request->password, $pelanggan->password)) {
            return response()->json(['error' => 'Login gagal. Periksa nomor HP dan password.'], 401);
        }

        return response()->json([
            'id_pelanggan' => $pelanggan->id,
            'nama' => $pelanggan->nama,
            'no_hp' => $pelanggan->no_hp,
        ]);
    }
}
