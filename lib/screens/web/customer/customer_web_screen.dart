import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/category_provider.dart'; // ড্রয়ার বা অন্য জায়গায় লাগতে পারে
import '../../../providers/banner_provider.dart';
import '../../../widgets/product_card.dart';
import '../../product_detail_screen.dart';
import '../widgets/customer_web_header.dart'; // নতুন হেডার
import '../widgets/customer_web_footer.dart'; // নতুন ফুটার

class CustomerWebScreen extends StatefulWidget {
  const CustomerWebScreen({super.key});

  @override
  State<CustomerWebScreen> createState() => _CustomerWebScreenState();
}

class _CustomerWebScreenState extends State<CustomerWebScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<BannerProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final bannerProvider = Provider.of<BannerProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ১. নতুন হেডার (যেখানে ক্যাটাগরি বারও আছে)
          const CustomerWebHeader(),

          // ২. মূল কন্টেন্ট
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ব্যানার
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: bannerProvider.bannerUrls.isNotEmpty
                          ? Image.network(bannerProvider.bannerUrls.first, height: 400, width: double.infinity, fit: BoxFit.cover)
                          : Container(height: 400, color: Colors.grey[300], child: const Center(child: Text('Banner'))),
                    ),
                  ),

                  // প্রোডাক্ট হেডিং
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Top Selling Products', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        TextButton(
                          onPressed: () {},
                          child: Text('See All', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                        ),
                      ],
                    ),
                  ),

                  // প্রোডাক্ট গ্রিড
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: productProvider.isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : productProvider.products.isEmpty
                        ? const Center(child: Text('No products available'))
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: productProvider.products.length,
                      itemBuilder: (context, index) {
                        final product = productProvider.products[index];
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

                  // ৩. নতুন ফুটার
                  const CustomerWebFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}