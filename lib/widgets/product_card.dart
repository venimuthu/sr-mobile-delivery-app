import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';
import '../core/utils/formatters.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../screens/product/product_detail_screen.dart';
import 'gradient_image.dart';
import 'quantity_selector.dart';

/// The catalogue card used in the home grid and category lists.
class ProductCard extends StatelessWidget {
  const ProductCard({super.key, required this.product, this.width});

  final Product product;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(productId: product.id),
        ),
      ),
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(22),
          boxShadow: AppColors.subtleShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: GradientImage(
                      product: product,
                      heroTag: 'product-${product.id}',
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: _badge('${product.discountPercent}% OFF'),
                    ),
                  Positioned(
                    top: 12,
                    right: 12,
                    child: _vegMark(product.isVeg),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subhead,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    product.unit,
                    style: AppTypography.caption,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(child: _priceBlock()),
                      Consumer<CartProvider>(
                        builder: (context, cart, _) {
                          final qty = cart.quantityOf(product.id);
                          return QuantitySelector(
                            compact: true,
                            quantity: qty,
                            onAdd: () => cart.add(product),
                            onRemove: () => cart.decrement(product),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _priceBlock() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            Formatters.price(product.price),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.price,
          ),
        ),
        if (product.hasDiscount) ...[
          const SizedBox(width: 6),
          Text(
            Formatters.price(product.mrp!),
            style: AppTypography.caption.copyWith(
              decoration: TextDecoration.lineThrough,
              color: AppColors.inkTertiary,
            ),
          ),
        ],
      ],
    );
  }

  Widget _badge(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: AppTypography.caption.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _vegMark(bool isVeg) {
    final color = isVeg ? AppColors.veg : AppColors.error;
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: color, width: 1.5),
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
