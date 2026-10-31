import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/category_model.dart';

class CategoryProvider extends ChangeNotifier {
  List<Category> _categories = [];
  bool _isLoading = false;

  List<Category> get categories => _categories;
  bool get isLoading => _isLoading;

  // ডেটাবেস থেকে ক্যাটাগরি লোড করা
  Future<void> fetchCategories() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('categories')
          .select()
          .order('created_at', ascending: true);

      _categories = (response as List).map((json) => Category.fromJson(json)).toList();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // নতুন ক্যাটাগরি যোগ করা (ভবিষ্যতে অ্যাডমিন প্যানেল থেকে কাজে লাগবে)
  Future<void> addCategory(String name) async {
    try {
      await Supabase.instance.client.from('categories').insert({'name': name});
      await fetchCategories();
    } catch (e) {
      debugPrint('Error adding category: $e');
    }
  }
}