import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BannerProvider extends ChangeNotifier {
  List<String> _bannerUrls = [];
  bool _isLoading = false;

  List<String> get bannerUrls => _bannerUrls;
  bool get isLoading => _isLoading;

  Future<void> fetchBanners() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await Supabase.instance.client
          .from('banners')
          .select('image_url')
          .order('created_at', ascending: false);

      _bannerUrls = (response as List).map((json) => json['image_url'] as String).toList();
    } catch (e) {
      debugPrint('Error fetching banners: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}