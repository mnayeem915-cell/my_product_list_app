import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ShopProvider extends ChangeNotifier {
  List<Product> _shopProducts = [];
  Map<String, dynamic>? _shopDetails;
  bool _isLoading = false;

  List<Product> get shopProducts => _shopProducts;
  Map<String, dynamic>? get shopDetails => _shopDetails;
  bool get isLoading => _isLoading;

  // নির্দিষ্ট দোকানের ডেটা লোড করা
  Future<void> fetchShopData(String shopName) async {
    _isLoading = true;
    notifyListeners();

    try {
      // ১. দোকানের ডিটেইলস আনা
      final shopResponse = await Supabase.instance.client
          .from('shops')
          .select()
          .eq('shop_name', shopName)
          .maybeSingle();

      if (shopResponse != null) {
        _shopDetails = shopResponse;

        // ২. এই দোকানের ভেন্ডরের প্রোডাক্ট আনা
        final productResponse = await Supabase.instance.client
            .from('products')
            .select()
            .eq('vendor_id', shopResponse['vendor_id'])
            .order('created_at', ascending: false);

        _shopProducts = (productResponse as List).map((json) => Product.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching shop data: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}