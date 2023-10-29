import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bookkart_flutter/components/cached_image_widget.dart';
import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/screens/bookDescription/view/book_description_screen.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_data_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_list_dashboard_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/book_store_slider_component.dart';
import 'package:bookkart_flutter/screens/dashboard/component/view_all_component.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/dashboard_book_info_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/header_model.dart';
import 'package:bookkart_flutter/utils/colors.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:bookkart_flutter/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs.dart' as custom_tabs;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:html/parser.dart';
import 'package:internet_file/internet_file.dart';
import 'package:internet_file/storage_io.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:vocsy_epub_viewer/epub_viewer.dart';

Future<bool> nativeEncrypt({required String filePath}) async {
  if ((!await File(filePath).exists())) {
    toast("File not found");
    return false;
  }

  if (filePath.contains('.pdf')) {
    try {
      return await platform.invokeMethod(ENCRYPT, {"File": filePath});
    } on PlatformException catch (e) {
      /// ERROR WHILE CALLING NATIVE METHOD

      log("\nError while Encrypting: $e\n\n");
      throw e;
    }
  } else {
    return false;
  }
}

Future<bool> nativeDecrypt({required String filePath}) async {
  // File Not Found
  if (!File(filePath).existsSync() || !filePath.contains('.pdf')) return false;

  try {
    appStore.setDecryption(true);
    return await platform.invokeMethod(DECRYPT, {"File": filePath}).then((value) {
      appStore.setDecryption(false);
      return value;
    }).catchError((e) {
      appStore.setDecryption(false);
      throw e;
    });
  } catch (e) {
    appStore.setDecryption(false);
    throw e;
  }
}

Future<void> commonLaunchUrl(String address, {LaunchMode launchMode = LaunchMode.inAppWebView}) async {
  await launchUrl(Uri.parse(address), mode: launchMode).catchError((e) {
    toast('${locale.invalidURL}: $address');
    throw e;
  });
}

String parseHtmlString(String? htmlString) {
  return parse(parse(htmlString).body!.text).documentElement!.text;
}

List<LanguageDataModel> languageList() {
  return [
    LanguageDataModel(id: 1, name: 'English', languageCode: 'en', fullLanguageCode: 'en-US', flag: 'assets/flag/ic_us.png'),
    // LanguageDataModel(id: 2, name: 'Hindi', languageCode: 'hi', fullLanguageCode: 'hi-IN', flag: 'assets/flag/ic_india.png'),
    LanguageDataModel(id: 3, name: 'Arabic', languageCode: 'ar', fullLanguageCode: 'ar-AR', flag: 'assets/flag/ic_ar.png'),
    // LanguageDataModel(id: 4, name: 'French', languageCode: 'fr', fullLanguageCode: 'fr-FR', flag: 'assets/flag/ic_fr.png'),
    // LanguageDataModel(id: 5, name: 'German', languageCode: 'de', fullLanguageCode: 'de-DE', flag: 'assets/flag/ic_de.png'),
  ];
}

InputDecoration inputDecoration(BuildContext context, String? title, {Color? borderColor, Widget? prefixIcon, double? radiusValue}) {
  return InputDecoration(
    labelStyle: secondaryTextStyle(),
    labelText: title.validate(),
    filled: true,
    fillColor: context.cardColor,
    prefixIcon: prefixIcon,
    prefixIconColor: context.iconColor,
    suffixIconColor: context.iconColor,
    counter: Offstage(),
    counterText: '',
    alignLabelWithHint: true,
    contentPadding: EdgeInsets.all(16),
    border: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? context.primaryColor), borderRadius: radius(radiusValue ?? defaultRadius)),
    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: borderColor ?? context.primaryColor), borderRadius: radius(radiusValue ?? defaultRadius)),
    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(radiusValue ?? defaultRadius)),
    errorBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.red), borderRadius: radius(radiusValue ?? defaultRadius)),
    disabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent), borderRadius: radius(radiusValue ?? defaultRadius)),
    focusedErrorBorder: OutlineInputBorder(borderSide: BorderSide(), borderRadius: radius(radiusValue ?? defaultRadius)),
  );
}

Future<void> downloadFileFromProvidedLink({
  required String link,
  required void Function(double percentage) progress,
  required DownloadModel locationOfStorage,
  required void Function() onSuccess,
  required void Function() onError,
}) async {
  log('$link');
  final storageIO = InternetFileStorageIO();

  ///step 1. downloading pdf or epub file

  await InternetFile.get(
    link,
    force: true,
    storage: storageIO,
    progress: (receivedLength, contentLength) {
      progress.call((receivedLength / contentLength * 100).round().toDouble());
      log('percentage of completing  download ' + (receivedLength / contentLength * 100).round().toDouble().toInt().toString());
    },
    storageAdditional: storageIO.additional(
      filename: await getBookFileName(locationOfStorage.id, locationOfStorage.file.validate()),
      location: await localPath,
    ),
  ).then((value) {
    onSuccess.call();
  }).catchError((e) {
    log(locale.lblDownloadFailed + '$e');
    onError.call();
  });
}

Color getBackGroundColor({required int index}) {
  return bookBackgroundColor[index % bookBackgroundColor.length];
}

void launchUrlCustomTab(String? url) {
  if (url.validate().isNotEmpty) {
    custom_tabs.launch(
      url!,
      customTabsOption: custom_tabs.CustomTabsOption(
        enableDefaultShare: true,
        enableInstantApps: true,
        enableUrlBarHiding: true,
        showPageTitle: true,
        toolbarColor: primaryColor,
      ),
      safariVCOption: custom_tabs.SafariViewControllerOption(
        preferredBarTintColor: primaryColor,
        preferredControlTintColor: Colors.white,
        barCollapsingEnabled: true,
        entersReaderIfAvailable: true,
        dismissButtonStyle: custom_tabs.SafariViewControllerDismissButtonStyle.close,
      ),
    );
  }
}

Color getRatingBarColor(int rating) {
  if (rating == 1) {
    return Color(0xFFE80000);
  } else if (rating == 3 || rating == 2) {
    return Colors.orange;
  } else if (rating == 5 || rating == 4) {
    return Color(0xFF73CB92);
  } else {
    return Color(0xFFE80000);
  }
}

class OpenBookDescriptionOnTap extends StatelessWidget {
  final String bookId;
  final int currentIndex;
  final Widget child;
  final void Function()? onInit;
  final Color? backgroundColor;

  OpenBookDescriptionOnTap({
    required this.child,
    required this.bookId,
    this.currentIndex = 0,
    this.backgroundColor,
    this.onInit,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        if (onInit != null) {
          BookDescriptionScreen(
            bookId: bookId,
            backgroundColor: backgroundColor ?? getBackGroundColor(index: currentIndex),
          ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide).then((value) {
            this.onInit!.call();
          });
        } else {
          BookDescriptionScreen(
            bookId: bookId,
            backgroundColor: backgroundColor ?? getBackGroundColor(index: currentIndex),
          ).launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
        }
      },
    );
  }
}

void openEpubFile(
  BuildContext context, {
  required String bookID,
  required String filePath,
  bool isFromAssets = false,
}) {
  if (filePath.isEmpty || !filePath.contains('.epub')) {
    toast('No File Found');
    return;
  }

  afterBuildCreated(
    () async {
      /// SETTING CONFIGURATION

      VocsyEpub.setConfig(
        enableTts: true,
        allowSharing: true,
        identifier: "iosBook",
        scrollDirection: EpubScrollDirection.ALLDIRECTIONS,
        themeColor: Theme.of(context).primaryColor,
      );

      /// RETRIEVING PAGE LOCATION
      EpubLocator? lastLocation;
      if (getStringAsync("LastPage_$bookID").validate().isNotEmpty) {
        lastLocation = EpubLocator.fromJson(jsonDecode(getStringAsync("LastPage_$bookID").validate()));
      }

      /// LISTING STREAM FOR CHANGING PAGE
      VocsyEpub.locatorStream.listen((locator) {
        log('${jsonDecode(locator)}');
        setValue("LastPage_$bookID", jsonDecode(locator));
      });

      if (isFromAssets) {
        await VocsyEpub.openAsset(filePath, lastLocation: lastLocation);
        return;
      }

      VocsyEpub.open(filePath, lastLocation: lastLocation);
    },
  );
}

class BookListTypeWidget extends StatelessWidget {
  final String title;
  final List<CardModel> list;
  final String requestType;

  BookListTypeWidget({required this.title, required this.list, required this.requestType});

  @override
  Widget build(BuildContext context) {
    if (list.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SeeAllButtonComponent(title, yourBooks: list, requestType: requestType),
        BookListDashboardComponent(bookList: list),
      ],
    );
  }
}

class ExploreWidget extends StatelessWidget {
  final List<BookDataModel> list;
  final List<HeaderModel> header;

  ExploreWidget({required this.list, required this.header});

  @override
  Widget build(BuildContext context) {
    if (list.validate().isEmpty) return Offstage();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(locale.exploreBooks, style: boldTextStyle(size: 20)).paddingLeft(16),
        16.height,
        BookStoreSliderComponent(header: header),
      ],
    );
  }
}

class BookDesign extends StatelessWidget {
  final CardModel data;
  final double? width;
  final int index;
  final bool? isShowRating;

  BookDesign(this.data, {this.width, required this.index, this.isShowRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: width ?? 110,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          decoration: boxDecorationWithRoundedCorners(
            borderRadius: radius(10),
            backgroundColor: context.scaffoldBackgroundColor,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    margin: EdgeInsets.only(left: 14, bottom: 8, top: 4),
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: context.scaffoldBackgroundColor,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: getBackGroundColor(index: index), width: 2),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    left: 8,
                    top: 10,
                    bottom: 4,
                    child: Container(
                      height: 120,
                      width: 120,
                      decoration: boxDecorationWithRoundedCorners(
                        backgroundColor: context.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: getBackGroundColor(index: index), width: 2),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 16,
                    bottom: 0,
                    left: 0,
                    child: Container(
                      decoration: boxDecorationWithRoundedCorners(borderRadius: radius(8)),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: CachedImageWidget(
                        height: 120,
                        width: 120,
                        url: formatImageUrl(data.image.validate()),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
              8.height,
              Text(
                data.name.validate(),
                overflow: TextOverflow.ellipsis,
                softWrap: true,
                textAlign: TextAlign.start,
                style: primaryTextStyle(size: 14),
              ),
            ],
          ),
        ),
        if (isShowRating ?? false) BookDataComponent(bookData: data, isShowRating: true)
      ],
    );
  }
}

class BookDesignSecond extends StatelessWidget {
  final CardModel data;
  final double? width;
  final int index;
  final bool? isShowRating;

  BookDesignSecond(this.data, {this.width, required this.index, this.isShowRating});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          color: context.scaffoldBackgroundColor,
          width: width ?? 110,
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  Container(
                    height: 70,
                    width: 140,
                    decoration: boxDecorationWithRoundedCorners(
                      backgroundColor: getBackGroundColor(index: index),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(120),
                        topRight: Radius.circular(120),
                      ),
                    ),
                  ),
                  Container(
                    height: 120,
                    width: 120,
                    decoration: boxDecorationWithRoundedCorners(borderRadius: radius(10)),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    margin: EdgeInsets.only(bottom: 16),
                    child: CachedImageWidget(width: 100, height: 150, url: formatImageUrl( data.image.validate()), fit: BoxFit.fill),
                  ),
                ],
              ),
              8.height,
              Text(
                data.name.toString(),
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.start,
                style: primaryTextStyle(size: 14),
              ),
            ],
          ),
        ),
        if (isShowRating ?? false) BookDataComponent(bookData: data, isShowRating: true),
      ],
    );
  }
}


Future<dynamic> buildPageChangeDialog(BuildContext context, Completer<PDFViewController> pdfController) {
  final TextEditingController textEditingCont = TextEditingController();

  return showInDialog(
    context,
    title: Text(locale.jumpTo),
    builder: (p0) {
      return AppTextField(
        keyboardType: TextInputType.number,
        textFieldType: TextFieldType.MULTILINE,
        decoration: inputDecoration(context, locale.lblEnterPageNumber, radiusValue: 10),
        controller: textEditingCont,
        maxLines: 1,
        minLines: 1,
      );
    },
    actions: [
      AppButton(
        elevation: 0,
        text: locale.lblCancel,
        textStyle: primaryTextStyle(color: context.primaryColor),
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
        onTap: () async {
          finish(context, appStore.page.validate() - 1);
        },
      ),
      AppButton(
        text: locale.lblOk,
        elevation: 0,
        color: context.primaryColor,
        textStyle: primaryTextStyle(color: white),
        shapeBorder: RoundedRectangleBorder(borderRadius: radius(), side: BorderSide(color: context.primaryColor)),
        onTap: () async {
          appStore.setPage(textEditingCont.text.toInt());
          await (await pdfController.future).setPage(textEditingCont.text.toInt());
          finish(context);
        },
      ),
    ],
  );
}
