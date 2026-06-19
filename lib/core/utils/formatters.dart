import 'package:intl/intl.dart';

import '../constants/app_constants.dart';

/// Small, dependency-light formatting helpers used across the UI.
class Formatters {
  Formatters._();

  static final NumberFormat _rupee = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  /// `1499` -> `₹1,499`
  static String price(num value) => _rupee.format(value);

  /// `1499.5` -> `₹1,499.50` (used on detailed bills where paise matter)
  static String priceDecimal(num value) => NumberFormat.currency(
        locale: 'en_IN',
        symbol: AppConstants.currencySymbol,
        decimalDigits: 2,
      ).format(value);

  /// Human delivery window, e.g. "Today, by 4:25 PM".
  static String deliveryWindow(DateTime eta) {
    final time = DateFormat('h:mm a').format(eta);
    final now = DateTime.now();
    final sameDay = eta.year == now.year &&
        eta.month == now.month &&
        eta.day == now.day;
    return sameDay ? 'Today, by $time' : '${DateFormat('d MMM').format(eta)}, by $time';
  }

  /// `2026-06-16T14:25` -> `16 Jun 2026, 2:25 PM`
  static String dateTime(DateTime dt) =>
      DateFormat('d MMM yyyy, h:mm a').format(dt);
}
