<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\StokBahan;
use Illuminate\Support\Facades\Auth;

class StokController extends Controller
{
    /**
     * Display a listing of the resource.
     */
    public function index(Request $request)
    {
        $query = StokBahan::with('admin');

        // Filter berdasarkan satuan
        if ($request->has('satuan') && $request->satuan != '') {
            $query->where('satuan', $request->satuan);
        }

        // Filter berdasarkan pencarian
        if ($request->has('search') && $request->search != '') {
            $query->where('nama_bahan', 'like', '%' . $request->search . '%');
        }

        $stok = $query->orderBy('id')->paginate(10);

        return view('stok.index', compact('stok'));
    }

    /**
     * Show the form for creating a new resource.
     */
    public function create()
    {
        return view('stok.create');
    }

    /**
     * Store a newly created resource in storage.
     */
    public function store(Request $request)
    {
        $request->validate([
            'nama_bahan' => 'required|string|max:255',
            'jumlah' => 'required|integer|min:0',
            'satuan' => 'required|in:kg,liter,pcs,tandan,dus',
        ]);

        $data = $request->all();
        $data['id_admin'] = Auth::id();

        StokBahan::create($data);

        return redirect()->route('stok.index')->with('success', 'Stok bahan berhasil ditambahkan.');
    }

    /**
     * Display the specified resource.
     */
    public function show(string $id)
    {
        $stok = StokBahan::with('admin')->findOrFail($id);
        return view('stok.show', compact('stok'));
    }

    /**
     * Show the form for editing the specified resource.
     */
    public function edit(string $id)
    {
        $stok = StokBahan::findOrFail($id);
        return view('stok.edit', compact('stok'));
    }

    /**
     * Update the specified resource in storage.
     */
    public function update(Request $request, string $id)
    {
        $request->validate([
            'nama_bahan' => 'required|string|max:255',
            'jumlah' => 'required|integer|min:0',
            'satuan' => 'required|in:kg,liter,pcs,tandan,dus',
        ]);

        $stok = StokBahan::findOrFail($id);
        $stok->update($request->all());

        return redirect()->route('stok.index')->with('success', 'Stok bahan berhasil diperbarui.');
    }

    /**
     * Remove the specified resource from storage.
     */
    public function destroy(string $id)
    {
        $stok = StokBahan::findOrFail($id);
        $stok->delete();

        return redirect()->route('stok.index')->with('success', 'Stok bahan berhasil dihapus.');
    }
}
