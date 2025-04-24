@extends('layouts.admin')

@section('title', 'Detail Produk - DelBites')

@section('page-title', 'Detail Produk')

@section('content')
<div class="container-fluid">
    <div class="row">
        <div class="col-md-12 mb-4">
            <div class="d-flex justify-content-end">
                <a href="{{ route('produk.index') }}" class="btn btn-secondary">
                    <i class="fas fa-arrow-left me-1"></i> Kembali
                </a>
            </div>
        </div>
    </div>
    
    <div class="row">
        <div class="col-md-4 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body text-center">
                    @if($produk->gambar)
                        <img src="{{ asset('storage/menu/' . $produk->gambar) }}" alt="{{ $produk->nama_menu }}" class="img-fluid rounded mb-3" style="max-height: 200px;">
                    @else
                        <img src="{{ asset('icon/no-image.png') }}" alt="No Image" class="img-fluid rounded mb-3" style="max-height: 200px;">
                    @endif
                    
                    <h4>{{ $produk->nama_menu }}</h4>
                    <p class="mb-1">
                        @if($produk->kategori == 'makanan')
                            <span class="badge bg-success">Makanan</span>
                        @else
                            <span class="badge bg-info">Minuman</span>
                        @endif
                    </p>
                    <h5 class="text-primary">Rp {{ number_format($produk->harga, 0, ',', '.') }}</h5>
                </div>
            </div>
        </div>
        
        <div class="col-md-8">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Informasi Produk</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-borderless">
                            <tr>
                                <th style="width: 30%">ID Produk</th>
                                <td>{{ $produk->id }}</td>
                            </tr>
                            <tr>
                                <th>Nama Produk</th>
                                <td>{{ $produk->nama_menu }}</td>
                            </tr>
                            <tr>
                                <th>Kategori</th>
                                <td>
                                    @if($produk->kategori == 'makanan')
                                        <span class="badge bg-success">Makanan</span>
                                    @else
                                        <span class="badge bg-info">Minuman</span>
                                    @endif
                                </td>
                            </tr>
                            <tr>
                                <th>Harga</th>
                                <td>Rp {{ number_format($produk->harga, 0, ',', '.') }}</td>
                            </tr>
                            <tr>
                                <th>Stok</th>
                                <td>{{ $produk->stok }}</td>
                            </tr>
                            <tr>
                                <th>Terjual</th>
                                <td>{{ $produk->stok_terjual }}</td>
                            </tr>
                            <tr>
                                <th>Ditambahkan Oleh</th>
                                <td>{{ $produk->admin->nama ?? 'Admin' }}</td>
                            </tr>
                            <tr>
                                <th>Tanggal Ditambahkan</th>
                                <td>{{ $produk->created_at->format('d/m/Y H:i') }}</td>
                            </tr>
                            <tr>
                                <th>Terakhir Diperbarui</th>
                                <td>{{ $produk->updated_at->format('d/m/Y H:i') }}</td>
                            </tr>
                        </table>
                    </div>
                    
                    <div class="d-flex justify-content-end mt-3">
                        <a href="{{ route('produk.edit', $produk->id) }}" class="btn btn-warning me-2">
                            <i class="fas fa-edit me-1"></i> Edit
                        </a>
                        <form action="{{ route('produk.destroy', $produk->id) }}" method="POST" onsubmit="return confirm('Apakah Anda yakin ingin menghapus produk ini?')">
                            @csrf
                            @method('DELETE')
                            <button type="submit" class="btn btn-danger">
                                <i class="fas fa-trash me-1"></i> Hapus
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection