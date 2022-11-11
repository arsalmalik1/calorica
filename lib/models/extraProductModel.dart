class ExtraProduct {
  int id;
  int meal_id;
  String ids;

  ExtraProduct({required this.id, required this.meal_id, required this.ids});

  factory ExtraProduct.fromMap(Map<String, dynamic> json) =>
      ExtraProduct(id: json["id"], meal_id: json["meal_id"], ids: json["ids"]);

  Map<String, dynamic> toMap() => {"id": id, "meal_id": meal_id, "ids": ids};
}
