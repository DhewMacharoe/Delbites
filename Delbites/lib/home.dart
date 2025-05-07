import 'dart:convert';
import 'dart:io';

import 'package:Delbites/widgets/bottom_nav.dart';
import 'package:Delbites/widgets/menu_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
    setState(() => isLoading = true);
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
                  'stok_terjual': (item['total_terjual'] ?? '0').toString(),
                  'kategori': item['kategori'].toString(),
                  'image': item['gambar'].toString(),
                  'rating': (item['rating'] ?? '0.0').toString(),
                  'deskripsi': item['deskripsi']?.toString() ?? '',
                })
            .toList();

        allItems.sort((a, b) => int.parse(b['stok_terjual']!)
            .compareTo(int.parse(a['stok_terjual']!)));

        setState(() {
          displayedItems = allItems.take(8).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Gagal memuat menu');
      }
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Terjadi kesalahan: $e')),
      );
    }
  }

  void filterCategory(String category) {
    setState(() {
      selectedCategory = category;
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
      bottomNavigationBar: const BottomNavBar(currentIndex: 0),
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
                            Navigator.pop(context);
                            Future.delayed(const Duration(milliseconds: 100),
                                () => exit(0));
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
