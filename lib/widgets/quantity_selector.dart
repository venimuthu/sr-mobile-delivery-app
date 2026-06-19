import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// A compact, rounded quantity stepper. When [quantity] is 0 it collapses to a
/// single "Add" pill; once items are in the cart it expands to − n +.
class QuantitySelector extends StatelessWidget {
  const QuantitySelector({
    super.key,
    required this.quantity,
    required this.onAdd,
    required this.onRemove,
    this.compact = false,
  });

  final int quantity;
  final VoidCallback onAdd;
  final VoidCallback onRemove;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final height = compact ? 34.0 : 40.0;

    if (quantity == 0) {
      return GestureDetector(
        onTap: onAdd,
        child: Container(
          height: height,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Text('Add',
              style: AppTypography.button
                  .copyWith(color: AppColors.accent, fontSize: 15)),
        ),
      );
    }

    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.remove_rounded, onRemove),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 150),
            child: Text(
              '$quantity',
              key: ValueKey(quantity),
              style: AppTypography.subhead
                  .copyWith(color: AppColors.onAccent, fontSize: 15),
            ),
          ),
          _btn(Icons.add_rounded, onAdd),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: compact ? 34 : 40,
        height: double.infinity,
        child: Icon(icon, color: AppColors.onAccent, size: compact ? 18 : 20),
      ),
    );
  }
}
