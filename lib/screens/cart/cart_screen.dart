import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../models/cart_item.dart';
import '../../providers/cart_provider.dart';
import '../../widgets/gradient_image.dart';
import '../../widgets/primary_button.dart';
import '../../widgets/quantity_selector.dart';
import '../checkout/checkout_screen.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Your cart')),
      body: cart.isEmpty ? _empty(context) : _filled(context, cart),
    );
  }

  Widget _empty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🛒', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text('Your cart is empty', style: AppTypography.headline),
          const SizedBox(height: 6),
          Text('Add a treat or two to get started.',
              style: AppTypography.body),
          const SizedBox(height: 24),
          SizedBox(
            width: 200,
            child: PrimaryButton(
              label: 'Browse the freezer',
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _filled(BuildContext context, CartProvider cart) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            children: [
              _freeDeliveryStrip(cart),
              const SizedBox(height: 16),
              ...cart.items.map((item) => _itemTile(context, cart, item)),
              const SizedBox(height: 8),
              _billCard(cart),
              const SizedBox(height: 16),
              _savingsNote(cart),
            ],
          ),
        ),
        _checkoutBar(context, cart),
      ],
    );
  }

  Widget _freeDeliveryStrip(CartProvider cart) {
    final qualifies = cart.qualifiesForFreeDelivery;
    final progress = qualifies
        ? 1.0
        : (cart.subtotal / AppConstants.freeDeliveryThreshold).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(qualifies ? Icons.check_circle_rounded : Icons.local_shipping_outlined,
                  size: 18,
                  color: qualifies ? AppColors.success : AppColors.accent),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  qualifies
                      ? 'You\u2019ve unlocked free delivery!'
                      : 'Add ${Formatters.price(cart.amountToFreeDelivery)} more for free delivery',
                  style: AppTypography.callout.copyWith(color: AppColors.ink),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: AppColors.border,
              valueColor: AlwaysStoppedAnimation(
                  qualifies ? AppColors.success : AppColors.accent),
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemTile(BuildContext context, CartProvider cart, CartItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          SizedBox(
            width: 72,
            height: 72,
            child: GradientImage(product: item.product, borderRadius: 16),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.subhead),
                const SizedBox(height: 2),
                Text(item.product.unit, style: AppTypography.caption),
                const SizedBox(height: 6),
                Text(Formatters.price(item.product.price),
                    style: AppTypography.price),
              ],
            ),
          ),
          QuantitySelector(
            compact: true,
            quantity: item.quantity,
            onAdd: () => cart.add(item.product),
            onRemove: () => cart.decrement(item.product),
          ),
        ],
      ),
    );
  }

  Widget _billCard(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _billRow('Item total', Formatters.price(cart.subtotal)),
          const SizedBox(height: 10),
          _billRow(
            'Delivery fee',
            cart.deliveryFee == 0 ? 'FREE' : Formatters.price(cart.deliveryFee),
            highlight: cart.deliveryFee == 0,
          ),
          const SizedBox(height: 10),
          _billRow('Packaging', Formatters.price(cart.packagingFee)),
          const SizedBox(height: 10),
          _billRow('GST (${AppConstants.gstPercent}%)',
              Formatters.price(cart.tax)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _billRow('To pay', Formatters.price(cart.total), bold: true),
        ],
      ),
    );
  }

  Widget _billRow(String label, String value,
      {bool bold = false, bool highlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: bold
                ? AppTypography.subhead
                : AppTypography.body.copyWith(fontSize: 15)),
        Text(value,
            style: bold
                ? AppTypography.subhead
                : AppTypography.bodyStrong.copyWith(
                    fontSize: 15,
                    color: highlight ? AppColors.success : AppColors.ink,
                  )),
      ],
    );
  }

  Widget _savingsNote(CartProvider cart) {
    if (cart.deliveryFee != 0) return const SizedBox.shrink();
    return Center(
      child: Text('🎉  Free delivery applied',
          style: AppTypography.caption.copyWith(color: AppColors.success)),
    );
  }

  Widget _checkoutBar(BuildContext context, CartProvider cart) {
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
              Text('Total', style: AppTypography.caption),
              Text(Formatters.price(cart.total),
                  style: AppTypography.headline),
            ],
          ),
          const SizedBox(width: 18),
          Expanded(
            child: PrimaryButton(
              label: 'Checkout',
              icon: Icons.arrow_forward_rounded,
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CheckoutScreen()),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
