<!-- resources/views/stocks/index.blade.php -->
@extends('layouts.admin')

@section('title', 'Manajemen Stok - Admin Panel')

@section('page-title', 'Stok')

@section('content')
<div class="container-fluid">
    <div class="row mb-4">
        <div class="col-md-6">
            <h1 class="h3">Manajemen Stok</h1>
            <p class="text-muted">Kelola stok bahan yang tersedia</p>
        </div>
        <div class="col-md-6 d-flex justify-content-md-end align-items-center">
            <div class="input-group me-2" style="max-width: 300px;">
                <input type="text" class="form-control" placeholder="Cari bahan...">
                <button class="btn btn-outline-secondary" type="button">
                    <i class="fas fa-search"></i>
                </button>
            </div>
            <button class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#createStockModal">
                <i class="fas fa-plus me-1"></i> Tambah Bahan
            </button>
        </div>
    </div>
    
    <div class="card">
        <div class="card-header">
            <h5 class="card-title mb-0">Daftar Stok Bahan</h5>
        </div>
        <div class="card-body">
            <div class="table-responsive">
                <table class="table table-hover">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nama Bahan</th>
                            <th>Deskripsi</th>
                            <th class="text-center">Jumlah</th>
                            <th>Satuan</th>
                            <th class="text-end">Harga per Satuan</th>
                            <th class="text-end">Total Nilai</th>
                            <th class="text-center">Aksi</th>
                        </tr>
                    </thead>
                    <tbody>
                        @forelse($stocks as $stock)
                        <tr>
                            <td>{{ $stock->id }}</td>
                            <td>{{ $stock->name }}</td>
                            <td>{{ Str::limit($stock->description, 30) }}</td>
                            <td class="text-center">
                                @if($stock->quantity > 10)
                                    <span class="badge bg-success">{{ $stock->quantity }}</span>
                                @elseif($stock->quantity > 0)
                                    <span class="badge bg-warning">{{ $stock->quantity }}</span>
                                @else
                                    <span class="badge bg-danger">Habis</span>
                                @endif
                            </td>
                            <td>{{ $stock->unit }}</td>
                            <td class="text-end">Rp {{ number_format($stock->price_per_unit, 0, ',', '.') }}</td>
                            <td class="text-end">Rp {{ number_format($stock->quantity * $stock->price_per_unit, 0, ',', '.') }}</td>
                            <td class="text-center">
                                <button class="btn btn-sm btn-info edit-stock" 
                                        data-id="{{ $stock->id }}"
                                        data-name="{{ $stock->name }}"
                                        data-description="{{ $stock->description }}"
                                        data-quantity="{{ $stock->quantity }}"
                                        data-unit="{{ $stock->unit }}"
                                        data-price="{{ $stock->price_per_unit }}">
                                    <i class="fas fa-edit"></i>
                                </button>
                                <button class="btn btn-sm btn-danger delete-stock" 
                                        data-id="{{ $stock->id }}" 
                                        data-name="{{ $stock->name }}">
                                    <i class="fas fa-trash"></i>
                                </button>
                            </td>
                        </tr>
                        @empty
                        <tr>
                            <td colspan="8" class="text-center py-4">Tidak ada data stok</td>
                        </tr>
                        @endforelse
                    </tbody>
                </table>
            </div>
            
            <div class="d-flex justify-content-center mt-4">
                {{ $stocks->links() }}
            </div>
        </div>
    </div>
</div>

<!-- Create Stock Modal -->
<div class="modal fade" id="createStockModal" tabindex="-1" aria-labelledby="createStockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="createStockModalLabel">Tambah Bahan Baru</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form action="{{ route('stocks.store') }}" method="POST">
                @csrf
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="name" class="form-label">Nama Bahan</label>
                        <input type="text" class="form-control" id="name" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="description" name="description" rows="3"></textarea>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="quantity" class="form-label">Jumlah</label>
                            <input type="number" class="form-control" id="quantity" name="quantity" min="0" required>
                        </div>
                        <div class="col-md-6">
                            <label for="unit" class="form-label">Satuan</label>
                            <select class="form-select" id="unit" name="unit" required>
                                <option value="pcs">Pcs</option>
                                <option value="kg">Kg</option>
                                <option value="gram">Gram</option>
                                <option value="liter">Liter</option>
                                <option value="ml">ml</option>
                                <option value="box">Box</option>
                                <option value="pack">Pack</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="price_per_unit" class="form-label">Harga per Satuan (Rp)</label>
                        <input type="number" class="form-control" id="price_per_unit" name="price_per_unit" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batalkan</button>
                    <button type="submit" class="btn btn-primary">Simpan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Edit Stock Modal -->
<div class="modal fade" id="editStockModal" tabindex="-1" aria-labelledby="editStockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="editStockModalLabel">Edit Bahan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <form id="editStockForm" method="POST">
                @csrf
                @method('PUT')
                <div class="modal-body">
                    <div class="mb-3">
                        <label for="edit_name" class="form-label">Nama Bahan</label>
                        <input type="text" class="form-control" id="edit_name" name="name" required>
                    </div>
                    <div class="mb-3">
                        <label for="edit_description" class="form-label">Deskripsi</label>
                        <textarea class="form-control" id="edit_description" name="description" rows="3"></textarea>
                    </div>
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <label for="edit_quantity" class="form-label">Jumlah</label>
                            <input type="number" class="form-control" id="edit_quantity" name="quantity" min="0" required>
                        </div>
                        <div class="col-md-6">
                            <label for="edit_unit" class="form-label">Satuan</label>
                            <select class="form-select" id="edit_unit" name="unit" required>
                                <option value="pcs">Pcs</option>
                                <option value="kg">Kg</option>
                                <option value="gram">Gram</option>
                                <option value="liter">Liter</option>
                                <option value="ml">ml</option>
                                <option value="box">Box</option>
                                <option value="pack">Pack</option>
                            </select>
                        </div>
                    </div>
                    <div class="mb-3">
                        <label for="edit_price_per_unit" class="form-label">Harga per Satuan (Rp)</label>
                        <input type="number" class="form-control" id="edit_price_per_unit" name="price_per_unit" min="0" required>
                    </div>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batalkan</button>
                    <button type="submit" class="btn btn-primary">Simpan Perubahan</button>
                </div>
            </form>
        </div>
    </div>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteStockModal" tabindex="-1" aria-labelledby="deleteStockModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="deleteStockModalLabel">Konfirmasi Hapus</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <p>Yakin untuk menghapus bahan <strong id="deleteStockName"></strong>?</p>
                <p class="text-danger">Tindakan ini tidak dapat dibatalkan.</p>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Batalkan</button>
                <form id="deleteStockForm" method="POST">
                    @csrf
                    @method('DELETE')
                    <button type="submit" class="btn btn-danger">Hapus Bahan</button>
                </form>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    document.addEventListener('DOMContentLoaded', function() {
        // Edit stock button click
        const editButtons = document.querySelectorAll('.edit-stock');
        const editStockForm = document.getElementById('editStockForm');
        const editStockModal = new bootstrap.Modal(document.getElementById('editStockModal'));
        
        editButtons.forEach(button => {
            button.addEventListener('click', function() {
                const id = this.dataset.id;
                const name = this.dataset.name;
                const description = this.dataset.description;
                const quantity = this.dataset.quantity;
                const unit = this.dataset.unit;
                const price = this.dataset.price;
                
                document.getElementById('edit_name').value = name;
                document.getElementById('edit_description').value = description;
                document.getElementById('edit_quantity').value = quantity;
                document.getElementById('edit_unit').value = unit;
                document.getElementById('edit_price_per_unit').value = price;
                
                editStockForm.action = `/stocks/${id}`;
                editStockModal.show();
            });
        });
        
        // Delete stock button click
        const deleteButtons = document.querySelectorAll('.delete-stock');
        const deleteStockForm = document.getElementById('deleteStockForm');
        const deleteStockName = document.getElementById('deleteStockName');
        const deleteStockModal = new bootstrap.Modal(document.getElementById('deleteStockModal'));
        
        deleteButtons.forEach(button => {
            button.addEventListener('click', function() {
                const id = this.dataset.id;
                const name = this.dataset.name;
                
                deleteStockName.textContent = name;
                deleteStockForm.action = `/stocks/${id}`;
                deleteStockModal.show();
            });
        });
    });
</script>
@endsection