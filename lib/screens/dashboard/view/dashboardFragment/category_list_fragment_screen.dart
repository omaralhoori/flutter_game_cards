import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/component/category_list_widget.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/model/category_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/extensions/string_extension.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class CategoriesListFragment extends StatefulWidget {
  final bool? showLargeTitle;

  const CategoriesListFragment({this.showLargeTitle});

  @override
  _CategoriesListFragmentState createState() => _CategoriesListFragmentState();
}

class _CategoriesListFragmentState extends State<CategoriesListFragment> {
  Future<List<CategoriesListResponse>>? future;

  List<CategoriesListResponse> searchList = [];
  List<CategoriesListResponse> categories = [];

  TextEditingController searchBookCont = TextEditingController();

  bool isLastPage = false;
  int page = 1;

  @override
  void initState() {
    if (mounted) {
      super.initState();
      cartStore.init();
      init();
    }
  }

  void init() async {
    future = getCatListRestApi(page, categories: categories, lastPageCallBack: (p0) {
      return isLastPage = p0;
    });

    searchList = categories;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  appBarWidget(
        locale.lblCategories,
        showBack: widget.showLargeTitle ?? true,
        titleWidget: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
            Text(locale.lblCategories, style:primaryTextStyle(size: 20, weight: FontWeight.bold) ,),
            Text( locale.lblBalance+": " + cartStore.customerBalance.toString(), style: primaryTextStyle(size: 20),)
          ],),) ),
      body: NoInternetFound(
        child: Stack(
          children: [
            SnapHelperWidget<List<CategoriesListResponse>>(
              future: future,
              loadingWidget: AppLoader(isObserver: false),
              defaultErrorMessage: locale.lblNoDataFound,
              errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
              onSuccess: (snap) {
                return AnimatedScrollView(
                  padding: EdgeInsets.fromLTRB(16, 16, 16, 60),
                  onNextPage: () {
                    if (!isLastPage) {
                      page++;
                      init();
                      setState(() {});
                    }
                  },
                  children: [
                    AppTextField(
                      controller: searchBookCont,
                      maxLines: 1,
                      cursorColor: context.primaryColor,
                      textStyle: primaryTextStyle(),
                      suffix: ic_search.iconImage(size: 10).paddingAll(14),
                      textFieldType: TextFieldType.OTHER,
                      autoFocus: false,
                      decoration: inputDecoration(context, locale.lblSearchForBooks.validate()),
                      onChanged: (string) async {
                        searchList = categories.where((u) {
                          return (u.name!.toLowerCase().contains(string.toLowerCase()));
                        }).toList();

                        setState(() {});
                      },
                    ),
                    16.height,
                    CategoryListWidget(itemList: searchList, searchText: searchBookCont.text.validate()),
                  ],
                );
              },
            )
          ],
        ),
      ),
    );
  }
}
