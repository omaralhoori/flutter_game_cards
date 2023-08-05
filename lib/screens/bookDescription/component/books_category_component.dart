import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BooksCategoryComponent extends StatelessWidget {
  final CardModel bookInfo;

  BooksCategoryComponent({required this.bookInfo});

  @override
  Widget build(BuildContext context) {
    List<String> categories = [bookInfo.category];
    if (bookInfo.subcategory != null){
      categories.add(bookInfo.subcategory.validate());
    }
    //if (bookInfo.categories.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.lblCategories, style: boldTextStyle(size: 18)).paddingLeft(16),
        HorizontalList(
          runSpacing: 8,
          spacing: 16,
          padding: EdgeInsets.only(left: 16, top: 16, right: 16),
          physics: BouncingScrollPhysics(),
          itemCount: categories.validate().length,
          itemBuilder: (context, index) {

            return GestureDetector(
              onTap: () async {
                await ViewAllBooksScreen(categoryId: categories.validate()[index], categoryName: categories.validate()[index], isCategoryBook: true).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
              },
              behavior: HitTestBehavior.translucent,
              child: Container(
                padding: EdgeInsets.only(top: 8, bottom: 8, right: 16, left: 16),
                decoration: boxDecorationWithRoundedCorners(backgroundColor: context.cardColor),
                child: Text(categories.validate()[index].validate().replaceAll('&amp;', '&').replaceAll(';', ''), style: boldTextStyle(size: 14)),
              ),
            );
          },
        ),
      ],
    );
  }
}
