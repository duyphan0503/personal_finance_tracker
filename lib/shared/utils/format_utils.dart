import 'package:intl/intl.dart';

class FormatUtils {
  static String formatDate(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d, yyyy').format(date);
  }

  static String formatDateWithoutYear(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMM d').format(date);
  }

  static String formatMonthYear(DateTime? date) {
    if (date == null) return '';
    return DateFormat('MMMM yyyy').format(date);
  }

  static String formatDateContextual(DateTime? date) {
    if (date == null) return '';

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final dateToCheck = DateTime(date.year, date.month, date.day);

    if (dateToCheck == today) {
      return 'Today';
    } else if (dateToCheck == yesterday) {
      return 'Yesterday';
    } else if (dateToCheck.year == today.year) {
      return DateFormat('MMM d').format(date);
    } else {
      return DateFormat('MMM d, yyyy').format(date);
    }
  }

  static String formatCurrency(double? amount, {bool showDecimals = true}) {
    if (amount == null) return '';

    final formatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: showDecimals ? 2 : 0,
    );

    return formatter.format(amount);
  }

  static String formatCurrencyCompact(double? amount, {bool showDecimals = true}) {
    if (amount == null) return '';

    if (amount.abs() >= 1000) {
      return NumberFormat.compactCurrency(
        symbol: '\$',
        decimalDigits: showDecimals ? 2 : 0,
      ).format(amount);
    }

    return formatCurrency(amount, showDecimals: showDecimals);
  }

  static String formatTransactionAmount(double? amount, {bool showDecimals = true}) {
    if (amount == null) return '';
    final prefix = amount >= 0 ? '+' : '';
    return '$prefix${formatCurrency(amount.abs(), showDecimals: showDecimals)}';
  }
}