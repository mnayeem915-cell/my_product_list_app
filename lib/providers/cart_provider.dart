import 'package:flutter/material.dart';
import '../models/product_model.dart';

// কার্টে প্রোডাক্ট এবং তার পরিমাণ (Quantity) একসাথে রাখার ক্লাস
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

class CartProvider extends ChangeNotifier {
  // কার্টের আইটেমগুলো রাখার ম্যাপ (Key: Product ID)
  final Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems => _cartItems;

  // কার্টে মোট কতগুলো প্রোডাক্ট (আইটেম) আছে
  int get itemCount => _cartItems.length;

  // কার্টের মোট দাম (প্রোডাক্টের দাম x পরিমাণ)
  double get totalPrice {
    double total = 0.0;
    _cartItems.forEach((key, item) {
      total += (item.product.price * item.quantity);
    });
    return total;
  }

  // কার্টে নতুন প্রোডাক্ট যোগ করা
  void addToCart(Product product) {
    if (_cartItems.containsKey(product.id)) {
      // যদি আগে থেকেই থাকে, তবে পরিমাণ ১ বাড়বে
      _cartItems[product.id]!.quantity += 1;
    } else {
      // নতুন হলে ১টি দিয়ে শুরু হবে
      _cartItems[product.id] = CartItem(product: product, quantity: 1);
    }
    notifyListeners();
  }

  // পরিমাণ বাড়ানো (+)
  void increaseQuantity(String productId) {
    if (_cartItems.containsKey(productId)) {
      _cartItems[productId]!.quantity += 1;
      notifyListeners();
    }
  }

  // পরিমাণ কমানো (-)
  void decreaseQuantity(String productId) {
    if (_cartItems.containsKey(productId)) {
      if (_cartItems[productId]!.quantity > 1) {
        _cartItems[productId]!.quantity -= 1;
        notifyListeners();
      } else {
        // যদি ১টা থাকে এবং আরও কমাতে চায়, তবে রিমুভ করে দেবে
        removeFromCart(productId);
      }
    }
  }

  // কার্ট থেকে সম্পূর্ণ বাদ দেওয়া
  void removeFromCart(String productId) {
    _cartItems.remove(productId);
    notifyListeners();
  }
}