import 'dart:convert';

import 'package:flutter/foundation.dart';

import '../../core/constants/app_constants.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import 'catalog_data_source.dart';

/// Talks to the live SR Department Store backend (the NestJS API that fronts
/// the PostgreSQL catalogue described in the architecture brief).
///
/// This is a ready-to-wire stub. To activate it:
///   1. Set `AppConfig.useDummyData = false` in app_constants.dart.
///   2. Add the `http` package to pubspec.yaml.
///   3. Replace the bodies below with real requests (sketched in comments).
///
/// Because [Product.fromJson] / [Category.fromJson] already exist and mirror the
/// dummy shapes, the parsing is done — only the transport is left.
class ApiCatalogDataSource implements CatalogDataSource {
  const ApiCatalogDataSource();

  String get _base => AppConfig.apiBaseUrl;

  @override
  Future<List<Category>> fetchCategories() async {
    // final res = await http.get(Uri.parse('$_base/categories'));
    // final list = jsonDecode(res.body) as List;
    // return list.map((j) => Category.fromJson(j)).toList();
    throw UnimplementedError(_todo('GET $_base/categories'));
  }

  @override
  Future<List<Product>> fetchProducts() async {
    // final res = await http.get(Uri.parse('$_base/products'));
    // final list = jsonDecode(res.body) as List;
    // return list.map((j) => Product.fromJson(j)).toList();
    throw UnimplementedError(_todo('GET $_base/products'));
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    // final res = await http.get(Uri.parse('$_base/products/$id'));
    // return Product.fromJson(jsonDecode(res.body));
    throw UnimplementedError(_todo('GET $_base/products/$id'));
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    // final res = await http.get(
    //   Uri.parse('$_base/products').replace(queryParameters: {'q': query}));
    // final list = jsonDecode(res.body) as List;
    // return list.map((j) => Product.fromJson(j)).toList();
    throw UnimplementedError(_todo('GET $_base/products?q=$query'));
  }

  String _todo(String endpoint) {
    final msg = 'ApiCatalogDataSource is not wired yet. Implement: $endpoint';
    if (kDebugMode) debugPrint('[SR] $msg');
    // Reference jsonDecode so the import is retained for implementers.
    assert(jsonDecode('{}') is Map);
    return msg;
  }
}
