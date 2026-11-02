import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/banner_provider.dart';
import '../../widgets/product_card.dart'; // তোমার প্রোডাক্ট কার্ড
import '../../screens/product_detail_screen.dart'; // প্রোডাক্ট ডিটেইলসের পাথ ঠিক করে নিও
import '../widgets/customer_web_header.dart';
import '../widgets/category_nav_bar.dart';
import '../widgets/customer_web_banner.dart';
import '../widgets/customer_web_footer.dart';
import '../widgets/web_category_slider.dart';

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

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ১. হেডার (সবচেয়ে উপরে)
          const CustomerWebHeader(),

          // ২. ক্যাটাগরি বার (হেডারের ঠিক নিচে)
          const CategoryNavBar(),

          // ৩. মূল স্ক্রলেবল কন্টেন্ট
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ১. নতুন স্লাইডার + স্থির ব্যানার
                  const CustomerWebBanner(),

                  // ২. নতুন Featured Categories (অনুভূমিক)
                  const WebCategorySlider(),

                  // ৩. প্রোডাক্ট হেডিং
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, right: 40.0, top: 40.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Top Selling Products', style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
                        TextButton(onPressed: () {}, child: Text('See All', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16))),
                      ],
                    ),
                  ),

                  // ৫. প্রোডাক্ট গ্রিড
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

                  // ৬. ফুটার
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