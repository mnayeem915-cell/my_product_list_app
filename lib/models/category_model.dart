class Category {
  final String id;
  final String name;
  final String? imageUrl; // আইকন বা ছবির লিংক

  Category({required this.id, required this.name, this.imageUrl});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] as String,
      name: json['name'] as String,
      imageUrl: json['image_url'] as String?, // ডেটাবেসে image_url কলাম থাকলে
    );
  }
}