import '../../models/category.dart';
import '../../models/product.dart';

/// Contract for "where does the catalogue come from?".
///
/// The UI and providers depend only on this interface. Today it is fulfilled by
/// [DummyCatalogDataSource]; tomorrow by [ApiCatalogDataSource] talking to the
/// SR Department Store backend. Neither the providers nor the widgets change.
abstract class CatalogDataSource {
  Future<List<Category>> fetchCategories();
  Future<List<Product>> fetchProducts();
  Future<Product?> fetchProductById(String id);
  Future<List<Product>> searchProducts(String query);
}
