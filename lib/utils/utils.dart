import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:bookkart_flutter/configs.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/network/network_utils.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:open_filex/open_filex.dart';
// import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';

Future<String> getTime() async {
  DateTime currentTime = DateTime.now().toUtc();
  final f = DateFormat('yyyy-MM-dd hh:mm');
  log(f.format(currentTime).toString());
  return f.format(currentTime).toString();
}

Future<String> getKey(time) async {
  String finalString = time + SALT;
  log("Final String: " + finalString);
  String md5String = md5.convert(utf8.encode(finalString)).toString();
  log("MD5 String: " + md5String);
  return md5String;
}

String reviewConvertDate(date) {
  try {
    return date != null ? DateTime.parse(date).timeAgo : '';
  } catch (e) {
    log(e.toString());
    return '';
  }
}

String getBaseUrl(final bool isTestMode) {
  return isTestMode ? DEBUG_BASE_URL : PROD_BASE_URL;
}

Future<String> encryptFile(String filePath) async {
  String encFilepath = '';
  AesCrypt crypt = AesCrypt();
  crypt.aesSetMode(AesMode.cbc);
  crypt.setPassword(ENCRYPTION_PASSWORD);
  crypt.setOverwriteMode(AesCryptOwMode.on);

  try {
    encFilepath = crypt.encryptFileSync(filePath);
    appStore.setEncryption(false);
  } on AesCryptException catch (e) {
    appStore.setEncryption(false);

    if (e.type == AesCryptExceptionType.destFileExists) print(e.message);
  }
  return encFilepath;
}

Future<String> decryptFile(String filePath) async {
  appStore.setDecryption(true);

  String encryptedFileName = filePath;
  log('decrypting');

  if (filePath.contains(PDF)) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(PDF, "");
  } else if (filePath.contains(MP4)) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(MP4, "");
  } else if (filePath.contains(MP3)) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(MP3, "");
  } else if (filePath.contains(MOV)) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(MOV, "");
  } else if (filePath.contains(WEBM)) {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(WEBM, "");
  } else {
    encryptedFileName = filePath.split("/").last.toString().replaceAll(EPUB, "");
  }

  Directory? dir;

  if (isAndroid) {
    dir = await getExternalStorageDirectory();
  } else {
    dir = await getApplicationDocumentsDirectory();
  }

  if (filePath.contains(PDF)) {
    filePath = '${dir!.path}/$encryptedFileName.pdf.aes';
  } else if (filePath.contains(MP4)) {
    filePath = '${dir!.path}/$encryptedFileName.mp4.aes';
  } else if (filePath.contains(MP3)) {
    filePath = '${dir!.path}/$encryptedFileName.mp3.aes';
  } else if (filePath.contains(MOV)) {
    filePath = '${dir!.path}/$encryptedFileName.mov.aes';
  } else if (filePath.contains(WEBM)) {
    filePath = '${dir!.path}/$encryptedFileName.webm.aes';
  } else {
    filePath = '${dir!.path}/$encryptedFileName.epub.aes';
  }

  String decryptFilePath = '';

  AesCrypt crypt = AesCrypt();
  crypt.aesSetMode(AesMode.cbc);
  crypt.setOverwriteMode(AesCryptOwMode.on);
  crypt.setPassword(ENCRYPTION_PASSWORD);

  try {
    decryptFilePath = crypt.decryptFileSync(filePath);
    appStore.setDecryption(false);
  } catch (e) {
    log('error while opening file ' + e.toString());
    appStore.setDecryption(false);
    throw e.toString();
  }

  return decryptFilePath;
}

Future<bool> checkPermission() async {
  if (isAndroid || isIOS) {
    if (await isAndroid12Above()) {
      return true;
    } else {
      Map<Permission, PermissionStatus> statuses = await [
        Permission.storage,
      ].request();

      bool isGranted = false;
      statuses.forEach((key, value) {
        isGranted = value.isGranted;
      });

      return isGranted;
    }
  } else {
    return false;
  }
}

Future<String> get localPath async {
  Directory? directory;

  try {
    if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    } else if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      toast("Not Supported Platform");

      throw 'Not Supported Platform';
    }
  } on PlatformException catch (e) {
    toast('${e.message}');
  }

  return directory!.path;
}

Future<String> getBookFileName(String? bookId, String url, {isSample = false}) async {
  List<String> name = url.split("/");

  String fileNameNew = url;

  if (name.length > 0) fileNameNew = name[name.length - 1];

  fileNameNew = fileNameNew.replaceAll("%", "");
  String fileName = isSample ? bookId! + "_sample_" + fileNameNew : bookId! + "_purchased_" + fileNameNew;
  log("File Name: " + fileName);

  return fileName;
}

Future<String> getBookFilePath(String? bookId, String url, {isSampleFile = false}) async {
  String path = await localPath;
  String filePath = path + "/" + await getBookFileName(bookId, url, isSample: isSampleFile);
  filePath = filePath.replaceAll("null/", "");
  log("--- FULL FILE PATH: " + filePath);

  return filePath;
}


String formatImageUrl(String src){
  if (src.startsWith('http')) return src;
  if (src == '') return src;
  return DOMAIN_URL + src;
}


Future<File?> downloadFile(String name) async {
  if (! await checkPermission() ){
    return null;
  }
  //if(Platform.isIOS) return null;
  final appStorage = await getApplicationDocumentsDirectory();
  // await getApplicationDocumentsDirectory(); //await getExternalStorageDirectory();
  //if (appStorage == null) return;
  final path = appStorage.path;
  final file = File('${path}/$name.pdf');
  try {
    final response = await  buildHttpResponse("frappe.utils.print_format.download_pdf?doctype=Sales%20Invoice&name=$name&key=None&format=Sales%20Invoice", responseType: HttpResponseType.BODY_BYTES);
    if (response.statusCode == 200) {
      final raf = file.openSync(mode: FileMode.write);
      raf.writeFromSync(response.bodyBytes.cast<int>());
      await raf.close();
    }

    return file;
  } catch (e) {
    print(e);
    return null;
  }
}

Future openFile({required String name}) async {
  final file = await downloadFile(name);
  if (file == null) return;
  print(file.path);
  //await OpenFile.open(file.path);
  await OpenFilex.open(file.path);
}

Future shareInvoiceByteList({required String name}) async {
  final file = await downloadFile(name);
  if (file == null) return null;
  var document = await PdfDocument.openData(file.readAsBytes());
  if (document.pagesCount == 0){
    return null;
  }

  List<XFile> files = [];

  for(int _pageCount=1; _pageCount<= document.pagesCount; _pageCount++){
    var page = await document.getPage(_pageCount);
    if( document.pagesCount > 1){
      document = await PdfDocument.openData(file.readAsBytes());
    }
    double aspectRatio = page.width / page.height;
    double height = 1000;
    double width = height * aspectRatio;
    var pageImage = await page.render(width: width, height: height,format: PdfPageImageFormat.png);
    files.add(XFile.fromData(pageImage!.bytes, mimeType: 'image/png'));
  }  
    await Share.shareXFiles(files, text: '');
}