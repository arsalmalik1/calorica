//@dart=2.9
import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:calorica/utils/dateHelpers/dateFromInt.dart';

class DBWishlisthMealProvider {
  DBWishlisthMealProvider._();

  static final DBWishlisthMealProvider db = DBWishlisthMealProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WishlistMeal.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE WishlistMeals ("
          "id INTEGER PRIMARY KEY,"
          "date INTEGER,"
          "ids TEXT,"
          "name TEXT,"
          "force INTEGER"
          ")");
    });
  }

  Future<bool> getPoductsByDate(DateTime date, int idToAdd) async {
    final db = await database;

    var dateByYMD = DateTime(date.year, date.month, date.day);
    var dateInt = epochFromDate(dateByYMD);

    bool resp = false;
    var res = await db
        .rawQuery("SELECT * FROM WishlistMeals WHERE date = '$dateInt'");

    if (res.length == 0) {
      var newDP = DashMeal(ids: idToAdd.toString(), date: dateByYMD);
      var response = await addDateProducts(newDP);
      resp = response != null;
    } else {
      var item = res.first;
      var products = DashMeal(
          id: item['id'],
          ids: item['ids'],
          date: DateTime.fromMillisecondsSinceEpoch(item['date']));
      try {
        products.ids += ";" + res.first['id'].toString();
      } catch (e) {}
      var response =
          await DBWishlisthMealProvider.db.updateDateProducts(products);
      resp = response == 1;
    }
    return resp;
  }

  updateDateProducts(DashMeal products) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE WishlistMeals SET ids = ? WHERE id = ?',
        ['${products.ids}', '${products.id}']);
  }

  Future<DashMeal> addDateProducts(DashMeal dateProducts) async {
    final db = await database;
    final name = dateProducts.name != null ? dateProducts.name : '';
    dateProducts.date = DateTime(
        dateProducts.date.year, dateProducts.date.month, dateProducts.date.day);
    var intDate = epochFromDate(dateProducts.date);

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM WishlistMeals");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into WishlistMeals (id, name, date, ids)"
        " VALUES (?,?,?,?)",
        [
          id,
          name,
          intDate,
          dateProducts.ids,
        ]);

    var respons = DashMeal(
      id: id,
      date: dateProducts.date,
      ids: dateProducts.ids,
    );

    return respons;
  }

  Future<DashMeal> addWishlistMeals(DashMeal dashMeal) async {
    final db = await database;

    dashMeal.date =
        DateTime(dashMeal.date.year, dashMeal.date.month, dashMeal.date.day);
    var intDate = epochFromDate(dashMeal.date);

    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM WishlistMeals");
    int id = table.first["id"];

    int raw = await db.rawInsert(
        "INSERT Into WishlistMeals (id, date, ids, name, force)"
        " VALUES (?,?,?,?,?)",
        [id, intDate, dashMeal.ids, dashMeal.name, dashMeal.force]);
    var respons = DashMeal(
        id: raw,
        date: dashMeal.date,
        ids: dashMeal.ids,
        name: dashMeal.name,
        force: dashMeal.force);

    return respons;
  }

  Future<List<int>> getDashMealIDsByDate(DateTime date) async {
    final db = await database;

    var dateByYMD = DateTime(date.year, date.month, date.day);
    var dateInt = epochFromDate(dateByYMD);

    var res = await db
        .rawQuery("SELECT * FROM WishlistMeals WHERE date = '$dateInt'");

    var item = res.first;
    var ids = item['ids'];
    var mass = ids.toString().split(";");
    List<int> result = [];
    for (var i = 0; i < mass.length; i++) {
      result.add(int.parse(mass[i]));
    }
    return result;
  }

  Future<bool> getDashMealByDate(
      DateTime date, int idToAdd, String name) async {
    final db = await database;

    var dateByYMD = DateTime(date.year, date.month, date.day);
    var dateInt = epochFromDate(dateByYMD);

    bool resp = false;
    var res = await db
        .rawQuery("SELECT * FROM WishlistMeals WHERE date = '$dateInt'");

    if (res.length == 0) {
      var newDP =
          DashMeal(ids: idToAdd.toString(), date: dateByYMD, name: name);
      var response = await addWishlistMeals(newDP);
      resp = response != null;
    } else {
      var item = res.first;
      var dashMeal = DashMeal(
          id: item['id'],
          ids: item['ids'],
          name: item['name'],
          force: item['force'],
          date: DateTime.fromMillisecondsSinceEpoch(item['date']));

      try {
        dashMeal.ids += ";" + res.first['id'].toString();
      } catch (e) {}
      var response =
          await DBWishlisthMealProvider.db.updateWishlistMeals(dashMeal);
      resp = response == 1;
    }
    return resp;
  }

  updateWishlistMeals(DashMeal dashMeal) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE WishlistMeals SET ids = ? WHERE id = ?',
        ['${dashMeal.ids}', '${dashMeal.id}']);
  }

  updateNameMeals(int id, String name) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE WishlistMeals SET name = ? WHERE id = ?', ['$name', '$id']);
  }

  Future<List<DashMeal>> getWishlistMeals() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM WishlistMeals");

    List<DashMeal> list =
        res.isNotEmpty ? res.map((c) => DashMeal.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<DashMeal>> getDashDateBaseMeals(int date, int force) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM WishlistMeals WHERE date = $date OR force = $force");

    List<DashMeal> list =
        res.isNotEmpty ? res.map((c) => DashMeal.fromMap(c)).toList() : [];
    return list;
  }

  Future deleteDashMeal(id) async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM WishlistMeals WHERE id = $id");
    print(res);
    return res;
  }

  Future deleteAllDashMeal() async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM WishlistMeals");
    print(res);
    return res;
  }
}
