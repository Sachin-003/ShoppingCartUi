import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'cart_provider.dart';
import 'product_model.dart';

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    double totalAmount = cartItems.fold(0, (sum, item) => sum + (item.finalPrice * item.quantity));
    int totalItems = cartItems.fold(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      backgroundColor: Colors.red[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Cart', style: TextStyle(fontSize: 20)),
        centerTitle: true,
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Stack(
            children: [
              Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (context, index) {
                final product = cartItems[index];
                return Container(
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,



                  ),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors.grey.withOpacity(0.2),
                                  width: 1,
                                )
                            ),
                            child: ClipRRect(
                              child: Image.network(
                                product.thumbnail,
                                width: MediaQuery.of(context).size.width/3,

                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.title, style: TextStyle(fontWeight: FontWeight.bold , fontSize: 12)),
                                SizedBox(height: 2),
                                Text(product.brand, style: TextStyle(fontSize: 10)),
                                SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      '₹${product.price}',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey[700],
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    SizedBox(width: 2),
                                    Text(
                                      '₹${product.finalPrice.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontSize: 8,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 5),
                                Text(
                                  '${product.discountPercentage}% OFF',
                                  style: TextStyle(fontSize: 8, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                          // ✅ Quantity Selector Buttons

                        ],
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(

                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          child:
                            Row(

                              children: [


                                GestureDetector(

                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(product, product.quantity - 1);
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.remove,size: 15,),
                                  ),
                                ),
                                Text(
                                  '${product.quantity}',
                                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold , color: Colors.pinkAccent),
                                ),
                                GestureDetector(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Icon(Icons.add,size: 15,),
                                  ),
                                  onTap: () {
                                    ref
                                        .read(cartProvider.notifier)
                                        .updateQuantity(product, product.quantity + 1);
                                  },
                                ),
                              ],
                            ),

                        ),
                      )
                    ],
                  ),
                );
              },
                      ),
                    ),
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(

                              child: Text(
                                'Amount Price',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only( top: 10),
                              child: Text(
                                '₹${totalAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          color: Colors.pinkAccent,

                        ),
                        child: Row(

                          children: [
                            Container(
                              child: Text(
                                'Check Out',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            CircleAvatar(
                              radius: 8, // Adjust the size
                              backgroundColor: Colors.white,
                              child: Text(
                                '$totalItems',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.pinkAccent,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
    );
  }
}
