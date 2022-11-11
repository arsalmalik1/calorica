//@dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../models/meal.dart';

class DBUserMealProvider {
  DBUserMealProvider._();

  static final DBUserMealProvider db = DBUserMealProvider._();

  Database _database;
  var rng = Random();
  Future<Database> get database async {
    // if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  firstCreateTable() async {
    await database;
    // int id = 0;
    // var raw = await db.rawInsert(
    //     "INSERT Into Meals (id, name, uid, products)"
    //     " VALUES (?,?,?,?,?,?,?)",
    //     [id, '', '', '']);
    // return (raw);
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "UserMeals.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE UserMeals ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "uid TEXT,"
          "products TEXT"
          ")");
    });
  }

  Future<int> addUserMeal(Meal meal) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM UserMeals");
    int id = table.first["id"];
    var raw = await db.rawInsert(
        "INSERT Into UserMeals (id, name, uid, products)"
        " VALUES (?,?,?,?)",
        [
          id,
          meal.name,
          meal.uid,
          meal.products,
        ]);
    return id;
  }

  Future<Meal> getUserMealById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM UserMeals WHERE id = $id");
    var item = res.first;
    Meal meal = Meal(
      id: item["id"],
      name: item["name"],
      uid: item["uid"],
      products: item["products"],
    );

    return meal;
  }

  Future<List<Meal>> getAllUserMealsSearch(String text) async {
    final db = await database;
    var res = await db
        .query("UserMeals", where: "name LIKE ?", whereArgs: ["%$text%"]);
    List<Meal> list =
        res.isNotEmpty ? res.map((c) => Meal.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Meal>> getAllMeals() async {
    var rnd = Random();
    var offset = rnd.nextInt(7000);
    final db = await database;
    var res =
        // await db.rawQuery("SELECT * FROM Products LIMIT 20 OFFSET '$offset'");
        await db.rawQuery("SELECT * FROM UserMeals ORDER BY id DESC");

    List<Meal> list =
        res.isNotEmpty ? res.map((c) => Meal.fromMap(c)).toList() : [];
    return list;
  }

  Future deleteMeal(id) async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM UserMeals WHERE id = $id");
    print(res);
    return res;
  }
}
