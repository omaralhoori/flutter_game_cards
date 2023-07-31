import 'dart:async';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/component/common_widget.dart';
import 'package:bookkart_flutter/screens/bookView/services/doc_store.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nb_utils/nb_utils.dart';

/// TODO-NOTE: do not delete comment you can only update it

class DocViewScreen extends StatelessWidget {
  final DocStore doc;
  final Completer<PDFViewController> pdfCont = Completer<PDFViewController>();

  DocViewScreen({required this.doc});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(doc.bookData.id.toString().toString()),
      body: Observer(
        builder: (_) {
          if (doc.isFileDownloading) return DownloadIndicatorWidget(docOperation: doc);

          if (!doc.downloadFile.filename.isPdf) return Offstage();

          return SizedBox(
            height: context.height(),
            child: PDFView(
              filePath: doc.fullFilePath,
              pageSnap: false,
              swipeHorizontal: false,
              nightMode: appStore.isDarkMode,
              defaultPage: appStore.page.validate(),
              onPageChanged: (int? page, int? total) {
                setValue(PAGE_NUMBER + doc.downloadFile.id.validate(), page);
                appStore.setPage(page.validate() + 1);
                doc.totalPage = total;
              },
              onViewCreated: (PDFViewController pdfViewController) {
                pdfCont.complete(pdfViewController);
              },
              onPageError: (page, error) {
                log('Something gone wrong pdf');
              },
            ),
          );
        },
      ),
      floatingActionButton: Observer(
        builder: (_) {
          if (!doc.isFileOpened && !doc.downloadFile.filename.isPdf) return Offstage();

          return GestureDetector(
            behavior: HitTestBehavior.translucent,
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: boxDecorationRoundedWithShadow(50, backgroundColor: context.cardColor),
              child: Text(doc.getPageNumbers, style: boldTextStyle()),
            ),
            onTap: () async {
              await buildPageChangeDialog(context, pdfCont);
            },
          );
        },
      ),
    );
  }
}
