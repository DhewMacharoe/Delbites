import 'dart:convert';

import 'package:Delbites/keranjang.dart';
import 'package:Delbites/suhu_selector.dart';
import 'package:flutter/material.dart';
import "package:flutter_rating_bar/flutter_rating_bar.dart";
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000';

class MenuDetail extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final int menuId;
  final String rating;
  final String kategori;
  final String deskripsi;

  const MenuDetail({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.menuId,
    required this.rating,
    required this.kategori,
    required this.deskripsi,
    Key? key,
  }) : super(key: key);

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  String? selectedSuhu;
  String? catatanTambahan;
  // Hapus list pesanan lokal
  double _userRating = 0;
  Future<void> addToCart() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/keranjang'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_menu': widget.menuId,
          'nama_menu': widget.name,
          'kategori': widget.kategori,
          'suhu': selectedSuhu,
          'jumlah': 1,
          'harga': int.tryParse(widget.price) ?? 0,
          'catatan': catatanTambahan ?? '',
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item berhasil ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        _addToLocalCart();
      }
    } catch (e) {
      _addToLocalCart();
    }
  }

  void _addToLocalCart() {
    try {
      // Gunakan list pesanan global dari keranjang.dart
      int index = pesanan.indexWhere((item) =>
          item['id'] == widget.menuId &&
          (widget.kategori == 'makanan' || item['suhu'] == selectedSuhu));

      if (index != -1) {
        // Update state untuk memicu rebuild
        setState(() {
          pesanan[index]['quantity'] += 1;
        });
      } else {
        // Update state untuk memicu rebuild
        setState(() {
          pesanan.add({
            'id': widget.menuId,
            'name': widget.name,
            'price': int.tryParse(widget.price) ?? 0,
            'quantity': 1,
            if (widget.kategori == 'minuman') 'suhu': selectedSuhu,
            'catatan': catatanTambahan ?? '',
          });
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Item berhasil ditambahkan ke keranjang'),
          backgroundColor: Colors.blue,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan ke keranjang: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> submitRating(double rating) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/rating'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_menu': widget.menuId,
          'rating': rating,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rating berhasil dikirim'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        throw Exception('Gagal mengirim rating');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal mengirim rating: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showCatatanDialog(BuildContext context) {
    final _catatanController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Catatan Tambahan'),
          content: TextField(
            controller: _catatanController,
            decoration: const InputDecoration(
              hintText: 'Contoh: Kurangi gula, tanpa es...',
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  catatanTambahan = _catatanController.text;
                });
                Navigator.pop(context);
                addToCart();
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double initialRating = double.tryParse(widget.rating) ?? 0.0;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: const Color(0xFF2D5EA2),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.imageUrl.isNotEmpty
                      ? widget.imageUrl
                      : 'https://via.placeholder.com/200', // Fallback to placeholder if imageUrl is null or empty
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Center(
                        child: Icon(Icons.fastfood, size: 80),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              'Rp${widget.price}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Text(
              widget.deskripsi,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            if (widget.kategori == 'minuman')
              SuhuSelector(
                selectedSuhu: selectedSuhu,
                onSelected: (suhu) => setState(() {
                  selectedSuhu = suhu;
                }),
              ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber, size: 20),
                const SizedBox(width: 5),
                Text(
                  '${initialRating.toStringAsFixed(1)} / 5.0',
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Text(
              'Beri Rating Anda:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            RatingBar.builder(
              initialRating: initialRating,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => const Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                setState(() {
                  _userRating = rating;
                });
              },
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                submitRating(_userRating);
              },
              child: const Text("Kirim Rating"),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () => _showCatatanDialog(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4C53A5),
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Center(
                child: Text(
                  "Tambah ke Keranjang",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
