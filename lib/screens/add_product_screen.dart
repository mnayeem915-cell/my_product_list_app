import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product_model.dart';
import '../data/dummy_data.dart';
import '../providers/category_provider.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _imageUrlController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // সিলেক্ট করা ক্যাটাগরি রাখার ভেরিয়েবল
  String? _selectedCategory;

  void _saveProduct() {
    if (_formKey.currentState!.validate()) {
      // নতুন প্রোডাক্ট তৈরি (সিলেক্ট করা ক্যাটাগরি সহ)
      final newProduct = Product(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text,
        description: _descriptionController.text,
        price: double.parse(_priceController.text),
        imageUrl: _imageUrlController.text,
        category: _selectedCategory!, // ড্রপডাউন থেকে আসা ক্যাটাগরি
        shopName: 'My Shop',
        rating: 0.0,
      );

      dummyProducts.add(newProduct);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Product Added Successfully!'), backgroundColor: Colors.green),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ক্যাটাগরি প্রোভাইডার থেকে লিস্ট নিচ্ছি
    final categoryProvider = Provider.of<CategoryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Product'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // প্রোডাক্টের নাম
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Product Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter name' : null,
              ),
              const SizedBox(height: 16),

              // প্রোডাক্টের দাম
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Price (BDT)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? 'Please enter price' : null,
              ),
              const SizedBox(height: 16),

              // ক্যাটাগরি সিলেক্ট ড্রপডাউন (নতুন)
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Category',
                  border: OutlineInputBorder(),
                ),
                value: _selectedCategory,
                items: categoryProvider.categories.map((category) {
                  return DropdownMenuItem(
                    value: category.name,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedCategory = value;
                  });
                },
                validator: (value) => value == null ? 'Please select a category' : null,
              ),
              const SizedBox(height: 16),

              // ইমেজ URL
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(
                  labelText: 'Image URL (https://...)',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Please enter image URL';
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // বিবরণ
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _saveProduct,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).primaryColor, // এখানে পরিবর্তন করো
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // একটু রাউন্ড করলাম
                ),
                child: const Text('Save Product', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}