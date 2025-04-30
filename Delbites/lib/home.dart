import 'dart:convert';

import 'package:Delbites/keranjang.dart';
import 'package:Delbites/menu_detail.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:8000';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
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
        final List<dynamic> data = jsonDecode(response.body);
        allItems = data
            .map<Map<String, String>>((item) => {
                  'id': item['id'].toString(),
                  'name': item['nama_menu'].toString(),
                  'price': item['harga'].toString(),
                  'stok': item['stok'].toString(),
                  'stok_terjual': (item['stok_terjual'] ?? '0').toString(),
                  'kategori': item['kategori'].toString(),
                  'image': item['gambar'].toString(),
                })
            .toList();

        // Sort the items based on stok_terjual in descending order
        allItems.sort((a, b) => int.parse(b['stok_terjual']!)
            .compareTo(int.parse(a['stok_terjual']!)));

        // Select the top 8 items based on the highest number of sold items
        setState(() {
          displayedItems = allItems.take(8).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load menu');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void filterCategory(String category) {
    setState(() {
      if (category == 'Rekomendasi') {
        displayedItems = allItems
            .where((item) => int.parse(item['stok']!) > 0)
            .toList()
          ..sort((a, b) => int.parse(b['jumlah_terjual']!)
              .compareTo(int.parse(a['jumlah_terjual']!)));
        displayedItems = displayedItems.take(8).toList();
      } else {
        displayedItems =
            allItems.where((item) => item['kategori'] == category).toList();
      }
      if (searchQuery.isNotEmpty) {
        applySearch(searchQuery, updateState: false);
      }
    });
  }

  void applySearch(String query, {bool updateState = true}) {
    final filtered = displayedItems
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
          _buildCategorySelector(),
          Expanded(
            child: isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: fetchMenu,
                    child: _buildMenuGrid(),
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
      decoration: const BoxDecoration(color: Color(0xFF2D5EA2)),
      child: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                children: [
                  const Text(
                    'Selamat Datang di DelBites',
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
                icon: const Icon(Icons.logout, size: 30, color: Colors.white),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Konfirmasi"),
                      content: const Text("Yakin ingin logout?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Batal"),
                        ),
                        TextButton(
                          onPressed: () async {
                            final prefs = await SharedPreferences.getInstance();
                            await prefs.clear(); // hapus semua data login
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                '/login', (route) => false);
                          },
                          child: const Text("Logout"),
                        ),
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
      padding: const EdgeInsets.all(16),
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
          filled: true,
          fillColor: Colors.grey[200],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: const [
            CategoryButton(label: "Rekomendasi"),
            CategoryButton(label: "makanan"),
            CategoryButton(label: "minuman"),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuGrid() {
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          childAspectRatio: 0.75),
      itemCount: displayedItems.length,
      itemBuilder: (context, index) {
        final item = displayedItems[index];
        return MenuCard(item: item);
      },
    );
  }

  Widget _buildBottomNavigation() {
    return CurvedNavigationBar(
      backgroundColor: Colors.transparent,
      color: const Color(0xFF2D5EA2),
      buttonBackgroundColor: const Color(0xFF2D5EA2),
      height: 60,
      items: const [
        Icon(Icons.home, size: 30, color: Colors.white),
        Icon(Icons.history, size: 30, color: Colors.white),
        Icon(Icons.shopping_cart, size: 30, color: Colors.white),
      ],
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        } else if (index == 1) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const RiwayatPesananPage()),
          );
        } else if (index == 2) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => KeranjangPage()),
          );
        }
      },
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String label;
  const CategoryButton({Key? key, required this.label}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _HomePageState? homeState =
        context.findAncestorStateOfType<_HomePageState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: () => homeState?.filterCategory(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2D5EA2),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        ),
        child: Text(label, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}

class MenuCard extends StatelessWidget {
  final Map<String, String> item;
  const MenuCard({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = int.parse(item['stok']!) == 0;
    return GestureDetector(
      onTap: isOutOfStock
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MenuDetail(
                    name: item['name']!,
                    price: item['price']!,
                    imageUrl: "$baseUrl/storage/${item['image']}",
                    menuId: int.parse(item['id']!),
                  ),
                ),
              );
            },
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 3,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      "$baseUrl/storage/${item['image']}",
                      height: 110,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        height: 110,
                        color: Colors.grey[300],
                        child: const Icon(Icons.fastfood, size: 40),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(item['name']!),
                          const SizedBox(height: 5),
                          Text('Rp ${item['price']}'),
                          const SizedBox(height: 4),
                          Text('Stok: ${item['stok']}'),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              if (isOutOfStock)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    color: Colors.red,
                    child: const Text(
                      'Habis',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
