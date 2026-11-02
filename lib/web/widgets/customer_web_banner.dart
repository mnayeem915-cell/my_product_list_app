import 'dart:async'; // 👈 টাইমারের জন্য
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../providers/banner_provider.dart';

class CustomerWebBanner extends StatefulWidget {
  const CustomerWebBanner({super.key});

  @override
  State<CustomerWebBanner> createState() => _CustomerWebBannerState();
}

class _CustomerWebBannerState extends State<CustomerWebBanner> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer; // 👈 টাইমার ভেরিয়েবল

  @override
  void initState() {
    super.initState();
    // ৩ সেকেন্ড পর পর অটোমেটিক স্লাইড হবে
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (_pageController.hasClients) {
        int next = _currentIndex + 1;
        // শেষ ছবি হলে আবার প্রথম ছবিতে ফিরে যাবে
        if (next == Provider.of<BannerProvider>(context, listen: false).bannerUrls.length) {
          next = 0;
        }
        _pageController.animateToPage(
          next,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // স্ক্রিন বন্ধ হলে টাইমার বন্ধ হবে
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bannerProvider = Provider.of<BannerProvider>(context);

    if (bannerProvider.bannerUrls.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
      child: Row(
        children: [
          // ১. বাম দিকের স্লাইডার ব্যানার
          Expanded(
            flex: 2,
            child: Column(
              children: [
                SizedBox(
                  height: 350,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (index) => setState(() => _currentIndex = index),
                    itemCount: bannerProvider.bannerUrls.length,
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          bannerProvider.bannerUrls[index],
                          width: double.infinity,
                          height: 350,
                          fit: BoxFit.cover, // পুরো জায়গা জুড়ে বসবে
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                SmoothPageIndicator(
                  controller: _pageController,
                  count: bannerProvider.bannerUrls.length,
                  effect: const WormEffect(dotColor: Colors.grey, activeDotColor: Colors.orange, dotHeight: 8, dotWidth: 8),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),

          // ২. ডান দিকের স্থির (Static) ব্যানার
          Expanded(
            flex: 1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Image.network(
                'https://images.unsplash.com/photo-1607082348824-0a96f2a4b9da?q=80&w=600&auto=format&fit=crop', // 👈 নতুন লিংক
                height: 380,
                width: double.infinity,
                fit: BoxFit.cover, // ডান দিকের ছবিটাও সুন্দরভাবে বসবে
              ),
            ),
          ),
        ],
      ),
    );
  }
}