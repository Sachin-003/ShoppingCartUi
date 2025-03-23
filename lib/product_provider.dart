import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

// API URL
const String apiUrl = 'https://dummyjson.com/products';

// Pagination StateNotifier
class ProductNotifier extends StateNotifier<List<Product>> {
  ProductNotifier() : super([]);

  int _page = 0;
  final int _limit = 10;
  bool _isFetching = false;
  bool _hasMore = true;

  Future<void> fetchProducts() async {
    if (_isFetching || !_hasMore) return;

    _isFetching = true;
    final response = await http.get(Uri.parse('$apiUrl?limit=$_limit&skip=${_page * _limit}'));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final List<dynamic> productsJson = jsonData['products'];

      if (productsJson.isEmpty) {
        _hasMore = false;
      } else {
        state = [...state, ...productsJson.map((json) => Product.fromJson(json)).toList()];
        _page++;
      }
    } else {
      throw Exception('Failed to load products');
    }

    _isFetching = false;
  }
}

// Provider for pagination
final productProvider = StateNotifierProvider<ProductNotifier, List<Product>>((ref) {
  final notifier = ProductNotifier();
  notifier.fetchProducts(); // Initial fetch
  return notifier;
});
