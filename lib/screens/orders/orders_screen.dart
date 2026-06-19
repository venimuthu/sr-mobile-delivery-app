import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import 'order_tracking_screen.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrderProvider>();
    final history = orders.history;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: history.isEmpty
            ? _empty()
            : ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
                children: [
                  Text('Orders', style: AppTypography.title),
                  const SizedBox(height: 4),
                  Text('Your recent orders from ${AppConstants.storeName}.',
                      style: AppTypography.body),
                  const SizedBox(height: 20),
                  ...history.map((o) => _orderCard(context, o, orders)),
                ],
              ),
      ),
    );
  }

  Widget _empty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🧾', style: TextStyle(fontSize: 52)),
          const SizedBox(height: 14),
          Text('No orders yet', style: AppTypography.headline),
          const SizedBox(height: 6),
          Text('When you order, it\u2019ll show up here.',
              style: AppTypography.body),
        ],
      ),
    );
  }

  Widget _orderCard(BuildContext context, Order order, OrderProvider orders) {
    final isActive =
        orders.active?.id == order.id && order.status != OrderStatus.delivered;
    final delivered = order.status == OrderStatus.delivered;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(order.id, style: AppTypography.subhead),
              const Spacer(),
              _statusChip(order.status),
            ],
          ),
          const SizedBox(height: 4),
          Text(Formatters.dateTime(order.placedAt),
              style: AppTypography.caption),
          const SizedBox(height: 12),
          Text(
            order.items.map((i) => '${i.quantity}× ${i.product.name}').join(', '),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.callout.copyWith(color: AppColors.ink),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Text(Formatters.price(order.total),
                  style: AppTypography.subhead),
              const Spacer(),
              if (isActive)
                GestureDetector(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => OrderTrackingScreen(orderId: order.id),
                    ),
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text('Track',
                        style: AppTypography.button.copyWith(
                            color: Colors.white, fontSize: 14)),
                  ),
                )
              else
                Text(delivered ? 'Delivered' : order.status.label,
                    style: AppTypography.callout
                        .copyWith(color: AppColors.inkSecondary)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusChip(OrderStatus status) {
    Color bg;
    Color fg;
    switch (status) {
      case OrderStatus.delivered:
        bg = const Color(0xFFE6F7EC);
        fg = AppColors.success;
        break;
      case OrderStatus.cancelled:
        bg = const Color(0xFFFDEAEA);
        fg = AppColors.error;
        break;
      default:
        bg = const Color(0xFFE9F2FF);
        fg = AppColors.accent;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(status.label,
          style: AppTypography.caption
              .copyWith(color: fg, fontWeight: FontWeight.w600)),
    );
  }
}
