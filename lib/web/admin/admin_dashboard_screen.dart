import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/admin_provider.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/product_provider.dart';
import '../vendor/vendor_dashboard_screen.dart'; // 👈 এই লাইনটা যোগ করো

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AdminProvider>(context, listen: false).fetchAllVendors();
      Provider.of<ProductProvider>(context, listen: false).fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final adminProvider = Provider.of<AdminProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Row(
          children: [
            Icon(Icons.admin_panel_settings, color: Theme.of(context).primaryColor, size: 30),
            const SizedBox(width: 8),
            Text('Admin Panel', style: TextStyle(color: Theme.of(context).primaryColor, fontWeight: FontWeight.bold, fontSize: 20)),
          ],
        ),
        actions: [
          Text(authProvider.currentUser?.email ?? 'Admin'),
          const SizedBox(width: 16),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            onPressed: () async {
              await authProvider.logout();
              if (context.mounted) Navigator.pop(context);
            },
          ),
          const SizedBox(width: 20),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ১. স্ট্যাটস কার্ড
            Row(
              children: [
                _buildStatCard(context, 'Total Vendors', '${adminProvider.allVendors.length}', Icons.store, Colors.blue),
                const SizedBox(width: 20),
                _buildStatCard(context, 'Total Products', '${productProvider.products.length}', Icons.shopping_bag, Colors.green),
                const SizedBox(width: 20),
                _buildStatCard(context, 'Platform Revenue', '৳ 15,000', Icons.attach_money, Colors.orange),
              ],
            ),
            const SizedBox(height: 40),

            // ২. ভেন্ডর সেকশন হেডিং ও বাটন
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('All Vendors', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ElevatedButton.icon(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildAddVendorDialog(context, adminProvider),
                    );
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Add New Vendor'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // ৩. ভেন্ডর লিস্ট
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: adminProvider.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : adminProvider.allVendors.isEmpty
                  ? const Center(child: Text('No vendors found.'))
                  : ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: adminProvider.allVendors.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final vendor = adminProvider.allVendors[index];
                  final vendorProducts = productProvider.products.where((p) => p.vendorId == vendor['id']).toList();

                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.orange,
                      child: Icon(Icons.store, color: Colors.white),
                    ),
                    title: Text(vendor['email'] ?? 'No Email', style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('Products: ${vendorProducts.length} | Role: ${vendor['role']}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.visibility, color: Colors.blue),
                          onPressed: () {
                            final vendorId = vendor['id'] as String?;
                            if (vendorId != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => VendorDashboardScreen(viewAsAdminId: vendorId),
                                ),
                              );
                            }
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            // ডিলিট করার আগে কনফার্মেশন ডায়ালগ
                            showDialog(
                              context: context,
                              builder: (dialogContext) => AlertDialog(
                                title: const Text('Delete Vendor'),
                                content: Text('Are you sure you want to delete ${vendor['email']}?'),
                                actions: [
                                  TextButton(
                                      onPressed: () => Navigator.pop(dialogContext),
                                      child: const Text('Cancel')
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      // ডায়ালগ বন্ধ করা
                                      Navigator.pop(dialogContext);

                                      // ডিলিট ফাংশন কল করা
                                      await adminProvider.deleteVendor(vendor['id']);

                                      // সাকসেস মেসেজ
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Vendor deleted successfully'), backgroundColor: Colors.green),
                                        );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: const Text('Delete', style: TextStyle(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // স্ট্যাটস কার্ড উইজেট
  Widget _buildStatCard(BuildContext context, String title, String value, IconData icon, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.1),
              radius: 25,
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.grey, fontSize: 14)),
                const SizedBox(height: 4),
                Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildAddVendorDialog(BuildContext context, AdminProvider adminProvider) {
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return AlertDialog(
      title: const Text('Add New Vendor'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(controller: emailController, decoration: const InputDecoration(labelText: 'Vendor Email')),
          const SizedBox(height: 10),
          TextField(controller: passwordController, obscureText: true, decoration: const InputDecoration(labelText: 'Password')),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          onPressed: () async {
            // এরর মেসেজ নিচ্ছি
            final error = await adminProvider.addNewVendor(
              emailController.text.trim(),
              passwordController.text.trim(),
            );

            if (context.mounted) {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(error == null ? 'Vendor Created Successfully!' : error),
                  backgroundColor: error == null ? Colors.green : Colors.red,
                ),
              );
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}