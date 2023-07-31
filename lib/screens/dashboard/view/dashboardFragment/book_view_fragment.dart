import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/components/sliver_appbar_widget.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/dashboard/component/category_wise_book_component.dart';
import 'package:bookkart_flutter/screens/dashboard/dashboard_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/header_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookStoreViewFragment extends StatefulWidget {
  const BookStoreViewFragment({Key? key}) : super(key: key);

  @override
  State<BookStoreViewFragment> createState() => _BookStoreViewFragmentState();
}

class _BookStoreViewFragmentState extends State<BookStoreViewFragment> {
  Future<DashboardResponse>? future;
  List<HeaderModel> header = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() {
    future = getDashboardDataRestApi(onHeaderCreated: (val) => header = val);
    dashboardFromCache(onHeaderCreated: (val) => setState(() => header = val));
    cartStore.init();
  }

  String get getName {
    if (appStore.isLoggedIn) {
      return appStore.userFullName.validate(value: appStore.userEmail.splitBefore('@'));
    } else {
      return locale.lblGuest;
    }
  }

  @override
  Widget build(BuildContext context) {
    return NoInternetFound(
      child: Scaffold(
        body: NestedScrollView(
          physics: NeverScrollableScrollPhysics(),
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return [
              SliverAppBar(
                elevation: 10.0,
                automaticallyImplyLeading: false,
                expandedHeight: 50,
                floating: true,
                title: CustomAppBar(
                  title1: '',
                  title2: "${locale.lblHello}, ${getName.validate()}",
                  isHome: false,
                ),
              )
            ];
          },
          body: Stack(
            children: [
              NoInternetFound(
                child: SnapHelperWidget<DashboardResponse>(
                  initialData: apiStore.getDashboardFromCache(),
                  future: future,
                  loadingWidget: AppLoader(),
                  defaultErrorMessage: locale.lblNoDataFound,
                  errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
                  onSuccess: (snap) {
                    return ListView(
                      shrinkWrap: true,
                      padding: EdgeInsets.only(bottom: 80),
                      children: [
                        16.height,
                        ExploreWidget(list: snap.newest.validate(), header: header),
                        CategoryWiseBookComponent(categoryList: snap.category.validate()),
                        BookListTypeWidget(
                          title: locale.headerNewestBookTitle,
                          list: snap.newest.validate(),
                          requestType: REQUEST_TYPE_NEWEST,
                        ),
                        BookListTypeWidget(
                          title: locale.headerFeaturedBookTitle,
                          list: snap.featured.validate(),
                          requestType: REQUEST_TYPE_PRODUCT_VISIBILITY,
                        ),
                        BookListTypeWidget(
                          title: locale.booksForYou,
                          list: snap.suggestedForYou.validate(),
                          requestType: REQUEST_TYPE_SUGGESTED_FOR_YOU,
                        ),
                        BookListTypeWidget(
                          title: locale.youMayLike,
                          list: snap.youMayLike.validate(),
                          requestType: REQUEST_TYPE_YOU_MAY_LIKE,
                        ),
                      ],
                    );
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
