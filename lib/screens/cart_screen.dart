import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'order_success_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: cart.itemCount == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text('Your cart is empty!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.grey)),
          ],
        ),
      )
          : Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                // ম্যাপ থেকে আইটেমগুলোকে লিস্টে নিচ্ছি
                final cartItem = cart.cartItems.values.toList()[index];
                final product = cartItem.product;

                return Container(
                  margin: const EdgeInsets.only(bottom: 16),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      // ছবি
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          product.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80, height: 80, color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),

                      // বিবরণ
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '৳${product.price.toStringAsFixed(0)}',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: 8),

                            // Quantity (+ / -) বাটন
                            Row(
                              children: [
                                // মাইনাস বাটন
                                InkWell(
                                  onTap: () {
                                    cart.decreaseQuantity(product.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.remove, size: 16, color: Colors.grey.shade700),
                                  ),
                                ),
                                // পরিমাণ
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    cartItem.quantity.toString().padLeft(2, '0'),
                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                // প্লাস বাটন
                                InkWell(
                                  onTap: () {
                                    cart.increaseQuantity(product.id);
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Icon(Icons.add, size: 16, color: Colors.grey.shade700),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // ডিলিট বাটন
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () {
                          cart.removeFromCart(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // চেকআউট অংশ
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              boxShadow: [
                BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, -5))
              ],
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Price', style: TextStyle(fontSize: 16, color: Colors.grey)),
                    Text(
                      '৳${cart.totalPrice.toStringAsFixed(0)}',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      // আপাতত চেকআউটে কার্ট খালি করে দিচ্ছি
                      cart.cartItems.clear();
                      cart.notifyListeners();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => const OrderSuccessScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Proceed to Checkout', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}