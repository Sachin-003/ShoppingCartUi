import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'product_model.dart';

// API URL
const String apiUrl = 'https://dummyjson.com/products';

// Provider to fetch products
final productProvider = FutureProvider<List<Product>>((ref) async {
  final response = await http.get(Uri.parse(apiUrl));

  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    final List<dynamic> productsJson = jsonData['products'];
    return productsJson.map((json) => Product.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load products');
  }
});
