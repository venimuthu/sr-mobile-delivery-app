import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/primary_button.dart';
import '../main_shell.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _otpController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _toShell() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  Future<void> _requestOtp(AuthProvider auth) async {
    if (_phoneController.text.trim().length < 10) {
      _snack('Enter a valid 10-digit mobile number');
      return;
    }
    await auth.requestOtp(_phoneController.text.trim());
  }

  Future<void> _verify(AuthProvider auth) async {
    final ok = await auth.verifyOtp(_otpController.text.trim());
    if (!mounted) return;
    if (ok) {
      _toShell();
    } else {
      _snack('Incorrect code. Hint: it\u2019s ${AuthProvider.demoOtp}.');
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Spacer(),
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9EB7), Color(0xFFFFC4A0)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Center(
                    child: Text('🍦', style: TextStyle(fontSize: 34))),
              ),
              const SizedBox(height: 28),
              Text(
                auth.otpSent ? 'Enter the code' : 'Sign in to SR',
                style: AppTypography.title,
              ),
              const SizedBox(height: 8),
              Text(
                auth.otpSent
                    ? 'We sent a 4-digit code to +91 ${auth.pendingPhone}.'
                    : 'Cold treats from ${AppConstants.storeName}, delivered to your door.',
                style: AppTypography.body,
              ),
              const SizedBox(height: 36),
              if (!auth.otpSent)
                _phoneField()
              else
                _otpField(),
              const SizedBox(height: 24),
              PrimaryButton(
                label: auth.otpSent ? 'Verify & continue' : 'Get OTP',
                busy: auth.busy,
                onPressed: auth.busy
                    ? null
                    : () => auth.otpSent ? _verify(auth) : _requestOtp(auth),
              ),
              const SizedBox(height: 16),
              Center(
                child: TextButton(
                  onPressed: () {
                    if (auth.otpSent) {
                      auth.signOut(); // resets the otpSent flag, back to phone
                    } else {
                      auth.skipForNow();
                      _toShell();
                    }
                  },
                  child: Text(
                    auth.otpSent ? 'Use a different number' : 'Skip for now',
                    style: AppTypography.callout
                        .copyWith(color: AppColors.accent),
                  ),
                ),
              ),
              const Spacer(),
              Center(
                child: Text(
                  'By continuing you agree to our Terms & Privacy Policy.',
                  textAlign: TextAlign.center,
                  style: AppTypography.caption,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  Widget _phoneField() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text('+91', style: AppTypography.subhead),
          const SizedBox(width: 12),
          Container(width: 1, height: 24, color: AppColors.border),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              style: AppTypography.subhead,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
                hintText: 'Mobile number',
                contentPadding: EdgeInsets.symmetric(vertical: 18),
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }

  Widget _otpField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: TextField(
            controller: _otpController,
            keyboardType: TextInputType.number,
            maxLength: 4,
            style: AppTypography.title.copyWith(letterSpacing: 12),
            textAlign: TextAlign.center,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: const InputDecoration(
              counterText: '',
              border: InputBorder.none,
              hintText: '••••',
              contentPadding: EdgeInsets.symmetric(vertical: 18),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Text('Demo code: ${AuthProvider.demoOtp}',
            style: AppTypography.caption),
      ],
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.1, end: 0);
  }
}
