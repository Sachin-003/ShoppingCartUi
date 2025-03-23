import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_model.dart';

// Cart State Provider
final cartProvider = StateNotifierProvider<CartNotifier, List<Product>>((ref) {
  return CartNotifier();
});

class CartNotifier extends StateNotifier<List<Product>> {
  CartNotifier() : super([]);

  void addToCart(Product product) {
    final existingProduct = state.firstWhere(
          (item) => item.id == product.id,
      orElse: () => Product(id: -1, title: '', description: '', price: 0, rating: 0, stock: 0, category: '', thumbnail: '', brand: '', discountPercentage: 0, finalPrice: 0, quantity: 0),
    );

    if (existingProduct.id != -1) {
      // If product exists, increase quantity
      state = state.map((item) {
        return item.id == product.id
            ? item.copyWith(quantity: item.quantity + 1)
            : item;
      }).toList();
    } else {
      // If product is new, add with quantity 1
      state = [...state, product.copyWith(quantity: 1)];
    }
  }

  void removeFromCart(Product product) {
    state = state.where((item) => item.id != product.id).toList();
  }

  void updateQuantity(Product product, int newQuantity) {
    if (newQuantity <= 0) {
      removeFromCart(product);
    } else {
      state = state.map((item) {
        return item.id == product.id ? item.copyWith(quantity: newQuantity) : item;
      }).toList();
    }
  }

  void clearCart() {
    state = [];
  }
}
