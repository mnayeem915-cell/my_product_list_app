import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;

  // ডিফল্ট রোল
  String _userRole = 'customer';
  String get userRole => _userRole;

  User? get currentUser => _supabase.auth.currentUser;
  bool get isLoggedIn => currentUser != null;

  // লগইন করা
  Future<String?> login(String email, String password) async {
    try {
      await _supabase.auth.signInWithPassword(email: email, password: password);
      await fetchUserRole(); // লগইন হলে রোল চেক করবে
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // নতুন অ্যাকাউন্ট তৈরি করা
  Future<String?> signUp(String email, String password) async {
    try {
      await _supabase.auth.signUp(email: email, password: password);
      await fetchUserRole();
      notifyListeners();
      return null;
    } on AuthException catch (e) {
      return e.message;
    } catch (e) {
      return e.toString();
    }
  }

  // ইউজারের রোল (Customer/Vendor) চেক করা
  Future<void> fetchUserRole() async {
    final user = currentUser;
    if (user != null) {
      try {
        final response = await _supabase
            .from('users')
            .select('role')
            .eq('id', user.id)
            .maybeSingle();

        if (response != null) {
          _userRole = response['role'] ?? 'customer';
        } else {
          // যদি নতুন ইউজার হয়, তবে users টেবিলে তাকে সেভ করে নেবে
          await _supabase.from('users').insert({
            'id': user.id,
            'email': user.email,
            'role': 'customer'
          });
          _userRole = 'customer';
        }
        notifyListeners();
      } catch (e) {
        debugPrint('Error fetching role: $e');
      }
    }
  }

  // লগআউট করা
  Future<void> logout() async {
    await _supabase.auth.signOut();
    _userRole = 'customer'; // লগআউট হলে আবার ডিফল্ট রোলে ফিরে যাবে
    notifyListeners();
  }
}