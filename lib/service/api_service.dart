import 'package:demo/models/product.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(baseUrl: 'https://fakestoreapi.com'));

  Future<List<Product>> fetchProducts() async {
    try {
      final response = await _dio.get('/products');
      return (response.data as List).map((e) => Product.fromJson(e)).toList();
    } catch (e) {
      throw Exception('Failed to load products');
    }
  }
}