import 'package:flutter/material.dart';

class CustomerWebFooter extends StatelessWidget {
  const CustomerWebFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.orange.shade50,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            spacing: 60,
            runSpacing: 30,
            alignment: WrapAlignment.spaceBetween,
            children: [
              // কলাম ১
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.shopping_bag, color: Theme.of(context).primaryColor, size: 30),
                      const SizedBox(width: 8),
                      Text('My Shop', style: TextStyle(color: Theme.of(context).primaryColor, fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text('Your trusted online grocery store.\nFresh products delivered to your door.', style: TextStyle(color: Colors.black87)),
                ],
              ),

              // কলাম ২
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Information', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 16),
                  Text('About Us', style: TextStyle(color: Colors.black87, height: 2)),
                  Text('Contact Us', style: TextStyle(color: Colors.black87, height: 2)),
                  Text('Terms & Conditions', style: TextStyle(color: Colors.black87, height: 2)),
                ],
              ),

              // কলাম ৩ (Download App - ছবি ছাড়া)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Download Our App', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      // Google Play বাটন
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.play_arrow, color: Colors.white),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('GET IT ON', style: TextStyle(color: Colors.white, fontSize: 8)),
                                  Text('Google Play', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // App Store বাটন
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.apple, color: Colors.white),
                              SizedBox(width: 8),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Download on the', style: TextStyle(color: Colors.white, fontSize: 8)),
                                  Text('App Store', style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          Divider(color: Colors.orange.shade200),
          const SizedBox(height: 20),
          const Center(
            child: Text('Copyright © 2026 My Shop. All rights reserved.', style: TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }
}