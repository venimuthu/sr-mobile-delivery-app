import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

/// The shopping cart and the live bill maths derived from it.
class CartProvider extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);
  bool get isEmpty => _items.isEmpty;
  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  int quantityOf(String productId) {
    for (final item in _items) {
      if (item.product.id == productId) return item.quantity;
    }
    return 0;
  }

  void add(Product product) {
    final existing = _indexOf(product.id);
    if (existing >= 0) {
      _items[existing].quantity++;
    } else {
      _items.add(CartItem(product: product));
    }
    notifyListeners();
  }

  void decrement(Product product) {
    final existing = _indexOf(product.id);
    if (existing < 0) return;
    if (_items[existing].quantity > 1) {
      _items[existing].quantity--;
    } else {
      _items.removeAt(existing);
    }
    notifyListeners();
  }

  void removeAll(Product product) {
    _items.removeWhere((i) => i.product.id == product.id);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }

  int _indexOf(String productId) =>
      _items.indexWhere((i) => i.product.id == productId);

  // ---- Bill maths -----------------------------------------------------------
  double get subtotal => _items.fold(0.0, (sum, i) => sum + i.lineTotal);

  bool get qualifiesForFreeDelivery =>
      subtotal >= AppConstants.freeDeliveryThreshold;

  double get deliveryFee =>
      isEmpty || qualifiesForFreeDelivery ? 0.0 : AppConstants.deliveryFee;

  double get packagingFee => isEmpty ? 0.0 : AppConstants.packagingFee;

  double get tax =>
      (subtotal * AppConstants.gstPercent / 100).roundToDouble();

  double get total => subtotal + deliveryFee + packagingFee + tax;

  /// How much more is needed to unlock free delivery (0 if already there).
  double get amountToFreeDelivery {
    final remaining = AppConstants.freeDeliveryThreshold - subtotal;
    return remaining > 0 ? remaining : 0;
  }
}
