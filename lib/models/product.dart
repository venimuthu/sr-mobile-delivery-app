import 'package:flutter/material.dart';

/// A single sellable item in the SR catalogue.
///
/// [imageUrl] is intentionally optional: until the real catalogue ships
/// photography, each product renders as a branded two-colour gradient
/// ([gradientStart] / [gradientEnd]) with an [emoji]. When the backend supplies
/// `imageUrl`, the UI switches to the photo automatically.
class Product {
  final String id;
  final String name;
  final String tagline;
  final String description;
  final String categoryId;
  final double price;
  final double? mrp; // original price, for showing a strike-through
  final String unit; // e.g. "500 ml", "Pack of 6"
  final double rating;
  final int reviewCount;
  final bool isVeg;
  final bool inStock;
  final bool isFeatured;
  final String emoji;
  final Color gradientStart;
  final Color gradientEnd;
  final String imageUrl;
  final List<String> highlights;

  const Product({
    required this.id,
    required this.name,
    required this.tagline,
    required this.description,
    required this.categoryId,
    required this.price,
    this.mrp,
    required this.unit,
    this.rating = 4.5,
    this.reviewCount = 0,
    this.isVeg = true,
    this.inStock = true,
    this.isFeatured = false,
    this.emoji = '🍨',
    this.gradientStart = const Color(0xFFFFE3EC),
    this.gradientEnd = const Color(0xFFFFB6C9),
    this.imageUrl = '',
    this.highlights = const [],
  });

  bool get hasDiscount => mrp != null && mrp! > price;

  int get discountPercent =>
      hasDiscount ? (((mrp! - price) / mrp!) * 100).round() : 0;

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      tagline: (json['tagline'] ?? '') as String,
      description: (json['description'] ?? '') as String,
      categoryId: json['categoryId'] as String,
      price: (json['price'] as num).toDouble(),
      mrp: json['mrp'] == null ? null : (json['mrp'] as num).toDouble(),
      unit: (json['unit'] ?? '') as String,
      rating: (json['rating'] as num?)?.toDouble() ?? 4.5,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      isVeg: (json['isVeg'] ?? true) as bool,
      inStock: (json['inStock'] ?? true) as bool,
      isFeatured: (json['isFeatured'] ?? false) as bool,
      emoji: (json['emoji'] ?? '🍨') as String,
      gradientStart: Color(
          (json['gradientStart'] as num?)?.toInt() ?? 0xFFFFE3EC),
      gradientEnd:
          Color((json['gradientEnd'] as num?)?.toInt() ?? 0xFFFFB6C9),
      imageUrl: (json['imageUrl'] ?? '') as String,
      highlights: (json['highlights'] as List?)?.cast<String>() ?? const [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'tagline': tagline,
        'description': description,
        'categoryId': categoryId,
        'price': price,
        'mrp': mrp,
        'unit': unit,
        'rating': rating,
        'reviewCount': reviewCount,
        'isVeg': isVeg,
        'inStock': inStock,
        'isFeatured': isFeatured,
        'emoji': emoji,
        'gradientStart': gradientStart.value,
        'gradientEnd': gradientEnd.value,
        'imageUrl': imageUrl,
        'highlights': highlights,
      };
}
