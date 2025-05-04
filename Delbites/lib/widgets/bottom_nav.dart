import 'package:Delbites/home.dart';
import 'package:Delbites/keranjang.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

class BottomNavBar extends StatefulWidget {
  final int currentIndex;

  const BottomNavBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  void _navigateTo(int index, BuildContext context) {
    if (index == widget.currentIndex) return;

    Widget targetPage;
    switch (index) {
      case 0:
        targetPage = const HomePage();
        break;
      case 1:
        targetPage = const RiwayatPesananPage();
        break;
      case 2:
        targetPage = const KeranjangPage();
        break;
      default:
        return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => targetPage),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(
      index: widget.currentIndex,
      backgroundColor: Colors.transparent,
      color: const Color(0xFF2D5EA2),
      buttonBackgroundColor: const Color(0xFF2D5EA2),
      height: 60,
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.history, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
      ],
      onTap: (index) => _navigateTo(index, context),
    );
  }
}
