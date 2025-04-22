    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>@yield('title', 'Admin Panel')</title>
        <link rel="icon" href="{{ asset('icon/logo.png') }}" type="image/png">


        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">

        <!-- Font Awesome -->
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

        <!-- Custom CSS -->
        <style>
            body {
                font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
                background-color: #f8f9fa;
            }

            .sidebar {
                min-height: 100vh;
                background-color: #343a40;
                color: #fff;
                box-shadow: 2px 0 5px rgba(0, 0, 0, 0.1);
            }

            .sidebar .nav-link {
                color: rgba(255, 255, 255, .75);
                padding: 0.75rem 1rem;
                border-radius: 0.25rem;
                margin: 0.2rem 0;
            }

            .sidebar .nav-link:hover {
                color: #fff;
                background-color: rgba(255, 255, 255, .1);
            }

            .sidebar .nav-link.active {
                color: #fff;
                background-color: #007bff;
            }

            .sidebar .nav-link i {
                margin-right: 0.5rem;
            }

            .main-content {
                padding: 20px;
            }

            .stat-card {
                transition: transform 0.3s;
                cursor: pointer;
            }

            .stat-card:hover {
                transform: translateY(-5px);
                box-shadow: 0 10px 20px rgba(0, 0, 0, 0.1);
            }

            .stat-card .icon {
                width: 48px;
                height: 48px;
                background-color: rgba(0, 123, 255, 0.1);
                color: #007bff;
                display: flex;
                align-items: center;
                justify-content: center;
                border-radius: 50%;
            }

            .navbar-brand {
                font-weight: bold;
            }

            .user-dropdown img {
                width: 32px;
                height: 32px;
                border-radius: 50%;
            }

            @media (max-width: 768px) {
                .sidebar {
                    position: fixed;
                    top: 0;
                    left: -250px;
                    width: 250px;
                    z-index: 1000;
                    transition: left 0.3s;
                }

                .sidebar.show {
                    left: 0;
                }

                .content-wrapper {
                    margin-left: 0 !important;
                }
            }
        </style>

        @yield('styles')
    </head>

    <body>
        <div class="container-fluid">
            <div class="row">
                <!-- Sidebar -->
                <div class="col-md-3 col-lg-2 d-md-block sidebar collapse" id="sidebarMenu">
                    <div class="position-sticky pt-3">
                        <div class="d-flex align-items-center justify-content-center mb-4 p-3">
                            <i class="fas fa-home me-2"></i>
                            <span class="fs-4">Del<strong>Bites</strong></span>
                        </div>

                        <!-- In resources/views/layouts/admin.blade.php -->
                        <!-- Find the sidebar navigation section and update the customers link -->

                        <ul class="nav flex-column">
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('dashboard') ? 'active' : '' }}"
                                    href="{{ route('dashboard') }}">
                                    <i class="fas fa-tachometer-alt"></i>
                                    Dashboard
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('pesanan*') ? 'active' : '' }}"
                                    href="{{ route('pesanan.index') }}">
                                    <i class="fas fa-shopping-cart"></i>
                                    Pesanan
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('produk*') ? 'active' : '' }}"
                                    href="{{ route('produk.index') }}">
                                    <i class="fas fa-box"></i>
                                    Produk
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('pelanggan*') ? 'active' : '' }}"
                                    href="{{ route('pelanggan.index') }}">
                                    <i class="fas fa-users"></i>
                                    Pelanggan
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('reports*') ? 'active' : '' }}"
                                    href="{{ route('reports.index') }}">
                                    <i class="fas fa-chart-bar"></i>
                                    Laporan
                                </a>
                            </li>
                            <li class="nav-item">
                                <a class="nav-link {{ request()->is('stok*') ? 'active' : '' }}"
                                    href="{{ route('stok.index') }}">
                                    <i class="fas fa-boxes"></i>
                                    Stok
                                </a>
                            </li>
                        </ul>

                        <hr>

                        <!-- Copyright notice at the bottom -->
                        <div class="text-center p-3 text small ">
                            Copyright &copy; Delbites 2025
                        </div>
                        {{-- <div class="dropdown p-3">
                            <a href="#"
                                class="d-flex align-items-center text-white text-decoration-none dropdown-toggle"
                                id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                                <img src="{{ asset('icon/logo.png') }}" alt="Admin" width="32" height="32"
                                    class="rounded-circle me-2">
                                <strong>Admin</strong>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-dark text-small shadow" aria-labelledby="dropdownUser1">
                                <li><a class="dropdown-item" href="#">Pengaturan</a></li>
                                <li><a class="dropdown-item" href="#">Profil</a></li>
                                <li>
                                    <hr class="dropdown-divider">
                                </li>
                                <li>
                                    <form method="POST" action="{{ route('logout') }}">
                                        @csrf
                                        <button type="submit" class="dropdown-item">Keluar</button>
                                    </form>
                                </li>
                            </ul>
                        </div> --}}
                    </div>
                </div>

                <!-- Main content -->
                <div class="col-md-9 col-lg-10 content-wrapper ms-sm-auto px-md-4">
                    <!-- Top navbar -->
                    <nav class="navbar navbar-expand-lg navbar-light bg-light border-bottom mb-4">
                        <div class="container-fluid">
                            <button class="navbar-toggler d-md-none" type="button" data-bs-toggle="collapse"
                                data-bs-target="#sidebarMenu" aria-controls="sidebarMenu" aria-expanded="false"
                                aria-label="Toggle navigation">
                                <span class="navbar-toggler-icon"></span>
                            </button>

                            <div class="d-flex align-items-center">
                                <span class="navbar-brand mb-0 h1">@yield('page-title', 'Dashboard')</span>
                            </div>

                            <div class="d-flex align-items-center">
                                <!-- Bell icon without dropdown -->
                                <div class="me-3">
                                    <a class="nav-link position-relative" href="#">
                                        <i class="fas fa-bell"></i>
                                        <span
                                            class="position-absolute top-0 start-100 translate-middle badge rounded-pill bg-danger">
                                            3
                                        </span>
                                    </a>
                                </div>

                                <!-- Admin profile image only -->
                                <div class="dropdown p-3">
                                    <a href="#" class="d-flex align-items-center text-white text-decoration-none"
                                        id="dropdownUser1" data-bs-toggle="dropdown" aria-expanded="false">
                                        <img src="{{ asset('icon/logo.png') }}" alt="Admin" width="32"
                                            height="32" class="rounded-circle me-2">
                                    </a>
                                    <ul class="dropdown-menu dropdown-menu-end text-small shadow"
                                        aria-labelledby="dropdownUser1" style="min-width: auto;">
                                        <li><a class="dropdown-item" href="#">Pengaturan</a></li>
                                        <li><a class="dropdown-item" href="#">Profil</a></li>
                                        <li>
                                            <hr class="dropdown-divider">
                                        </li>
                                        <li>
                                            <form method="POST" action="{{ route('logout') }}">
                                                @csrf
                                                <button type="submit" class="dropdown-item">Logout</button>
                                            </form>
                                        </li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </nav>

                    <!-- Flash messages -->
                    @if (session('success'))
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            {{ session('success') }}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                aria-label="Close"></button>
                        </div>
                    @endif

                    @if (session('error'))
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            {{ session('error') }}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"
                                aria-label="Close"></button>
                        </div>
                    @endif

                    <!-- Page content -->
                    <main class="pb-5">
                        @yield('content')
                    </main>
                </div>
            </div>
        </div>

        <!-- Bootstrap JS Bundle with Popper -->
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

        <!-- jQuery -->
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

        @yield('scripts')
    </body>

    </html>
