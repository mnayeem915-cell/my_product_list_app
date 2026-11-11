import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // ১. সব প্রোডাক্ট লোড করা (কাস্টমারদের জন্য)
  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .order('created_at', ascending: false);

      _products = (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ২. নির্দিষ্ট ভেন্ডরের প্রোডাক্ট লোড করা (ভেন্ডর ড্যাশবোর্ডের জন্য)
  Future<void> fetchProductsByVendor(String vendorId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('vendor_id', vendorId)
          .order('created_at', ascending: false);

      _products = (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching vendor products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ৩. নতুন প্রোডাক্ট অ্যাড করা
  Future<void> addProduct(Product product) async {
    try {
      final user = Supabase.instance.client.auth.currentUser;

      await Supabase.instance.client.from('products').insert({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'image_url': product.imageUrl,
        'category': product.category,
        'shop_name': product.shopName,
        'rating': product.rating,
        'vendor_id': user?.id,
      });

      await fetchProductsByVendor(user!.id);
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }
}