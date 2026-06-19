import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../auth/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.user;
    final address = user?.primaryAddress;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            Text('Account', style: AppTypography.title),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFFF9EB7), Color(0xFFFFC4A0)],
                      ),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Center(
                      child: Text(
                        (user?.name.isNotEmpty ?? false)
                            ? user!.name.substring(0, 1).toUpperCase()
                            : '🙂',
                        style: AppTypography.headline
                            .copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(user?.name ?? 'Guest',
                            style: AppTypography.subhead),
                        const SizedBox(height: 2),
                        Text(
                          (user?.phone.isNotEmpty ?? false)
                              ? '+91 ${user!.phone}'
                              : 'Not signed in',
                          style: AppTypography.callout,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _sectionLabel('Saved address'),
            const SizedBox(height: 10),
            _tile(
              icon: Icons.home_rounded,
              title: address?.label ?? 'Add an address',
              subtitle: address?.oneLine ?? 'No address saved yet',
            ),
            const SizedBox(height: 24),
            _sectionLabel('Support'),
            const SizedBox(height: 10),
            _tile(
              icon: Icons.call_rounded,
              title: 'Call us',
              subtitle: AppConstants.supportPhone,
            ),
            const SizedBox(height: 10),
            _tile(
              icon: Icons.mail_outline_rounded,
              title: 'Email',
              subtitle: AppConstants.supportEmail,
            ),
            const SizedBox(height: 10),
            _tile(
              icon: Icons.store_mall_directory_outlined,
              title: AppConstants.storeName,
              subtitle: AppConstants.storeFullAddress,
            ),
            const SizedBox(height: 28),
            GestureDetector(
              onTap: () {
                auth.signOut();
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text('Sign out',
                    style: AppTypography.button
                        .copyWith(color: AppColors.error)),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text('SR Department Store • v1.0.0',
                  style: AppTypography.caption),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionLabel(String text) =>
      Text(text, style: AppTypography.subhead);

  Widget _tile({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.accent),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.subhead),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTypography.callout),
              ],
            ),
          ),
          const Icon(Icons.chevron_right_rounded,
              color: AppColors.inkTertiary),
        ],
      ),
    );
  }
}
