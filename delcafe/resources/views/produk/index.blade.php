@extends('layouts.admin')

@section('title', 'Manajemen Menu - DelBites')
@section('page-title', 'Manajemen Menu')

@section('content')
<div class="container-fluid">
    <!-- Filter Form -->
    <div class="row mb-4">
        <div class="col-md-12">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <form action="{{ route('produk.index') }}" method="GET" class="row g-3 align-items-end">
                        <div class="col-md-4">
                            <label for="kategori" class="form-label">Filter Kategori</label>
                            <select name="kategori" id="kategori" class="form-select">
                                <option value="">Semua Kategori</option>
                                <option value="makanan" {{ request('kategori') == 'makanan' ? 'selected' : '' }}>Makanan</option>
                                <option value="minuman" {{ request('kategori') == 'minuman' ? 'selected' : '' }}>Minuman</option>
                            </select>
                        </div>
                        <div class="col-md-4">
                            <label for="search" class="form-label">Cari Menu</label>
                            <input type="text" name="search" id="search" class="form-control" value="{{ request('search') }}" placeholder="Masukkan nama menu...">
                        </div>
                        <div class="col-md-4 text-end">
                            <button type="submit" class="btn btn-primary me-2">Filter</button>
                            <a href="{{ route('produk.index') }}" class="btn btn-secondary">Reset</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Menu Table -->
    <div class="row">
        <div class="col-md-12">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white d-flex justify-content-between align-items-center">
                    <h5 class="mb-0">Daftar Menu</h5>
                    <a href="{{ route('produk.create') }}" class="btn btn-primary">
                        <i class="fas fa-plus me-1"></i> Tambah Menu
                    </a>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover align-middle">
                            <thead class="table-light">
                                <tr>
                                    <th>Gambar</th>
                                    <th>Nama Menu</th>
                                    <th>Kategori</th>
                                    <th>Harga</th>
                                    <th>Stok</th>
                                    <th>Terjual</th>
                                    <th>Aksi</th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse($produk as $p)
                                <tr>
                                    <td>
                                        <img src="{{ $p->gambar ? asset('storage/' . $p->gambar) : asset('icon/no-image.png') }}" alt="{{ $p->nama_menu }}" class="img-thumbnail" width="50">
                                    </td>
                                    <td>{{ $p->nama_menu }}</td>
                                    <td>
                                        <span class="badge {{ $p->kategori == 'makanan' ? 'bg-success' : 'bg-info' }}">
                                            {{ ucfirst($p->kategori) }}
                                        </span>
                                    </td>
                                    <td>Rp {{ number_format($p->harga, 0, ',', '.') }}</td>
                                    <td>{{ $p->stok }}</td>
                                    <td>{{ $p->stok_terjual }}</td>
                                    <td>
                                        <div class="btn-group" role="group">
                                            <a href="{{ route('produk.show', $p->id) }}" class="btn btn-sm btn-info" title="Lihat"><i class="fas fa-eye"></i></a>
                                            <a href="{{ route('produk.edit', $p->id) }}" class="btn btn-sm btn-warning" title="Edit"><i class="fas fa-edit"></i></a>
                                            <form action="{{ route('produk.destroy', $p->id) }}" method="POST" onsubmit="return confirm('Yakin ingin menghapus produk ini?')" class="d-inline">
                                                @csrf
                                                @method('DELETE')
                                                <button type="submit" class="btn btn-sm btn-danger" title="Hapus"><i class="fas fa-trash"></i></button>
                                            </form>
                                        </div>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="7" class="text-center">Tidak ada data produk</td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-center mt-3">
                        {{ $produk->appends(request()->query())->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    document.getElementById('kategori').addEventListener('change', function () {
        this.form.submit();
    });
</script>
@endsection
