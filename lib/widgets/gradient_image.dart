import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../core/theme/app_colors.dart';
import '../models/product.dart';

/// The product visual.
///
/// While the catalogue has no photography, this paints the product's signature
/// two-colour gradient with its emoji floating in the centre — intentional and
/// premium, never a broken-image box. The moment a product carries a real
/// `imageUrl`, this widget shows the photo instead. No call-site changes.
class GradientImage extends StatelessWidget {
  const GradientImage({
    super.key,
    required this.product,
    this.borderRadius = 20,
    this.emojiSize = 64,
    this.heroTag,
  });

  final Product product;
  final double borderRadius;
  final double emojiSize;
  final Object? heroTag;

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(borderRadius);

    Widget content;
    if (product.imageUrl.isNotEmpty) {
      content = CachedNetworkImage(
        imageUrl: product.imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => _gradient(),
        errorWidget: (_, __, ___) => _gradient(),
      );
    } else {
      content = _gradient();
    }

    final clipped = ClipRRect(borderRadius: radius, child: content);
    if (heroTag != null) {
      return Hero(tag: heroTag!, child: clipped);
    }
    return clipped;
  }

  Widget _gradient() {
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [product.gradientStart, product.gradientEnd],
        ),
      ),
      child: Stack(
        children: [
          // Soft highlight in the corner for a glossy, product-shot feel.
          Positioned(
            top: -30,
            right: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.18),
              ),
            ),
          ),
          Center(
            child: Text(
              product.emoji,
              style: TextStyle(
                fontSize: emojiSize,
                shadows: [
                  Shadow(
                    color: AppColors.ink.withOpacity(0.12),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
