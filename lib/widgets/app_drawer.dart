import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import '../screens/category_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Drawer(
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
        ),
        child: ClipRRect(
          borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
          child: SafeArea(
            bottom: false,
            child: Column(
              children: [
                // ... হেডার অংশ (আগের মতোই)

                // ডাইনামিক ক্যাটাগরি লিস্ট
                Expanded(
                  child: categoryProvider.categories.isEmpty
                      ? const Center(child: Text('Loading...'))
                      : ListView.builder(
                    padding: const EdgeInsets.only(top: 15, bottom: 20),
                    itemCount: categoryProvider.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryProvider.categories[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CategoryScreen(categoryName: category.name)),
                            );
                          },
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF9F9F9),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300, width: 1),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(category.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
                                const Icon(Icons.keyboard_arrow_down, size: 20, color: Colors.grey),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}