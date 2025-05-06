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
    required String harga, // Asumsikan harga awal dalam format String seperti "Rp 5000"
  }) async {
    try {
      // Jika harga datang sebagai format string seperti "Rp 5000", kita konversi menjadi angka
      final int parsedHarga = _parseHarga(harga);

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
          'harga': parsedHarga, // Kirim harga dalam bentuk integer
        }),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw Exception('Failed to add to cart: ${response.body}');
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  // Fungsi untuk mengkonversi harga dari string (misalnya "Rp 5000") ke integer
  static int _parseHarga(String harga) {
    try {
      // Menghapus "Rp" dan karakter non-digit lainnya, lalu mengubah ke integer
      final numericHarga = harga.replaceAll(RegExp(r'\D'), '');
      return int.parse(numericHarga);
    } catch (e) {
      print('Error parsing harga: $e');
      return 0; // Jika terjadi kesalahan, mengembalikan harga 0
    }
  }
}
