import '../../models/category.dart';
import '../../models/product.dart';
import '../dummy_data.dart';
import 'catalog_data_source.dart';

/// Serves the in-memory [DummyData]. A small artificial delay is added so the
/// loading states (shimmers, spinners) behave the same as they will against a
/// real network — making the eventual swap visually seamless.
class DummyCatalogDataSource implements CatalogDataSource {
  const DummyCatalogDataSource();

  static const Duration _latency = Duration(milliseconds: 450);

  @override
  Future<List<Category>> fetchCategories() async {
    await Future.delayed(_latency);
    return DummyData.categories;
  }

  @override
  Future<List<Product>> fetchProducts() async {
    await Future.delayed(_latency);
    return DummyData.products;
  }

  @override
  Future<Product?> fetchProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 150));
    try {
      return DummyData.products.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Product>> searchProducts(String query) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return DummyData.products;
    return DummyData.products
        .where((p) =>
            p.name.toLowerCase().contains(q) ||
            p.tagline.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q))
        .toList();
  }
}
