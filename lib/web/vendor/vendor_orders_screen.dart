import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/order_provider.dart';

class VendorOrdersScreen extends StatefulWidget {
  const VendorOrdersScreen({super.key});

  @override
  State<VendorOrdersScreen> createState() => _VendorOrdersScreenState();
}

class _VendorOrdersScreenState extends State<VendorOrdersScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchVendorOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text('My Orders', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
      ),
      body: orderProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : orderProvider.vendorOrders.isEmpty
          ? const Center(child: Text('No orders yet!', style: TextStyle(fontSize: 18, color: Colors.grey)))
          : ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: orderProvider.vendorOrders.length,
        itemBuilder: (context, index) {
          final orderItem = orderProvider.vendorOrders[index];
          final product = orderItem['products'];
          final order = orderItem['orders'];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: Image.network(product['image_url'], width: 50, height: 50, fit: BoxFit.cover),
              title: Text(product['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('Quantity: ${orderItem['quantity']} | Total: ৳${order['total_amount']}'),
              trailing: Chip(
                label: Text(order['status'] ?? 'Pending'),
                backgroundColor: order['status'] == 'Pending' ? Colors.orange.shade100 : Colors.green.shade100,
              ),
            ),
          );
        },
      ),
    );
  }
}