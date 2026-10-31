import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../providers/product_provider.dart'; // প্রোডাক্ট প্রোভাইডার

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    // ডেটাবেস থেকে আসা প্রোডাক্টগুলো নিচ্ছি
    final productProvider = Provider.of<ProductProvider>(context);
    final allProducts = productProvider.products;

    // সার্চ কোয়েরি অনুযায়ী প্রোডাক্ট ফিল্টার করা
    final List<Product> filteredProducts = allProducts.where((product) {
      return product.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          product.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          decoration: const InputDecoration(
            hintText: 'Search for products, brands & more...',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
          onChanged: (value) {
            setState(() {
              _searchQuery = value;
            });
          },
        ),
      ),
      body: filteredProducts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 80, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            const Text(
              'No products found!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          ],
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
          itemCount: filteredProducts.length,
          itemBuilder: (context, index) {
            final product = filteredProducts[index];
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