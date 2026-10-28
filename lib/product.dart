import 'package:flutter/material.dart';

class Product {
  const Product({
    required this.name,
    required this.pricePaise,
    required this.unit,
    required this.category,
    required this.color,
  });

  final String name;
  final int pricePaise; // money in whole paise: Rs 45.00 = 4500
  final String unit; // 'kg' | 'pc' | 'bun'
  final String category; // 'top' | 'regular' | 'slow'
  final Color color;

  bool get isWeighed => unit == 'kg';

  String get priceLabel => '₹${pricePaise ~/ 100}/$unit';
}

// Hardcoded for now. Stage 4 moves these into the SQLite products table.
const List<Product> products = [
  Product(name: 'Tomato', pricePaise: 4500, unit: 'kg', category: 'top', color: Color(0xFFB91C1C)),
  Product(name: 'Potato', pricePaise: 3000, unit: 'kg', category: 'top', color: Color(0xFF57534E)),
  Product(name: 'Onion', pricePaise: 2800, unit: 'kg', category: 'top', color: Color(0xFF9F1239)),
  Product(name: 'Green Chilli', pricePaise: 8000, unit: 'kg', category: 'top', color: Color(0xFF166534)),
  Product(name: 'Lemon', pricePaise: 500, unit: 'pc', category: 'regular', color: Color(0xFFA16207)),
  Product(name: 'Palak', pricePaise: 2000, unit: 'bun', category: 'regular', color: Color(0xFF4D7C0F)),
  Product(name: 'Coriander', pricePaise: 1000, unit: 'bun', category: 'top', color: Color(0xFF4D7C0F)),
  Product(name: 'Carrot', pricePaise: 4000, unit: 'kg', category: 'regular', color: Color(0xFFC2410C)),
  Product(name: 'Beans', pricePaise: 5500, unit: 'kg', category: 'slow', color: Color(0xFF1D4ED8)),
];
