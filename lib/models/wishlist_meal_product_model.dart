//@dart=2.9

import 'package:calorica/models/dbModels.dart';

class WishlistMealProduct {
  int id;
  String name;
  String category;
  double calory;
  double squi;
  double gram;
  double fat;
  double carboh;
  int mealID;
  int productID;

  WishlistMealProduct(
      {this.id,
      this.name,
      this.category,
      this.calory,
      this.squi,
      this.fat,
      this.carboh,
      this.gram,
      this.productID,
      this.mealID});

  factory WishlistMealProduct.fromMap(Map<String, dynamic> json) =>
      WishlistMealProduct(
          id: json["id"],
          name: json["name"],
          category: json["category"],
          calory: json["calory"],
          squi: json["squi"],
          fat: json["fat"],
          carboh: json["carboh"],
          gram: json['gram'],
          mealID: json["meal_id"],
          productID: json['product_id']);

  Map<String, dynamic> toMap() => {
        "id": id,
        "name": name,
        "category": category,
        "calory": calory,
        "squi": squi,
        "fat": fat,
        'gram': gram,
        "carboh": carboh,
        'product_id': productID
      };

  static WishlistMealProduct castWishlistMealProduct(
      Product product, double gram) {
    return WishlistMealProduct(
        productID: product.id,
        name: product.name,
        calory: product.calory,
        category: product.category,
        carboh: product.carboh,
        fat: product.fat,
        squi: product.squi,
        gram: gram);
  }
}
