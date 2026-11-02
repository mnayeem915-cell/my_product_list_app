class Product {
  final String id;
  final String? vendorId; // 👈 নতুন যোগ হলো
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String category;
  final String shopName;
  final double rating;

  Product({
    required this.id,
    this.vendorId, // অপশনাল
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.category,
    required this.shopName,
    required this.rating,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      vendorId: json['vendor_id'] as String?, // 👈 JSON থেকে নেওয়া
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String? ?? '',
      category: json['category'] as String? ?? 'General',
      shopName: json['shop_name'] as String? ?? 'My Shop',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}