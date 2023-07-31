import 'dart:io';

import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookView/model/downloaded_book_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/offline_book_list_model.dart';
import 'package:bookkart_flutter/utils/common_base.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobx/mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

part 'doc_store.g.dart';

enum CustomFileType { PDF, EPUB }

class DocStore = DocStoreBase with _$DocStore;

abstract class DocStoreBase with Store {
  final DownloadModel downloadFile;
  final BookDataModel bookData;

  @observable
  String fullFilePath = '';

  @observable
  bool isOffline = false;

  @observable
  bool isFileDownloading = false;

  @observable
  bool isDownloadFailFile = false;

  @observable
  double percentageCompleted = 0;

  @observable
  int? totalPage = 0;

  final CustomFileType fileType;

  DocStoreBase({required this.downloadFile, required this.bookData, required this.fileType, required this.fullFilePath});

  @computed
  bool get isBetweenZeroToHundred => percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2).toInt() != 0;

  @computed
  bool get downloadComplete => percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2).toInt() == 100;

  @computed
  String get getPercentage => percentageCompleted.toString().substring(0, percentageCompleted.toString().length - 2) + "% ${locale.lblComplete}";

  @computed
  String get getPageNumbers => locale.lblGoTo + "${downloadFile.filename.isPdf ? " ${appStore.page.validate()} / $totalPage" : ''}";

  @computed
  bool get isFileOpened => (downloadFile.filename.isPdf && !isFileDownloading) || (isOffline ?? false);

  @action
  Future<void> init(BuildContext context) async {
    // FILE OFFLINE FOUND AND IS PDF

    if ((fullFilePath.isNotEmpty && File(fullFilePath).existsSync()) && (fileType == CustomFileType.PDF || fullFilePath.contains('.pdf'))) {
      try {
        isOffline = true;
        await nativeDecrypt(filePath: fullFilePath);

        // SETTING PAGE NUMBER FOR PREVIOUSLY DOWNLOADED FILE
        int currentPage = getIntAsync(PAGE_NUMBER + downloadFile.id.validate());
        (currentPage.toString().isNotEmpty) ? appStore.setPage(currentPage) : appStore.setPage(0);

        return;
      } catch (e) {
        await File(fullFilePath).delete();
        log("- ERROR WHILE DECRYPTING FILE -");
        log("DOWNLOADING NEW FILE");
      }
    }

    // ASKING FOR PERMISSION AND IF NOT THEN OPENING SETTING AND THE WE ARE STARTING AGAIN
    if (!await checkPermission()) await openAppSettings();

    await downloadFileFromID(context, bookID: bookData.id.toString());
  }

  @action
  Future<void> dispose() async {
    isOffline = false;
    isFileDownloading = false;
    isDownloadFailFile = false;
    percentageCompleted = 0;
    totalPage = 0;
    appStore.setLoading(false);

    if (fullFilePath.contains('.epub')) return; // Not Saving Path For Epub

    try {
      appStore.setEncryption(true);
      await nativeEncrypt(filePath: fullFilePath).then((value) {
        appStore.setEncryption(false);
        insertFileIntoDatabase(fullFilePath);
      });
    } on PlatformException catch (e, s) {
      appStore.setEncryption(false);
      debugPrint('ERROR - $e - STACK-TRACE - $s');
    }
  }

  @action
  Future<void> downloadFileFromID(BuildContext context, {required String bookID}) async {
    isOffline = false;
    isFileDownloading = true;
    appStore.setLoading(true);

    await downloadFileFromProvidedLink(
      link: downloadFile.file.validate(),
      locationOfStorage: downloadFile,
      progress: (percentage) async {
        percentageCompleted = percentage;
      },
      onError: () {
        isDownloadFailFile = true;
        isFileDownloading = false;
        appStore.setLoading(false);
      },
      onSuccess: () async {
        isFileDownloading = false;
        appStore.setLoading(false);
        fullFilePath = await getBookFilePath(downloadFile.id, downloadFile.file.validate());

        // TODO: OPENING EPUB FILE HERE
        if (fullFilePath.contains('.epub')) {
          finish(context);
          openEpubFile(context, filePath: fullFilePath, bookID: bookID);
        }
      },
    );
  }

  @action
  Future<void> insertFileIntoDatabase(String filePath) async {
    if (!(filePath.contains('.pdf'))) return; // WE ARE ONLY STORING PDF FILE

    List<OfflineBookList>? data = await dbHelper.queryAllRows(appStore.userId);

    if (data == null) return; // DON'T HAVE DATA TO MAKE QUERIES

    DownloadedBook book = DownloadedBook(
      userId: appStore.userId.toString(),
      bookId: bookData.id.toString(),
      bookName: bookData.name.validate(),
      frontCover: bookData.getImage,
      fileType: downloadFile.filename.isPdf ? "PDF FILE" : "EPUB FILE",
      filePath: filePath,
      fileName: '',
    );

    data.toSet().toList();

    if (data.validate().isEmpty) {
      dbHelper.insert(book);
      return;
    }

    // NOTHING WE ARE JUST MAKING SURE WE DON'T ADD SAME FILE-PATH AGAIN IN DATABASE
    for (OfflineBookList offlineBook in data) {
      for (OfflineBook element in offlineBook.offlineBook) {
        if (element.filePath != filePath) dbHelper.insert(book);
      }
    }
  }
}
