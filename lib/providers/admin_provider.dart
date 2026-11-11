import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:http/http.dart' as http;

class AdminProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _allVendors = [];
  bool _isLoading = false;

  List<Map<String, dynamic>> get allVendors => _allVendors;
  bool get isLoading => _isLoading;

  // ১. সব ভেন্ডর লোড করা
  Future<void> fetchAllVendors() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('users')
          .select()
          .eq('role', 'vendor');

      _allVendors = List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching vendors: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ২. নতুন ভেন্ডর তৈরি করা (অটোমেটিক users টেবিলে সেভ হবে)
  Future<String?> addNewVendor(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      const supabaseUrl = 'https://mwjgomchnayflyyjmqgc.supabase.co';
      const supabaseKey = 'sb_publishable_mJR3mwsyCLH8iLd0P3qPUQ_BUrBfefr'; // anon key

      final response = await http.post(
        Uri.parse('$supabaseUrl/auth/v1/signup'),
        headers: {
          'apikey': supabaseKey,
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);

        // Supabase রেসপন্সের 'user' অবজেক্ট থেকে id নিতে হবে
        final newUserId = data['user']?['id'];

        if (newUserId == null) {
          return 'Failed to get user ID from Supabase';
        }

        // users টেবিলে রোল ভেন্ডর হিসেবে সেভ করা
        await Supabase.instance.client.from('users').insert({
          'id': newUserId,
          'email': email,
          'role': 'vendor',
        });

        await fetchAllVendors(); // লিস্ট আপডেট
        return null; // সফল হলে null রিটার্ন করবে
      } else {
        final errorData = jsonDecode(response.body);
        return errorData['msg'] ?? 'Failed to create vendor';
      }
    } catch (e) {
      debugPrint('Error adding vendor: $e');
      return e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // 👇 ৩. ভেন্ডর ডিলিট করার ফাংশন (এখানেই বসাতে হবে)
  Future<void> deleteVendor(String vendorId) async {
    try {
      // 👇 SQL Function কল করছি (এটি Authentication এবং users টেবিল দুই থেকেই ডিলিট করবে)
      await Supabase.instance.client.rpc('delete_vendor', params: {
        'vendor_id': vendorId,
      });

      // লিস্ট আপডেট
      await fetchAllVendors();
    } catch (e) {
      debugPrint('Error deleting vendor: $e');
    }
  }
}