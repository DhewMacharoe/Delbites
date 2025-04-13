import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'http://127.0.0.1:8000/api/menu'));

  Future<List<dynamic>> fetchMenu() async {
    try {
      Response response = await _dio.get('/menu');
      return response.data;
    } catch (e) {
      throw Exception('Gagal mengambil data menu');
    }
  }

  Future<void> addMenu(Map<String, dynamic> data) async {
    try {
      await _dio.post('/menu', data: data);
    } catch (e) {
      throw Exception('Gagal menambahkan menu');
    }
  }
}
