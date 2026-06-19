import 'cart_item.dart';

/// Lifecycle of an order, matching the delivery-tracking flow in the
/// architecture brief: Confirmed -> Preparing -> Out for delivery -> Delivered.
enum OrderStatus {
  confirmed,
  preparing,
  outForDelivery,
  delivered,
  cancelled,
}

extension OrderStatusX on OrderStatus {
  String get label {
    switch (this) {
      case OrderStatus.confirmed:
        return 'Order confirmed';
      case OrderStatus.preparing:
        return 'Preparing & packing';
      case OrderStatus.outForDelivery:
        return 'Out for delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String get description {
    switch (this) {
      case OrderStatus.confirmed:
        return 'We\u2019ve received your order at SR Department Store.';
      case OrderStatus.preparing:
        return 'Your items are being packed in insulated, cold packaging.';
      case OrderStatus.outForDelivery:
        return 'Your rider has left the store and is on the way.';
      case OrderStatus.delivered:
        return 'Enjoy! Your order has been delivered.';
      case OrderStatus.cancelled:
        return 'This order was cancelled.';
    }
  }
}

class Order {
  final String id;
  final List<CartItem> items;
  final double subtotal;
  final double deliveryFee;
  final double packagingFee;
  final double tax;
  final double total;
  final DateTime placedAt;
  final DateTime estimatedDelivery;
  final String addressLabel;
  final String addressLine;
  OrderStatus status;

  Order({
    required this.id,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.packagingFee,
    required this.tax,
    required this.total,
    required this.placedAt,
    required this.estimatedDelivery,
    required this.addressLabel,
    required this.addressLine,
    this.status = OrderStatus.confirmed,
  });

  int get itemCount => items.fold(0, (sum, i) => sum + i.quantity);

  Map<String, dynamic> toJson() => {
        'id': id,
        'items': items.map((i) => i.toJson()).toList(),
        'subtotal': subtotal,
        'deliveryFee': deliveryFee,
        'packagingFee': packagingFee,
        'tax': tax,
        'total': total,
        'placedAt': placedAt.toIso8601String(),
        'estimatedDelivery': estimatedDelivery.toIso8601String(),
        'addressLabel': addressLabel,
        'addressLine': addressLine,
        'status': status.name,
      };
}
