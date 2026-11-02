import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/category_provider.dart';
import '../../screens/category_screen.dart'; // ক্যাটাগরি স্ক্রিনের পাথ

class WebCategorySlider extends StatelessWidget {
  const WebCategorySlider({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Column(
      children: [
        const SizedBox(height: 30),
        const Text('Featured Categories', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SizedBox(
          height: 160,
          child: categoryProvider.categories.isEmpty
              ? const Center(child: Text('Loading Categories...'))
              : ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 40),
            itemCount: categoryProvider.categories.length,
            itemBuilder: (context, index) {
              final category = categoryProvider.categories[index];
              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CategoryScreen(categoryName: category.name)),
                  );
                },
                child: Container(
                  width: 120,
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      // আইকন/ছবি
                      Container(
                        height: 90,
                        width: 90,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)],
                        ),
                        child: category.imageUrl != null
                            ? Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Image.network(category.imageUrl!, fit: BoxFit.contain),
                        )
                            : Icon(Icons.category, size: 40, color: Theme.of(context).primaryColor),
                      ),
                      const SizedBox(height: 10),
                      // নাম
                      Text(
                        category.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}