/// Static, business-level constants for the SR Department Store app.
///
/// Keeping the store identity and the data-source switch in one place means
/// rebranding or flipping from dummy data to the live backend is a one-line
/// change here — nothing in the UI needs to know.
class AppConstants {
  AppConstants._();

  // ---- Store identity -------------------------------------------------------
  static const String storeName = 'SR Department Store';
  static const String storeTagline = 'Ice Cream & Frozen, delivered cold.';
  static const String storeAddressLine1 = 'No.1 Tolgate';
  static const String storeAddressLine2 = 'Trichy';
  static const String storeFullAddress = 'No.1 Tolgate, Trichy';
  static const String supportPhone = '+91 90000 00000';
  static const String supportEmail = 'care@srdepartmentstore.in';

  // ---- Commerce -------------------------------------------------------------
  static const String currencySymbol = '\u20B9'; // Indian Rupee
  static const String currencyCode = 'INR';
  static const double freeDeliveryThreshold = 499.0;
  static const double deliveryFee = 39.0;
  static const double packagingFee = 15.0;
  static const int gstPercent = 5;

  // ---- Delivery promise -----------------------------------------------------
  static const int estimatedDeliveryMinutes = 35;
}

/// Runtime configuration.
///
/// Flip [useDummyData] to `false` once the SR Department Store backend is
/// reachable. The repository layer reads this flag to decide which data source
/// to construct — see `data/repositories`.
class AppConfig {
  AppConfig._();

  /// `true`  -> in-memory dummy catalog & mocked flows (current).
  /// `false` -> live SR Department Store API / database.
  static const bool useDummyData = true;

  /// Base URL of the NestJS backend that fronts the SR Department Store
  /// database. Used only when [useDummyData] is `false`.
  static const String apiBaseUrl = 'https://api.srdepartmentstore.in/v1';
}
