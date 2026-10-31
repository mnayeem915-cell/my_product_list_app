import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/translations/app_localizations.dart';
import '../widgets/product_card.dart';
import 'product_detail_screen.dart';
import '../widgets/app_drawer.dart';
import 'category_screen.dart';
import '../providers/product_provider.dart';
import '../providers/category_provider.dart';
import '../providers/banner_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    final l10n = AppLocalizations.of(context)!;
    final productProvider = Provider.of<ProductProvider>(context);
    final categoryProvider = Provider.of<CategoryProvider>(context);
    final bannerProvider = Provider.of<BannerProvider>(context);

    return Scaffold(
      drawer: const AppDrawer(),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverAppBar(
              floating: true,
              leading: Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () => Scaffold.of(context).openDrawer(),
                ),
              ),
              title: Row(
                children: [
                  Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 8),
                  Text(
                    l10n.appTitle,
                    style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor, fontSize: 18),
                  ),
                ],
              ),
              actions: [
                IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
              ],
            ),

            // ব্যানার
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: bannerProvider.bannerUrls.isEmpty
                      ? Container(height: 150, color: Colors.grey[300], child: const Center(child: Text('No Banner')))
                      : Image.network(
                    bannerProvider.bannerUrls.first, // প্রথম ব্যানারটা দেখাবে
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),

            // ক্যাটাগরি হেডিং
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Categories', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('See All', style: TextStyle(color: Theme.of(context).primaryColor)),
                  ],
                ),
              ),
            ),

            // ক্যাটাগরি লিস্ট (ডেটাবেস থেকে)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: categoryProvider.categories.isEmpty
                    ? const Center(child: Text('Loading Categories...'))
                    : ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  itemCount: categoryProvider.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryProvider.categories[index];
                    return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CategoryScreen(categoryName: category.name)),
                        );
                      },
                      child: Container(
                        width: 90,
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: Colors.orange.shade50,
                              child: Icon(Icons.category, color: Theme.of(context).primaryColor),
                            ),
                            const SizedBox(height: 8),
                            Text(category.name, style: const TextStyle(fontSize: 12), textAlign: TextAlign.center),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Top Selling হেডিং
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
                child: Row(
                  children: [
                    Icon(Icons.local_fire_department, color: Colors.orange),
                    SizedBox(width: 8),
                    Text('Top Selling', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),

            // প্রোডাক্ট গ্রিড
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              sliver: productProvider.isLoading
                  ? const SliverToBoxAdapter(child: Center(child: CircularProgressIndicator()))
                  : productProvider.products.isEmpty
                  ? const SliverToBoxAdapter(child: Center(child: Padding(padding: EdgeInsets.all(20.0), child: Text('No products found in the database.'))))
                  : SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.70,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
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
                  childCount: productProvider.products.length,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}