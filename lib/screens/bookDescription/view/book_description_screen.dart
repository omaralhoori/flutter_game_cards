import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/auth/view/sign_in_screen.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/book_description_top_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/book_detail_review_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/books_category_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/description_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/download_file_component.dart';
import 'package:bookkart_flutter/screens/bookDescription/component/get_author_component.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/transaction/view/my_cart_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class BookDescriptionScreen extends StatefulWidget {
  final String bookId;
  final Color? backgroundColor;

  BookDescriptionScreen({required this.bookId, this.backgroundColor, Key? key}) : super(key: key);

  @override
  State<BookDescriptionScreen> createState() => _BookDescriptionScreenState();
}

class _BookDescriptionScreenState extends State<BookDescriptionScreen> {
  late Future<CardModel> future;

  @override
  void initState() {
    super.initState();
    init();

    LiveStream().on(REFRESH_REVIEW_LIST, (p0) async {
      init();
      setState(() {});
    });
  }

  Future<List<DownloadModel>> getPaidFileDetails() async {
    String time = await getTime();
    Map<String, String> request = {'book_id': widget.bookId, 'time': time, 'secret_salt': await getKey(time)};

    return await getPaidBookFileListRestApi(request).then((res) async {
      return res.data.validate();
    }).catchError((e) {
      throw e;
    });
  }

  void init() async {
    future = getBookDetailsRestWithLoading(context, request: {'item_id': widget.bookId});
  }

  AppBar _buildAppBarWidget(CardModel snap, BuildContext context) {
    return appBarWidget(
      snap.name.validate(),
      titleTextStyle: boldTextStyle(),
      actions: [
        Stack(
          alignment: Alignment.topRight,
          children: [
            if ((isAndroid && !getBoolAsync(HAS_IN_REVIEW)))
              IconButton(
                icon: Icon(Icons.shopping_cart_outlined),
                padding: EdgeInsets.only(top: 12),
                onPressed: () async {
                  if (appStore.isLoggedIn) {
                    await MyCartScreen(bookInfo: snap).launch(context);
                    return;
                  }

                  await SignInScreen().launch(context);
                },
              ),
            Container(
              margin: EdgeInsets.only(right: 10, top: 2),
              decoration: boxDecorationWithRoundedCorners(boxShape: BoxShape.circle, backgroundColor: redColor),
              child: Observer(
                builder: (context) {
                  if (cartStore.productId.isNotEmpty) return Text(cartStore.productId.length.toString(), style: primaryTextStyle(size: 12, color: white)).paddingAll(4);
                  return Offstage();
                },
              ),
            )
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NoInternetFound(
        child: SnapHelperWidget<CardModel>(
          future: future,
          loadingWidget: AppLoader(isObserver: false, loadingVisible: true),
          defaultErrorMessage: locale.lblNoDataFound,
          errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
          onSuccess: (snap) {
            return Scaffold(
              appBar: _buildAppBarWidget(snap, context),
              body: Stack(
                children: [
                  AnimatedScrollView(
                    padding: EdgeInsets.only(bottom: 30),
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      BookDescriptionTopComponent(bookId: widget.bookId, bookInfo: snap, backgroundColor: widget.backgroundColor),
                      // DownloadFileComponent(bookID: widget.bookId, snap),
                      DescriptionComponent(bookInfo: snap),
                      16.height,
                      // GetAuthorComponent(bookInfo: snap),
                      // 32.height,
                      BooksCategoryComponent(bookInfo: snap),
                      // 32.height,
                      // BookDetailReviewComponent(bookInfo: snap),
                    ],
                  ),
                  AppLoader(isObserver: true, loadingVisible: true),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
