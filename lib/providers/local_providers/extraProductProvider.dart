//@dart=2.9
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/extraProductModel.dart';

class DBExtraProductsProvider {
  DBExtraProductsProvider._();

  static final DBExtraProductsProvider db = DBExtraProductsProvider._();

  Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ExtraProducts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE ExtraProducts ("
          "id INTEGER PRIMARY KEY,"
          "meal_id INTEGER,"
          "ids TEXT"
          ")");
    });
  }

  Future addProduct(ExtraProduct product) async {
    final db = await database;

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM ExtraProducts");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into ExtraProducts (id, meal_id, ids)"
        " VALUES (?,?,?)",
        [id, product.meal_id, product.ids]);
  }

  Future<List<ExtraProduct>> getAllProducts(int mealID) async {
    final db = await database;

    var res = await db
        .rawQuery("SELECT * FROM ExtraProducts WHERE meal_id = '$mealID'");
    print('res: $res');
    List<ExtraProduct> list =
        res.isNotEmpty ? res.map((c) => ExtraProduct.fromMap(c)).toList() : [];

    //   var inArgs = ['cat', 'dog', 'fish'];
    //   var list = await db.query('my_table',
    // where: 'name IN (${List.filled(inArgs.length, '?').join(',')})',
    // whereArgs: inArgs);
    return list;
  }

  Future deleteAllMealProducts(int mealID) async {
    final db = await database;

    var list = [mealID];
    return await db.delete('ExtraProducts',
        where: 'meal_id IN (${List.filled(list.length, '?').join(',')})',
        whereArgs: list);
  }
}
