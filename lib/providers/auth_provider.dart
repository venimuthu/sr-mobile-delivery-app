import 'package:flutter/foundation.dart';

import '../core/constants/app_constants.dart';
import '../models/user.dart';

/// Mocked authentication that mirrors the OTP flow from the brief.
///
/// In dummy mode any 10-digit number "works" and the OTP is always `1234`
/// (surfaced in the UI as a hint). Swap the two marked methods for real
/// SMS-OTP calls against the backend when ready.
class AuthProvider extends ChangeNotifier {
  AppUser? _user;
  AppUser? get user => _user;
  bool get isLoggedIn => _user != null;

  bool _otpSent = false;
  bool get otpSent => _otpSent;

  String _pendingPhone = '';
  String get pendingPhone => _pendingPhone;

  bool _busy = false;
  bool get busy => _busy;

  /// The fixed OTP accepted in dummy mode.
  static const String demoOtp = '1234';

  Future<void> requestOtp(String phone) async {
    _busy = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO(backend): POST $apiBaseUrl/auth/otp/request { phone }
    _pendingPhone = phone;
    _otpSent = true;
    _busy = false;
    notifyListeners();
  }

  Future<bool> verifyOtp(String otp) async {
    _busy = true;
    notifyListeners();
    await Future.delayed(const Duration(milliseconds: 700));
    // TODO(backend): POST $apiBaseUrl/auth/otp/verify { phone, otp } -> JWT
    final ok = otp == demoOtp;
    if (ok) {
      _user = AppUser(
        id: 'u1',
        name: 'Guest Customer',
        phone: _pendingPhone,
        email: AppConstants.supportEmail,
        addresses: const [
          Address(
            id: 'a1',
            label: 'Home',
            line1: '12, Thillai Nagar',
            line2: 'Trichy',
            city: 'Tiruchirappalli',
            pincode: '620018',
          ),
        ],
      );
      _otpSent = false;
    }
    _busy = false;
    notifyListeners();
    return ok;
  }

  void skipForNow() {
    _user = const AppUser(
      id: 'guest',
      name: 'Guest',
      phone: '',
      email: '',
      addresses: [
        Address(
          id: 'a1',
          label: 'Home',
          line1: '12, Thillai Nagar',
          line2: 'Trichy',
          city: 'Tiruchirappalli',
          pincode: '620018',
        ),
      ],
    );
    notifyListeners();
  }

  void signOut() {
    _user = null;
    _otpSent = false;
    _pendingPhone = '';
    notifyListeners();
  }
}
