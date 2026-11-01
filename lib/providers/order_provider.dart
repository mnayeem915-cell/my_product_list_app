import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;
  List<Map<String, dynamic>> _myOrders = []; // অর্ডার লিস্ট রাখার জন্য

  bool get isLoading => _isLoading;
  List<Map<String, dynamic>> get myOrders => _myOrders;

  // নতুন অর্ডার প্লেস করা
  Future<bool> placeOrder(double totalAmount) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;

      await Supabase.instance.client.from('orders').insert({
        'total_amount': totalAmount,
        'status': 'Pending',
        'user_id': user?.id, // লগইন করা ইউজারের আইডি
      });

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

  // লগইন করা ইউজারের অর্ডারগুলো নিয়ে আসা
  Future<void> fetchMyOrders() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) {
        _myOrders = [];
        return;
      }

      final response = await Supabase.instance.client
          .from('orders')
          .select()
          .eq('user_id', user.id) // শুধু এই ইউজারের অর্ডার
          .order('created_at', ascending: false); // নতুন অর্ডার আগে

      _myOrders = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching orders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}