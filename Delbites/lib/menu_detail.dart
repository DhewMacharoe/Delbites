import 'package:Delbites/keranjang.dart';
import 'package:flutter/material.dart';

class MenuDetail extends StatelessWidget {
  final String name;
  final String price;

  const MenuDetail({required this.name, required this.price, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
  title: Text(
    name,
    style: const TextStyle(color: Colors.white),
  ),
  backgroundColor: const Color(0xFF2D5EA2),
),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Icon(Icons.fastfood, size: 100, color: Colors.grey[700]),
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
                pesanan.add({
                  'name': name,
                  'price': price,
                  'quantity': 1,
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Pesanan ditambahkan ke keranjang')),
                );
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
