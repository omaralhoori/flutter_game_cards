import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';

class BookWidget extends StatelessWidget {
  final CardModel newBookData;
  final int index;
  final double? width;
  final bool? isShowRating;
  final bool showSecondDesign;

  BookWidget({
    required this.newBookData,
    required this.index,
    this.width,
    this.isShowRating,
    this.showSecondDesign = false,
  });

  @override
  Widget build(BuildContext context) {
    if (showSecondDesign) {
      return BookDesign(newBookData, index: index, isShowRating: isShowRating, width: width);
    }

    return BookDesignSecond(newBookData, index: index, isShowRating: isShowRating, width: width);
  }
}
