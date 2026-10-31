import '../models/product_model.dart';

List<Product> dummyProducts = [
  Product(
    id: '1',
    name: 'Fresh Apples (1kg)',
    description: 'Fresh and crispy apples directly from the farm.',
    price: 120.0,
    imageUrl: 'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?q=80&w=600&auto=format&fit=crop',
    category: 'Fruits',
    shopName: 'Fresh Bazar',
    rating: 4.5,
  ),
  Product(
    id: '2',
    name: 'Premium Basmati Rice (5kg)',
    description: 'High quality aromatic basmati rice.',
    price: 850.0,
    imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?q=80&w=600&auto=format&fit=crop',
    category: 'Grocery',
    shopName: 'Fresh Bazar',
    rating: 4.8,
  ),
  Product(
    id: '3',
    name: 'Wireless Headphones',
    description: 'Noise cancelling over-ear headphones.',
    price: 2500.0,
    imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?q=80&w=600&auto=format&fit=crop',
    category: 'Electronics',
    shopName: 'Gadget Hub',
    rating: 4.2,
  ),
];