class Meal {
  int? id;
  String? name, uid, products;

  Meal({
    this.id,
    this.name,
    this.uid,
    this.products,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'uid': uid,
      'products': products,
    };
  }

  factory Meal.fromMap(Map<String, dynamic> json) => Meal(
        id: json["id"],
        name: json["name"],
        uid: json["uid"],
        products: json["products"],
      );
}
