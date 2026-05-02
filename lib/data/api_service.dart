import 'package:dio/dio.dart';
import '../domain/product.dart';

class ApiService {
  final Dio _dio;

  ApiService() : _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com')) {
    // Interceptor sesuai syarat (POIN 2 - Logger)
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

  Future<List<Product>> fetchProducts() async {
    try {
      // 1. Pastikan pakai _dio (dengan garis bawah)
      final response = await _dio.get('/products');
      
      // 2. Ambil data mentah (JSON)
      final List<dynamic> rawData = response.data;

      // 3. LOGIKA PERSONAL (NIM GENAP): Manipulasi di layer Service (Anti-AI Rule)
      // Kita manipulasi JSON-nya sebelum diubah jadi object Product
      final List<dynamic> manipulatedData = rawData.map((json) {
        final Map<String, dynamic> item = Map<String, dynamic>.from(json);
        
        // Tambahkan [Promo Ongkir] ke nama produk
        item['title'] = '${item['title']} [Promo Ongkir]';
        
        return item;
      }).toList();

      // 4. Baru ubah ke bentuk List Product
      return manipulatedData.map((json) => Product.fromJson(json)).toList();
      
    } catch (e) {
      throw Exception('Gagal mengambil data produk: $e');
    }
  }
}