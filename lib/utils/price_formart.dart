import 'package:intl/intl.dart';

String formattedPrice (String price) {
  
  
  return price.isEmpty
    ? '0'
    : NumberFormat.currency(symbol: '', decimalDigits: 2)
        .format(double.parse(price));}
