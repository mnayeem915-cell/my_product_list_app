import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;

  Future<void> fetchProducts() async {
    _isLoading = true;
    notifyListeners();

    try {
      // এখানে order('created_at') সরিয়ে দিলাম, শুধু select() রাখলাম
      final response = await Supabase.instance.client
          .from('products')
          .select();

      print("Supabase Response: $response"); // ডেটা আসছে কিনা টার্মিনালে দেখার জন্য

      _products = (response as List).map((json) => Product.fromJson(json)).toList();
    } catch (e) {
      print("Error fetching products: $e"); // এরর টার্মিনালে দেখার জন্য
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // নতুন প্রোডাক্ট ডেটাবেসে যোগ করা
  Future<void> addProduct(Product product) async {
    try {
      await Supabase.instance.client.from('products').insert({
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'image_url': product.imageUrl,
        'category': product.category,
        'shop_name': product.shopName,
        'rating': product.rating,
      });
      await fetchProducts(); // নতুন প্রোডাক্ট যোগ হওয়ার পর আবার লিস্ট আপডেট হবে
    } catch (e) {
      debugPrint('Error adding product: $e');
    }
  }
}