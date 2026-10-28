import 'package:flutter/material.dart';
import '../l10n/translations/app_localizations.dart';
import '../data/dummy_data.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.appTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // সার্চ ফাংশনালিটি পরে যোগ করবো
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: GridView.builder(
          padding: const EdgeInsets.only(top: 16, bottom: 16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // এক লাইনে ২টি প্রোডাক্ট
            childAspectRatio: 0.68, // কার্ডের উচ্চতা ও প্রস্থের অনুপাত
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: dummyProducts.length,
          itemBuilder: (context, index) {
            final product = dummyProducts[index];
            return ProductCard(
              product: product,
              onTap: () {
                // প্রোডাক্টে ক্লিক করলে ডিটেইলস পেজে যাবে (পরে করবো)
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Clicked: ${product.name}')),
                );
              },
            );
          },
        ),
      ),
    );
  }
}