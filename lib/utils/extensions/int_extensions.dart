import 'package:bookkart_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

extension StringExt on String {
  String getFormattedPrice() {
    return '${getStringAsync(CURRENCY_SYMBOL)}$this';
  }
}
