@extends('layouts.admin')

@section('title', 'Menejemen Pelanggan - DelBites')

@section('page-title', 'Menejemen Pelanggan')

@section('content')
<div class="container">
    <h1 class="mb-4">Daftar Pelanggan</h1>

    {{-- Filter dan Search --}}
    <div class="card border-0 shadow-sm mb-4">
        <div class="card-body">
            <form action="{{ route('pelanggan.index') }}" method="GET" class="row g-3">
                <div class="col-md-4">
                    <label for="status" class="form-label">Filter Status</label>
                    <select name="status" id="status" class="form-select">
                        <option value="">Semua Status</option>
                        <option value="aktif" {{ request('status') == 'aktif' ? 'selected' : '' }}>Aktif</option>
                        <option value="nonaktif" {{ request('status') == 'nonaktif' ? 'selected' : '' }}>Nonaktif</option>
                    </select>
                </div>
                <div class="col-md-4">
                    <label for="search" class="form-label">Cari Pelanggan</label>
                    <input type="text" class="form-control" id="search" name="search" value="{{ request('search') }}" placeholder="Masukkan nama atau telepon...">
                </div>
                <div class="col-md-4 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary me-2">Filter</button>
                    <a href="{{ route('pelanggan.index') }}" class="btn btn-secondary">Reset</a>
                </div>
            </form>
        </div>
    </div>

    {{-- Tabel Pelanggan --}}
    <div class="card border-0 shadow-sm">
        <div class="card-body p-0">
            <table class="table table-hover mb-0">
                <thead class="table-light">
                    <tr>
                        <th>
                            <a href="{{ route('pelanggan.index', array_merge(request()->all(), ['sort_by' => 'nama', 'sort_order' => $sortBy == 'nama' && $sortOrder == 'asc' ? 'desc' : 'asc'])) }}">
                                Nama {!! $sortBy == 'nama' ? ($sortOrder == 'asc' ? '↑' : '↓') : '' !!}
                            </a>
                        </th>
                        <th>
                            <a href="{{ route('pelanggan.index', array_merge(request()->all(), ['sort_by' => 'telepon', 'sort_order' => $sortBy == 'telepon' && $sortOrder == 'asc' ? 'desc' : 'asc'])) }}">
                                Telepon {!! $sortBy == 'telepon' ? ($sortOrder == 'asc' ? '↑' : '↓') : '' !!}
                            </a>
                        </th>
                        <th>
                            <a href="{{ route('pelanggan.index', array_merge(request()->all(), ['sort_by' => 'status', 'sort_order' => $sortBy == 'status' && $sortOrder == 'asc' ? 'desc' : 'asc'])) }}">
                                Status {!! $sortBy == 'status' ? ($sortOrder == 'asc' ? '↑' : '↓') : '' !!}
                            </a>
                        </th>
                    </tr>
                </thead>
                <tbody>
                    @forelse ($pelanggan as $p)
                        <tr>
                            <td>{{ $p->nama }}</td>
                            <td>{{ $p->telepon }}</td>
                            <td>{{ ucfirst($p->status) }}</td>
                        </tr>
                    @empty
                        <tr>
                            <td colspan="3" class="text-center">Tidak ada data pelanggan.</td>
                        </tr>
                    @endforelse
                </tbody>
            </table>
        </div>
    </div>

    {{-- Pagination --}}
    <div class="mt-3">
        {{ $pelanggan->links() }}
    </div>
</div>
@endsection
