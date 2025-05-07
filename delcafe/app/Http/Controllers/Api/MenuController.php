<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Models\Menu;

class MenuController extends Controller
{
    // Menampilkan semua menu dengan total penjualan
    public function index()
    {
        $menu = Menu::with('detailPemesanans')->get();

        // Menambahkan total penjualan per menu
        $menu = $menu->map(function ($item) {
            $item->total_terjual = $item->detailPemesanans->sum('jumlah');
            return $item;
        });

        return response()->json($menu);
    }

    // Menampilkan menu tertentu berdasarkan ID
    public function show($id)
    {
        return response()->json(Menu::findOrFail($id));
    }

    // Menambahkan menu baru
    public function store(Request $request)
    {
        $request->validate([
            'admin_id' => 'required|exists:admins,admin_id',
            'nama_menu' => 'required|string|max:50',
            'kategori' => 'required|in:makanan,minuman',
            'harga' => 'required|numeric|min:0',
            'stok' => 'required|integer|min:0',
            'gambar' => 'nullable|string|max:100',
        ]);

        $menu = Menu::create($request->all());
        return response()->json($menu, 201);
    }

    // Memperbarui menu
    public function update(Request $request, $id)
    {
        $menu = Menu::findOrFail($id);
        $request->validate([
            'admin_id' => 'sometimes|exists:admins,admin_id',
            'nama_menu' => 'sometimes|string|max:50',
            'kategori' => 'sometimes|in:makanan,minuman',
            'harga' => 'sometimes|numeric|min:0',
            'stok' => 'sometimes|integer|min:0',
            'gambar' => 'nullable|string|max:100',
        ]);

        $menu->update($request->all());
        return response()->json($menu);
    }

    // Menghapus menu
    public function destroy($id)
    {
        Menu::findOrFail($id)->delete();
        return response()->json(['message' => 'Menu berhasil dihapus']);
    }

    // Menampilkan menu terlaris
    public function topMenu()
    {
        $menu = Menu::with('detailPemesanans')->get();

        // Menambahkan total penjualan per menu
        $menu = $menu->map(function ($item) {
            $item->total_terjual = $item->detailPemesanans->sum('jumlah');
            return $item;
        });

        // Urutkan berdasarkan jumlah penjualan terbanyak
        $sortedMenu = $menu->sortByDesc('total_terjual')->values()->take(8);

        return response()->json($sortedMenu);
    }
}
