import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/book_description_repository.dart';
import 'package:bookkart_flutter/screens/offline/view/download_files_screen.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../dashboard/model/dashboard_book_info_model.dart';

class DownloadFileComponent extends StatelessWidget {
  final String bookID;
  final BookDataModel snap;

  DownloadFileComponent(this.snap, {required this.bookID});

  Future<List<DownloadModel>> getPaidFileDetails(String bookID) async {
    String time = await getTime();
    Map<String, String> request = {'book_id': bookID, 'time': time, 'secret_salt': await getKey(time)};

    return await getPaidBookFileListRestApi(request).then((res) async {
      return res.data.validate();
    }).catchError((e) {
      throw e;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      if (!getBoolAsync(HAS_IN_REVIEW) && snap.isFreeBook.validate()) {
        return SnapHelperWidget<List<DownloadModel>>(
          future: getPaidFileDetails(bookID),
          defaultErrorMessage: locale.lblNoDataFound,
          errorWidget: Offstage(),
          loadingWidget: Text('Loading Books...', style: boldTextStyle()).center(),
          onSuccess: (data) {
            if (data.validate().isEmpty)
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Suggested book :', style: boldTextStyle(size: 16)),
                  16.height,
                  ButtonForDownloadFileComponent(
                    isFromAsset: true,
                    bookData: snap,
                    isSampleFile: false,
                    downloads: DownloadModel(id: '1', name: 'Suggested book', file: 'assets/epub/free_epub.epub'),
                  ),
                ],
              );
            else
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(locale.availableFiles, style: boldTextStyle(size: 18)),
                  16.height,
                  AnimatedWrap(
                    spacing: 16,
                    runSpacing: 16,
                    itemCount: data.length,
                    listAnimationType: ListAnimationType.Scale,
                    itemBuilder: (_, index) {
                      return ButtonForDownloadFileComponent(
                        bookData: snap,
                        downloads: data[index],
                        isSampleFile: false,
                        isFromAsset: false,
                      );
                    },
                  ),
                ],
              ).paddingAll(16);
          },
        );
      }

      if (!snap.isFreeBook.validate())
        return Container(
          padding: EdgeInsets.all(16),
          // margin: EdgeInsets.only(top: 16),
          child: SnapHelperWidget<List<DownloadModel>>(
            future: getPaidFileDetails(bookID),
            defaultErrorMessage: locale.lblNoDataFound,
            errorWidget: Offstage(),
            loadingWidget: Offstage(),
            onSuccess: (data) {
              if (data.validate().isNotEmpty)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(locale.availableFiles, style: boldTextStyle(size: 18)),
                    16.height,
                    AnimatedWrap(
                      spacing: 16,
                      runSpacing: 16,
                      itemCount: data.length,
                      listAnimationType: ListAnimationType.Scale,
                      itemBuilder: (_, index) {
                        return ButtonForDownloadFileComponent(
                          bookData: snap,
                          downloads: data[index],
                          isSampleFile: false,
                          isFromAsset: false, // TODO : MAKE FOR LIVE CHANGE LATER
                        );
                      },
                    ),
                  ],
                );
              else
                return Offstage();
            },
          ),
        );

      return Offstage();
    });
  }
}
