import 'product.dart';

/// A line in the cart: a product plus the chosen quantity.
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get lineTotal => product.price * quantity;

  Map<String, dynamic> toJson() => {
        'productId': product.id,
        'quantity': quantity,
        'unitPrice': product.price,
      };
}
