import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../models/user.dart';
import '../../providers/auth_provider.dart';
import '../../providers/cart_provider.dart';
import '../../providers/order_provider.dart';
import '../../widgets/primary_button.dart';
import '../orders/order_tracking_screen.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

enum _PayMethod { upi, card, cod }

class _CheckoutScreenState extends State<CheckoutScreen> {
  _PayMethod _method = _PayMethod.upi;
  bool _placing = false;

  Future<void> _placeOrder() async {
    final cart = context.read<CartProvider>();
    final orders = context.read<OrderProvider>();
    final auth = context.read<AuthProvider>();
    final address = auth.user?.primaryAddress;

    setState(() => _placing = true);
    await Future.delayed(const Duration(milliseconds: 900)); // mock gateway

    final order = orders.placeOrder(
      items: cart.items,
      subtotal: cart.subtotal,
      deliveryFee: cart.deliveryFee,
      packagingFee: cart.packagingFee,
      tax: cart.tax,
      total: cart.total,
      addressLabel: address?.label ?? 'Home',
      addressLine: address?.oneLine ?? 'Trichy',
    );
    cart.clear();

    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => OrderTrackingScreen(orderId: order.id),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final auth = context.watch<AuthProvider>();
    final address = auth.user?.primaryAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Checkout')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        children: [
          _sectionLabel('Delivery address'),
          const SizedBox(height: 10),
          _addressCard(address),
          const SizedBox(height: 24),
          _sectionLabel('Delivery'),
          const SizedBox(height: 10),
          _etaCard(),
          const SizedBox(height: 24),
          _sectionLabel('Payment method'),
          const SizedBox(height: 10),
          _payOption(_PayMethod.upi, Icons.qr_code_rounded, 'UPI',
              'Pay by any UPI app'),
          const SizedBox(height: 10),
          _payOption(_PayMethod.card, Icons.credit_card_rounded,
              'Card', 'Credit or debit card'),
          const SizedBox(height: 10),
          _payOption(_PayMethod.cod, Icons.payments_outlined,
              'Cash on delivery', 'Pay when it arrives'),
          const SizedBox(height: 24),
          _sectionLabel('Bill summary'),
          const SizedBox(height: 10),
          _miniBill(cart),
        ],
      ),
      bottomSheet: Container(
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
                label: _method == _PayMethod.cod
                    ? 'Place order'
                    : 'Pay ${Formatters.price(cart.total)}',
                busy: _placing,
                onPressed: _placing ? null : _placeOrder,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) =>
      Text(text, style: AppTypography.subhead);

  Widget _addressCard(Address? address) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.home_rounded, color: AppColors.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(address?.label ?? 'Home', style: AppTypography.subhead),
                const SizedBox(height: 2),
                Text(address?.oneLine ?? 'Trichy',
                    style: AppTypography.callout),
              ],
            ),
          ),
          Text('Change',
              style: AppTypography.callout.copyWith(color: AppColors.accent)),
        ],
      ),
    );
  }

  Widget _etaCard() {
    final eta = DateTime.now().add(const Duration(minutes: 35));
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.ac_unit_rounded, color: AppColors.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Text('Arriving frozen — ${Formatters.deliveryWindow(eta)}',
                style: AppTypography.callout.copyWith(color: AppColors.ink)),
          ),
        ],
      ),
    );
  }

  Widget _payOption(
      _PayMethod method, IconData icon, String title, String subtitle) {
    final selected = _method == method;
    return GestureDetector(
      onTap: () => setState(() => _method = method),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: selected ? AppColors.accent : AppColors.ink),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTypography.subhead),
                  Text(subtitle, style: AppTypography.caption),
                ],
              ),
            ),
            Icon(
              selected
                  ? Icons.radio_button_checked_rounded
                  : Icons.radio_button_off_rounded,
              color: selected ? AppColors.accent : AppColors.inkTertiary,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }

  Widget _miniBill(CartProvider cart) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          _row('Item total', Formatters.price(cart.subtotal)),
          const SizedBox(height: 10),
          _row('Delivery',
              cart.deliveryFee == 0 ? 'FREE' : Formatters.price(cart.deliveryFee)),
          const SizedBox(height: 10),
          _row('Packaging', Formatters.price(cart.packagingFee)),
          const SizedBox(height: 10),
          _row('GST', Formatters.price(cart.tax)),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(height: 1),
          ),
          _row('To pay', Formatters.price(cart.total), bold: true),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {bool bold = false}) {
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
                : AppTypography.bodyStrong.copyWith(fontSize: 15)),
      ],
    );
  }
}
