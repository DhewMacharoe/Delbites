import 'dart:convert';

import 'package:Delbites/menu_detail.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

const String baseUrl = 'https://delbites.d4trpl-itdel.id';

class MenuCard extends StatelessWidget {
  final Map<String, String> item;

  const MenuCard({Key? key, required this.item}) : super(key: key);

  Future<void> checkAndNavigate(
      BuildContext context, Map<String, String> item) async {
    final prefs = await SharedPreferences.getInstance();
    final existingId = prefs.getInt('id_pelanggan');

    if (existingId != null) {
      _navigateToMenuDetail(context, item);
      return;
    }

    String? storedDeviceId = prefs.getString('device_id');
    if (storedDeviceId == null || storedDeviceId.isEmpty) {
      storedDeviceId = (await getDeviceId()).toLowerCase();
      await prefs.setString('device_id', storedDeviceId);
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/pelanggan/by-device?device_id=$storedDeviceId'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await prefs.setInt('id_pelanggan', data['id']);
        await prefs.setString('nama_pelanggan', data['nama']);
        await prefs.setString('telepon_pelanggan', data['telepon'] ?? '');
        _navigateToMenuDetail(context, item);
        return;
      }
    } catch (e) {
      print("Error fetching customer data: $e");
    }

    // Tampilkan form jika pelanggan belum ada
    _showPelangganForm(context, storedDeviceId, item);
  }

  void _showPelangganForm(
      BuildContext context, String deviceId, Map<String, String> item) {
    String nama = '';
    String nomor = '';
    String email = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lengkapi Data Pelanggan"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) => nama = value,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                ),
              ),
              TextField(
                onChanged: (value) => nomor = value,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: "Nomor WhatsApp",
                ),
              ),
              TextField(
                onChanged: (value) => email = value.trim(),
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: "Email",
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
                if (nama.isEmpty ||
                    nomor.isEmpty ||
                    email.isEmpty ||
                    !emailRegex.hasMatch(email)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Semua data wajib diisi dengan benar.")),
                  );
                  return;
                }

                try {
                  final response = await http.post(
                    Uri.parse('$baseUrl/api/pelanggan'),
                    headers: {'Content-Type': 'application/json'},
                    body: jsonEncode({
                      'nama': nama,
                      'telepon': nomor,
                      'email': email,
                      'device_id': deviceId,
                    }),
                  );

                  if (response.statusCode == 201) {
                    final data = jsonDecode(response.body);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('id_pelanggan', data['id']);
                    await prefs.setString('nama_pelanggan', data['nama']);
                    await prefs.setString('telepon_pelanggan', data['telepon']);
                    await prefs.setString(
                        'email_pelanggan', email); // Simpan email
                    Navigator.pop(context);
                    _navigateToMenuDetail(context, item);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text("Gagal menyimpan data pelanggan")),
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal: $e")),
                  );
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  String formatPrice(String rawPrice) {
    final int price = int.tryParse(
            rawPrice.replaceAll('.', '').replaceAll('Rp', '').trim()) ??
        0;
    return NumberFormat.decimalPattern('id').format(price);
  }

  Future<String> getDeviceId() async {
    final prefs = await SharedPreferences.getInstance();
    String? deviceId = prefs.getString('device_id');
    if (deviceId == null) {
      deviceId = const Uuid().v4(); // UUID acak
      await prefs.setString('device_id', deviceId);
    }
    return deviceId;
  }

  void _navigateToMenuDetail(BuildContext context, Map<String, String> item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MenuDetail(
          name: item['name']!,
          price: item['price']!,
          imageUrl: "$baseUrl/storage/${item['image']!}",
          menuId: int.parse(item['id']!),
          rating: item['rating'] ?? '0.0',
          kategori: item['kategori']!,
          deskripsi: item['deskripsi'] ?? '',
        ),
      ),
    );
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
      child: Opacity(
        opacity: isOutOfStock ? 0.5 : 1.0,
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          elevation: 4,
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Image.network(
                      'https://delbites.d4trpl-itdel.id/storage/${item['image']}',
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Center(
                            child: Icon(Icons.broken_image, size: 40),
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Rp ${formatPrice(item['price']!)}',
                          style: const TextStyle(color: Colors.black87),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (isOutOfStock)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                    child: const Text(
                      'Habis',
                      style: TextStyle(color: Colors.white, fontSize: 12),
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
