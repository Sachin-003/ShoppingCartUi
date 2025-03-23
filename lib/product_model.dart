class Product {
  final int id;
  final String title;
  final String description;
  final double price;
  final double rating;
  final int stock;
  final String category;
  final String thumbnail;
  final String brand;
  final double discountPercentage;
  final double finalPrice;
  final int quantity; // ✅ Add quantity field

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.rating,
    required this.stock,
    required this.category,
    required this.thumbnail,
    required this.brand,
    required this.discountPercentage,
    required this.finalPrice,
    this.quantity = 1, // ✅ Default quantity to 1
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'Unknown Title',
      description: json['description'] ?? 'No description available',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      stock: json['stock'] ?? 0,
      category: json['category'] ?? 'Unknown Category',
      thumbnail: json['thumbnail'] ?? '',
      brand: json['brand'] ?? 'Unknown Brand',
      discountPercentage: (json['discountPercentage'] as num?)?.toDouble() ?? 0.0,
      finalPrice: (json['price']-(json['price']*json['discountPercentage']/100)),
      quantity: 1, // ✅ Initialize quantity
    );
  }

  // ✅ Add copyWith method to update quantity
  Product copyWith({int? quantity}) {
    return Product(
      id: id,
      title: title,
      description: description,
      price: price,
      rating: rating,
      stock: stock,
      category: category,
      thumbnail: thumbnail,
      brand: brand,
      discountPercentage: discountPercentage,
      finalPrice: finalPrice,
      quantity: quantity ?? this.quantity,
    );
  }
}
