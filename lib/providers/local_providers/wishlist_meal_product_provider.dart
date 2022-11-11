//@dart=2.9
import 'dart:async';
import 'dart:developer' as log;
import 'dart:io';
import 'dart:math';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:calorica/models/dbModels.dart';

import '../../models/wishlist_meal_product_model.dart';

class DBWishlistMealProductProvider {
  DBWishlistMealProductProvider._();

  static final DBWishlistMealProductProvider db =
      DBWishlistMealProductProvider._();

  Database _database;
  var rng = Random();
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "WishlistMealProducts.db");
    return await openDatabase(path, version: 1, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      await db.execute("CREATE TABLE WishlistMealProducts ("
          "id INTEGER PRIMARY KEY,"
          "name TEXT,"
          "category TEXT,"
          "calory DOUBLE,"
          "squi DOUBLE,"
          "fat DOUBLE,"
          "carboh DOUBLE,"
          "gram DOUBLE,"
          "meal_id INTEGER,"
          "product_id INTEGER"
          ")");
    });
  }

  Future<int> addProduct(WishlistMealProduct product) async {
    final db = await database;
    var table =
        await db.rawQuery("SELECT MAX(id)+1 as id FROM WishlistMealProducts");
    int id = table.first["id"];

    var raw = await db.rawInsert(
        "INSERT Into WishlistMealProducts (id, name, category, calory, squi, fat, carboh, gram, meal_id, product_id)"
        " VALUES (?,?,?,?,?,?,?,?,?,?)",
        [
          id,
          product.name,
          product.category,
          product.calory,
          product.squi,
          product.fat,
          product.carboh,
          product.gram,
          product.mealID,
          product.productID
        ]);
    return raw;
  }

  Future<List<Product>> getAllProductsSearch(String text) async {
    final db = await database;
    var res = await db.query("WishlistMealProducts",
        where: "name LIKE ?", whereArgs: ["%$text%"]);
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<Product>> getProductByIds(var ids) async {
    final db = await database;

    // var res = await db.rawQuery("SELECT * FROM Products WHERE id = ($ids)");

    var res = await db.query('WishlistMealProducts',
        where: 'id IN (${List.filled(ids.length, '?').join(',')})',
        whereArgs: ids);
    List<Product> list =
        res.isNotEmpty ? res.map((c) => Product.fromMap(c)).toList() : [];
    return list;
  }

  Future<List<WishlistMealProduct>> getProductByMealID(int id) async {
    final db = await database;
    List<WishlistMealProduct> products = [];
    var res = await db
        .rawQuery("SELECT * FROM WishlistMealProducts WHERE meal_id = $id");
    for (var item in res) {
      WishlistMealProduct product = WishlistMealProduct(
          id: item["id"],
          name: item["name"],
          category: item["category"],
          calory: item["calory"],
          squi: item["squi"],
          fat: item["fat"],
          carboh: item["carboh"],
          gram: item["gram"],
          mealID: item["meal_id"],
          productID: item['product_id']);
      products.add(product);
    }

    return products;
  }

  Future<List<WishlistMealProduct>> getProducts() async {
    final db = await database;
    List<WishlistMealProduct> products = [];
    var res = await db.rawQuery("SELECT * FROM WishlistMealProducts");
    for (var item in res) {
      WishlistMealProduct product = WishlistMealProduct(
          id: item["id"],
          name: item["name"],
          category: item["category"],
          calory: item["calory"],
          squi: item["squi"],
          fat: item["fat"],
          carboh: item["carboh"],
          gram: item["gram"],
          mealID: item["meal_id"],
          productID: item['product_id']);
      products.add(product);
    }

    return products;
  }

  Future deleteProductsByMeal(id) async {
    final db = await database;
    var res = await db
        .rawQuery("DELETE FROM WishlistMealProducts WHERE meal_id = $id");
    print(res);
    return res;
  }

  Future deleteAllWishlistMealProducts() async {
    final db = await database;
    var res = await db.rawQuery("DELETE FROM WishlistMealProducts");
    print(res);
    return res;
  }

  Future<int> updateProduct(WishlistMealProduct product) async {
    final db = await database;

    final count = await db.rawUpdate(
        'UPDATE WishlistMealProducts SET name = ?, category = ?, calory = ?, squi = ?, fat = ?, carboh = ?, gram = ?, meal_id = ?, product_id = ? WHERE id = ?',
        [
          '${product.name}',
          '${product.category}',
          '${product.calory}',
          '${product.squi}',
          '${product.fat}',
          '${product.carboh}',
          '${product.gram}',
          '${product.mealID}',
          '${product.productID}',
          product.id
        ]);
    return count;
  }
}
