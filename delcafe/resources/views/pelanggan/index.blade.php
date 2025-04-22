@extends('layouts.admin')

@section('title', 'Manajemen Pelanggan - Admin Panel')

@section('page-title', 'Pelanggan')

@section('content')
    <div class="container-fluid">
        <div class="row mb-4">
            <div class="col-md-6">
                <h1 class="h3">Daftar Pelanggan</h1>
                <p class="text-muted">Kelola data pelanggan di sini</p>
            </div>
            <div class="col-md-6 d-flex justify-content-md-end align-items-center">
                <div class="input-group me-2" style="max-width: 300px;">
                    <input type="text" class="form-control" id="searchKeyword" placeholder="Cari pelanggan...">
                    <button class="btn btn-outline-secondary" type="button" id="searchBtn">
                        <i class="fas fa-search"></i>
                    </button>
                </div>
            </div>
        </div>

        <div class="card">
            <div class="card-header">
                <h5 class="card-title mb-0">Daftar Pelanggan</h5>
            </div>
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover align-middle">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nama</th>
                                <th>Email</th>
                                <th>Telepon</th>
                                <th>Status</th>
                                <th>Aksi</th>
                            </tr>
                        </thead>
                        <tbody>
                            @foreach ($pelanggan as $item)
                                <tr>
                                    <td>{{ $item->id }}</td>
                                    <td>{{ $item->nama }}</td>
                                    <td>{{ $item->email }}</td>
                                    <td>{{ $item->telepon }}</td>
                                    <td>
                                        @if ($item->status == 'aktif')
                                            <span class="badge bg-success">{{ ucfirst($item->status) }}</span>
                                        @else
                                            <span class="badge bg-danger">{{ ucfirst($item->status) }}</span>
                                        @endif
                                    </td>
                                    <td>
                                        <button class="btn btn-sm btn-primary" data-bs-toggle="modal" data-bs-target="#viewDetailModal" data-id="{{ $item->id }}" id="viewDetailBtn">
                                            <i class="fas fa-eye"></i> Lihat Detail
                                        </button>

                                        <form action="{{ route('pelanggan.destroy', $item) }}" method="POST" style="display:inline-block;">
                                            @csrf
                                            @method('DELETE')
                                            <button type="submit" class="btn btn-sm btn-danger" onclick="return confirm('Apakah Anda yakin ingin menghapus pelanggan ini?')">
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
                        {{ $pelanggan->links() }}
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal Lihat Detail -->
    <div class="modal fade" id="viewDetailModal" tabindex="-1" aria-labelledby="viewDetailModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="viewDetailModalLabel">Detail Pelanggan</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <div id="detailContent">
                        <!-- Konten detail pelanggan akan dimuat melalui AJAX -->
                    </div>
                </div>
            </div>
        </div>
    </div>
@endsection

@section('scripts')
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // AJAX untuk menampilkan detail pelanggan saat tombol "Lihat Detail" diklik
            const viewDetailBtns = document.querySelectorAll('#viewDetailBtn');
            viewDetailBtns.forEach(btn => {
                btn.addEventListener('click', function() {
                    const id = this.getAttribute('data-id');
                    fetch(`/admin/pelanggan/detail/${id}`)
                        .then(response => response.json())
                        .then(data => {
                            let content = `
                                <p><strong>Nama:</strong> ${data.nama}</p>
                                <p><strong>Email:</strong> ${data.email}</p>
                                <p><strong>Telepon:</strong> ${data.telepon}</p>
                                <p><strong>Status:</strong> ${data.status == 'aktif' ? 'Aktif' : 'Nonaktif'}</p>
                            `;
                            document.getElementById('detailContent').innerHTML = content;
                        })
                        .catch(error => {
                            console.error('Error:', error);
                        });
                });
            });

            // AJAX untuk pencarian pelanggan
            const searchBtn = document.getElementById('searchBtn');
            searchBtn.addEventListener('click', function() {
                const keyword = document.getElementById('searchKeyword').value;
                window.location.href = `/admin/pelanggan/search?keyword=${keyword}`;
            });
        });
    </script>
@endsection
