import 'package:dio/dio.dart';
import '../domain/product.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com')) {
    // Menambahkan Interceptor sesuai syarat ETS Modul 4
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          print('MENGIRIM REQUEST... ke: ${options.uri}');
          return handler.next(options); 
        },
        onResponse: (response, handler) {
          print('BERHASIL.... Mendapat data dari: ${response.requestOptions.uri}');
          return handler.next(response);
        },
        onError: (DioException e, handler) {
          print('X ERROR: ${e.message}');
          return handler.next(e);
        },
      ),
    );
  }

  // Fungsi untuk mengambil daftar produk
  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/products');
      List<dynamic> data = response.data;
      // Mengubah list JSON menjadi list Objek Product
      return data.map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Gagal memuat produk: $e');
    }
  }
}