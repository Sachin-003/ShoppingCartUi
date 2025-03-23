import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'product_provider.dart';
import 'product_model.dart';
import 'cart_provider.dart';
import 'cart_screen.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<Home> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  Widget build(BuildContext context) {
    final productAsync = ref.watch(productProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: Colors.red[50],

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text('Catalogue'),
        centerTitle: true,
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CartScreen()),
                  );
                },
              ),

              Positioned(
                right: 8,
                top: 8,
                child: CircleAvatar(
                  radius: 6,
                  backgroundColor: Colors.red,
                  child: Text(
                    cart.length.toString(),
                    style: TextStyle(fontSize: 8, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      body: productAsync.when(
        data: (products) => Padding(
          padding: const EdgeInsets.all(5.0),
          child: GridView.builder(
            itemCount: products.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 5,
              mainAxisSpacing: 10,
              childAspectRatio: 0.52,
            ),
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,

                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        ClipRRect(

                          child: Image.network(
                            product.thumbnail,

                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Positioned(
                          bottom: 5,
                          right: 5,
                          child: GestureDetector(
                            onTap: () {
                              ref.read(cartProvider.notifier).addToCart(product);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('${product.title} added to cart')),
                              );
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              width: 75,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.2),
                                    spreadRadius: 2,
                                    blurRadius: 5,
                                    offset: Offset(3, 3),
                                  ),
                                ],
                              ),
                              child: Text(
                                'ADD',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.title, style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text(product.brand, style: TextStyle(fontSize: 12)),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Text(
                                '₹${product.price}',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[700],
                                  decoration: TextDecoration.lineThrough,
                                ),
                              ),
                              SizedBox(width: 5),
                              Text(
                                '₹${product.finalPrice.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 15,
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Text(
                            '${product.discountPercentage}% OFF',
                            style: TextStyle(fontSize: 12, color: Colors.red),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }
}
