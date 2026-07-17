import 'package:intl/intl.dart';

/// Currency/number formatting used across balance, transactions, and charts.
extension NumCurrencyX on num {
  String toCurrency({String symbol = '\$'}) {
    final formatter = NumberFormat.currency(symbol: symbol, decimalDigits: 2);
    return formatter.format(this);
  }

  /// Compact form for chart axes / small badges, e.g. 1200 -> "1.2K".
  String toCompact() => NumberFormat.compact().format(this);
}
