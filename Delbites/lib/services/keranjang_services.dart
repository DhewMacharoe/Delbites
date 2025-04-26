import 'dart:convert';

import 'package:http/http.dart' as http;

const String baseUrl = 'http://127.0.0.1:8000/keranjang';

class KeranjangService {
  static Future<bool> addToCart({
    required int idPelanggan,
    required int idMenu,
    required String namaMenu,
    required String kategori,
    required int jumlah,
    required String harga,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/keranjang'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'id_pelanggan': idPelanggan,
          'id_menu': idMenu,
          'nama_menu': namaMenu,
          'kategori': kategori,
          'jumlah': jumlah,
          'harga': harga,
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add to cart');
      }
    } catch (e) {
      rethrow;
    }
  }
}
