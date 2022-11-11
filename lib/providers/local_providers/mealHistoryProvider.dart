//@dart=2.9
import 'dart:async';
import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:calorica/utils/dateHelpers/dateFromInt.dart';

class DBDashMealHistoryProvider {
  DBDashMealHistoryProvider._();

  static final DBDashMealHistoryProvider db = DBDashMealHistoryProvider._();

  Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "DashMealHistory.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE DashMealHistory ("
          "id INTEGER PRIMARY KEY,"
          "date INTEGER,"
          "ids TEXT,"
          "name TEXT,"
          "force INTEGER,"
          "meal_id INTEGER"
          ")");
    });
  }

  Future<bool> getPoductsByDate(DateTime date, int idToAdd) async {
    final db = await database;

    var dateByYMD = DateTime(date.year, date.month, date.day);
    var dateInt = epochFromDate(dateByYMD);

    bool resp = false;
    var res = await db
        .rawQuery("SELECT * FROM DashMealHistory WHERE date = '$dateInt'");

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
          await DBDashMealHistoryProvider.db.updateDateProducts(products);
      resp = response == 1;
    }
    return resp;
  }

  updateDateProducts(DashMeal products) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE DashMealHistory SET ids = ? WHERE id = ?',
        ['${products.ids}', '${products.id}']);
  }

  Future<DashMeal> addDateProducts(DashMeal dateProducts) async {
    final db = await database;
    final name = dateProducts.name != null ? dateProducts.name : '';
    dateProducts.date = DateTime(
        dateProducts.date.year, dateProducts.date.month, dateProducts.date.day);
    var intDate = epochFromDate(dateProducts.date);

    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM DashMealHistory");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into DashMealHistory (id, name, date, ids, meal_id)"
        " VALUES (?,?,?,?,?)",
        [id, name, intDate, dateProducts.ids, dateProducts.mealID]);

    var respons = DashMeal(
      id: id,
      date: dateProducts.date,
      ids: dateProducts.ids,
    );

    return respons;
  }

  Future<DashMeal> addDashMeals(DashMeal dashMeal) async {
    final db = await database;

    dashMeal.date =
        DateTime(dashMeal.date.year, dashMeal.date.month, dashMeal.date.day);
    var intDate = epochFromDate(dashMeal.date);

    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM DashMealHistory");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into DashMealHistory (id, date, ids, name, force, meal_id)"
        " VALUES (?,?,?,?,?,?)",
        [
          id,
          intDate,
          dashMeal.ids,
          dashMeal.name,
          dashMeal.force,
          dashMeal.mealID
        ]);

    var respons = DashMeal(
        id: raw,
        date: dashMeal.date,
        ids: dashMeal.ids,
        name: dashMeal.name,
        force: dashMeal.force,
        mealID: dashMeal.mealID);

    return respons;
  }

  Future<List<int>> getDashMealIDsByDate(DateTime date) async {
    final db = await database;

    var dateByYMD = DateTime(date.year, date.month, date.day);
    var dateInt = epochFromDate(dateByYMD);

    var res = await db
        .rawQuery("SELECT * FROM DashMealHistory WHERE date = '$dateInt'");

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
        .rawQuery("SELECT * FROM DashMealHistory WHERE date = '$dateInt'");

    if (res.length == 0) {
      var newDP =
          DashMeal(ids: idToAdd.toString(), date: dateByYMD, name: name);
      var response = await addDashMeals(newDP);
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
          await DBDashMealHistoryProvider.db.updateDashMeals(dashMeal);
      resp = response == 1;
    }
    return resp;
  }

  updateDashMeals(DashMeal dashMeal) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE DashMealHistory SET ids = ? WHERE id = ?',
        ['${dashMeal.ids}', '${dashMeal.id}']);
  }

  Future updateNameMeals(int id, String name) async {
    final db = await database;

    int count = await db.rawUpdate(
        'UPDATE DashMealHistory SET name = ? WHERE id = ?', ['$name', '$id']);
  }

  Future<List<DashMeal>> getDashMeals() async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM DashMealHistory");

    List<DashMeal> list =
        res.isNotEmpty ? res.map((c) => DashMeal.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<DashMeal>> getDashDateBaseMeals(int date, int force) async {
    final db = await database;
    var res = await db.rawQuery(
        "SELECT * FROM DashMealHistory WHERE date = $date OR force = $force");

    List<DashMeal> list =
        res.isNotEmpty ? res.map((c) => DashMeal.fromMap(c)).toList() : [];
    return list;
  }

  Future deleteDashMeal(id) async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM DashMealHistory WHERE id = $id");
    print(res);
    return res;
  }

  Future deleteAllDashMeal() async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM DashMealHistory");
    print(res);
    return res;
  }
}
