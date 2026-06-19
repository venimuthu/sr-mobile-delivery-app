import 'dart:async';

import 'package:flutter/foundation.dart';

import '../data/repositories/order_repository.dart';
import '../models/cart_item.dart';
import '../models/order.dart';

/// Owns the active order and a small in-session history, and subscribes to the
/// (simulated) delivery-status stream.
class OrderProvider extends ChangeNotifier {
  OrderProvider({OrderRepository? repository})
      : _repo = repository ?? OrderRepository();

  final OrderRepository _repo;

  final List<Order> _history = [];
  List<Order> get history => List.unmodifiable(_history.reversed);

  Order? _active;
  Order? get active => _active;

  StreamSubscription<OrderStatus>? _statusSub;

  Order placeOrder({
    required List<CartItem> items,
    required double subtotal,
    required double deliveryFee,
    required double packagingFee,
    required double tax,
    required double total,
    required String addressLabel,
    required String addressLine,
  }) {
    final order = _repo.placeOrder(
      items: items,
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      packagingFee: packagingFee,
      tax: tax,
      total: total,
      addressLabel: addressLabel,
      addressLine: addressLine,
    );
    _active = order;
    _history.add(order);
    _trackStatus(order);
    notifyListeners();
    return order;
  }

  void _trackStatus(Order order) {
    _statusSub?.cancel();
    _statusSub = _repo.watchStatus(order).listen((status) {
      order.status = status;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _statusSub?.cancel();
    super.dispose();
  }
}
