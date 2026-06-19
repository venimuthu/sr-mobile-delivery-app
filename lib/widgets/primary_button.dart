import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../core/theme/app_typography.dart';

/// The app's primary call-to-action: a full-width, pill-shaped Apple-blue
/// button with a gentle press scale. Use [PrimaryButton.secondary] for the
/// quieter tinted variant.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.busy = false,
    this.variant = _ButtonVariant.filled,
  });

  const PrimaryButton.secondary({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.expanded = true,
    this.busy = false,
  }) : variant = _ButtonVariant.tinted;

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool expanded;
  final bool busy;
  final _ButtonVariant variant;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

enum _ButtonVariant { filled, tinted }

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.busy;
    final filled = widget.variant == _ButtonVariant.filled;

    final bg = filled
        ? (_down ? AppColors.accentPressed : AppColors.accent)
        : AppColors.surface;
    final fg = filled ? AppColors.onAccent : AppColors.accent;

    final child = AnimatedScale(
      scale: _down ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: AnimatedOpacity(
        opacity: enabled ? 1 : 0.5,
        duration: const Duration(milliseconds: 150),
        child: Container(
          height: 54,
          width: widget.expanded ? double.infinity : null,
          padding: widget.expanded
              ? null
              : const EdgeInsets.symmetric(horizontal: 28),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(27),
          ),
          child: widget.busy
              ? SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    valueColor: AlwaysStoppedAnimation(fg),
                  ),
                )
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.icon != null) ...[
                      Icon(widget.icon, color: fg, size: 20),
                      const SizedBox(width: 8),
                    ],
                    Text(widget.label,
                        style: AppTypography.button.copyWith(color: fg)),
                  ],
                ),
        ),
      ),
    );

    return GestureDetector(
      onTapDown: enabled ? (_) => setState(() => _down = true) : null,
      onTapUp: enabled ? (_) => setState(() => _down = false) : null,
      onTapCancel: enabled ? () => setState(() => _down = false) : null,
      onTap: enabled ? widget.onPressed : null,
      child: child,
    );
  }
}
