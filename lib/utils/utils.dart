import 'dart:convert';
import 'dart:io';

import 'package:aes_crypt_null_safe/aes_crypt_null_safe.dart';
import 'package:bookkart_flutter/main.dart';
import 'package:bookkart_flutter/utils/constants.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

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
