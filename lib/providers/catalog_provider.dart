import 'package:flutter/foundation.dart';

import '../data/repositories/catalog_repository.dart';
import '../models/category.dart';
import '../models/product.dart';

enum LoadState { idle, loading, ready, error }

/// Holds the catalogue in memory for the session and exposes simple selectors
/// for the screens. Source-agnostic — it only talks to [CatalogRepository].
class CatalogProvider extends ChangeNotifier {
  CatalogProvider({CatalogRepository? repository})
      : _repo = repository ?? CatalogRepository();

  final CatalogRepository _repo;

  LoadState _state = LoadState.idle;
  LoadState get state => _state;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  List<Product> _products = [];
  List<Product> get products => _products;

  String? _error;
  String? get error => _error;

  List<Product> get featured =>
      _products.where((p) => p.isFeatured).toList();

  List<Product> byCategory(String categoryId) =>
      _products.where((p) => p.categoryId == categoryId).toList();

  Product? byId(String id) {
    for (final p in _products) {
      if (p.id == id) return p;
    }
    return null;
  }

  Category? categoryById(String id) {
    for (final c in _categories) {
      if (c.id == id) return c;
    }
    return null;
  }

  Future<void> load() async {
    _state = LoadState.loading;
    notifyListeners();
    try {
      _categories = await _repo.getCategories();
      _products = await _repo.getProducts();
      _state = LoadState.ready;
    } catch (e) {
      _error = e.toString();
      _state = LoadState.error;
    }
    notifyListeners();
  }

  Future<List<Product>> search(String query) => _repo.search(query);
}
