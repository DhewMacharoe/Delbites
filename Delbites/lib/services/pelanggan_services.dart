import 'dart:convert';

import 'package:http/http.dart' as http;

class PelangganService {
  final String _baseUrl = 'http://127.0.0.1:8000/api/pelanggan';

  Future<List<dynamic>> fetchPelanggan() async {
    final response = await http.get(Uri.parse('$_baseUrl/pelanggan'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengambil data pelanggan');
    }
  }

  Future<Map<String, dynamic>> getPelangganById(int id) async {
    final response = await http.get(Uri.parse('$_baseUrl/pelanggan/$id'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Pelanggan tidak ditemukan');
    }
  }

  Future<Map<String, dynamic>> createPelanggan({
    required String nama,
    String? telepon,
    required String password,
    String status = 'aktif',
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/pelanggan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'nama': nama,
        'telepon': telepon,
        'password': password,
        'status': status,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal membuat pelanggan');
    }
  }

  Future<Map<String, dynamic>> updatePelanggan({
    required int id,
    String? nama,
    String? telepon,
    String? password,
    String? status,
  }) async {
    final response = await http.put(
      Uri.parse('$_baseUrl/pelanggan/$id'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        if (nama != null) 'nama': nama,
        if (telepon != null) 'telepon': telepon,
        if (password != null) 'password': password,
        if (status != null) 'status': status,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Gagal mengupdate pelanggan');
    }
  }

  Future<void> deletePelanggan(int id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/pelanggan/$id'));

    if (response.statusCode != 200) {
      throw Exception('Gagal menghapus pelanggan');
    }
  }
}
