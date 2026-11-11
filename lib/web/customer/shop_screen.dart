import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/product_card.dart';
import '../../screens/product_detail_screen.dart';

class ShopScreen extends StatefulWidget {
  final String shopName; // লিংক থেকে আসা দোকানের নাম

  const ShopScreen({super.key, required this.shopName});

  @override
  State<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ShopProvider>(context, listen: false).fetchShopData(widget.shopName);
    });
  }

  @override
  Widget build(BuildContext context) {
    final shopProvider = Provider.of<ShopProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(shopProvider.shopDetails?['shop_name'] ?? 'Shop'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: shopProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : shopProvider.shopDetails == null
          ? const Center(child: Text('Shop not found!'))
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // দোকানের ব্যানার
            if (shopProvider.shopDetails!['shop_banner_url'] != null)
              Image.network(
                shopProvider.shopDetails!['shop_banner_url'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),

            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Text(
                'Products from ${shopProvider.shopDetails!['shop_name']}',
                style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),

            // দোকানের প্রোডাক্ট গ্রিড
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: shopProvider.shopProducts.isEmpty
                  ? const Center(child: Text('No products in this shop yet.'))
                  : GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 250,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: shopProvider.shopProducts.length,
                itemBuilder: (context, index) {
                  final product = shopProvider.shopProducts[index];
                  return ProductCard(
                    product: product,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ProductDetailScreen(product: product)),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}