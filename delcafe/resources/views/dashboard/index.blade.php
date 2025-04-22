<!-- resources/views/dashboard/index.blade.php -->
@extends('layouts.admin')

@section('title', 'Dashboard - DelBites')

@section('page-title', 'Dashboard')

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-12">
                <h1 class="h3">Selamat Datang di Panel Admin DelBites</h1>
                <p class="text-muted">Lihat statistik dan kelola pesanan Anda</p>
            </div>
        </div>

        <div class="row">
            <!-- Total Pendapatan -->
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="card-title mb-0">Total Pendapatan</h6>
                            <div class="icon">
                                <i class="fas fa-dollar-sign"></i>
                            </div>
                        </div>
                        <h2 class="mb-1">Rp {{ number_format($totalRevenue, 0, ',', '.') }}</h2>
                        <div class="d-flex align-items-center">
                            <span class="text-muted small">Bulan ini</span>
                            <span class="ms-2 badge bg-success d-flex align-items-center">
                                <i class="fas fa-arrow-up me-1"></i> 12%
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Total Pesanan -->
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="card-title mb-0">Total Pesanan</h6>
                            <div class="icon">
                                <i class="fas fa-shopping-cart"></i>
                            </div>
                        </div>
                        <h2 class="mb-1">{{ $totalOrders }}</h2>
                        <div class="d-flex align-items-center">
                            <span class="text-muted small">Bulan ini</span>
                            <span class="ms-2 badge bg-success d-flex align-items-center">
                                <i class="fas fa-arrow-up me-1"></i> 8%
                            </span>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Stok Habis -->
            <div class="col-lg-4 col-md-6 mb-4">
                <div class="card stat-card h-100">
                    <div class="card-body">
                        <div class="d-flex justify-content-between align-items-center mb-3">
                            <h6 class="card-title mb-0">Stok Habis</h6>
                            <div class="icon">
                                <i class="fas fa-box"></i>
                            </div>
                        </div>
                        <h2 class="mb-1">{{ $outOfStockCount }}</h2>
                        <div class="d-flex align-items-center">
                            <span class="text-muted small">Produk</span>
                            <span class="ms-2 badge bg-danger d-flex align-items-center">
                                <i class="fas fa-arrow-down me-1"></i> 3
                            </span>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- resources/views/dashboard/index.blade.php -->
        <!-- Replace the orders table section with this -->

        <div class="row mt-4">
            <div class="col-12">
                <div class="card">
                    <div class="card-header">
                        <h5 class="card-title mb-0">Pesanan Menunggu</h5>
                    </div>
                    <div class="card-body">
                        <div class="table-responsive">
                            <table class="table table-hover">
                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Pelanggan</th>
                                        <th>Tanggal</th>
                                        <th>Total</th>
                                        <th>Status</th>
                                        <th>Aksi</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    @forelse($pendingOrders as $pesanan)
                                    <tr>
                                        <td>#ORD-{{ str_pad($pesanan->id, 3, '0', STR_PAD_LEFT) }}</td>
                                        <td>{{ $pesanan->pelanggan->nama }}</td>
                                        <td>{{ $pesanan->created_at->format('Y-m-d H:i') }}</td>
                                        <td>Rp {{ number_format($pesanan->total_harga, 0, ',', '.') }}</td>
                                        <td><span class="badge bg-warning">Menunggu</span></td>
                                        <td>
                                            <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#orderDetailModal{{ $pesanan->id }}">
                                                Detail
                                            </button>
                                        </td>
                                    </tr>
                                    @empty
                                    <tr>
                                        <td colspan="6" class="text-center py-4">Tidak ada pesanan yang menunggu</td>
                                    </tr>
                                    @endforelse
                                </tbody>
                            </table>
                        </div>
                        <div class="text-end mt-3">
                            <a href="{{ route('pesanan.index') }}" class="btn btn-primary">Lihat Semua Pesanan</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- Create a separate modal for each pesanan -->
        @foreach($pendingOrders as $pesanan)
        <!-- Order Detail Modal for Order #{{ $pesanan->id }} -->
        <div class="modal fade" id="orderDetailModal{{ $pesanan->id }}" tabindex="-1" aria-labelledby="orderDetailModalLabel{{ $pesanan->id }}" aria-hidden="true">
            <div class="modal-dialog modal-lg">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="orderDetailModalLabel{{ $pesanan->id }}">Detail Pesanan #ORD-{{ str_pad($pesanan->id, 3, '0', STR_PAD_LEFT) }}</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <div class="container-fluid">
                            <!-- Basic Order Info -->
                            <div class="row mb-4">
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0">Informasi Pesanan</h6>
                                        </div>
                                        <div class="card-body">
                                            <table class="table table-borderless">
                                                <tr>
                                                    <th style="width: 40%">ID Pelanggan</th>
                                                    <td>CUST-{{ str_pad($pesanan->id_pelanggan, 3, '0', STR_PAD_LEFT) }}</td>
                                                </tr>
                                                <tr>
                                                    <th>Nama Pelanggan</th>
                                                    <td>{{ $pesanan->pelanggan->nama }}</td>
                                                </tr>
                                                <tr>
                                                    <th>Total</th>
                                                    <td>Rp {{ number_format($pesanan->total_harga, 0, ',', '.') }}</td>
                                                </tr>
                                                <tr>
                                                    <th>Status</th>
                                                    <td>
                                                        @if($pesanan->status == 'menunggu')
                                                        <span class="badge bg-warning">Menunggu</span>
                                                        @elseif($pesanan->status == 'pembayaran')
                                                        <span class="badge bg-warning text-dark">Pembayaran</span>
                                                        @elseif($pesanan->status == 'dibayar')
                                                        <span class="badge bg-info">Dibayar</span>
                                                        @elseif($pesanan->status == 'diproses')
                                                        <span class="badge bg-primary">Diproses</span>
                                                        @elseif($pesanan->status == 'selesai')
                                                        <span class="badge bg-success">Selesai</span>
                                                        @elseif($pesanan->status == 'dibatalkan')
                                                        <span class="badge bg-danger">Dibatalkan</span>
                                                        @endif
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <th>Metode Pembayaran</th>
                                                    <td>{{ $pesanan->metode_pembayaran == 'tunai' ? 'Tunai' : 'Transfer' }}</td>
                                                </tr>
                                            </table>
                                        </div>
                                    </div>
                                </div>
                                <div class="col-md-6">
                                    <div class="card h-100">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0">Catatan</h6>
                                        </div>
                                        <div class="card-body">
                                            <p class="mb-0">{{ $pesanan->catatan ?? '-' }}</p>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <!-- Order Items -->
                            <div class="row">
                                <div class="col-12">
                                    <div class="card">
                                        <div class="card-header">
                                            <h6 class="card-title mb-0">Makanan yang Dipesan</h6>
                                        </div>
                                        <div class="card-body">
                                            <div class="table-responsive">
                                                <table class="table table-bordered">
                                                    <thead>
                                                        <tr>
                                                            <th>Nama Makanan</th>
                                                            <th class="text-center">Harga</th>
                                                            <th class="text-center">Jumlah</th>
                                                            <th class="text-end">Subtotal</th>
                                                        </tr>
                                                    </thead>
                                                    <tbody>
                                                        @forelse($pesanan->items as $item)
                                                        <tr>
                                                            <td>{{ $item->produk->nama }}</td>
                                                            <td class="text-center">Rp {{ number_format($item->harga, 0, ',', '.') }}</td>
                                                            <td class="text-center">{{ $item->jumlah }}</td>
                                                            <td class="text-end">Rp {{ number_format($item->harga * $item->jumlah, 0, ',', '.') }}</td>
                                                        </tr>
                                                        @empty
                                                        <tr>
                                                            <td colspan="4" class="text-center">Tidak ada item</td>
                                                        </tr>
                                                        @endforelse
                                                    </tbody>
                                                </table>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <form action="{{ route('pesanan.update.status', ['pesanan' => $pesanan->id]) }}" method="POST">
                            @csrf
                            @method('PUT')
                            <button type="button" class="btn btn-danger me-2" onclick="confirmCancel(this.form, 'dibatalkan')">
                                <i class="fas fa-times-circle me-1"></i> Batalkan Pesanan
                            </button>
                            <button type="button" class="btn btn-success" onclick="confirmAccept(this.form, 'diproses')">
                                <i class="fas fa-check-circle me-1"></i> Terima Pesanan
                            </button>
                            <input type="hidden" name="status" id="status_{{ $pesanan->id }}">
                        </form>
                    </div>
                </div>
            </div>
        </div>
        @endforeach
        
        <!-- Confirmation Modal -->
        <div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel" aria-hidden="true">
            <div class="modal-dialog">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="confirmationModalLabel">Konfirmasi</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body" id="confirmationMessage">
                        Yakin untuk melakukan tindakan ini?
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tidak</button>
                        <button type="button" class="btn btn-primary" id="confirmActionBtn">Ya, Lanjutkan</button>
                    </div>
                </div>
            </div>
        </div>
    
@endsection

{{-- 
<!-- Order Detail Modal -->
<!-- resources/views/dashboard/index.blade.php -->
<!-- Replace the entire pesanan detail modal with this simplified version -->

<!-- Order Detail Modal -->
<div class="modal fade" id="orderDetailModal" tabindex="-1" aria-labelledby="orderDetailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="orderDetailModalLabel">Detail Pesanan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="container-fluid">
                    <!-- Basic Order Info -->
                    <div class="row mb-4">
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Informasi Pesanan</h6>
                                </div>
                                <div class="card-body">
                                    <table class="table table-borderless">
                                        <tr>
                                            <th style="width: 40%">ID Pelanggan</th>
                                            <td id="customer-id">CUST-001</td>
                                        </tr>
                                        <tr>
                                            <th>Total</th>
                                            <td id="pesanan-total">Rp 75.000</td>
                                        </tr>
                                        <tr>
                                            <th>Status</th>
                                            <td id="pesanan-status"><span class="badge bg-warning">Menunggu</span></td>
                                        </tr>
                                        <tr>
                                            <th>Metode Pembayaran</th>
                                            <td id="payment-method">Cash</td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card h-100">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Catatan</h6>
                                </div>
                                <div class="card-body">
                                    <p id="pesanan-notes" class="mb-0">-</p>
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Order Items -->
                    <div class="row">
                        <div class="col-12">
                            <div class="card">
                                <div class="card-header">
                                    <h6 class="card-title mb-0">Makanan yang Dipesan</h6>
                                </div>
                                <div class="card-body">
                                    <div class="table-responsive">
                                        <table class="table table-bordered">
                                            <thead>
                                                <tr>
                                                    <th>Nama Makanan</th>
                                                    <th class="text-center">Harga</th>
                                                    <th class="text-center">Jumlah</th>
                                                    <th class="text-end">Subtotal</th>
                                                </tr>
                                            </thead>
                                            <tbody id="pesanan-items">
                                                <!-- Order items will be inserted here dynamically -->
                                            </tbody>
                                        </table>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <form id="updateOrderStatusForm" method="POST"
                    action="{{ route('orders.update.status', ['pesanan' => 1]) }}">
                    @csrf
                    @method('PUT')
                    <input type="hidden" name="status" id="updateStatusValue">
                    <input type="hidden" name="order_id" id="updateOrderId">
                    <button type="button" class="btn btn-danger me-2" id="cancelOrderBtn">
                        <i class="fas fa-times-circle me-1"></i> Batalkan Pesanan
                    </button>
                    <button type="button" class="btn btn-success" id="acceptOrderBtn">
                        <i class="fas fa-check-circle me-1"></i> Terima Pesanan
                    </button>
                </form>
            </div>
        </div>
    </div>
</div>

<!-- Confirmation Modal -->
<div class="modal fade" id="confirmationModal" tabindex="-1" aria-labelledby="confirmationModalLabel"
    aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="confirmationModalLabel">Konfirmasi</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body" id="confirmationMessage">
                Yakin untuk melakukan tindakan ini?
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tidak</button>
                <button type="button" class="btn btn-primary" id="confirmActionBtn">Ya, Lanjutkan</button>
            </div>
        </div>
    </div>
</div> --}}


<!-- resources/views/dashboard/index.blade.php -->
<!-- Replace the JavaScript for the pesanan detail modal -->
<!-- resources/views/dashboard/index.blade.php -->
<!-- Replace the JavaScript for the pesanan detail modal -->

<!-- resources/views/dashboard/index.blade.php -->
<!-- Add this to the scripts section -->

@section('scripts')
<script>
    let currentForm = null;
    const confirmationModal = new bootstrap.Modal(document.getElementById('confirmationModal'));
    const confirmActionBtn = document.getElementById('confirmActionBtn');
    const confirmationMessage = document.getElementById('confirmationMessage');

    function confirmCancel(form, status) {
        currentForm = form;
        const statusInput = form.querySelector('input[name="status"]');
        statusInput.value = status;
        confirmationMessage.textContent = 'Yakin untuk membatalkan pesanan ini?';
        confirmActionBtn.className = 'btn btn-danger';
        confirmActionBtn.onclick = submitForm;
        confirmationModal.show();
    }

    function confirmAccept(form, status) {
        currentForm = form;
        const statusInput = form.querySelector('input[name="status"]');
        statusInput.value = status;
        confirmationMessage.textContent = 'Yakin untuk menerima pesanan ini?';
        confirmActionBtn.className = 'btn btn-success';
        confirmActionBtn.onclick = submitForm;
        confirmationModal.show();
    }

    function submitForm() {
        if (currentForm) {
            currentForm.submit();
        }
        confirmationModal.hide();
    }
</script>
@endsection