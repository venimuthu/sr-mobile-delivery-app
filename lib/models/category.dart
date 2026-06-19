import 'package:flutter/material.dart';

/// A merchandising group, e.g. "Tubs", "Cones & Bars", "Kulfi & Indian".
class Category {
  final String id;
  final String name;
  final String emoji;
  final Color tint;

  const Category({
    required this.id,
    required this.name,
    required this.emoji,
    this.tint = const Color(0xFFF5F5F7),
  });

  factory Category.fromJson(Map<String, dynamic> json) => Category(
        id: json['id'] as String,
        name: json['name'] as String,
        emoji: (json['emoji'] ?? '🍦') as String,
        tint: Color((json['tint'] as num?)?.toInt() ?? 0xFFF5F5F7),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'emoji': emoji,
        'tint': tint.value,
      };
}
