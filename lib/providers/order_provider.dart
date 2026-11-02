import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _myOrders = [];
  List<Map<String, dynamic>> _vendorOrders = []; // ভেন্ডরের অর্ডার

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get myOrders => _myOrders;
  List<Map<String, dynamic>> get vendorOrders => _vendorOrders;

  // গ্রাহকের নিজের অর্ডার লোড করা
  Future<void> fetchMyOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('orders')
          .select('*, order_items(*, products(*))') // অর্ডারের সাথে প্রোডাক্ট ডিটেইলস
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      _myOrders = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ভেন্ডরের অর্ডার লোড করা
  Future<void> fetchVendorOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      // order_items থেকে সেই অর্ডারগুলো আনছি যেখানে vendor_id মিলে
      final response = await Supabase.instance.client
          .from('order_items')
          .select('*, orders(*), products(*)')
          .eq('vendor_id', user.id);

      _vendorOrders = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching vendor orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // নতুন অর্ডার প্লেস করা
  Future<bool> placeOrder(double totalAmount, List<Map<String, dynamic>> cartItems) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;

      // ১. orders টেবিলে মেইন অর্ডার তৈরি
      final orderResponse = await Supabase.instance.client.from('orders').insert({
        'total_amount': totalAmount,
        'status': 'Pending',
        'user_id': user?.id,
      }).select().single();

      final orderId = orderResponse['id'];

      // ২. order_items টেবিলে প্রতিটি প্রোডাক্ট যোগ করা
      for (var item in cartItems) {
        await Supabase.instance.client.from('order_items').insert({
          'order_id': orderId,
          'product_id': item['product_id'],
          'vendor_id': item['vendor_id'], // কোন ভেন্ডরের প্রোডাক্ট
          'quantity': item['quantity'],
          'price': item['price'],
        });
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint('Error placing order: $e');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}