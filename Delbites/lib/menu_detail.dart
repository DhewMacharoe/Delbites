import 'dart:convert';

import 'package:Delbites/suhu_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
  double _userRating = 0;
  Future<void> addToCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final idPelanggan = prefs.getInt('id_pelanggan');

      if (idPelanggan == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sesi tidak valid, silahkan coba lagi')),
        );
        return;
      }

      print("DEBUG - id_pelanggan = $idPelanggan");

      final body = jsonEncode({
        'id_menu': widget.menuId,
        'id_pelanggan': idPelanggan,
        'nama_menu': widget.name,
        'kategori': widget.kategori,
        'suhu': selectedSuhu,
        'jumlah': 1,
        'harga': int.tryParse(widget.price) ?? 0,
        'catatan': catatanTambahan ?? '',
      });

      print("DEBUG - body = $body");

      final response = await http.post(
        Uri.parse('$baseUrl/api/keranjang'), // Gunakan baseUrl yang konsisten
        headers: {'Content-Type': 'application/json'},
        body: body,
      );
      // Perbaikan pengecekan response
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(responseData['message'] ??
                'Item berhasil ditambahkan ke keranjang'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pop(context);
      } else {
        final errorData = json.decode(response.body);
        print("GAGAL: ${response.statusCode} ${response.body}");
        throw Exception(
            errorData['message'] ?? 'Gagal menambahkan ke keranjang');
      }
    } catch (e) {
      // Jika error mengandung "validasi gagal" → reset id_pelanggan dan buka pop-up
      final errorMsg = e.toString();
      if (errorMsg.toLowerCase().contains('validasi') ||
          errorMsg.toLowerCase().contains('pelanggan')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('id_pelanggan'); // reset id yang tidak valid

        // Tampilkan dialog pengisian data pelanggan
        _showPelangganDialog();
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Gagal menambahkan ke keranjang: $errorMsg'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showPelangganDialog() {
    String nama = '';
    String nomor = '';
    final _formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Lengkapi Data Pelanggan"),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: "Nama Lengkap"),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nama wajib diisi';
                    }
                    return null;
                  },
                  onChanged: (value) => nama = value.trim(),
                ),
                TextFormField(
                  decoration:
                      const InputDecoration(labelText: "Nomor WhatsApp"),
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Nomor HP wajib diisi';
                    }
                    return null;
                  },
                  onChanged: (value) => nomor = value.trim(),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  try {
                    final prefs = await SharedPreferences.getInstance();
                    final deviceId = prefs.getString('device_id') ?? '';

                    final response = await http.post(
                      Uri.parse('$baseUrl/api/pelanggan'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        'nama': nama,
                        'telepon': nomor,
                        'device_id': deviceId,
                      }),
                    );

                    if (response.statusCode == 200 ||
                        response.statusCode == 201) {
                      final data = jsonDecode(response.body);
                      await prefs.setInt('id_pelanggan', data['id']);
                      await prefs.setString('nama_pelanggan', data['nama']);
                      await prefs.setString(
                          'telepon_pelanggan', data['telepon'] ?? '');
                      Navigator.pop(context);
                      addToCart(); // retry
                    } else {
                      throw Exception('Gagal menyimpan pelanggan');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Gagal menyimpan pelanggan: $e')),
                    );
                  }
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  // Fungsi untuk menampilkan dialog catatan tambahan
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
        backgroundColor: const Color(0xFF2D5EA2),
        title: Text(
          widget.name,
          style: const TextStyle(
            color: Colors.white, // warna teks putih
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white), // ikon putih
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
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
                      : 'https://via.placeholder.com/200',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Center(child: CircularProgressIndicator());
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
            const Text(
              'Deskripsi:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 5),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                widget.deskripsi,
                style: const TextStyle(fontSize: 16),
              ),
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
            RatingBarIndicator(
              rating: double.tryParse(widget.rating) ?? 0.0,
              itemBuilder: (context, index) =>
                  const Icon(Icons.star, color: Colors.amber),
              itemCount: 5,
              itemSize: 30.0,
              direction: Axis.horizontal,
            ),
            Text('${widget.rating}/5.0', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (widget.kategori == 'minuman' && selectedSuhu == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Pilih versi minuman terlebih dahulu!')),
                  );
                  return;
                }
                _showCatatanDialog(context);
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
