import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/auth_provider.dart';
import '../add_product_web_screen.dart';
import '../widgets/web_sidebar.dart';
import '../widgets/web_stat_card.dart';
import '../widgets/web_product_card.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // স্ক্রিন ছোট হলে সাইডবার লুকাবে
    bool isDesktop = MediaQuery.of(context).size.width > 800;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC),
      drawer: !isDesktop
          ? Drawer(
        child: WebSidebar(
          selectedIndex: _selectedIndex,
          onItemSelected: (index) {
            setState(() => _selectedIndex = index);
            Navigator.pop(context); // ছোট স্ক্রিনে ক্লিক করলে ড্রয়ার বন্ধ হবে
          },
          onLogout: () async {
            await authProvider.logout();
            if (mounted) Navigator.pop(context);
          },
        ),
      )
          : null,
      body: Row(
        children: [
          // সাইডবার (শুধু বড় স্ক্রিনে দেখাবে)
          if (isDesktop)
            WebSidebar(
              selectedIndex: _selectedIndex,
              onItemSelected: (index) => setState(() => _selectedIndex = index),
              onLogout: () async {
                await authProvider.logout();
                if (mounted) Navigator.pop(context);
              },
            ),

          // মূল কন্টেন্ট
          Expanded(
            child: Column(
              children: [
                // উপরের অ্যাপবার
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      // ছোট স্ক্রিনে মেনু আইকন
                      if (!isDesktop)
                        IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => Scaffold.of(context).openDrawer(),
                        ),
                      const Text('Dashboard Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      const Icon(Icons.notifications_none, color: Colors.grey),
                      const SizedBox(width: 20),
                      const CircleAvatar(
                        backgroundColor: Colors.orange,
                        child: Text('V', style: TextStyle(color: Colors.white)),
                      ),
                      const SizedBox(width: 10),
                      Text(authProvider.currentUser?.email ?? 'Vendor', style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),

                // মূল কন্টেন্ট এরিয়া
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // স্ট্যাটস কার্ড (Wrap ব্যবহার করায় স্ক্রিন ছোট হলেও ভাঙবে না)
                        Wrap(
                          spacing: 20,
                          runSpacing: 20,
                          children: [
                            SizedBox(
                              width: isDesktop ? (MediaQuery.of(context).size.width - 300) / 3 : double.infinity,
                              child: WebStatCard(title: 'Total Products', value: '${productProvider.products.length}', icon: Icons.shopping_bag, color: Colors.blue),
                            ),
                            SizedBox(
                              width: isDesktop ? (MediaQuery.of(context).size.width - 300) / 3 : double.infinity,
                              child: const WebStatCard(title: 'Total Orders', value: '12', icon: Icons.receipt_long, color: Colors.orange),
                            ),
                            SizedBox(
                              width: isDesktop ? (MediaQuery.of(context).size.width - 300) / 3 : double.infinity,
                              child: const WebStatCard(title: 'Revenue', value: '৳ 5,400', icon: Icons.attach_money, color: Colors.green),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // প্রোডাক্ট সেকশন
                        Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 20,
                          runSpacing: 10,
                          children: [
                            const Text('My Products', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => const AddProductWebScreen()),
                                ).then((_) => productProvider.fetchProducts());
                              },
                              icon: const Icon(Icons.add),
                              label: const Text('Add New Product'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange.shade700,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // প্রোডাক্ট গ্রিড (রেসপন্সিভ)
                        productProvider.isLoading
                            ? const Center(child: CircularProgressIndicator())
                            : productProvider.products.isEmpty
                            ? const Center(child: Text('No products available'))
                            : GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: isDesktop ? 280 : 200,
                            childAspectRatio: 0.75,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20,
                          ),
                          itemCount: productProvider.products.length,
                          itemBuilder: (context, index) {
                            final product = productProvider.products[index];
                            return WebProductCard(
                              product: product,
                              onEdit: () {},
                              onDelete: () {},
                            );
                          },
                        ),
                      ],
                    ),
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