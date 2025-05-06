import 'package:Delbites/menu_detail.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuCard extends StatelessWidget {
  final Map<String, String> item;

  const MenuCard({Key? key, required this.item}) : super(key: key);

  Future<void> checkAndNavigate(
      BuildContext context, Map<String, String> item) async {
    final prefs = await SharedPreferences.getInstance();
    final String? nama = prefs.getString('nama');
    final String? nomor = prefs.getString('nomor');

    if (nama == null || nomor == null) {
      // Tampilkan dialog untuk meminta pengisian data pelanggan
      showDialog(
        context: context,
        builder: (context) {
          String newNama = '';
          String newNomor = '';

          return AlertDialog(
            title: const Text("Lengkapi Data Pelanggan"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  onChanged: (value) {
                    newNama = value;
                  },
                  decoration: const InputDecoration(
                    labelText: "Nama Lengkap",
                  ),
                ),
                TextField(
                  onChanged: (value) {
                    newNomor = value;
                  },
                  keyboardType: TextInputType.phone,
                  decoration: const InputDecoration(
                    labelText: "Nomor WhatsApp",
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  if (newNama.isNotEmpty && newNomor.isNotEmpty) {
                    prefs.setString('nama', newNama);
                    prefs.setString('nomor', newNomor);
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuDetail(
                          name: item['name']!,
                          price: item['price']!,
                          imageUrl: "$baseUrl/storage/${item['image']!}",
                          menuId: int.parse(item['id']!),
                          rating: item['rating']!,
                          kategori: item['kategori']!,
                          deskripsi: item['deskripsi'] ?? '',
                        ),
                      ),
                    );
                  } else {
                    // Tampilkan pesan jika data belum lengkap
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Data tidak boleh kosong!")),
                    );
                  }
                },
                child: const Text("Simpan"),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Batal"),
              ),
            ],
          );
        },
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => MenuDetail(
            name: item['name']!,
            price: item['price']!,
            imageUrl: "$baseUrl/storage/${item['image']!}",
            menuId: int.parse(item['id']!),
            rating: item['rating']!,
            kategori: item['kategori']!,
            deskripsi: item['deskripsi'] ?? '',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isOutOfStock = int.parse(item['stok']!) == 0;

    return GestureDetector(
      onTap: () {
        if (!isOutOfStock) {
          checkAndNavigate(context, item);
        }
      },
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 5,
        child: Stack(
          children: [
            item['image'] == null || item['image']!.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.fastfood,
                      size: 60,
                      color: Colors.grey,
                    ),
                  )
                : Image.network(
                    item['image']!,
                    fit: BoxFit.cover,
                    height: double.infinity,
                    width: double.infinity,
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
                      return const Center(
                        child: Icon(
                          Icons.fastfood,
                          size: 60,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
            if (isOutOfStock)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: const Center(
                    child: Text(
                      'Stok Habis',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ),
              ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item['name']!,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Rp ${item['price']}',
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        item['deskripsi'] ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
