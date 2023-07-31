import 'package:bookkart_flutter/components/disabled_rating_bar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/extensions/int_extensions.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookDataComponent extends StatelessWidget {
  final BookDataModel bookData;

  final bool? isShowRating;
  final bool? isShowPrice;

  BookDataComponent({Key? key, required this.bookData, this.isShowRating, this.isShowPrice}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // if (isShowRating ?? false) DisabledRatingBarWidget(rating: bookData.averageRating.toDouble().ceil(), size: 15),
        if (bookData.isFreeBook && (isShowPrice ?? true)) Text(locale.lblFree, style: boldTextStyle(color: Colors.green)),
        if (bookData.isPaid && (isShowPrice ?? true))
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (bookData.salePrice.validate().toString().validate().toDouble() != 0.0) Text(bookData.salePrice.validate().toString().getFormattedPrice(), style: boldTextStyle(color: context.primaryColor)),
              if (!getBoolAsync(HAS_IN_REVIEW) && (bookData.regularPrice.validate().toDouble() != 0.0))
                Text('${(bookData.regularPrice != 0.0) ? bookData.regularPrice.toString().getFormattedPrice() : 'Free'}', style: boldTextStyle(size: 16, color: (bookData.regularPrice != 0.0) ? context.primaryColor : Colors.green))
              else
                Text('Free', style: boldTextStyle(color: Colors.green)),
            ],
          ),
        8.height,
      ],
    );
  }
}
