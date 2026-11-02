import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';

class CategoryNavBar extends StatelessWidget {
  const CategoryNavBar({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Container(
      height: 50,
      color: const Color(0xFF2E2E2E), // কালো/গাঢ় ধূসর
      child: categoryProvider.categories.isEmpty
          ? const Center(child: Text('Loading...', style: TextStyle(color: Colors.white)))
          : ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 40),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Center(
              child: Text(
                categoryProvider.categories[index].name,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
              ),
            ),
          );
        },
      ),
    );
  }
}