import 'dart:io';

import 'package:bookkart_flutter/screens/bookView/model/downloaded_book_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/card_model.dart';
import 'package:bookkart_flutter/screens/dashboard/model/offline_book_list_model.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static const _databaseName = "MyDatabase.db";
  static const _databaseVersion = 3;
  static const String TABLE_NAME = "downloaded_book_table";
  static const String COLUMN_NAME_ID = "id";
  static const String COLUMN_NAME_BOOK_ID = "book_id";
  static const String COLUMN_NAME_BOOK_NAME = "book_name";
  static const String COLUMN_NAME_USER_ID = "user_id";
  static const String COLUMN_NAME_FILE_PATH = "file_path";
  static const String COLUMN_NAME_FILE_NAME = "file_Name";
  static const String COLUMN_NAME_FRONT_COVER = "front_cover";
  static const String COLUMN_NAME_FILE_TYPE = "file_type";
  static const String SQL_CREATE_ENTRIES = "CREATE TABLE IF NOT EXISTS " +
      TABLE_NAME +
      " (" +
      COLUMN_NAME_ID +
      " INTEGER PRIMARY KEY," +
      COLUMN_NAME_BOOK_ID +
      " TEXT, " +
      COLUMN_NAME_FILE_NAME +
      " TEXT, " +
      COLUMN_NAME_BOOK_NAME +
      " TEXT, " +
      COLUMN_NAME_USER_ID +
      " TEXT, " +
      COLUMN_NAME_FILE_PATH +
      " TEXT, " +
      COLUMN_NAME_FRONT_COVER +
      " TEXT, " +
      COLUMN_NAME_FILE_TYPE +
      " TEXT " +
      ")";

  static const String CARD_TABLE_NAME = "card_table";
  static const String CARD_COLUMN_NAME_ID = "id";
  static const String CARD_COLUMN_NAME_CARD_ID = "name";
  static const String CARD_COLUMN_NAME_CARD_NAME = "item_name";
  static const String CARD_COLUMN_NAME_CARD_CATEGORY = "item_group";
  static const String CARD_COLUMN_NAME_CARD_SUBCATEGORY = "brand";
  static const String CARD_COLUMN_NAME_CARD_IMAGE = "image";
  static const String CARD_COLUMN_NAME_CARD_PRICE = "price_list_rate";
  static const String CARD_COLUMN_NAME_CARD_CURRENCY = "currency";
  static const String CARD_COLUMN_NAME_CARD_QTY = "projected_qty";

  static const String CARD_SQL_CREATE_ENTRIES = "CREATE TABLE IF NOT EXISTS " +
      CARD_TABLE_NAME +
      " (" +
      CARD_COLUMN_NAME_ID +
      " INTEGER PRIMARY KEY," +
      CARD_COLUMN_NAME_CARD_ID +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_NAME +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_CATEGORY +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_SUBCATEGORY +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_IMAGE +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_PRICE +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_CURRENCY +
      " TEXT, " +
      CARD_COLUMN_NAME_CARD_QTY +
      " TEXT " +
      ")";

  DatabaseHelper._privateConstructor();

  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path, version: _databaseVersion, onCreate: _onCreate, onUpgrade: _onUpgrade);
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (newVersion > oldVersion) {
      log('Update DB Version');
    }
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute(SQL_CREATE_ENTRIES);
    await db.execute(CARD_SQL_CREATE_ENTRIES);
  }

  Future<int> insert(DownloadedBook book) async {
    Database? db = await (instance.database);
    log('insert data' + book.toJson().toString());
    log('--- FILE WAS ADDEND TO LIBRARY   ---');
    return await db!.insert(TABLE_NAME, book.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }
  Future<int> insertCard(CardModel card) async {
    Database? db = await (instance.database);
    log('insert data' + card.toJson().toString());
    log('--- FILE WAS ADDEND TO LIBRARY   ---');
    return await db!.insert(CARD_TABLE_NAME, card.toJson(), conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CardModel>> getCards() async {
    Database? db = await (instance.database);
    List<Map<String, dynamic>> list = await db!.query(
      CARD_TABLE_NAME,
    );
    List<CardModel> cards = [];
    for (var item in list){
     CardModel card = cards.firstWhere((element) => element.id == item['name'], orElse: () {
       CardModel _card = CardModel.fromJson(item);
       cards.add(_card);
        return _card;
     },);
     card.qty +=1 ;
    }
    return cards;
  }
  Future<List<OfflineBookList>?> queryAllRows(userId) async {
    Database? db = await (instance.database);
    List<Map<String, dynamic>> list = await db!.query(
      TABLE_NAME,
      where: "$COLUMN_NAME_USER_ID = ?",
      whereArgs: [userId.toString()],
      orderBy: COLUMN_NAME_BOOK_NAME + " ASC",
    );
    List<DownloadedBook> bookList = list.map((i) => DownloadedBook.fromJson(i)).toList();
    List<OfflineBookList>? newList = [];

    bookList.forEach((element) async {
      OfflineBookList book = OfflineBookList();
      book.bookId = element.bookId;
      book.id = element.id;
      book.bookName = element.bookName;
      book.frontCover = element.frontCover;

      OfflineBook bookFile = OfflineBook();
      bookFile.fileName = element.fileName;
      bookFile.filePath = element.filePath;
      bookFile.fileType = element.fileType;

      if (newList != null) {
        bool isExistData = false;
        newList!.forEach((newElement) async {
          if (newElement.bookId == element.bookId) {
            isExistData = true;
            newElement.offlineBook.add(bookFile);
          }
        });
        if (!isExistData) {
          book.offlineBook.add(bookFile);
          newList!.add(book);
        }
      } else {
        newList = [];
        book.offlineBook.add(bookFile);
        newList!.add(book);
      }
    });
    newList!.forEach((newElement) async {
      newElement.offlineBook.forEach((bookData) async {});
    });

    return newList;
  }

  Future<int?> queryRowCount() async {
    Database? db = await (instance.database);
    return Sqflite.firstIntValue(await db!.rawQuery('SELECT COUNT(*) FROM $TABLE_NAME'));
  }

  Future<List<DownloadedBook>?> queryRowBook(bookId) async {
    Database? db = await (instance.database);
    List list = await db!.rawQuery("SELECT DISTINCT * FROM " + TABLE_NAME, null);
    return list.map((i) => DownloadedBook.fromJson(i)).toList();
  }

  Future<int> update(DownloadedBook book) async {
    Database? db = await (instance.database);
    int? id = book.id;
    return await db!.update(TABLE_NAME, book.toJson(), where: '$COLUMN_NAME_ID = ?', whereArgs: [id]);
  }

  Future<int> delete(String path) async {
    Database? db = await (instance.database);
    return await db!.delete(TABLE_NAME, where: '$COLUMN_NAME_FILE_PATH = ?', whereArgs: [path]);
  }

  Future<void> removeCard(String cardId) async {
    Database? db = await (instance.database);
    return await db!.execute("DELETE FROM $CARD_TABLE_NAME WHERE $CARD_COLUMN_NAME_ID=(SELECT MIN($CARD_COLUMN_NAME_ID) FROM $CARD_TABLE_NAME WHERE $CARD_COLUMN_NAME_CARD_ID='$cardId')");
  }
  Future<void> removeAllCard(String cardId) async {
    Database? db = await (instance.database);
    return await db!.execute("DELETE FROM $CARD_TABLE_NAME WHERE $CARD_COLUMN_NAME_CARD_ID='$cardId'");
  }
}
