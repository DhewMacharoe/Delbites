import 'package:Delbites/home.dart';
import 'package:Delbites/keranjang.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Import SharedPreferences

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();
  int? _idPelanggan; // Variabel untuk menyimpan ID pelanggan
  bool _isLoading =
      true; // Status untuk menunjukkan apakah data pelanggan sedang dimuat

  // Daftar halaman yang akan ditampilkan di PageView
  // Diinisialisasi sebagai list kosong dan akan diisi setelah idPelanggan dimuat
  List<Widget> _pages = [];

  @override
  void initState() {
    super.initState();
    _loadPelangganInfo(); // Memuat informasi pelanggan saat widget diinisialisasi
  }

  // Fungsi untuk memuat ID pelanggan dari SharedPreferences
  Future<void> _loadPelangganInfo() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        _idPelanggan = prefs.getInt('id_pelanggan');
        _initializePages(); // Inisialisasi daftar halaman setelah idPelanggan dimuat
      });
    } catch (e) {
      // Tangani kesalahan saat memuat info pelanggan
      print('Error loading pelanggan info: $e');
      setState(() {
        _idPelanggan = 0;
        _initializePages();
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat info pelanggan: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _initializePages() {
    _pages = [
      const HomePage(),
      const RiwayatPesananPage(),
      KeranjangPage(idPelanggan: _idPelanggan ?? 0),
    ];
  }

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: _pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        backgroundColor: Colors.transparent,
        color: const Color(0xFF2D5EA2),
        buttonBackgroundColor: const Color(0xFF2D5EA2),
        height: 60,
        items: const [
          Icon(Icons.home, size: 30, color: Colors.white),
          Icon(Icons.receipt_long, size: 30, color: Colors.white),
          Icon(Icons.shopping_cart, size: 30, color: Colors.white),
        ],
        onTap: _onTap,
      ),
    );
  }
}
