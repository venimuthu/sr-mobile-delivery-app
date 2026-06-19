import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/utils/formatters.dart';
import '../../models/order.dart';
import '../../providers/order_provider.dart';
import '../../widgets/primary_button.dart';

class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.orderId});

  final String orderId;

  static const _stages = [
    OrderStatus.confirmed,
    OrderStatus.preparing,
    OrderStatus.outForDelivery,
    OrderStatus.delivered,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Track order'),
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context)
                .popUntil((route) => route.isFirst),
            child: Text('Done',
                style: AppTypography.button
                    .copyWith(color: AppColors.accent, fontSize: 15)),
          ),
        ],
      ),
      body: Consumer<OrderProvider>(
        builder: (context, orders, _) {
          final order = orders.active;
          if (order == null || order.id != orderId) {
            return const Center(child: Text('Order not found'));
          }
          final currentIndex = _stages.indexOf(order.status);
          final delivered = order.status == OrderStatus.delivered;

          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            children: [
              _heroCard(order, delivered),
              const SizedBox(height: 24),
              Text('Order ${order.id}', style: AppTypography.subhead),
              const SizedBox(height: 16),
              ..._stages.asMap().entries.map((entry) {
                final i = entry.key;
                final stage = entry.value;
                return _timelineRow(
                  stage: stage,
                  done: i < currentIndex,
                  active: i == currentIndex,
                  isLast: i == _stages.length - 1,
                );
              }),
              const SizedBox(height: 16),
              _addressCard(order),
              const SizedBox(height: 16),
              _itemsCard(order),
              const SizedBox(height: 24),
              PrimaryButton.secondary(
                label: 'Need help with this order?',
                onPressed: () {},
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _heroCard(Order order, bool delivered) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: delivered
              ? const [Color(0xFF1E7A3D), Color(0xFF34C759)]
              : const [Color(0xFF1D1D1F), Color(0xFF3A2A33)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: AppColors.softShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(delivered ? 'Delivered 🎉' : 'Arriving soon',
              style: AppTypography.caption.copyWith(
                  color: Colors.white70,
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 8),
          Text(
            delivered
                ? 'Enjoy your treats!'
                : Formatters.deliveryWindow(order.estimatedDelivery),
            style: AppTypography.title.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(order.status.description,
              style: AppTypography.callout.copyWith(color: Colors.white70)),
        ],
      ),
    );
  }

  Widget _timelineRow({
    required OrderStatus stage,
    required bool done,
    required bool active,
    required bool isLast,
  }) {
    final reached = done || active;
    final color = reached ? AppColors.accent : AppColors.border;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  color: reached ? AppColors.accent : AppColors.background,
                  shape: BoxShape.circle,
                  border: Border.all(color: color, width: 2),
                ),
                child: done
                    ? const Icon(Icons.check_rounded,
                        size: 16, color: Colors.white)
                    : active
                        ? Center(
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle),
                            ),
                          )
                        : null,
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: done ? AppColors.accent : AppColors.border,
                  ),
                ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 22),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(stage.label,
                      style: AppTypography.subhead.copyWith(
                        color: reached ? AppColors.ink : AppColors.inkTertiary,
                      )),
                  const SizedBox(height: 2),
                  Text(stage.description,
                      style: AppTypography.caption),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addressCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_on_rounded, color: AppColors.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Delivering to ${order.addressLabel}',
                    style: AppTypography.subhead),
                const SizedBox(height: 2),
                Text(order.addressLine, style: AppTypography.callout),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemsCard(Order order) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${order.itemCount} items from ${AppConstants.storeName}',
              style: AppTypography.subhead),
          const SizedBox(height: 12),
          ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text('${item.quantity} × ${item.product.name}',
                          style: AppTypography.body.copyWith(fontSize: 15)),
                    ),
                    Text(Formatters.price(item.lineTotal),
                        style: AppTypography.bodyStrong.copyWith(fontSize: 15)),
                  ],
                ),
              )),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Divider(height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total paid', style: AppTypography.subhead),
              Text(Formatters.price(order.total),
                  style: AppTypography.subhead),
            ],
          ),
        ],
      ),
    );
  }
}
