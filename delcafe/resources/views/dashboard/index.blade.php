@extends('layouts.admin')

@section('title', 'Dashboard - DelBites')

@section('page-title', 'Dashboard')

@section('content')
<div class="container-fluid">
    <!-- Statistik -->
    <div class="row mb-4">
        <div class="col-md-3 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Total Pesanan</h6>
                            <h4 class="mb-0">{{ $totalPesanan }}</h4>
                        </div>
                        <div class="bg-primary bg-opacity-10 p-3 rounded">
                            <i class="fas fa-shopping-cart text-primary"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Total Pelanggan</h6>
                            <h4 class="mb-0">{{ $totalPelanggan }}</h4>
                        </div>
                        <div class="bg-success bg-opacity-10 p-3 rounded">
                            <i class="fas fa-users text-success"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Total Menu</h6>
                            <h4 class="mb-0">{{ $totalMenu }}</h4>
                        </div>
                        <div class="bg-warning bg-opacity-10 p-3 rounded">
                            <i class="fas fa-box text-warning"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <div class="col-md-3 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center">
                        <div>
                            <h6 class="text-muted mb-2">Total Stok Bahan</h6>
                            <h4 class="mb-0">{{ $totalStok }}</h4>
                        </div>
                        <div class="bg-info bg-opacity-10 p-3 rounded">
                            <i class="fas fa-boxes text-info"></i>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Pesanan Terbaru -->
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Pesanan Terbaru (FIFO)</h5>
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
                                @forelse($pesananTerbaru as $pesanan)
                                <tr>
                                    <td>#{{ $pesanan->id }}</td>
                                    <td>{{ $pesanan->pelanggan->nama }}</td>
                                    <td>{{ $pesanan->created_at->format('d/m/Y H:i') }}</td>
                                    <td>Rp {{ number_format($pesanan->total_harga, 0, ',', '.') }}</td>
                                    <td>
                                        @if($pesanan->status == 'menunggu')
                                            <span class="badge bg-warning">Menunggu</span>
                                        @elseif($pesanan->status == 'pembayaran')
                                            <span class="badge bg-info">Pembayaran</span>
                                        @elseif($pesanan->status == 'dibayar')
                                            <span class="badge bg-primary">Dibayar</span>
                                        @elseif($pesanan->status == 'diproses')
                                            <span class="badge bg-secondary">Diproses</span>
                                        @elseif($pesanan->status == 'selesai')
                                            <span class="badge bg-success">Selesai</span>
                                        @elseif($pesanan->status == 'dibatalkan')
                                            <span class="badge bg-danger">Dibatalkan</span>
                                        @endif
                                    </td>
                                    <td>
                                        <button type="button" class="btn btn-primary btn-sm" 
                                                data-bs-toggle="modal" 
                                                data-bs-target="#detailModal" 
                                                data-id="{{ $pesanan->id }}">
                                            Detail
                                        </button>
                                    </td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="6" class="text-center">Tidak ada pesanan terbaru</td>
                                </tr>
                                @endforelse
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Menu Terlaris -->
    <div class="row">
        <div class="col-12 mb-4">
            <div class="card border-0 shadow-sm">
                <div class="card-header bg-white">
                    <h5 class="mb-0">Menu Terlaris</h5>
                </div>
                <div class="card-body">
                    <div class="table-responsive">
                        <table class="table table-hover">
                            <thead>
                                <tr>
                                    <th>Menu</th>
                                    <th>Kategori</th>
                                    <th>Harga</th>
                                    <th>Terjual</th>
                                </tr>
                            </thead>
                            <tbody>
                                @forelse($menuTerlaris as $menu)
                                <tr>
                                    <td>{{ $menu->nama_menu }}</td>
                                    <td>
                                        @if($menu->kategori == 'makanan')
                                            <span class="badge bg-success">Makanan</span>
                                        @else
                                            <span class="badge bg-info">Minuman</span>
                                        @endif
                                    </td>
                                    <td>Rp {{ number_format($menu->harga, 0, ',', '.') }}</td>
                                    <td>{{ $menu->stok_terjual }}</td>
                                </tr>
                                @empty
                                <tr>
                                    <td colspan="4" class="text-center">Tidak ada data menu</td>
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

<!-- Modal Detail Pesanan -->
<div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
    <div class="modal-dialog modal-lg">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="detailModalLabel">Detail Pesanan</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <div class="row mb-3">
                    <div class="col-md-6">
                        <p><strong>ID Pelanggan:</strong> <span id="idPelanggan"></span></p>
                        <p><strong>Nama Pelanggan:</strong> <span id="namaPelanggan"></span></p>
                    </div>
                    <div class="col-md-6">
                        <p><strong>Total:</strong> <span id="totalHarga"></span></p>
                        <p><strong>Metode Pembayaran:</strong> <span id="metodePembayaran"></span></p>
                    </div>
                </div>
                
                <h6 class="mb-3">Daftar Pesanan</h6>
                <div class="table-responsive">
                    <table class="table table-bordered">
                        <thead>
                            <tr>
                                <th>Nama Makanan</th>
                                <th>Harga</th>
                                <th>Jumlah</th>
                                <th>Subtotal</th>
                            </tr>
                        </thead>
                        <tbody id="detailPesananBody">
                            <!-- Data akan diisi melalui JavaScript -->
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
            </div>
        </div>
    </div>
</div>
@endsection

@section('scripts')
<script>
    // Script untuk mengambil detail pesanan saat modal dibuka
    document.addEventListener('DOMContentLoaded', function() {
        const detailModal = document.getElementById('detailModal');
        
        detailModal.addEventListener('show.bs.modal', function(event) {
            const button = event.relatedTarget;
            const id = button.getAttribute('data-id');
            
            // Fetch detail pesanan dari server
            fetch(`/dashboard/detail-pesanan/${id}`)
                .then(response => response.json())
                .then(data => {
                    // Isi data ke dalam modal
                    document.getElementById('idPelanggan').textContent = data.pesanan.id_pelanggan;
                    document.getElementById('namaPelanggan').textContent = data.pesanan.pelanggan.nama;
                    document.getElementById('totalHarga').textContent = 'Rp ' + new Intl.NumberFormat('id-ID').format(data.pesanan.total_harga);
                    
                    let metodePembayaran = '';
                    switch(data.pesanan.metode_pembayaran) {
                        case 'tunai':
                            metodePembayaran = 'Tunai';
                            break;
                        case 'qris':
                            metodePembayaran = 'QRIS';
                            break;
                        case 'transfer bank':
                            metodePembayaran = 'Transfer Bank';
                            break;
                        default:
                            metodePembayaran = data.pesanan.metode_pembayaran;
                    }
                    document.getElementById('metodePembayaran').textContent = metodePembayaran;
                    
                    // Isi tabel detail pesanan
                    const detailBody = document.getElementById('detailPesananBody');
                    detailBody.innerHTML = '';
                    
                    data.details.forEach(detail => {
                        const row = document.createElement('tr');
                        
                        const namaMakanan = document.createElement('td');
                        namaMakanan.textContent = detail.menu.nama_menu;
                        
                        const harga = document.createElement('td');
                        harga.textContent = 'Rp ' + new Intl.NumberFormat('id-ID').format(detail.harga_satuan);
                        
                        const jumlah = document.createElement('td');
                        jumlah.textContent = detail.jumlah;
                        
                        const subtotal = document.createElement('td');
                        subtotal.textContent = 'Rp ' + new Intl.NumberFormat('id-ID').format(detail.subtotal);
                        
                        row.appendChild(namaMakanan);
                        row.appendChild(harga);
                        row.appendChild(jumlah);
                        row.appendChild(subtotal);
                        
                        detailBody.appendChild(row);
                    });
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('Terjadi kesalahan saat mengambil data pesanan.');
                });
        });
    });
</script>
@endsection