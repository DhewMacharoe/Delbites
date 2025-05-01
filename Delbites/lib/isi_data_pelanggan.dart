import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class IsiDataPelanggan extends StatefulWidget {
  @override
  _IsiDataPelangganState createState() => _IsiDataPelangganState();
}

class _IsiDataPelangganState extends State<IsiDataPelanggan> {
  final TextEditingController _namaController = TextEditingController();
  final TextEditingController _nomorController = TextEditingController();

  Future<void> _simpanData() async {
    final nama = _namaController.text.trim();
    final nomor = _nomorController.text.trim();

    if (nama.isEmpty || nomor.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Nama dan nomor telepon wajib diisi.')),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('nama', nama);
    await prefs.setString('nomor', nomor);

    Navigator.pop(context); // Kembali ke halaman sebelumnya
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Isi Data Pelanggan'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama'),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _nomorController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _simpanData,
              child: Text('Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
