import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/category_provider.dart';
import 'category_screen.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('All Categories', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: categoryProvider.categories.isEmpty
          ? const Center(child: Text('No categories available yet.'))
          : ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: categoryProvider.categories.length,
        itemBuilder: (context, index) {
          final category = categoryProvider.categories[index];
          return Card(
            elevation: 0,
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: Colors.grey.shade200),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: Colors.orange.shade50,
                child: Icon(Icons.category, color: Theme.of(context).primaryColor),
              ),
              title: Text(category.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CategoryScreen(categoryName: category.name)),
                );
              },
            ),
          );
        },
      ),
    );
  }
}