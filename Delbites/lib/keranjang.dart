import 'package:Delbites/checkout.dart';
import 'package:Delbites/home.dart';
import 'package:Delbites/riwayat_pesanan.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

// This should be a global list that can be accessed from menu_detail.dart
List<Map<String, dynamic>> pesanan = [];

class KeranjangPage extends StatefulWidget {
  const KeranjangPage({Key? key}) : super(key: key);

  @override
  State<KeranjangPage> createState() => _KeranjangPageState();
}

class _KeranjangPageState extends State<KeranjangPage> {
  int getTotalHarga() {
    int total = 0;
    for (var item in pesanan) {
      // Pastikan tipe data sesuai
      int price = 0;
      int quantity = 0;

      // Handle berbagai kemungkinan tipe data
      if (item['price'] is int) {
        price = item['price'];
      } else if (item['price'] is String) {
        // Coba parse string ke int
        price = int.tryParse(item['price']
                .toString()
                .replaceAll('Rp ', '')
                .replaceAll('.', '')) ??
            0;
      }

      if (item['quantity'] is int) {
        quantity = item['quantity'];
      } else {
        quantity = int.tryParse(item['quantity'].toString()) ?? 0;
      }

      total += price * quantity;
    }
    return total;
  }

  String formatPrice(int price) {
    // Format the price with thousand separators
    return price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]}.');
  }

  @override
  void initState() {
    super.initState();
    // Debugging: print isi keranjang
    print('Isi keranjang: $pesanan');
    print('Jumlah item: ${pesanan.length}');
    for (var item in pesanan) {
      print(
          'Item: ${item['name']}, Jumlah: ${item['quantity']}, Harga: ${item['price']}');
    }
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
            Navigator.pop(context);
          },
        ),
      ),
      body: pesanan.isEmpty
          ? const Center(
              child: Text(
                'Keranjang masih kosong',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: pesanan.length,
              itemBuilder: (context, index) {
                final item = pesanan[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.fastfood,
                                size: 50, color: Colors.grey[700]),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    'Rp${formatPrice(item['price'])}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  // Display temperature if available
                                  if (item['suhu'] != null)
                                    Text(
                                      'Suhu: ${item['suhu']}',
                                      style:
                                          const TextStyle(color: Colors.grey),
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
                                    setState(() {
                                      if (item['quantity'] > 1) {
                                        item['quantity']--;
                                      } else {
                                        pesanan.removeAt(index);
                                      }
                                    });
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
                                    setState(() {
                                      item['quantity']++;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                        // Display notes if available
                        if (item['catatan'] != null &&
                            item['catatan'].isNotEmpty)
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
                );
              },
            ),
      bottomNavigationBar: pesanan.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Harga',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        'Rp ${formatPrice(getTotalHarga())}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                CheckoutPage(pesanan: pesanan),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2D5EA2),
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        "Lanjut ke Pembayaran",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget buildBottomNavigation(BuildContext context) {
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
