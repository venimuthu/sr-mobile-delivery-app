import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../providers/catalog_provider.dart';
import '../auth/login_screen.dart';
import '../main_shell.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _boot();
  }

  Future<void> _boot() async {
    final catalog = context.read<CatalogProvider>();
    await Future.wait([
      catalog.load(),
      Future.delayed(const Duration(milliseconds: 1400)),
    ]);
    if (!mounted) return;

    final loggedIn = context.read<AuthProvider>().isLoggedIn;
    Navigator.of(context).pushReplacement(
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 450),
        pageBuilder: (_, __, ___) =>
            loggedIn ? const MainShell() : const LoginScreen(),
        transitionsBuilder: (_, anim, __, child) =>
            FadeTransition(opacity: anim, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFFF9EB7), Color(0xFFFFC4A0)],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: AppColors.softShadow,
              ),
              child: const Center(
                child: Text('🍦', style: TextStyle(fontSize: 48)),
              ),
            )
                .animate()
                .scale(
                  duration: 600.ms,
                  curve: Curves.easeOutBack,
                  begin: const Offset(0.7, 0.7),
                )
                .fadeIn(duration: 400.ms),
            const SizedBox(height: 28),
            Text('SR', style: AppTypography.title)
                .animate()
                .fadeIn(delay: 300.ms, duration: 500.ms),
            const SizedBox(height: 4),
            Text(
              AppConstants.storeName,
              style: AppTypography.callout,
            ).animate().fadeIn(delay: 450.ms, duration: 500.ms),
            const SizedBox(height: 2),
            Text(
              AppConstants.storeFullAddress,
              style: AppTypography.caption,
            ).animate().fadeIn(delay: 550.ms, duration: 500.ms),
          ],
        ),
      ),
    );
  }
}
