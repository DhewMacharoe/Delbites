import 'dart:convert';

import 'package:Delbites/checkout.dart';
import 'package:Delbites/main_screen.dart';
// import 'package:Delbites/riwayat_pesanan.dart';
// import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class KeranjangPage extends StatefulWidget {
  final int idPelanggan;

  const KeranjangPage({Key? key, required this.idPelanggan}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  List<Map<String, dynamic>> pesanan = [];
  bool isLoading = true;
  bool isError = false;
  // int _currentIndex = 1; // Indeks untuk keranjang

  @override
  void initState() {
    super.initState();
    _loadKeranjang();
  }

  Future<void> _loadKeranjang() async {
    try {
      final response = await http.get(
        Uri.parse(
            'https://delbites.d4trpl-itdel.id/api/keranjang/pelanggan/${widget.idPelanggan}'),
      );

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          pesanan = data.map<Map<String, dynamic>>((item) {
            double harga = double.tryParse(item['harga'].toString()) ?? 0;
            return {
              'id': item['id'],
              'id_menu': item['id_menu'],
              'name': item['nama_menu'],
              'price': harga.toInt(),
              'quantity': item['jumlah'],
              'catatan': item['catatan'],
              'suhu': item['suhu'],
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load cart');
      }
    } catch (e) {
      setState(() {
        isError = true;
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal memuat keranjang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _updateQuantity(int index, int newQuantity) async {
    try {
      final item = pesanan[index];

      if (newQuantity < 1) {
        // Jika quantity menjadi 0, hapus item
        await _removeItem(index);
        return;
      }

      final response = await http.put(
        Uri.parse('https://delbites.d4trpl-itdel.id/api/keranjang/${item['id']}'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'jumlah': newQuantity,
        }),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          pesanan[index]['quantity'] = newQuantity;
        });
      } else {
        throw Exception('Gagal mengupdate jumlah');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengupdate jumlah: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      _loadKeranjang(); // Reload data untuk sinkronisasi
    }
  }

  Future<void> _removeItem(int index) async {
    try {
      final item = pesanan[index];
      final response = await http.delete(
        Uri.parse('https://delbites.d4trpl-itdel.id/api/keranjang/${item['id']}'),
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        setState(() {
          pesanan.removeAt(index);
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item berhasil dihapus dari keranjang'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Gagal menghapus item');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menghapus item: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
      _loadKeranjang(); // Reload data untuk sinkronisasi
    }
  }

  int getTotalHarga() {
    int total = 0;
    for (var item in pesanan) {
      int price = 0;
      int quantity = 0;

      if (item['price'] is int) {
        price = item['price'];
      } else if (item['price'] is String) {
        price = int.tryParse(item['price']
                .toString()
                .replaceAll('Rp ', '')
                .replaceAll('.', '')) ??
            0;
      }

      quantity = item['quantity'] is int
          ? item['quantity']
          : int.tryParse(item['quantity'].toString()) ?? 0;

      total += price * quantity;
    }
    return total;
  }

  String formatPrice(int price) {
    return price.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (Match m) => '${m[1]}.',
        );
  }

  Widget _buildCartContent() {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isError) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Gagal memuat keranjang',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _loadKeranjang,
              child: const Text('Coba Lagi'),
            ),
          ],
        ),
      );
    }

    if (pesanan.isEmpty) {
      return const Center(
        child: Text(
          'Keranjang masih kosong',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 80), // Ruang untuk bottom nav
      itemCount: pesanan.length,
      itemBuilder: (context, index) {
        final item = pesanan[index];
        return Dismissible(
          key: Key(item['id'].toString()),
          direction: DismissDirection.endToStart,
          background: Container(
            alignment: Alignment.centerRight,
            padding: const EdgeInsets.only(right: 20),
            color: Colors.red,
            child: const Icon(Icons.delete, color: Colors.white),
          ),
          onDismissed: (direction) => _removeItem(index),
          child: Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.fastfood, size: 40, color: Colors.grey[700]),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name'],
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rp${formatPrice(item['price'])}',
                              style: const TextStyle(color: Colors.grey),
                            ),
                            if (item['suhu'] != null && item['suhu'].isNotEmpty)
                              Text(
                                'Suhu: ${item['suhu']}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                          ],
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.remove_circle,
                                color: Colors.black),
                            onPressed: () {
                              _updateQuantity(index, item['quantity'] - 1);
                            },
                          ),
                          Text(
                            item['quantity'].toString(),
                            style: const TextStyle(fontSize: 16),
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle,
                                color: Colors.black),
                            onPressed: () {
                              _updateQuantity(index, item['quantity'] + 1);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (item['catatan'] != null && item['catatan'].isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'Catatan: ${item['catatan']}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF2D5EA2),
        title: const Text(
          'Pesanan',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => const MainScreen(),
                settings: RouteSettings(arguments: 0), // 0 = tab Home
              ),
            );
          },
        ),
      ),
      body: _buildCartContent(),
      floatingActionButton: pesanan.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D5EA2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          pesanan: pesanan,
                          idPelanggan: widget.idPelanggan,
                          totalHarga: getTotalHarga(),
                        ),
                      ),
                    ).then((_) => _loadKeranjang());
                  },
                  child: Text(
                    'Rp${formatPrice(getTotalHarga())} - Checkout',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
