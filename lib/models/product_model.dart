class Product {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String shopName;
  final double rating;

  Product({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.shopName,
    required this.rating,
  });

  // ডেটাবেস থেকে JSON ডেটা নেওয়ার জন্য ফ্যাক্টরি মেথড
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '', // ডেটা না থাকলে ফাঁকা স্ট্রিং
      price: (json['price'] as num).toDouble(), // double এ কনভার্ট করা
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      shopName: json['shop_name'] as String? ?? 'My Shop',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}