import 'dart:convert';

import 'package:Delbites/keranjang.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import "package:flutter_rating_bar/flutter_rating_bar.dart";

const String baseUrl = 'http://127.0.0.1:8000';

class MenuDetail extends StatefulWidget {
  final String name;
  final String price;
  final String imageUrl;
  final int menuId;
  final String rating;

  const MenuDetail({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.menuId,
    required this.rating,
    Key? key,
  }) : super(key: key);

  @override
  State<MenuDetail> createState() => _MenuDetailState();
}

class _MenuDetailState extends State<MenuDetail> {
  double _userRating = 0;

  Future<void> addToCart() async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/keranjang'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id_menu': widget.menuId,
          'nama_menu': widget.name,
          'kategori': 'makanan',
          'jumlah': 1,
          'harga': widget.price,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Item berhasil ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
          ),
        );
      } else {
        _addToLocalCart();
      }
    } catch (e) {
      _addToLocalCart();
    }
  }

  void _addToLocalCart() {
    try {
      int index = pesanan.indexWhere((item) => item['id'] == widget.menuId);
      if (index != -1) {
        pesanan[index]['quantity'] += 1;
      } else {
        pesanan.add({
          'id': widget.menuId,
          'name': widget.name,
          'price': widget.price,
          'quantity': 1,
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
                  widget.imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
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
              'Rp ${widget.price}',
              style: const TextStyle(fontSize: 18, color: Colors.grey),
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
              initialRating: 0,
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
              onPressed: () {
                addToCart();
              },
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
