import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../providers/cart_provider.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/gradient_image.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/quantity_selector.dart';
import '../cart/cart_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({super.key, required this.productId});

  final String productId;

  @override
  Widget build(BuildContext context) {
    final product = context.watch<CatalogProvider>().byId(productId);
    if (product == null) {
      return const Scaffold(
        body: Center(child: Text('Product not found')),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            expandedHeight: 360,
            backgroundColor: AppColors.background,
            surfaceTintColor: Colors.transparent,
            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: _circleIcon(context, Icons.arrow_back_ios_new_rounded,
                  () => Navigator.of(context).pop()),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.fromLTRB(20, 80, 20, 20),
                child: GradientImage(
                  product: product,
                  borderRadius: 32,
                  emojiSize: 130,
                  heroTag: 'product-${product.id}',
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(product.name,
                            style: AppTypography.title),
                      ),
                      _vegMark(product.isVeg),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(product.tagline, style: AppTypography.body),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _pill(Icons.star_rounded,
                          '${product.rating}  (${product.reviewCount})',
                          color: AppColors.warning),
                      const SizedBox(width: 10),
                      _pill(Icons.inventory_2_outlined, product.unit),
                    ],
                  ),
                  const SizedBox(height: 24),
                  if (product.highlights.isNotEmpty) ...[
                    Text('Highlights', style: AppTypography.subhead),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: product.highlights
                          .map((h) => Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 14, vertical: 9),
                                decoration: BoxDecoration(
                                  color: AppColors.surface,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(h,
                                    style: AppTypography.callout.copyWith(
                                        color: AppColors.ink)),
                              ))
                          .toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Text('About', style: AppTypography.subhead),
                  const SizedBox(height: 8),
                  Text(product.description, style: AppTypography.body),
                  const SizedBox(height: 24),
                  _deliveryNote(),
                  const SizedBox(height: 140),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _bottomBar(context, product.id),
    );
  }

  Widget _bottomBar(BuildContext context, String id) {
    return Consumer2<CatalogProvider, CartProvider>(
      builder: (context, catalog, cart, _) {
        final product = catalog.byId(id);
        if (product == null) return const SizedBox.shrink();
        final qty = cart.quantityOf(product.id);

        return Container(
          padding: EdgeInsets.fromLTRB(
              20, 14, 20, 14 + MediaQuery.of(context).padding.bottom),
          decoration: const BoxDecoration(
            color: AppColors.background,
            border: Border(top: BorderSide(color: AppColors.divider)),
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (product.hasDiscount)
                    Text(Formatters.price(product.mrp!),
                        style: AppTypography.caption.copyWith(
                          decoration: TextDecoration.lineThrough,
                          color: AppColors.inkTertiary,
                        )),
                  Text(Formatters.price(product.price),
                      style: AppTypography.headline),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: qty == 0
                    ? PrimaryButton(
                        label: 'Add to cart',
                        icon: Icons.add_rounded,
                        onPressed: () => cart.add(product),
                      )
                    : Row(
                        children: [
                          QuantitySelector(
                            quantity: qty,
                            onAdd: () => cart.add(product),
                            onRemove: () => cart.decrement(product),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton.secondary(
                              label: 'Go to cart',
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (_) => const CartScreen()),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _deliveryNote() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.ac_unit_rounded, color: AppColors.accent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Delivered in insulated cold packaging to keep it frozen.',
              style: AppTypography.callout.copyWith(color: AppColors.ink),
            ),
          ),
        ],
      ),
    );
  }

  Widget _pill(IconData icon, String text, {Color? color}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color ?? AppColors.inkSecondary),
          const SizedBox(width: 6),
          Text(text,
              style: AppTypography.callout.copyWith(color: AppColors.ink)),
        ],
      ),
    );
  }

  Widget _circleIcon(BuildContext context, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.background.withOpacity(0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }

  Widget _vegMark(bool isVeg) {
    final color = isVeg ? AppColors.veg : AppColors.error;
    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(color: color, width: 2),
      ),
      child: Center(
        child: Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}
