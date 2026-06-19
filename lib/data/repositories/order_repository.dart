import 'dart:async';

import '../../core/constants/app_constants.dart';
import '../../models/cart_item.dart';
import '../../models/order.dart';

/// Creates orders and reports their progress.
///
/// In dummy mode this builds an [Order] locally and advances its status on a
/// timer to emulate the WebSocket / Redis pub-sub delivery feed from the
/// architecture brief. Against the real backend, [watchStatus] becomes a
/// WebSocket stream — the public surface stays identical.
class OrderRepository {
  int _counter = 1042;

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
    final now = DateTime.now();
    final id = 'SR${_counter++}';
    return Order(
      id: id,
      items: items
          .map((i) => CartItem(product: i.product, quantity: i.quantity))
          .toList(),
      subtotal: subtotal,
      deliveryFee: deliveryFee,
      packagingFee: packagingFee,
      tax: tax,
      total: total,
      placedAt: now,
      estimatedDelivery:
          now.add(const Duration(minutes: AppConstants.estimatedDeliveryMinutes)),
      addressLabel: addressLabel,
      addressLine: addressLine,
      status: OrderStatus.confirmed,
    );
  }

  /// Emits each new [OrderStatus] as the (simulated) delivery progresses.
  Stream<OrderStatus> watchStatus(Order order) async* {
    const steps = [
      OrderStatus.confirmed,
      OrderStatus.preparing,
      OrderStatus.outForDelivery,
      OrderStatus.delivered,
    ];
    for (final step in steps) {
      yield step;
      if (step != OrderStatus.delivered) {
        await Future.delayed(const Duration(seconds: 6));
      }
    }
  }
}
