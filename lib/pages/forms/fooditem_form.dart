//@dart=2.9
import 'package:calorica/common/theme/custom_theme/custom_theme.dart';
import 'package:calorica/models/dbModels.dart';
import 'package:calorica/models/food_item.dart';
import 'package:calorica/pages/product/widgets/app_bar.dart';
import 'package:calorica/providers/local_providers/dietProvider.dart';
import 'package:calorica/providers/local_providers/productProvider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../providers/local_providers/fooditemsProvider.dart';

class FooditemForm extends StatefulWidget {
  const FooditemForm({Key key}) : super(key: key);

  @override
  State<FooditemForm> createState() => _FooditemFormState();
}

class _FooditemFormState extends State<FooditemForm> {
  TextEditingController name = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController protiens = TextEditingController();
  TextEditingController fats = TextEditingController();
  TextEditingController carbohydrates = TextEditingController();
  TextEditingController calories = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text('Создать еду'),
      ),
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.only(left: 20, right: 20, top: 20),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset(
                  'assets/food.png',
                  width: MediaQuery.of(context).size.width * 0.6,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                    autofocus: false,
                    controller: name,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please Enter Your Food Name");
                      }

                      return null;
                    },
                    onSaved: (value) {
                      name.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.restaurant),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "название еды",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: calories,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please Enter Calories");
                      }

                      return null;
                    },
                    onSaved: (value) {
                      calories.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.sports_handball_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "калории",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: fats,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please Enter Fats");
                      }

                      return null;
                    },
                    onSaved: (value) {
                      fats.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.run_circle),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "жиры",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: protiens,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please Enter Protiens");
                      }

                      return null;
                    },
                    onSaved: (value) {
                      protiens.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.fitness_center_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Белки",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: carbohydrates,
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value.isEmpty) {
                        return ("Please Enter Carbohydrates");
                      }

                      return null;
                    },
                    onSaved: (value) {
                      carbohydrates.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.water_drop_outlined),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "Углеводы",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                    autofocus: false,
                    controller: description,
                    keyboardType: TextInputType.text,
                    validator: (value) {
                      return null;
                    },
                    onSaved: (value) {
                      description.text = value;
                    },
                    textInputAction: TextInputAction.next,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.category),
                      contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      hintText: "описание",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    )),
                SizedBox(
                  height: 20,
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.greenAccent,
                  child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          Product product = Product(
                              name: name.text,
                              category: description.text,
                              squi: double.parse(protiens.text),
                              fat: double.parse(fats.text),
                              calory: double.parse(calories.text),
                              carboh: double.parse(carbohydrates.text));
                          DBProductProvider.db.addProduct(product);
                          // DBFoodItemProvider.db.addFoodItem(product);
                          Get.back(result: 'refresh');
                        }
                      },
                      child: Text(
                        "Создавать",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
