import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final wishlist = Provider.of<WishlistProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Wishlist', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: wishlist.itemCount == 0
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.favorite_border, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'Your wishlist is empty!',
              style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the heart icon on any product to save it here.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.65, // আপাতত আগের রেশিওটাই রাখলাম
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: wishlist.wishlistItems.length,
          itemBuilder: (context, index) {
            final product = wishlist.wishlistItems.values.toList()[index];
            return ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}