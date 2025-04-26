import 'dart:convert';

import 'package:Delbites/keranjang.dart';
import 'package:Delbites/menu_detail.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, String>> allItems = [];
  List<Map<String, String>> displayedItems = [];
  bool isLoading = true;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    fetchMenu();
  }

  Future<void> fetchMenu() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/menu'));
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        allItems = data
            .map((item) => {
                  "name": item["nama_menu"].toString(),
                  "price": "Rp ${item["harga"]}",
                  "stok": item["stok"].toString(),
                  "jumlah_terjual": (item["jumlah_terjual"] ?? "0").toString(),
                  "kategori": item["kategori"].toString(),
                  "image": item["gambar"].toString(),
                })
            .toList();

        setState(() {
          displayedItems =
              allItems.where((item) => int.parse(item['stok']!) > 0).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal mengambil data menu');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void filterKategori(String kategori) {
    setState(() {
      if (kategori == 'Semua') {
        displayedItems =
            allItems.where((item) => int.parse(item['stok']!) > 0).toList();
      } else {
        displayedItems = allItems
            .where((item) => item['kategori'] == kategori)
            .toList(); // tidak filter stok
      }
      applySearch(searchQuery, updateState: false); // tetap filter nama
    });
  }

  void applySearch(String query, {bool updateState = true}) {
    List<Map<String, String>> filtered = displayedItems
        .where(
            (item) => item['name']!.toLowerCase().contains(query.toLowerCase()))
        .toList();
    if (updateState) {
      setState(() {
        searchQuery = query;
        displayedItems = filtered;
      });
    } else {
      displayedItems = filtered;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          _buildHeader(),
          _buildSearchBar(),
          _buildCategoryButtons(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchMenu,
                    child: _buildFoodGrid(),
                  ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0xFF2D5EA2),
      ),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Selamat Datang di Del Cafe',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Image.asset('assets/icon/logo1.png', width: 60, height: 60),
                ],
              ),
            ),
            Positioned(
              top: 25,
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.logout, size: 35, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Yakin ingin logout?"),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Batal")),
                        TextButton(
                            onPressed: () => SystemNavigator.pop(),
                            child: const Text("Logout")),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: TextField(
        onChanged: applySearch,
        decoration: InputDecoration(
          hintText: 'Cari menu...',
          prefixIcon: const Icon(Icons.search),
          suffixIcon: searchQuery.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      searchQuery = '';
                      displayedItems = allItems
                          .where((item) => int.parse(item['stok']!) > 0)
                          .toList();
                    });
                  },
                )
              : null,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildCategoryButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            CategoryButton(
                label: "Semua", onTap: () => filterKategori("Semua")),
            CategoryButton(
                label: "Makanan", onTap: () => filterKategori("makanan")),
            CategoryButton(
                label: "Minuman", onTap: () => filterKategori("minuman")),
          ],
        ),
      ),
    );
  }

  Widget _buildFoodGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 15,
        mainAxisSpacing: 15,
        childAspectRatio: 0.8,
      ),
      itemCount: displayedItems.length,
      itemBuilder: (context, index) {
        final item = displayedItems[index];
        final isOutOfStock = int.parse(item['stok']!) == 0;

        return GestureDetector(
          onTap: isOutOfStock
              ? null
              : () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MenuDetail(
                        name: item["name"]!,
                        price: item["price"]!,
                        imageUrl: "$baseUrl/storage/${item['image']}",
                      ),
                    ),
                  );
                },
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            elevation: 4,
            child: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(10)),
                      child: Image.network(
                        "$baseUrl/storage/${item['image']}",
                        height: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 100,
                            color: Colors.grey[300],
                            child: const Icon(Icons.fastfood, size: 50),
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item["name"]!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 5),
                            Text(item["price"]!,
                                style: const TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text('Tersisa: ${item["stok"]}',
                                style: const TextStyle(
                                    fontSize: 13, color: Colors.grey)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isOutOfStock)
                  Positioned(
                    top: 10,
                    right: 10,
                    child: Container(
                      color: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: const Text(
                        'Habis',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomNavigation() {
    return CurvedNavigationBar(
      backgroundColor: Colors.white,
      color: const Color(0xFF2D5EA2),
      buttonBackgroundColor: const Color(0xFF2D5EA2),
      height: 60,
      animationDuration: const Duration(milliseconds: 300),
      items: const <Widget>[
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.access_time, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const RiwayatPesananPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => KeranjangPage()),
          );
        }
      },
    );
  }
}

// Komponen Tambahan

class CategoryButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const CategoryButton({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D5EA2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        ),
        child: Text(
          label,
          style:
              const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
