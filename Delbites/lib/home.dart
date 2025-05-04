// semua import tetap
import 'dart:convert';

import 'package:Delbites/keranjang.dart';
import 'package:Delbites/menu_detail.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import "package:flutter_rating_bar/flutter_rating_bar.dart";

// const String baseUrl = 'http://10.0.2.2:8000';
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
  String selectedCategory = 'Rekomendasi';

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
                  'rating': (item['rating'] ?? '0.0').toString(), 
                })
            .toList();

        allItems.sort((a, b) => int.parse(b['stok_terjual']!)
            .compareTo(int.parse(a['stok_terjual']!)));

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
    selectedCategory = category;
    setState(() {
      if (category == 'Rekomendasi') {
        displayedItems = allItems
            .where((item) => int.parse(item['stok']!) > 0)
            .toList()
          ..sort((a, b) => int.parse(b['stok_terjual']!)
              .compareTo(int.parse(a['stok_terjual']!)));
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
    List<Map<String, String>> sourceItems;
    if (selectedCategory == 'Rekomendasi') {
      sourceItems = allItems
          .where((item) => int.parse(item['stok']!) > 0)
          .toList()
        ..sort((a, b) => int.parse(b['stok_terjual']!)
            .compareTo(int.parse(a['stok_terjual']!)));
      sourceItems = sourceItems.take(8).toList();
    } else {
      sourceItems = allItems
          .where((item) => item['kategori'] == selectedCategory)
          .toList();
    }

    final filtered = sourceItems
        .where((item) =>
            int.parse(item['stok']!) > 0 &&
            item['name']!.toLowerCase().contains(query.toLowerCase()))
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
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE6EBF5)],
          ),
        ),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchBar(),
            _buildCategorySelector(),
            const SizedBox(height: 8),
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
                          onPressed: () {
                            Navigator.pop(context); // tutup dialog
                            Future.delayed(const Duration(milliseconds: 100),
                                () {
                              // beri delay agar dialog benar-benar tertutup dulu
                              Future.microtask(() => SystemNavigator.pop());
                            });
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
    final categories = ["Rekomendasi", "makanan", "minuman"];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: categories
              .map((cat) => CategoryButton(
                    label: cat,
                    isSelected: selectedCategory == cat,
                    onTap: () => filterCategory(cat),
                  ))
              .toList(),
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
        childAspectRatio: 0.75,
      ),
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
  final bool isSelected;
  final VoidCallback onTap;

  const CategoryButton({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? const Color(0xFF2D5EA2)
              : const Color.fromARGB(255, 161, 161, 161),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white),
        ),
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
          : () async {
              final prefs = await SharedPreferences.getInstance();
              final name = prefs.getString('nama_pelanggan');
              final phone = prefs.getString('telepon_pelanggan');

              if (name == null || phone == null) {
                String tempName = '';
                String tempPhone = '';

                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Data Pelanggan"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Nama'),
                          onChanged: (value) => tempName = value,
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Telepon'),
                          keyboardType: TextInputType.phone,
                          onChanged: (value) => tempPhone = value,
                        ),
                      ],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          if (tempName.isNotEmpty && tempPhone.isNotEmpty) {
                            try {
                              final response = await http.post(
                                Uri.parse('$baseUrl/api/pelanggan'),
                                headers: {
                                  'Content-Type': 'application/json',
                                  'Accept': 'application/json',
                                },
                                body: jsonEncode({
                                  'nama': tempName,
                                  'telepon': tempPhone,
                                }),
                              );

                              if (response.statusCode == 200 ||
                                  response.statusCode == 201) {
                                final data = jsonDecode(response.body);
                                final idPelanggan = data['id'];

                                SharedPreferences prefs =
                                    await SharedPreferences.getInstance();
                                await prefs.setInt('id_pelanggan', idPelanggan);
                                await prefs.setString(
                                    'nama_pelanggan', tempName);
                                await prefs.setString(
                                    'telepon_pelanggan', tempPhone);

                                Navigator.pop(context);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MenuDetail(
                                      name: item['name']!,
                                      price: item['price']!,
                                      imageUrl:
                                          "$baseUrl/storage/${item['image']}",
                                      menuId: int.parse(item['id']!), rating: '',
                                    ),
                                  ),
                                );
                              } else {
                                print(
                                    'Gagal menyimpan pelanggan: ${response.body}');
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content:
                                          Text('Gagal menyimpan pelanggan')),
                                );
                              }
                            } catch (e) {
                              print('Exception: $e');
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    content:
                                        Text('Terjadi kesalahan jaringan')),
                              );
                            }
                          }
                        },
                        child: const Text('Lanjutkan'),
                      ),
                    ],
                  ),
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MenuDetail(
                      name: item['name']!,
                      price: item['price']!,
                      imageUrl: "$baseUrl/storage/${item['image']}",
                      menuId: int.parse(item['id']!), rating: '0.0',
                    ),
                  ),
                );
              }
            },
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(16)),
                child: Image.network(
                  "$baseUrl/storage/${item['image']}",
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 120,
                    color: Colors.grey[300],
                    child: const Icon(Icons.fastfood, size: 40),
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name']!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Rp ${item['price']}',
                      style: const TextStyle(
                        color: Color(0xFF2D5EA2),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    // Tampilkan rating dengan RatingBarIndicator
                    RatingBarIndicator(
                      rating: double.tryParse(item['rating'] ?? '0.0') ?? 0.0,
                      itemCount: 5,
                      itemSize: 20.0,
                      direction: Axis.horizontal,
                      unratedColor: Colors.grey.shade300,
                      itemBuilder: (context, index) => const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                    ),
                  ],
                ),
              ),
              if (isOutOfStock)
                const Padding(
                  padding: EdgeInsets.only(bottom: 8.0),
                  child: Center(
                    child: Text(
                      'Habis',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
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