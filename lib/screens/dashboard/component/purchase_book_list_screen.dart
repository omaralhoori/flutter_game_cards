import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/model/book_purchase_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import 'purchase_book_item_component.dart';

class PurchaseBookListScreen extends StatelessWidget {
  final List<LineItems> lineItemList;
  final void Function()? onNextPage;

  PurchaseBookListScreen({required this.lineItemList, required this.onNextPage});

  @override
  Widget build(BuildContext context) {
    if (lineItemList.validate().isEmpty)
      return BackgroundComponent(text: locale.lblYouHaveAnyPurchasedBook, subTitle: locale.lblPurchasedNow, showLoadingWhileNotLoading: true).center();
    else
      return AnimatedScrollView(
        children: [
          Wrap(
            children: List.generate(lineItemList.length, (index) {
              return OpenBookDescriptionOnTap(
                bookId: lineItemList[index].productId.toString(),
                currentIndex: index,
                child: PurchaseBookItemComponent(
                  bookData: lineItemList.validate()[index],
                  bgColor: getBackGroundColor(index: index),
                ).paddingOnly(top: 16, bottom: 16, left: 16),
              );
            }),
          ),
        ],
      );
  }
}
