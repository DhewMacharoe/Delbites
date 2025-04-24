<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Menu;
use Illuminate\Http\Request;

class MenuController extends Controller
{
    public function index()
    {
        return response()->json(Menu::all(), 200);
    }

    public function show($id)
    {
        $menu = Menu::find($id);
        if (!$menu) return response()->json(['message' => 'Menu tidak ditemukan'], 404);
        return response()->json($menu, 200);
    }

    public function store(Request $request)
    {
        $menu = Menu::create($request->all());
        return response()->json($menu, 201);
    }

    public function update(Request $request, $id)
    {
        $menu = Menu::find($id);
        if (!$menu) return response()->json(['message' => 'Menu tidak ditemukan'], 404);
        $menu->update($request->all());
        return response()->json($menu, 200);
    }

    public function destroy($id)
    {
        $menu = Menu::find($id);
        if (!$menu) return response()->json(['message' => 'Menu tidak ditemukan'], 404);
        $menu->delete();
        return response()->json(['message' => 'Menu berhasil dihapus'], 200);
    }
}
