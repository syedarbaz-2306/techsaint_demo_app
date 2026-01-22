import 'package:demo/models/product.dart';
import 'package:demo/service/api_service.dart';
import 'package:demo/service/hive_service.dart';
import 'package:flutter/material.dart';

class AppProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  Map<int, int> _cart = {};
  bool _isDarkMode = false;
  bool _ascending = false;

  List<Product> get products => _filteredProducts;
  Map<int, int> get cart => _cart;
  bool get isDarkMode => _isDarkMode;
  bool get ascending => _ascending;

  AppProvider() {
    _loadCart();
    loadProducts();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }

  Future<void> loadProducts() async {
    _products = await _apiService.fetchProducts();
    _filteredProducts = _products;
    notifyListeners();
  }

  void searchProducts(String query) {
    _filteredProducts = _products
        .where((p) => p.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
    notifyListeners();
  }

  void sortProducts(bool ascending) {
    _ascending = ascending;
    _filteredProducts.sort(
      (a, b) =>
          ascending ? a.price.compareTo(b.price) : b.price.compareTo(a.price),
    );
    notifyListeners();
  }

  void _loadCart() {
    final box = HiveService.getCartBox();
    _cart = Map<int, int>.from(box.get('items', defaultValue: {}));
    notifyListeners();
  }

  void addToCart(int productId) {
    _cart[productId] = (_cart[productId] ?? 0) + 1;
    _saveCart();
  }

  void removeFromCart(int productId) {
    if (_cart.containsKey(productId)) {
      if (_cart[productId]! > 1) {
        _cart[productId] = _cart[productId]! - 1;
      } else {
        _cart.remove(productId);
      }
      _saveCart();
    }
  }

  void _saveCart() {
    HiveService.getCartBox().put('items', _cart);
    notifyListeners();
  }
}
