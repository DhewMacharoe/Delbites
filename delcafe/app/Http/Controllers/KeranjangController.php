<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Keranjang;
use App\Models\Menu;
use App\Models\Pelanggan;

class KeranjangController extends Controller
{
    public function index()
    {
        $keranjangs = Keranjang::with(['pelanggan', 'menu'])->get();
        return response()->json($keranjangs);
    }

    /**
     * Show the specified cart item.
     */
    public function show($id)
    {
        $keranjang = Keranjang::with(['pelanggan', 'menu'])->findOrFail($id);
        return response()->json($keranjang);
    }

    /**
     * Store a newly created cart item in storage.
     */
    public function store(Request $request)
    {
        // Validate incoming request
        $request->validate([
            'id_pelanggan' => 'required|exists:pelanggan,id',
            'id_menu' => 'required|exists:menu,id',
            'nama_menu' => 'required|string|max:50',
            'kategori' => 'required|in:makanan,minuman',
            'harga' => 'required|numeric|min:0',
            'jumlah' => 'required|integer|min:1',
            'suhu' => 'nullable|string|max:20', // Added validation for temperature
            'catatan' => 'nullable|string|max:255', // Added validation for notes
        ]);

        // Create the cart item
        $keranjang = Keranjang::create($request->all());

        return response()->json($keranjang, 201);
    }

    /**
     * Update the specified cart item.
     */
    public function update(Request $request, $id)
    {
        $keranjang = Keranjang::findOrFail($id);

        // Validate incoming request
        $request->validate([
            'id_pelanggan' => 'sometimes|exists:pelanggan,id',
            'id_menu' => 'sometimes|exists:menu,id',
            'nama_menu' => 'sometimes|string|max:50',
            'kategori' => 'sometimes|in:makanan,minuman',
            'harga' => 'sometimes|numeric|min:0',
            'jumlah' => 'sometimes|integer|min:1',
            'suhu' => 'nullable|string|max:20', // Added validation for temperature
            'catatan' => 'nullable|string|max:255', // Added validation for notes
        ]);

        // Update the cart item
        $keranjang->update($request->all());

        return response()->json($keranjang);
    }

    /**
     * Remove the specified cart item from storage.
     */
    public function destroy($id)
    {
        $keranjang = Keranjang::findOrFail($id);
        $keranjang->delete();

        return response()->json(['message' => 'Cart item successfully deleted']);
    }

    /**
     * Remove all items from the cart of a specific customer.
     */
    public function clearCart($id_pelanggan)
    {
        Keranjang::where('id_pelanggan', $id_pelanggan)->delete();

        return response()->json(['message' => 'All items have been removed from the cart']);
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
}