<?php

namespace App\Http\Controllers;

use App\Models\DetailPemesanan;
use Illuminate\Http\Request;

class DetailPemesananController extends Controller
{
    public function index()
    {
        return DetailPemesanan::with(['pemesanan', 'menu'])->get();
    }

    public function store(Request $request)
    {
        $request->validate([
            'id_pemesanan' => 'required|exists:pemesanan,id',
            'id_menu' => 'required|exists:menu,id',
            'jumlah' => 'required|integer',
            'harga_satuan' => 'required|integer',
            'subtotal' => 'required|integer',
        ]);

        return DetailPemesanan::create($request->all());
    }

    public function show($id)
    {
        return DetailPemesanan::with(['pemesanan', 'menu'])->findOrFail($id);
    }

    public function update(Request $request, $id)
    {
        $detail = DetailPemesanan::findOrFail($id);
        $detail->update($request->all());
        return $detail;
    }

    public function destroy($id)
    {
        DetailPemesanan::destroy($id);
        return response()->json(['message' => 'Deleted successfully']);
    }
}
