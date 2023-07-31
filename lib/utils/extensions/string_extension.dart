import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

extension strEtx on String {
  Widget iconImage({double? size, Color? color, BoxFit? fit}) {
    return Image.asset(
      this,
      height: size ?? 24,
      width: size ?? 24,
      fit: fit ?? BoxFit.cover,
      color: color ?? (appStore.isDarkMode ? Colors.white : textSecondaryColor),
      errorBuilder: (context, error, stackTrace) {
        return Image.asset(ic_book_logo, height: size ?? 24, width: size ?? 24);
      },
    );
  }
}
