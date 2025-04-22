@extends('layouts.admin')

@section('title', 'Manajemen Produk - Admin Panel')

@section('page-title', 'Produk')

@section('styles')
    <style>
        .product-image {
            width: 50px;
            height: 50px;
            object-fit: cover;
            border-radius: 4px;
        }

        .table-responsive {
            overflow: visible !important;
        }

        .table td,
        .table th {
            vertical-align: middle;
        }

        .dropdown {
            position: relative;
        }

        .dropdown-menu {
            z-index: 1050;
        }

        .dropzone {
            border: 2px dashed #ccc;
            border-radius: 5px;
            padding: 20px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s;
        }

        .dropzone:hover {
            border-color: #007bff;
        }

        .dropzone.dragover {
            border-color: #28a745;
            background-color: rgba(40, 167, 69, 0.1);
        }

        .preview-image {
            max-width: 100%;
            max-height: 200px;
            margin-top: 10px;
            border-radius: 5px;
        }
    </style>
@endsection

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-md-6">
                <h1 class="h3">Manajemen Produk</h1>
                <p class="text-muted">Kelola semua produk di sini</p>
            </div>
            <div class="col-md-6 d-flex justify-content-md-end align-items-center">
                <div class="input-group me-2" style="max-width: 300px;">
                    <input type="text" class="form-control" placeholder="Cari produk...">
                    <button class="btn btn-outline-secondary" type="button">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
                <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createProductModal">
                    Tambah Produk
                </button>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Daftar Produk</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Gambar</th>
                                <th>Nama Produk</th>
                                <th>Harga</th>
                                <th>Stok</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($produk as $item)
                                <tr>
                                    <td>{{ $item->id }}</td>
                                    <td>
                                        @if ($item->gambar)
                                            <img src="{{ asset('storage/' . $item->gambar) }}" alt="{{ $item->nama }}"
                                                class="product-image">
                                        @else
                                            <div class="bg-light rounded d-flex align-items-center justify-content-center"
                                                style="width: 50px; height: 50px;">
                                                <i class="fas fa-image text-muted"></i>
                                            </div>
                                        @endif
                                    </td>
                                    <td>{{ $item->nama }}</td>
                                    <td>Rp {{ number_format($item->harga, 0, ',', '.') }}</td>
                                    <td>
                                        @if ($item->stok > 10)
                                            <span class="badge bg-success">{{ $item->stok }}</span>
                                        @elseif($item->stok > 0)
                                            <span class="badge bg-warning text-dark">{{ $item->stok }}</span>
                                        @else
                                            <span class="badge bg-danger">Habis</span>
                                        @endif
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-sm btn-primary me-1 view-product"
                                            data-id="{{ $item->id }}" data-name="{{ $item->nama }}"
                                            data-description="{{ $item->deskripsi }}" data-price="{{ $item->harga }}"
                                            data-stock="{{ $item->stok }}"
                                            data-photo="{{ asset('storage/' . $item->gambar) }}">
                                            <i class="fas fa-eye"></i> Detail
                                        </button>

                                        <button type="button" class="btn btn-sm btn-warning me-1 edit-product"
                                            data-id="{{ $item->id }}" data-name="{{ $item->nama }}"
                                            data-description="{{ $item->deskripsi }}" data-price="{{ $item->harga }}"
                                            data-stock="{{ $item->stok }}"
                                            data-photo="{{ asset('storage/' . $item->gambar) }}">
                                            <i class="fas fa-edit"></i> Edit
                                        </button>

                                        <form action="{{ route('produk.destroy', $item) }}" method="POST" class="d-inline"
                                            onsubmit="return confirm('Apakah Anda yakin ingin menghapus produk ini?')">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-danger">
                                                <i class="fas fa-trash-alt"></i> Hapus
                                            </button>
                                        </form>
                                    </td>

                                </tr>
                            @endforeach
                        </tbody>
                    </table>

                    <!-- Pagination -->
                    <div class="d-flex justify-content-center mt-4">
                        {{ $produk->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Tambah Produk -->
    <div class="modal fade" id="createProductModal" tabindex="-1" aria-labelledby="createProductModalLabel"
        aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="createProductModalLabel">Tambah Produk</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <form action="{{ route('produk.store') }}" method="POST" enctype="multipart/form-data">
                    @csrf
                    <div class="modal-body">
                        <!-- Nama Produk -->
                        <div class="mb-3">
                            <label for="productName" class="form-label">Nama Produk</label>
                            <input type="text" class="form-control" id="productName" name="nama" required>
                        </div>

                        <!-- Deskripsi Produk (nullable) -->
                        <div class="mb-3">
                            <label for="productDescription" class="form-label">Deskripsi Produk</label>
                            <textarea class="form-control" id="productDescription" name="deskripsi"></textarea>
                        </div>

                        <!-- Harga Produk -->
                        <div class="mb-3">
                            <label for="productPrice" class="form-label">Harga</label>
                            <input type="number" class="form-control" id="productPrice" name="harga" required>
                        </div>

                        <!-- Stok Produk -->
                        <div class="mb-3">
                            <label for="productStock" class="form-label">Stok</label>
                            <input type="number" class="form-control" id="productStock" name="stok" required>
                        </div>

                        <!-- Gambar Produk -->
                        <div class="mb-3">
                            <label for="productImage" class="form-label">Gambar Produk</label>
                            <input type="file" class="form-control" id="productImage" name="gambar" required>
                        </div>

                        <!-- Admin ID (Hidden, di-set otomatis) -->
                        <input type="hidden" name="id_admin" value="{{ auth()->user()->id }}">
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                        <button type="submit" class="btn btn-primary">Simpan</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- Modal Lihat Detail Produk -->
    <div class="modal fade" id="modalDetailProduk" tabindex="-1" aria-labelledby="modalDetailProdukLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="modalDetailProdukLabel">Detail Produk</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
                </div>
                <div class="modal-body">
                    <div class="row">
                        <div class="col-md-4 text-center">
                            <img id="detail-gambar" class="img-fluid rounded" alt="Gambar Produk">
                        </div>
                        <div class="col-md-8">
                            <h5 id="detail-nama"></h5>
                            <p id="detail-deskripsi" class="text-muted"></p>
                            <p><strong>Harga:</strong> Rp <span id="detail-harga"></span></p>
                            <p><strong>Stok:</strong> <span id="detail-stok"></span></p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Edit Produk -->
    <div class="modal fade" id="modalEditProduk" tabindex="-1" aria-labelledby="modalEditProdukLabel"
        aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <form id="formEditProduk" method="POST" enctype="multipart/form-data">
                    @csrf
                    @method('PUT')
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalEditProdukLabel">Edit Produk</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Tutup"></button>
                    </div>
                    <div class="modal-body">
                        <input type="hidden" id="edit-id" name="id">
                        <div class="mb-3">
                            <label for="edit-nama" class="form-label">Nama Produk</label>
                            <input type="text" class="form-control" id="edit-nama" name="nama" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-deskripsi" class="form-label">Deskripsi</label>
                            <textarea class="form-control" id="edit-deskripsi" name="deskripsi" rows="3"></textarea>
                        </div>
                        <div class="mb-3">
                            <label for="edit-harga" class="form-label">Harga</label>
                            <input type="number" class="form-control" id="edit-harga" name="harga" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-stok" class="form-label">Stok</label>
                            <input type="number" class="form-control" id="edit-stok" name="stok" required>
                        </div>
                        <div class="mb-3">
                            <label for="edit-gambar" class="form-label">Gambar (jika ingin diganti)</label>
                            <input type="file" class="form-control" id="edit-gambar" name="gambar">
                            <img id="edit-preview" src="" alt="Preview Gambar" class="mt-2" width="100">
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batal</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

@endsection
@section('scripts')
    <script>
        // Tampilkan modal detail produk
        document.querySelectorAll('.view-product').forEach(button => {
            button.addEventListener('click', function() {
                document.getElementById('detail-nama').textContent = this.dataset.name;
                document.getElementById('detail-deskripsi').textContent = this.dataset.description || '-';
                document.getElementById('detail-harga').textContent = Number(this.dataset.price)
                    .toLocaleString('id-ID');
                document.getElementById('detail-stok').textContent = this.dataset.stock;
                document.getElementById('detail-gambar').src = this.dataset.photo;
                new bootstrap.Modal(document.getElementById('modalDetailProduk')).show();
            });
        });

        // Tampilkan modal edit produk
        document.querySelectorAll('.edit-product').forEach(button => {
            button.addEventListener('click', function() {
                const id = this.dataset.id;
                document.getElementById('edit-nama').value = this.dataset.name;
                document.getElementById('edit-deskripsi').value = this.dataset.description;
                document.getElementById('edit-harga').value = this.dataset.price;
                document.getElementById('edit-stok').value = this.dataset.stock;
                document.getElementById('edit-preview').src = this.dataset.photo;
                document.getElementById('formEditProduk').action = `/produk/${id}`;
                new bootstrap.Modal(document.getElementById('modalEditProduk')).show();
            });
        });
    </script>
@endsection
