//@dart=2.9
import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:calorica/models/food_item.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBFoodItemProvider {
  DBFoodItemProvider._();

  static final DBFoodItemProvider db = DBFoodItemProvider._();

  Database _database;
  var rng = Random();
  Future<Database> get database async {
    print(_database);
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  firstCreateTable() async {
    final db = await database;
    // int id = 0;
    // var raw = await db.rawInsert(
    //     "INSERT Into Fooditems (id, name, description, calories, protiens, fats, carbohydrate)"
    //     " VALUES (?,?,?,?,?,?,?)",
    //     [id, 'food item name', 'food item description', 218, 18.6, 16, 0]);
    // return (raw);
  }

  initDB() async {
    print('sjkdcsvn');

    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "Fooditems.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE Fooditems ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "description TEXT,"
          "calories DOUBLE,"
          "protiens DOUBLE,"
          "fats DOUBLE,"
          "carbohydrate DOUBLE"
          ")");
    });
  }

  Future<FoodItem> getFoodItemById(int id) async {
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Fooditems WHERE id = $id");
    var item = res.first;
    FoodItem foodItem = FoodItem(
      id: item["id"],
      name: item["name"],
      description: item["description"],
      calories: item["calories"],
      protiens: item["protiens"],
      fats: item["fats"],
      carbohydrate: item["carbohydrate"],
    );

    return foodItem;
  }

  Future<List<FoodItem>> getAllFoodItemsSearch(String text) async {
    final db = await database;
    var res = await db
        .query("Fooditems", where: "name LIKE ?", whereArgs: ["%$text%"]);
    List<FoodItem> list =
        res.isNotEmpty ? res.map((c) => FoodItem.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<FoodItem>> getAllFoodItems() async {
    var rnd = Random();
    var offset = rnd.nextInt(7000);
    final db = await database;
    var res = await db.rawQuery("SELECT * FROM Fooditems");
    List<FoodItem> list =
        res.isNotEmpty ? res.map((c) => FoodItem.fromMap(c)).toList() : [];
    print(res);
    return list;
  }

  Future<int> addFoodItem(FoodItem foodItem) async {
    final db = await database;
    var table = await db.rawQuery("SELECT MAX(id)+1 as id FROM Fooditems");
    int id = table.first["id"];
    if (id == 0 || id == null) {
      id = 1;
    }
    var raw = await db.rawInsert(
        "INSERT Into Fooditems (id, name, description, calories, protiens, fats, carbohydrate)"
        " VALUES (?,?,?,?,?,?,?)",
        [
          id,
          foodItem.name,
          foodItem.description,
          foodItem.calories,
          foodItem.protiens,
          foodItem.fats,
          foodItem.carbohydrate,
        ]);
    print(raw);
    return id;
  }
}
