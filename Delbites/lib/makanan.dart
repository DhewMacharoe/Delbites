import 'dart:convert';

import 'package:Delbites/home.dart';
import 'package:Delbites/keranjang.dart';
import 'package:Delbites/menu_detail.dart';
import 'package:Delbites/minuman.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class MenuMakanan extends StatefulWidget {
  const MenuMakanan({Key? key}) : super(key: key);

  @override
  State<MenuMakanan> createState() => _MenuMakananState();
}

class _MenuMakananState extends State<MenuMakanan> {
  late Future<List<dynamic>> makananList;

  @override
  void initState() {
    super.initState();
    makananList = fetchMakanan();
  }

  Future<List<dynamic>> fetchMakanan() async {
    try {
      final response =
          await http.get(Uri.parse('http://127.0.0.1:8000/api/menu'));

      if (response.statusCode == 200) {
        List<dynamic> allItems = json.decode(response.body);
        if (allItems.isEmpty) return [];

        List<dynamic> makananOnly = allItems
            .where((item) =>
                item['kategori']?.toString().toLowerCase() == 'makanan')
            .toList();

        return makananOnly;
      } else {
        print("Status code error: ${response.statusCode}");
        return [];
      }
    } catch (e) {
      print("Fetch error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDECF2),
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildCategoryButtons(),
          Expanded(
            child: FutureBuilder<List<dynamic>>(
              future: makananList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(child: Text("Gagal mengambil data"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                      child: Text("Tidak ada makanan tersedia"));
                }
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: GridView.builder(
                    itemCount: snapshot.data!.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemBuilder: (context, index) {
                      return _buildMenuItem(snapshot.data![index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: const Color(0xFF2D5EA2),
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => Navigator.pop(context),
      ),
      title: const Text(
        'Daftar Makanan',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
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
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            }),
            _buildCategoryButton('Makanan', () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MenuMakanan()));
            }),
            _buildCategoryButton('Minuman', () {
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => const MenuMinuman()));
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem(dynamic item) {
  bool isOutOfStock = (item['stok'] ?? 0) == 0;
  String imageUrl = "http://10.0.2.2:8000/storage/${item['gambar']}";

  return GestureDetector(
    onTap: isOutOfStock
        ? null
        : () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuDetail(
                  name: item['nama_menu'] ?? 'Tanpa Nama',
                  price: "Rp ${item['harga'] ?? 0}",
                  imageUrl: imageUrl, // ✅ tambahkan ini
                ),
              ),
            );
          },
    child: Opacity(
      opacity: isOutOfStock ? 0.5 : 1.0,
      child: Stack(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            elevation: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                  child: Image.network(
                    imageUrl, // ✅ gunakan ini
                    height: 100,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 100,
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(Icons.fastfood, size: 50),
                        ),
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        "Rp ${item['harga'] ?? 0}",
                        style: const TextStyle(color: Colors.grey),
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
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
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
            MaterialPageRoute(builder: (context) => RiwayatPesananPage()),
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
