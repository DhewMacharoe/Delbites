import 'package:flutter/material.dart';

class MenuDetail extends StatelessWidget {
  final String name;
  final String price;
  final String imageUrl;
  final int menuId;

  const MenuDetail({
    Key? key,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.menuId,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
        backgroundColor: const Color(0xFF2D5EA2),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.network(
            imageUrl,
            height: 200,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              height: 200,
              color: Colors.grey[300],
              child: const Icon(Icons.fastfood, size: 50),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Harga: Rp $price',
              style: const TextStyle(fontSize: 18, color: Color(0xFF2D5EA2)),
            ),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D5EA2),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child:
                  const Text('Pesan Sekarang', style: TextStyle(fontSize: 16)),
            ),
          ),
        ],
      ),
    );
  }
}
