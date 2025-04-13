import 'dart:convert';

import 'package:Delbites/history_pesanan.dart';
import 'package:Delbites/keranjang.dart';
import 'package:Delbites/mainy.dart';
import 'package:Delbites/makanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuMinuman extends StatefulWidget {
  const MenuMinuman();

  @override
  _MenuMinumanState createState() => _MenuMinumanState();
}

class _MenuMinumanState extends State<MenuMinuman> {
  int selectedIndex = 0;
  List<dynamic> minuman = [];

  @override
  void initState() {
    super.initState();
    fetchMinuman();
  }

  Future<void> fetchMinuman() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));
      if (response.statusCode == 200) {
        List<dynamic> allItems = json.decode(response.body);
        List<dynamic> minumanOnly = allItems
            .where((item) =>
                item['kategori'].toString().toLowerCase() == 'minuman')
            .toList();
        setState(() {
          minuman = minumanOnly;
        });
      }
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5EA2),
        elevation: 0,
        title: const Text(
          'Minuman',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: minuman.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: minuman.length,
                      itemBuilder: (context, index) {
                        return _buildMenuItem(minuman[index]);
                      },
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildCategoryButton('Rekomendasi !!', () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
            _buildCategoryButton('Makanan', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MenuMakanan()));
            }),
            _buildCategoryButton('Minuman', () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => MenuMinuman()));
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(String text, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D5EA2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        child: Text(
          text,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMenuItem(dynamic item) {
    bool isOutOfStock = (item['stok'] ?? 0) == 0;

    return Opacity(
      opacity: isOutOfStock ? 0.5 : 1.0,
      child: Stack(
        children: [
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    "http://127.0.0.1:8000/storage/${item['gambar']}",
                    width: double.infinity,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                            child: Icon(Icons.broken_image, size: 50)),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['nama_menu'] ?? 'Tanpa Nama',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Rp ${item['harga'] ?? 0}",
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isOutOfStock)
            Positioned(
              top: 5,
              right: 5,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Text(
                  "Habis",
                  style: TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: const Color(0xFF2D5EA2),
      buttonBackgroundColor: const Color(0xFF2D5EA2),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.access_time, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HistoryPesananPage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KeranjangPage()),
          );
        }
      },
    );
  }
}
