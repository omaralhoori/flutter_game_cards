import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/services/doc_store.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';

class DownloadIndicatorWidget extends StatelessWidget {
  final DocStore docOperation;

  DownloadIndicatorWidget({required this.docOperation});

  @override
  Widget build(BuildContext context) {
    if (docOperation.isDownloadFailFile) {
      return Text(locale.lblDownloadFailed, style: boldTextStyle(size: 20)).paddingOnly(top: 16, bottom: 16).center();
    }

    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (docOperation.isBetweenZeroToHundred)
            Observer(
              builder: (context) {
                return Text(docOperation.getPercentage, style: boldTextStyle(size: 20)).paddingOnly(top: 20);
              },
            ),
          Text((docOperation.downloadComplete) ? "Encrypting" : "Opening", style: primaryTextStyle(size: 20)),
        ],
      ),
    );
  }
}

class DownloadImageWidget extends StatelessWidget {
  final DownloadModel downloads;

  bool get isDefaultFile {
    return !(downloads.filename.contains(PDF) ||
        downloads.filename.contains(MP4) ||
        downloads.filename.contains(MOV) ||
        downloads.filename.contains(WEBM) ||
        downloads.filename.contains(MP3) ||
        downloads.filename.contains(FLAC) ||
        downloads.filename.contains(EPUB));
  }

  const DownloadImageWidget(this.downloads);

  @override
  Widget build(BuildContext context) {
    if (downloads.filename.isPdf) return Image.asset(img_pdf, width: 24, color: context.iconColor);
    if (downloads.filename.isVideo) return Image.asset(img_video, width: 24, color: context.iconColor);
    if (downloads.filename.isAudio) return Image.asset(img_music, width: 24, color: context.iconColor);
    if (downloads.filename.contains(EPUB)) return Image.asset(img_epub, width: 24, color: context.iconColor);
    if (isDefaultFile) return Image.asset(img_default, width: 24, color: context.iconColor);

    return Offstage();
  }
}
