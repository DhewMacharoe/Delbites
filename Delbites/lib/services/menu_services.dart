import 'dart:convert';

import 'package:Delbites/models/menu.dart';
import 'package:http/http.dart' as http;

class MenuService {
  final String baseUrl = 'https://delbites.d4trpl-itdel.id/api/menu';

  Future<List<Menu>> fetchMenus() async {
    final response = await http.get(Uri.parse(baseUrl));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((item) => Menu.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil data menu');
    }
  }

  Future<List<Menu>> fetchTopMenus() async {
    final response = await http.get(Uri.parse('$baseUrl/top'));

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);

      List<dynamic> data = responseData['data'];
      return data.map((item) => Menu.fromJson(item)).toList();
    } else {
      throw Exception('Gagal mengambil top menu');
    }
  }

  Future<bool> tambahMenu({
    required String namaMenu,
    required int harga,
    required int stok,
    required String kategori,
  }) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'nama_menu': namaMenu,
        'harga': harga.toString(),
        'stok': stok.toString(),
        'kategori': kategori,
      },
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Error: ${response.body}');
      return false;
    }
  }
}
