import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/model/category_model.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/list_view_all_books_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/subcategory_model.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AllSubCategoryComponent extends StatefulWidget {
  final String categoryId;

  AllSubCategoryComponent({required this.categoryId});

  @override
  AllSubCategoryComponentState createState() => AllSubCategoryComponentState();
}

class AllSubCategoryComponentState extends State<AllSubCategoryComponent> {
  Future<List<SubcategoryModel>>? future;
  List<CategoryModel> subCategoryList = [];

  @override
  void initState() {
    if (mounted) {
      super.initState();
      init();
    }
  }

  void init() async {
    Map<String, dynamic> request = {"category": widget.categoryId};
    future = getSubCategories(request: request);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SnapHelperWidget<List<SubcategoryModel>>(
      future: future,
      loadingWidget: Offstage(),
      defaultErrorMessage: locale.lblNoDataFound,
      errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
      onSuccess: (snap) {
        if (snap.validate().isEmpty) {
          return Offstage();
        }

        return Column(
          children: [
            HorizontalList(
              itemCount: snap.validate().length,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
                    padding: EdgeInsets.fromLTRB(8, 8, 8, 8),
                    child: Text(
                      snap.validate()[index].id.validate().replaceAll('&amp;', '&'),
                      style: boldTextStyle(color: textPrimaryColorGlobal),
                    ),
                  ),
                  onTap: () {
                    ViewAllBooksScreen(
                      isCategoryBook: true,
                      showSecondDesign: true,
                      categoryId: widget.categoryId,
                      subcategoryId: snap.validate()[index].id.toString(),
                      categoryName: snap.validate()[index].id.validate().replaceAll('&amp;', '&'),
                    ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                );
              },
            ),
          ],
        );
      },
    );
  }
}
