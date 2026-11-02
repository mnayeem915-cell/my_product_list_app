import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  // ১. গ্রাহকদের জন্য সব প্রোডাক্ট লোড করা (হোম স্ক্রিনের জন্য)
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

  // ২. ভেন্ডরের নিজের প্রোডাক্ট লোড করা (ভেন্ডর ড্যাশবোর্ডের জন্য)
  Future<void> fetchVendorProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user == null) return;

      final response = await Supabase.instance.client
          .from('products')
          .select()
          .eq('vendor_id', user.id) // শুধু এই ভেন্ডরের প্রোডাক্ট
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
        'vendor_id': user?.id, // ভেন্ডরের আইডি সেভ করা
      });

      // অ্যাড হওয়ার পর আবার লিস্ট আপডেট করা
      await fetchVendorProducts();
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }
}