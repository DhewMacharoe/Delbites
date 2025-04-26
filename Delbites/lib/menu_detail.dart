import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000/keranjang';

class MenuDetail extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final int menuId;

  const MenuDetail({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.menuId,
    Key? key,
  }) : super(key: key);

  Future<void> addToCart(BuildContext context) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/keranjang'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_pelanggan': 1,
          'id_menu': menuId,
          'nama_menu': name,
          'kategori': 'makanan',
          'jumlah': 1,
          'harga': price,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Item successfully added to the cart')),
        );
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
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
                  imageUrl,
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
              name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              price,
              style: const TextStyle(fontSize: 18, color: Colors.grey),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                addToCart(context);
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
