import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/category_provider.dart';
import '../../providers/banner_provider.dart';
import '../../providers/shop_provider.dart';
import '../../widgets/product_card.dart';
import '../../screens/product_detail_screen.dart';

// উইজেট ইম্পোর্ট
import '../widgets/customer_web_header.dart';
import '../widgets/category_nav_bar.dart';
import '../widgets/customer_web_banner.dart';
import '../widgets/customer_web_footer.dart';

class CustomerWebScreen extends StatefulWidget {
  final String? initialShopName; // 👈 প্যারামিটার

  const CustomerWebScreen({super.key, this.initialShopName});

  @override
  State<CustomerWebScreen> createState() => _CustomerWebScreenState();
}

class _CustomerWebScreenState extends State<CustomerWebScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialShopName != null) {
        Provider.of<ShopProvider>(context, listen: false).fetchShopData(widget.initialShopName!);
      } else {
        Provider.of<ProductProvider>(context, listen: false).fetchProducts();
      }
      Provider.of<CategoryProvider>(context, listen: false).fetchCategories();
      Provider.of<BannerProvider>(context, listen: false).fetchBanners();
    });
  }

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    final shopProvider = Provider.of<ShopProvider>(context);

    final displayProducts = widget.initialShopName != null
        ? shopProvider.shopProducts
        : productProvider.products;

    final isLoading = widget.initialShopName != null
        ? shopProvider.isLoading
        : productProvider.isLoading;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CustomerWebHeader(),
          const CategoryNavBar(),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // ব্যানার
                  const CustomerWebBanner(),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.initialShopName != null
                              ? 'Products from ${widget.initialShopName}'
                              : 'Top Selling Products',
                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        if (widget.initialShopName != null)
                          TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (context) => const CustomerWebScreen()),
                              );
                            },
                            child: Text('See All Products', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                          )
                        else
                          TextButton(
                            onPressed: () {},
                            child: Text('See All', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 16)),
                          ),
                      ],
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                    child: isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : displayProducts.isEmpty
                        ? const Center(
                      child: Padding(
                        padding: EdgeInsets.all(40.0),
                        child: Text('No products available', style: TextStyle(fontSize: 18, color: Colors.grey)),
                      ),
                    )
                        : GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 300,
                        childAspectRatio: 0.7,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                      ),
                      itemCount: displayProducts.length,
                      itemBuilder: (context, index) {
                        final product = displayProducts[index];
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