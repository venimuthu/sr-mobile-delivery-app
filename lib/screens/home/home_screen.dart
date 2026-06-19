import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/catalog_provider.dart';
import '../../widgets/product_card.dart';
import '../cart/cart_screen.dart';
import '../catalog/search_screen.dart';
import 'widgets/category_rail.dart';
import 'widgets/hero_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final catalog = context.watch<CatalogProvider>();
    final loading = catalog.state == LoadState.loading ||
        catalog.state == LoadState.idle;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: RefreshIndicator(
          color: AppColors.accent,
          onRefresh: () => context.read<CatalogProvider>().load(),
          child: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _header(context)),
              SliverToBoxAdapter(child: _searchBar(context)),
              const SliverToBoxAdapter(child: SizedBox(height: 16)),
              SliverToBoxAdapter(
                child: HeroBanner(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SearchScreen()),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 28)),
              if (loading)
                const SliverToBoxAdapter(child: _LoadingBlock())
              else ...[
                SliverToBoxAdapter(
                    child: _sectionTitle('Shop by category')),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverToBoxAdapter(
                    child: CategoryRail(categories: catalog.categories)),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
                SliverToBoxAdapter(
                    child: _sectionTitle('Featured',
                        subtitle: 'Hand-picked favourites')),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                SliverToBoxAdapter(child: _featuredRail(catalog)),
                const SliverToBoxAdapter(child: SizedBox(height: 28)),
                SliverToBoxAdapter(child: _sectionTitle('All treats')),
                const SliverToBoxAdapter(child: SizedBox(height: 14)),
                _grid(catalog),
              ],
              const SliverToBoxAdapter(child: SizedBox(height: 120)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 16, 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on_rounded,
                        size: 16, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text('Deliver to',
                        style: AppTypography.caption
                            .copyWith(color: AppColors.inkSecondary)),
                  ],
                ),
                const SizedBox(height: 2),
                Text(AppConstants.storeFullAddress,
                    style: AppTypography.subhead),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const CartScreen()),
            ),
            child: Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.shopping_bag_outlined, size: 22),
            ),
          ),
        ],
      ),
    );
  }

  Widget _searchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const SearchScreen()),
        ),
        child: Container(
          height: 50,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              const Icon(Icons.search_rounded,
                  color: AppColors.inkTertiary, size: 22),
              const SizedBox(width: 10),
              Text('Search ice cream, kulfi, sorbet…',
                  style: AppTypography.body.copyWith(fontSize: 15)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String title, {String? subtitle}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTypography.headline),
          if (subtitle != null) ...[
            const SizedBox(height: 2),
            Text(subtitle, style: AppTypography.callout),
          ],
        ],
      ),
    );
  }

  Widget _featuredRail(CatalogProvider catalog) {
    final items = catalog.featured;
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 14),
        itemBuilder: (_, i) => ProductCard(product: items[i], width: 180),
      ),
    );
  }

  Widget _grid(CatalogProvider catalog) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.62,
        ),
        delegate: SliverChildBuilderDelegate(
          (_, i) => ProductCard(product: catalog.products[i]),
          childCount: catalog.products.length,
        ),
      ),
    );
  }
}

/// Lightweight skeleton shown while the catalogue loads.
class _LoadingBlock extends StatelessWidget {
  const _LoadingBlock();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Padding(
          padding: EdgeInsets.only(top: 60),
          child: CircularProgressIndicator(
            color: AppColors.accent,
            strokeWidth: 2.4,
          ),
        ),
      ),
    );
  }
}
