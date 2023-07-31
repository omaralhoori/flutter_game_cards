// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'doc_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$DocStore on DocStoreBase, Store {
  Computed<bool>? _$isBetweenZeroToHundredComputed;

  @override
  bool get isBetweenZeroToHundred => (_$isBetweenZeroToHundredComputed ??=
          Computed<bool>(() => super.isBetweenZeroToHundred,
              name: 'DocStoreBase.isBetweenZeroToHundred'))
      .value;
  Computed<bool>? _$downloadCompleteComputed;

  @override
  bool get downloadComplete => (_$downloadCompleteComputed ??= Computed<bool>(
          () => super.downloadComplete,
          name: 'DocStoreBase.downloadComplete'))
      .value;
  Computed<String>? _$getPercentageComputed;

  @override
  String get getPercentage =>
      (_$getPercentageComputed ??= Computed<String>(() => super.getPercentage,
              name: 'DocStoreBase.getPercentage'))
          .value;
  Computed<String>? _$getPageNumbersComputed;

  @override
  String get getPageNumbers =>
      (_$getPageNumbersComputed ??= Computed<String>(() => super.getPageNumbers,
              name: 'DocStoreBase.getPageNumbers'))
          .value;
  Computed<bool>? _$isFileOpenedComputed;

  @override
  bool get isFileOpened =>
      (_$isFileOpenedComputed ??= Computed<bool>(() => super.isFileOpened,
              name: 'DocStoreBase.isFileOpened'))
          .value;

  late final _$fullFilePathAtom =
      Atom(name: 'DocStoreBase.fullFilePath', context: context);

  @override
  String get fullFilePath {
    _$fullFilePathAtom.reportRead();
    return super.fullFilePath;
  }

  @override
  set fullFilePath(String value) {
    _$fullFilePathAtom.reportWrite(value, super.fullFilePath, () {
      super.fullFilePath = value;
    });
  }

  late final _$isOfflineAtom =
      Atom(name: 'DocStoreBase.isOffline', context: context);

  @override
  bool get isOffline {
    _$isOfflineAtom.reportRead();
    return super.isOffline;
  }

  @override
  set isOffline(bool value) {
    _$isOfflineAtom.reportWrite(value, super.isOffline, () {
      super.isOffline = value;
    });
  }

  late final _$isFileDownloadingAtom =
      Atom(name: 'DocStoreBase.isFileDownloading', context: context);

  @override
  bool get isFileDownloading {
    _$isFileDownloadingAtom.reportRead();
    return super.isFileDownloading;
  }

  @override
  set isFileDownloading(bool value) {
    _$isFileDownloadingAtom.reportWrite(value, super.isFileDownloading, () {
      super.isFileDownloading = value;
    });
  }

  late final _$isDownloadFailFileAtom =
      Atom(name: 'DocStoreBase.isDownloadFailFile', context: context);

  @override
  bool get isDownloadFailFile {
    _$isDownloadFailFileAtom.reportRead();
    return super.isDownloadFailFile;
  }

  @override
  set isDownloadFailFile(bool value) {
    _$isDownloadFailFileAtom.reportWrite(value, super.isDownloadFailFile, () {
      super.isDownloadFailFile = value;
    });
  }

  late final _$percentageCompletedAtom =
      Atom(name: 'DocStoreBase.percentageCompleted', context: context);

  @override
  double get percentageCompleted {
    _$percentageCompletedAtom.reportRead();
    return super.percentageCompleted;
  }

  @override
  set percentageCompleted(double value) {
    _$percentageCompletedAtom.reportWrite(value, super.percentageCompleted, () {
      super.percentageCompleted = value;
    });
  }

  late final _$totalPageAtom =
      Atom(name: 'DocStoreBase.totalPage', context: context);

  @override
  int? get totalPage {
    _$totalPageAtom.reportRead();
    return super.totalPage;
  }

  @override
  set totalPage(int? value) {
    _$totalPageAtom.reportWrite(value, super.totalPage, () {
      super.totalPage = value;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('DocStoreBase.init', context: context);

  @override
  Future<void> init(BuildContext context) {
    return _$initAsyncAction.run(() => super.init(context));
  }

  late final _$disposeAsyncAction =
      AsyncAction('DocStoreBase.dispose', context: context);

  @override
  Future<void> dispose() {
    return _$disposeAsyncAction.run(() => super.dispose());
  }

  late final _$downloadFileFromIDAsyncAction =
      AsyncAction('DocStoreBase.downloadFileFromID', context: context);

  @override
  Future<void> downloadFileFromID(BuildContext context,
      {required String bookID}) {
    return _$downloadFileFromIDAsyncAction
        .run(() => super.downloadFileFromID(context, bookID: bookID));
  }

  late final _$insertFileIntoDatabaseAsyncAction =
      AsyncAction('DocStoreBase.insertFileIntoDatabase', context: context);

  @override
  Future<void> insertFileIntoDatabase(String filePath) {
    return _$insertFileIntoDatabaseAsyncAction
        .run(() => super.insertFileIntoDatabase(filePath));
  }

  @override
  String toString() {
    return '''
fullFilePath: ${fullFilePath},
isOffline: ${isOffline},
isFileDownloading: ${isFileDownloading},
isDownloadFailFile: ${isDownloadFailFile},
percentageCompleted: ${percentageCompleted},
totalPage: ${totalPage},
isBetweenZeroToHundred: ${isBetweenZeroToHundred},
downloadComplete: ${downloadComplete},
getPercentage: ${getPercentage},
getPageNumbers: ${getPageNumbers},
isFileOpened: ${isFileOpened}
    ''';
  }
}
