import 'package:bookkart_flutter/components/app_loader.dart';
import 'package:bookkart_flutter/components/background_component.dart';
import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/components/no_internet_component.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/author/author_repository.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_widget.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class AuthorWiseBookScreen extends StatefulWidget {
  final AuthorResponse authorDetails;

  AuthorWiseBookScreen({required this.authorDetails, Key? key}) : super(key: key);

  @override
  State<AuthorWiseBookScreen> createState() => _AuthorWiseBookScreenState();
}

class _AuthorWiseBookScreenState extends State<AuthorWiseBookScreen> {
  Future<List<BookDataModel>>? future;

  List<BookDataModel> authorBookList = [];

  int page = 1;

  bool isLastPage = false;

  @override
  void initState() {
    if (mounted) {
      appStore.setLoading(false);
      super.initState();
      init();
    }
  }

  void init() {
    future = getAuthorBookListRestApi(
      page: page,
      id: widget.authorDetails.id.validate(),
      services: authorBookList,
      lastPageCallBack: (p0) => isLastPage = p0,
    );
  }

  void onNextPage() {
    if (!isLastPage) {
      page++;
      init();
      setState(() {});
    }
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Row(
        children: [
          CachedImageWidget(height: 40, width: 40, url: widget.authorDetails.image.validate(), fit: BoxFit.fill).cornerRadiusWithClipRRect(40),
          8.width,
          Text(widget.authorDetails.name.validate(), style: boldTextStyle()),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: NoInternetFound(
        child: SnapHelperWidget<List<BookDataModel>>(
          future: future,
          loadingWidget: AppLoader(),
          defaultErrorMessage: locale.lblNoDataFound,
          errorWidget: BackgroundComponent(text: locale.lblNoDataFound, image: img_no_data_found, showLoadingWhileNotLoading: true),
          onSuccess: (snap) {
            return snap.validate().isEmpty
                ? BackgroundComponent(text: locale.lblNoDataFound, showLoadingWhileNotLoading: true).paddingOnly(top: 16, left: 16)
                : Align(
                    alignment: Alignment.topLeft,
                    child: AnimatedScrollView(
                      padding: EdgeInsets.only(bottom: 32, top: 16),
                      onNextPage: onNextPage,
                      children: [
                        AnimatedWrap(
                          itemCount: snap.validate().length,
                          listAnimationType: ListAnimationType.Scale,
                          itemBuilder: (_, index) {
                            return Container();
                            // return OpenBookDescriptionOnTap(
                            //   bookId: snap.validate()[index].id.validate().toString(),
                            //   currentIndex: index,
                            //   child: BookWidget(
                            //     newBookData: snap.validate()[index],
                            //     showSecondDesign: true,
                            //     index: index,
                            //     width: context.width() / 2 - 8,
                            //   ),
                            // ).paddingSymmetric(vertical: 8);
                          },
                        ),
                      ],
                    ),
                  );
          },
        ),
      ),
    );
  }
}
