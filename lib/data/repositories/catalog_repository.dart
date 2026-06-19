import '../../core/constants/app_constants.dart';
import '../../models/category.dart';
import '../../models/product.dart';
import '../datasources/api_catalog_data_source.dart';
import '../datasources/catalog_data_source.dart';
import '../datasources/dummy_catalog_data_source.dart';

/// The one place that decides where catalogue data comes from.
///
/// Everything above this line (providers, screens) is source-agnostic. Flip
/// [AppConfig.useDummyData] and the entire app moves to the live backend.
class CatalogRepository {
  CatalogRepository({CatalogDataSource? source})
      : _source = source ??
            (AppConfig.useDummyData
                ? const DummyCatalogDataSource()
                : const ApiCatalogDataSource());

  final CatalogDataSource _source;

  Future<List<Category>> getCategories() => _source.fetchCategories();
  Future<List<Product>> getProducts() => _source.fetchProducts();
  Future<Product?> getProduct(String id) => _source.fetchProductById(id);
  Future<List<Product>> search(String query) => _source.searchProducts(query);
}
