import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/category_list_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoryListWidget extends StatelessWidget {
  final List<CategoriesListResponse> itemList;
  final String searchText;

  CategoryListWidget({required this.itemList, required this.searchText});

  @override
  Widget build(BuildContext context) {
    if (itemList.isEmpty && searchText.isNotEmpty) {
      return BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true);
    } else {
      return AnimatedWrap(
        itemCount: itemList.validate().length,
        itemBuilder: (_, index) {
          CategoriesListResponse data = itemList.validate()[index];

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              width: context.width() / 2 - 20,
              padding: EdgeInsets.all(8),
              child: Column(
                children: [
                  Container(
                    //decoration: BoxDecoration(color: context.cardColor, shape: BoxShape.rectangle),
                    child: data.image == null
                        ? CachedImageWidget(
                            url: ic_book_logo,
                            color: primaryColor.withOpacity(0.2),
                            width: 120,
                            height: 120,
                            fit: BoxFit.cover,
                            // circle: true,
                          )
                        : Container(
                            // margin: EdgeInsets.all(8),
                            child: CachedImageWidget(
                              url: formatImageUrl(data.image!.src.validate()),
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              // circle: true,
                            ).paddingAll(16),
                          ),
                  ),
                  8.height,
                  Marquee(
                    child: Text(
                      data.name.validate().replaceAll('&amp;', ''),
                      textAlign: TextAlign.center,
                      style: primaryTextStyle(size: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            onTap: () {
              hideKeyboard(context);
              ViewAllBooksScreen(
                categoryId: data.id.toString(),
                categoryName: data.name.validate(),
                isCategoryBook: true,
                showSecondDesign: true,
              ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
          );
        },
      );
    }
  }
}
