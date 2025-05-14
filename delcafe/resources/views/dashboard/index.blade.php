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
                        <h5 class="mb-0">Pesanan Terbaru</h5>
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
                                                @if ($pesanan->status == 'menunggu')
                                                    <span class="badge bg-warning">Menunggu</span>
                                                @endif
                                            </td>
                                            <td>
                                                <button type="button" class="btn btn-primary btn-sm" data-bs-toggle="modal"
                                                    data-bs-target="#detailModal" data-id="{{ $pesanan->id }}">
                                                    Detail
                                                </button>
                                            </td>
                                        </tr>
                                    @empty
                                        <tr>
                                            <td colspan="6" class="text-center">Tidak ada pesanan menunggu</td>
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
                                                @if ($menu->kategori == 'makanan')
                                                    <span class="badge bg-success">Makanan</span>
                                                @else
                                                    <span class="badge bg-info">Minuman</span>
                                                @endif
                                            </td>
                                            <td>Rp {{ number_format($menu->harga, 0, ',', '.') }}</td>
                                            <td>{{ $menu->total_terjual }}</td>
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
                    <h5 class="modal-title" id="detailModalLabel">Detail Pesanan #<span id="pesananId"></span></h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div class="row mb-3">
                        <div class="col-md-6">
                            <p><strong>ID Pelanggan:</strong> <span id="idPelanggan"></span></p>
                            <p><strong>Nama Pelanggan:</strong> <span id="namaPelanggan"></span></p>
                            <p><strong>Telepon:</strong> <span id="teleponPelanggan"></span></p>
                        </div>
                        <div class="col-md-6">
                            <p><strong>Tanggal Pesanan:</strong> <span id="tanggalPesanan"></span></p>
                            <p><strong>Total:</strong> <span id="totalHarga"></span></p>
                            <p><strong>Metode Pembayaran:</strong> <span id="metodePembayaran"></span></p>
                            <p><strong>Status:</strong> <span id="statusPesanan"></span></p>
                        </div>
                    </div>

                    <h6 class="mb-3">Daftar Pesanan</h6>
                    <div class="table-responsive">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>Nama Menu</th>
                                    <th>Harga</th>
                                    <th>Jumlah</th>
                                    <th>Subtotal</th>
                                    <th>Suhu</th>
                                    <th>Catatan</th>
                                </tr>
                            </thead>
                            <tbody id="detailPesananBody">
                                <!-- Data akan diisi melalui JavaScript -->
                            </tbody>
                        </table>
                    </div>
                    <div class="modal-footer" id="modalFooter">
                        <!-- Tombol akan diisi secara dinamis berdasarkan status -->
                    </div>
                </div>
            </div>
        </div>
    @endsection

    @section('scripts')
        <script>
            document.addEventListener('DOMContentLoaded', function() {
                const detailModal = document.getElementById('detailModal');

                detailModal.addEventListener('show.bs.modal', function(event) {
                    const button = event.relatedTarget;
                    const id = button.getAttribute('data-id');
                    const modalFooter = document.getElementById('modalFooter');

                    // Kosongkan footer modal terlebih dahulu
                    modalFooter.innerHTML =
                        '<button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>';

                    // Fetch detail pesanan dari server
                    fetch(`/pesanan/${id}`)
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(data => {
                            // Isi data ke dalam modal
                            document.getElementById('pesananId').textContent = data.id;
                            document.getElementById('idPelanggan').textContent = data.id_pelanggan;
                            document.getElementById('namaPelanggan').textContent = data.pelanggan.nama;
                            document.getElementById('teleponPelanggan').textContent = data.pelanggan
                                .telepon || '-';
                            document.getElementById('tanggalPesanan').textContent = new Date(data
                                .created_at).toLocaleString('id-ID');
                            document.getElementById('totalHarga').textContent = 'Rp ' + new Intl
                                .NumberFormat('id-ID').format(data.total_harga);

                            // Format metode pembayaran
                            let metodePembayaran = '';
                            switch (data.metode_pembayaran) {
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
                                    metodePembayaran = data.metode_pembayaran;
                            }
                            document.getElementById('metodePembayaran').textContent = metodePembayaran;

                            // Format status
                            let statusBadge = '';
                            switch (data.status) {
                                case 'menunggu':
                                    statusBadge = '<span class="badge bg-warning">Menunggu</span>';
                                    break;
                                case 'pembayaran':
                                    statusBadge = '<span class="badge bg-info">Pembayaran</span>';
                                    break;
                                case 'dibayar':
                                    statusBadge = '<span class="badge bg-primary">Dibayar</span>';
                                    break;
                                case 'diproses':
                                    statusBadge = '<span class="badge bg-secondary">Diproses</span>';
                                    break;
                                case 'selesai':
                                    statusBadge = '<span class="badge bg-success">Selesai</span>';
                                    break;
                                case 'dibatalkan':
                                    statusBadge = '<span class="badge bg-danger">Dibatalkan</span>';
                                    break;
                            }
                            document.getElementById('statusPesanan').innerHTML = statusBadge;

                            // Isi tabel detail pesanan
                            const detailBody = document.getElementById('detailPesananBody');
                            detailBody.innerHTML = '';

                            data.detail_pemesanan.forEach(detail => {
                                const row = document.createElement('tr');

                                const cells = [
                                    detail.menu.nama_menu,
                                    'Rp ' + new Intl.NumberFormat('id-ID').format(detail
                                        .harga_satuan),
                                    detail.jumlah,
                                    'Rp ' + new Intl.NumberFormat('id-ID').format(detail
                                        .subtotal),
                                    detail.suhu || '-',
                                    detail.catatan || '-'
                                ];

                                cells.forEach(cellData => {
                                    const cell = document.createElement('td');
                                    cell.textContent = cellData;
                                    row.appendChild(cell);
                                });

                                detailBody.appendChild(row);
                            });

                            // Set tombol WhatsApp
                            const telepon = data.pelanggan.telepon.replace(/[^0-9]/g, '');
                            let formattedPhone = telepon.startsWith('0') ? '62' + telepon.substring(1) :
                                telepon;

                            const statusText = {
                                'menunggu': 'Pesanan Anda sedang menunggu konfirmasi.',
                                'pembayaran': 'Silakan segera lakukan pembayaran.',
                                'dibayar': 'Pembayaran Anda telah kami terima.',
                                'diproses': 'Pesanan Anda sedang diproses.',
                                'selesai': 'Pesanan Anda telah selesai. Terima kasih!',
                                'dibatalkan': 'Pesanan Anda telah dibatalkan.'
                            } [data.status] || `Status pesanan Anda: ${data.status}`;

                            const pesan =
                                `Halo ${data.pelanggan.nama},\n\nPesanan Anda di *DelBites*:\nTotal: Rp ${new Intl.NumberFormat('id-ID').format(data.total_harga)}\nStatus: *${data.status.charAt(0).toUpperCase() + data.status.slice(1)}*\n\n${statusText}\n\nTerima kasih telah memesan.`;

                            // Kosongkan footer modal dan buat tombol berdasarkan status
                            modalFooter.innerHTML = '';

                            // Tombol WhatsApp untuk semua status
                            const whatsappBtn = document.createElement('a');
                            whatsappBtn.className = 'btn btn-success me-2';
                            whatsappBtn.href =
                                `https://wa.me/${formattedPhone}?text=${encodeURIComponent(pesan)}`;
                            whatsappBtn.target = '_blank';
                            whatsappBtn.innerHTML = '<i class="fab fa-whatsapp"></i> Hubungi Pelanggan';
                            modalFooter.appendChild(whatsappBtn);

                            // Tombol khusus untuk status menunggu
                            if (data.status === 'menunggu') {
                                const terimaBtn = document.createElement('button');
                                terimaBtn.className = 'btn btn-primary';
                                terimaBtn.innerHTML = '<i class="fas fa-check-circle"></i> Terima Pesanan';
                                terimaBtn.onclick = function() {
                                    updateStatus(data.id, 'pembayaran');
                                };
                                modalFooter.appendChild(terimaBtn);
                            } else {
                                // Tombol tutup untuk status selain menunggu
                                const closeBtn = document.createElement('button');
                                closeBtn.className = 'btn btn-secondary';
                                closeBtn.setAttribute('data-bs-dismiss', 'modal');
                                closeBtn.textContent = 'Tutup';
                                modalFooter.appendChild(closeBtn);

                                // Tombol cetak struk untuk status yang sesuai
                                if (['dibayar', 'diproses', 'selesai'].includes(data.status)) {
                                    const cetakBtn = document.createElement('a');
                                    cetakBtn.className = 'btn btn-primary ms-2';
                                    cetakBtn.href = `/pesanan/cetak-struk/${data.id}`;
                                    cetakBtn.target = '_blank';
                                    cetakBtn.innerHTML = '<i class="fas fa-print"></i> Cetak Struk';
                                    modalFooter.appendChild(cetakBtn);
                                }
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Terjadi kesalahan saat mengambil data pesanan.');
                        });
                });

                function updateStatus(pesananId, status) {
                    fetch(`/pesanan/status/${pesananId}/${status}`, {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/json',
                                'X-CSRF-TOKEN': document.querySelector('meta[name="csrf-token"]').content
                            }
                        })
                        .then(response => {
                            if (!response.ok) {
                                throw new Error('Network response was not ok');
                            }
                            return response.json();
                        })
                        .then(data => {
                            if (data.success) {
                                // Tutup modal dan refresh halaman
                                const modal = bootstrap.Modal.getInstance(document.getElementById('detailModal'));
                                modal.hide();
                                window.location.reload();
                            } else {
                                alert('Gagal memperbarui status pesanan');
                            }
                        })
                        .catch(error => {
                            console.error('Error:', error);
                            alert('Terjadi kesalahan saat memperbarui status pesanan');
                        });
                }
            });
        </script>
    @endsection
