import 'package:flutter/material.dart';
import '../models/product_model.dart';

class WishlistProvider extends ChangeNotifier {
  // উইশলিস্টের আইটেমগুলো রাখার লিস্ট
  final Map<String, Product> _wishlistItems = {};

  Map<String, Product> get wishlistItems => _wishlistItems;

  // উইশলিস্টে কয়টি আইটেম আছে
  int get itemCount => _wishlistItems.length;

  // প্রোডাক্ট উইশলিস্টে যোগ বা বাদ দেওয়া
  void toggleWishlist(Product product) {
    if (_wishlistItems.containsKey(product.id)) {
      _wishlistItems.remove(product.id); // যদি আগে থেকেই থাকে, তবে বাদ যাবে
    } else {
      _wishlistItems[product.id] = product; // না থাকলে যোগ হবে
    }
    notifyListeners(); // UI আপডেট
  }

  // প্রোডাক্টটি উইশলিস্টে আছে কিনা চেক করা
  bool isInWishlist(String productId) {
    return _wishlistItems.containsKey(productId);
  }
}