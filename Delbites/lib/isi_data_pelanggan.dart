import 'package:Delbites/services/pelanggan_services.dart';
import 'package:flutter/material.dart';

class IsiDataPelanggan extends StatefulWidget {
  @override
  _IsiDataPelangganState createState() => _IsiDataPelangganState();
}

class _IsiDataPelangganState extends State<IsiDataPelanggan> {
  final _namaController = TextEditingController();
  final _teleponController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _saveData() async {
    final nama = _namaController.text;
    final telepon = _teleponController.text;
    final password = _passwordController.text;

    try {
      final result = await PelangganService().createPelanggan(
        nama: nama,
        telepon: telepon,
        password: password,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Pelanggan berhasil dibuat: ${result['nama']}')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gagal membuat pelanggan: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Isi Data Pelanggan")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _namaController,
              decoration: InputDecoration(labelText: 'Nama Lengkap'),
            ),
            TextField(
              controller: _teleponController,
              decoration: InputDecoration(labelText: 'Nomor Telepon'),
              keyboardType: TextInputType.phone,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveData,
              child: Text('Simpan Data'),
            ),
          ],
        ),
      ),
    );
  }
}
