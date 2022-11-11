class FoodItem {
  int? id;
  double? calories, fats, protiens, carbohydrate;
  String? name, description;

  FoodItem(
      {this.id,
      this.name,
      this.description,
      this.calories,
      this.protiens,
      this.carbohydrate,
      this.fats});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'calories': calories,
      'protiens': protiens,
      'carbohydrate': carbohydrate,
      'fats': fats,
    };
  }

  factory FoodItem.fromMap(Map<String, dynamic> json) => FoodItem(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        calories: json["calories"],
        protiens: json["protiens"],
        fats: json["fats"],
        carbohydrate: json["carbohydrate"],
      );
}
