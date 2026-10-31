import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class OrderProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  // নতুন অর্ডার প্লেস করা
  Future<bool> placeOrder(double totalAmount) async {
    _isLoading = true;
    notifyListeners();

    try {
      await Supabase.instance.client.from('orders').insert({
        'total_amount': totalAmount,
        'status': 'Pending',
        // 'user_id': Supabase.instance.client.auth.currentUser?.id, // লগইন সিস্টেম হলে এটি ব্যবহার করবো
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
}