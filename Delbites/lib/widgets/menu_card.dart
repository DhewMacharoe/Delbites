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
    } catch (_) {}

    // Tampilkan form jika pelanggan belum ada
    _showPelangganForm(context, storedDeviceId, item);
  }

  void _showPelangganForm(
      BuildContext context, String deviceId, Map<String, String> item) {
    String nama = '';
    String nomor = '';

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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            TextButton(
              onPressed: () async {
                if (nama.isEmpty || nomor.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text("Nama dan nomor HP wajib diisi.")),
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
                      'device_id': deviceId,
                    }),
                  );

                  if (response.statusCode == 201) {
                    final data = jsonDecode(response.body);
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('id_pelanggan', data['id']);
                    await prefs.setString('nama_pelanggan', data['nama']);
                    await prefs.setString('telepon_pelanggan', data['telepon']);
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

  Future<String> getDeviceId() async {
    final deviceInfo = DeviceInfoPlugin();
    if (Platform.isAndroid) {
      final info = await deviceInfo.androidInfo;
      return info.id?.toLowerCase() ?? '';
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
                      "$baseUrl/storage/${item['image']}",
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
                          'Rp ${item['price']}',
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
