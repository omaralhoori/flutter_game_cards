import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/component/common_widget.dart';
import 'package:bookkart_flutter/screens/bookView/services/doc_store.dart';
import 'package:bookkart_flutter/screens/bookView/view/audio_book_player_screen.dart';
import 'package:bookkart_flutter/screens/bookView/view/doc_view_screen.dart';
import 'package:bookkart_flutter/screens/bookView/view/video_book_player_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class ButtonForDownloadFileComponent extends StatefulWidget {
  final DownloadModel downloads;
  final bool isSampleFile;
  final BookDataModel bookData;
  final bool isFromAsset;

  ButtonForDownloadFileComponent({required this.isFromAsset, required this.downloads, required this.bookData, this.isSampleFile = false});

  @override
  ButtonForDownloadFileComponentState createState() => ButtonForDownloadFileComponentState();
}

class ButtonForDownloadFileComponentState extends State<ButtonForDownloadFileComponent> {
  @override
  void dispose() {
    onDispose();
    super.dispose();
  }

  Future<void> onDispose() async {
    String fullFilePath = await getBookFilePath(widget.downloads.id, widget.downloads.file.validate());

    if (await File(fullFilePath).exists() && fullFilePath.isNotEmpty && fullFilePath.contains('.epub')) File(fullFilePath).deleteSync();
  }

  Future<void> onDownloadTap() async {
    if (widget.isFromAsset && widget.downloads.filename.contains(EPUB)) {
      openEpubFile(context, bookID: widget.bookData.id.validate().toString(), filePath: 'assets/epub/free_epub.epub', isFromAssets: true);
      return;
    }

    if (widget.downloads.filename.isVideo) {
      await VideoBookPlayerScreen(downloads: widget.downloads).launch(context);
      return;
    }

    if (widget.downloads.filename.isAudio) {
      await AudioBookPlayerScreen(url: widget.downloads.file.validate(), bookImage: widget.downloads.file.validate(), bookName: widget.downloads.name.validate()).launch(context);
      return;
    }

    if (widget.downloads.filename.isPdf || widget.downloads.filename.contains(EPUB)) {
      final fileType = (widget.downloads.filename.isPdf) ? CustomFileType.PDF : CustomFileType.EPUB;
      final filePath = await getBookFilePath(widget.downloads.id, widget.downloads.file.validate());
      final doc = DocStore(downloadFile: widget.downloads, bookData: widget.bookData, fileType: fileType, fullFilePath: filePath);

      await doc.init(context);
      await DocViewScreen(doc: doc).launch(context).then((value) async {
        await doc.dispose();
      });

      return;
    }

    toast(locale.lblBookTypeNotSupported);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width() / 2 - 26,
      decoration: boxDecorationDefault(boxShadow: defaultBoxShadow(blurRadius: 0, spreadRadius: 0), color: context.cardColor),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onDownloadTap,
        child: Row(
          children: [
            DownloadImageWidget(widget.downloads),
            8.width,
            Marquee(child: Text(softWrap: false, textAlign: TextAlign.start, overflow: TextOverflow.fade, widget.downloads.name.validate().capitalizeFirstLetter(), style: primaryTextStyle(size: 18, color: context.iconColor))).expand(),
            16.width,
            SnapHelperWidget<String>(
              future: getBookFilePath(widget.downloads.id, widget.downloads.file.validate()),
              onSuccess: (s) {
                if (widget.downloads.filename.isPdf && !File(s).existsSync()) return Image.asset(img_downloads, width: 18, color: context.iconColor);
                return Offstage();
              },
            ),
          ],
        ).paddingSymmetric(vertical: 8),
      ),
    );
  }
}
