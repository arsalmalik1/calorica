//@dart=2.9
import 'package:calorica/models/meal.dart';
import 'package:calorica/pages/product/products_list.dart';
import 'package:calorica/providers/local_providers/mealsProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/dbModels.dart';
import '../pages/forms/fooditem_form.dart';
import '../pages/product/widgets/fooditem_appbar.dart';
import '../pages/product/widgets/product_card.dart';

class AddMeal extends StatefulWidget {
  const AddMeal({Key key}) : super(key: key);

  @override
  State<AddMeal> createState() => _AddMealState();
}

class _AddMealState extends State<AddMeal> {
  TextEditingController nameController = TextEditingController();
  List<Product> products = [];
  List<int> ids = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20),
        child: Material(
            elevation: 5,
            borderRadius: BorderRadius.circular(30),
            color: Colors.greenAccent,
            child: MaterialButton(
                padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                minWidth: MediaQuery.of(context).size.width,
                onPressed: () {
                  print(FirebaseAuth.instance.currentUser.uid);
                  print(ids.toString());
                  Meal meal = new Meal(
                      name: nameController.text,
                      uid: FirebaseAuth.instance.currentUser.uid,
                      products: ids.toString());
                  DBMealProvider.db.addMeal(meal).then((value) {
                    Get.back(result: 'refresh');
                  });
                },
                child: Text(
                  "Create Meal",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ))),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 45),
        child: Column(
          children: [
            FooditemsListAppBar(
              title: 'New Meal',
              isMeal: false,
              onPress: () async {
                Product product = await Get.to(() => AddPage(
                      isMeal: true,
                    ));
                bool isExist = false;
                for (Product p in products) {
                  if (p.id == product.id) {
                    isExist = true;
                  }
                }
                if (!isExist) {
                  products.add(product);
                  ids.add(product.id);
                }

                print(products.length);
                setState(() {});
              },
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                children: [
                  TextFormField(
                      autofocus: false,
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                        prefixIcon: Icon(Icons.restaurant_outlined),
                        contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                        hintText: "Meal Name",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      )),
                ],
              ),
            ),
            Expanded(
                child: ListView.builder(
                    itemCount: products.length + 1,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      if (index == products.length) {
                        return SizedBox(height: 80);
                      } else {
                        return ProductCard(
                          product: products[index],
                          check: 'remove',
                          onPress: () {
                            ids.remove(products[index].id);
                            products.remove(products[index]);
                            setState(() {});
                          },
                        );
                      }
                    }))
          ],
        ),
      ),
    );
  }
}
