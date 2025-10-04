import 'package:intl/intl.dart';

class NumberFormatter {
  // Currency formatter for USD
  static final NumberFormat _currencyFormatter = NumberFormat.currency(
    locale: 'en_US',
    symbol: '\$',
    decimalDigits: 0,
  );

  // Compact number formatter (e.g., 1.2K, 1.5M)
  static final NumberFormat _compactFormatter = NumberFormat.compact();

  // Decimal number formatter
  static final NumberFormat _decimalFormatter = NumberFormat('#,##0');

  // Decimal number formatter with 2 decimal places
  static final NumberFormat _decimalFormatter2 = NumberFormat('#,##0.00');

  /// Format currency amount (e.g., $1,250, $2,500)
  static String formatCurrency(num amount) {
    if (amount <= 0) return '\$0';
    return _currencyFormatter.format(amount);
  }

  /// Format currency with decimal places (e.g., $1,250.50, $2,500.00)
  static String formatCurrencyWithDecimals(num amount) {
    if (amount <= 0) return '\$0.00';
    return NumberFormat.currency(
      locale: 'en_US',
      symbol: '\$',
      decimalDigits: 2,
    ).format(amount);
  }

  /// Format compact numbers (e.g., 1.2K, 1.5M, 2.1B)
  static String formatCompact(num number) {
    if (number <= 0) return '0';
    return _compactFormatter.format(number);
  }

  /// Format numbers with commas (e.g., 1,250, 2,500,000)
  static String formatNumber(num number) {
    if (number <= 0) return '0';
    return _decimalFormatter.format(number);
  }

  /// Format numbers with 2 decimal places (e.g., 1,250.50, 2,500.00)
  static String formatNumberWithDecimals(num number) {
    if (number <= 0) return '0.00';
    return _decimalFormatter2.format(number);
  }

  /// Format price range (e.g., $1,250 - $2,500)
  static String formatPriceRange(num minPrice, num maxPrice) {
    if (minPrice <= 0 && maxPrice <= 0) return 'Price on request';
    if (minPrice <= 0) return formatCurrency(maxPrice);
    if (maxPrice <= 0) return formatCurrency(minPrice);
    if (minPrice == maxPrice) return formatCurrency(minPrice);
    return '${formatCurrency(minPrice)} - ${formatCurrency(maxPrice)}';
  }

  /// Format price per unit (e.g., $120/night, $50/person)
  static String formatPricePerUnit(num price, String unit) {
    if (price <= 0) return 'Price on request';
    return '${formatCurrency(price)}/$unit';
  }

  /// Format price with currency code (e.g., $1,250 USD, €1,250 EUR)
  static String formatCurrencyWithCode(num amount, String currencyCode) {
    if (amount <= 0) return '\$0 $currencyCode';
    return '${formatCurrency(amount)} $currencyCode';
  }

  /// Format price for real estate (e.g., $250,000, $1.2M)
  static String formatRealEstatePrice(num price) {
    if (price <= 0) return 'Price on request';
    
    // For very large numbers, use compact format
    if (price >= 1000000) {
      return '${formatCompact(price)}';
    }
    
    // For regular prices, use currency format
    return formatCurrency(price);
  }

  /// Format price for real estate with currency (e.g., $250,000, 1.2M RWF)
  static String formatRealEstatePriceWithCurrency(num price, String currency) {
    if (price <= 0) return 'Price on request';
    
    // For very large numbers, use compact format
    if (price >= 1000000) {
      final compactPrice = formatCompact(price);
      if (currency == 'USD') {
        return '\$$compactPrice';
      } else {
        return '$compactPrice $currency';
      }
    }
    
    // For regular prices, format with appropriate currency symbol
    if (currency == 'USD') {
      return formatCurrency(price);
    } else {
      // For RWF and other currencies, use number format with currency code
      return '${formatNumber(price)} $currency';
    }
  }

  /// Format price for hotels/accommodations (e.g., $120/night)
  static String formatHotelPrice(num price) {
    if (price <= 0) return 'Price on request';
    return formatPricePerUnit(price, 'night');
  }

  /// Format price for events/tickets (e.g., $25/person)
  static String formatEventPrice(num price) {
    if (price <= 0) return 'Free';
    return formatPricePerUnit(price, 'person');
  }

  /// Format price for restaurants (e.g., $, $$, $$$)
  static String formatRestaurantPrice(num price) {
    if (price <= 0) return '';
    if (price <= 1) return '\$';
    if (price == 2) return '\$\$';
    if (price >= 3) return '\$\$\$';
    return '';
  }

  /// Format percentage (e.g., 15%, 25.5%)
  static String formatPercentage(num percentage) {
    if (percentage <= 0) return '0%';
    return '${percentage.toStringAsFixed(percentage.truncateToDouble() == percentage ? 0 : 1)}%';
  }

  /// Format distance (e.g., 1.2 km, 500 m)
  static String formatDistance(num distanceInMeters) {
    if (distanceInMeters <= 0) return '0 m';
    if (distanceInMeters < 1000) {
      return '${distanceInMeters.toStringAsFixed(0)} m';
    }
    return '${(distanceInMeters / 1000).toStringAsFixed(1)} km';
  }

  /// Format area (e.g., 120 sq ft, 1,500 sq m)
  static String formatArea(num area, {String unit = 'sq ft'}) {
    if (area <= 0) return '0 $unit';
    return '${formatNumber(area)} $unit';
  }

  /// Format phone number (e.g., +1 (555) 123-4567)
  static String formatPhoneNumber(String phoneNumber) {
    // Remove all non-digit characters
    String digits = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');
    
    if (digits.length == 10) {
      return '(${digits.substring(0, 3)}) ${digits.substring(3, 6)}-${digits.substring(6)}';
    } else if (digits.length == 11 && digits.startsWith('1')) {
      return '+1 (${digits.substring(1, 4)}) ${digits.substring(4, 7)}-${digits.substring(7)}';
    } else if (digits.length > 10) {
      return '+${digits.substring(0, digits.length - 10)} (${digits.substring(digits.length - 10, digits.length - 7)}) ${digits.substring(digits.length - 7, digits.length - 4)}-${digits.substring(digits.length - 4)}';
    }
    
    return phoneNumber; // Return original if can't format
  }

  /// Format date range (e.g., Jan 15 - Jan 20, 2024)
  static String formatDateRange(DateTime startDate, DateTime endDate) {
    final DateFormat monthDay = DateFormat('MMM dd');
    final DateFormat monthDayYear = DateFormat('MMM dd, yyyy');
    
    if (startDate.year == endDate.year) {
      if (startDate.month == endDate.month) {
        return '${monthDay.format(startDate)} - ${monthDay.format(endDate)}, ${startDate.year}';
      } else {
        return '${monthDay.format(startDate)} - ${monthDay.format(endDate)}, ${startDate.year}';
      }
    } else {
      return '${monthDayYear.format(startDate)} - ${monthDayYear.format(endDate)}';
    }
  }

  /// Format time (e.g., 2:30 PM, 14:30)
  static String formatTime(DateTime time, {bool use24Hour = false}) {
    if (use24Hour) {
      return DateFormat('HH:mm').format(time);
    } else {
      return DateFormat('h:mm a').format(time);
    }
  }

  /// Format duration (e.g., 2h 30m, 1 day)
  static String formatDuration(Duration duration) {
    if (duration.inDays > 0) {
      return '${duration.inDays} day${duration.inDays > 1 ? 's' : ''}';
    } else if (duration.inHours > 0) {
      int minutes = duration.inMinutes % 60;
      if (minutes > 0) {
        return '${duration.inHours}h ${minutes}m';
      } else {
        return '${duration.inHours}h';
      }
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m';
    } else {
      return '${duration.inSeconds}s';
    }
  }
}
