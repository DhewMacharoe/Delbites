import 'dart:convert';
import 'dart:io';

import 'package:Delbites/menu_detail.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

const String baseUrl = 'http://127.0.0.1:8000';

class MenuCard extends StatelessWidget {
  final Map<String, String> item;

  const MenuCard({Key? key, required this.item}) : super(key: key);

  Future<void> checkAndNavigate(
      BuildContext context, Map<String, String> item) async {
    final prefs = await SharedPreferences.getInstance();
    final existingId = prefs.getInt('id_pelanggan');

    print('📦 id_pelanggan dari prefs: $existingId');

    if (existingId != null) {
      _navigateToMenuDetail(context, item);
      return;
    }

    String? storedDeviceId = prefs.getString('device_id');
    if (storedDeviceId == null || storedDeviceId.isEmpty) {
      storedDeviceId = (await getDeviceId()).toLowerCase();
      await prefs.setString('device_id', storedDeviceId);
    }

    print('📱 DEVICE ID FLUTTER: $storedDeviceId');

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
      print('❌ Error GET pelanggan by-device: $e');
    }

    // Jika belum ada di backend, tampilkan form
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
                onChanged: (value) => newNama = value,
                decoration: const InputDecoration(labelText: "Nama Lengkap"),
              ),
              TextField(
                onChanged: (value) => newNomor = value,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: "Nomor WhatsApp"),
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
                if (newNama.isNotEmpty) {
                  try {
                    final postResponse = await http.post(
                      Uri.parse('$baseUrl/api/pelanggan'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'nama': newNama,
                        'telepon': newNomor,
                        'device_id': storedDeviceId,
                      }),
                    );

                    if (postResponse.statusCode == 201) {
                      final data = jsonDecode(postResponse.body);
                      await prefs.setInt('id_pelanggan', data['id']);
                      await prefs.setString('nama_pelanggan', data['nama']);
                      await prefs.setString(
                          'telepon_pelanggan', data['telepon'] ?? '');
                      Navigator.pop(context);
                      _navigateToMenuDetail(context, item);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Gagal menyimpan pelanggan: ${postResponse.body}')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan pelanggan: $e')),
                    );
                  }
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Nama tidak boleh kosong")),
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

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.id?.toLowerCase() ?? ''; // ✅ tambahkan toLowerCase()
    } else if (Platform.isIOS) {
      final info = await deviceInfo.iosInfo;
      return info.identifierForVendor?.toLowerCase() ?? '';
    }
    return '';
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
                        return const Center(child: CircularProgressIndicator());
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
