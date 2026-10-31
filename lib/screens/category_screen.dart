import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/product_provider.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String categoryName;

  const CategoryScreen({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // ডেটাবেস থেকে প্রোডাক্ট নিচ্ছি
    final productProvider = Provider.of<ProductProvider>(context);

    // শুধু সেই নির্দিষ্ট ক্যাটাগরির প্রোডাক্ট ফিল্টার করা
    final categoryProducts = productProvider.products.where((product) {
      return product.category.toLowerCase().contains(categoryName.toLowerCase()) ||
          categoryName.toLowerCase().contains(product.category.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName, style: const TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: categoryProducts.isEmpty
          ? const Center(
        child: Text(
          'No products found in this category.',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.70,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: categoryProducts.length,
          itemBuilder: (context, index) {
            final product = categoryProducts[index];
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