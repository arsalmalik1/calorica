//@dart=2.9
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/dateAndCalory.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/product/widgets/widgets.dart';
import 'package:calorica/pages/wishlist/wishlist_btn.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/dateProvider.dart';
import 'package:calorica/providers/local_providers/productProvider.dart';
import 'package:calorica/providers/local_providers/userProductsProvider.dart';

import 'package:calorica/utils/doubleRounder.dart';

import 'package:flutter/material.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';

class WishlistMealProductDetails extends StatefulWidget {
  WishlistMealProduct product;
  WishlistMealProductDetails({this.product});

  @override
  _WishlistMealProductDetailsState createState() =>
      _WishlistMealProductDetailsState();
}

class _WishlistMealProductDetailsState
    extends State<WishlistMealProductDetails> {
  String id;
  final _grammController = TextEditingController();
  Product product = Product();
  String name = "";
  String category = "";

  double calory = 0.0;
  double caloryConst = 0.0;
  double squi = 0.0;
  double squiConst = 0.0;
  double fat = 0.0;
  double fatConst = 0.0;
  double carboh = 0.0;
  double carbohConst = 0.0;
  double gramsEditing = 0;
  // BannerAd _bannerAd;

  bool canWriteInDB = true;

  final _formKey = GlobalKey<FormState>();
  TextEditingController caloryController = TextEditingController();
  TextEditingController squiController = TextEditingController();
  TextEditingController fatController = TextEditingController();
  TextEditingController carbohController = TextEditingController();
  double noCarboh = 0.0, noCalory = 0.0, noSqui = 0.0, noFat = 0.0;

  setWriteStatus(state) {
    setState() {
      canWriteInDB = state;
    }
  }

  @override
  void dispose() {
    // _bannerAd?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    gramsEditing = widget.product.gram;
    _grammController.text = '$gramsEditing';

    calory = widget.product.calory;
    squi = widget.product.squi;
    fat = widget.product.fat;
    carboh = widget.product.carboh;
    name = widget.product.name;
    category = widget.product.category;
    product = Product(
        name: name,
        calory: calory,
        category: category,
        squi: squi,
        fat: fat,
        carboh: carboh);

    noCarboh = carboh / widget.product.gram;
    noCalory = calory / widget.product.gram;
    noFat = fat / widget.product.gram;
    noSqui = squi / widget.product.gram;

    caloryController.text = calory.toString();
    squiController.text = squi.toString();
    fatController.text = fat.toString();
    carbohController.text = carboh.toString();
  }

  void multiData(double grams) {
    double multiplier = grams / widget.product.gram;
    calory = roundDouble(product.calory * multiplier, 2);
    squi = roundDouble(product.squi * multiplier, 2);
    fat = roundDouble(product.fat * multiplier, 2);
    carboh = roundDouble(product.carboh * multiplier, 2);
    caloryController.text = calory.toString();
    squiController.text = squi.toString();
    fatController.text = fat.toString();
    carbohController.text = carboh.toString();
  }

  void caloryBaseData(double grams) {
    _grammController.text = roundDouble(grams, 2).toString();
    double multiplier = grams / widget.product.gram;
    squi = roundDouble(product.squi * multiplier, 2);
    fat = roundDouble(product.fat * multiplier, 2);
    carboh = roundDouble(product.carboh * multiplier, 2);
    squiController.text = squi.toString();
    fatController.text = fat.toString();
    carbohController.text = carboh.toString();
  }

  void fatBaseData(double grams) {
    _grammController.text = roundDouble(grams, 2).toString();
    double multiplier = grams / widget.product.gram;

    squi = roundDouble(product.squi * multiplier, 2);
    calory = roundDouble(product.calory * multiplier, 2);
    carboh = roundDouble(product.carboh * multiplier, 2);
    squiController.text = squi.toString();
    caloryController.text = calory.toString();
    carbohController.text = carboh.toString();
  }

  void squiBaseData(double grams) {
    _grammController.text = roundDouble(grams, 2).toString();

    double multiplier = grams / widget.product.gram;

    calory = roundDouble(product.calory * multiplier, 2);
    fat = roundDouble(product.fat * multiplier, 2);
    carboh = roundDouble(product.carboh * multiplier, 2);
    caloryController.text = calory.toString();
    fatController.text = fat.toString();
    carbohController.text = carboh.toString();
  }

  void carbohBaseData(double grams) {
    _grammController.text = roundDouble(grams, 2).toString();

    double multiplier = grams / widget.product.gram;

    squi = roundDouble(product.squi * multiplier, 2);
    fat = roundDouble(product.fat * multiplier, 2);
    calory = roundDouble(product.calory * multiplier, 2);
    squiController.text = squi.toString();
    fatController.text = fat.toString();
    caloryController.text = calory.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: Icon(
              Icons.arrow_back,
              size: 24,
            )),
        elevation: 5.0,
        backgroundColor: DesignTheme.whiteColor,
        title: Text(
          name == '' ? 'Загрузка...' : splitText(name),
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(
          top: 0,
        ),
        child: Container(
          padding: const EdgeInsets.all(0.0),
          constraints:
              BoxConstraints.expand(height: MediaQuery.of(context).size.height),
          child: Padding(
            padding: EdgeInsets.only(left: 15, right: 15, bottom: 40, top: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: DesignTheme.whiteColor,
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        boxShadow: DesignTheme.shadowByOpacity(0.05),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: 15, right: 15, bottom: 20, top: 20),
                        child: Column(children: <Widget>[
                          Text(
                            product == null ? 'Загрузка...' : name,
                            style: isStringOverSize(name)
                                ? DesignTheme.bigText20
                                : DesignTheme.bigText24,
                            textAlign: TextAlign.start,
                          ),
                          SizedBox(height: 10),
                          TextFormField(
                            onChanged: (text) {
                              // if (_formKey.currentState.validate()) {}
                              print(text);
                              multiData(double.parse(text));
                            },
                            keyboardType: TextInputType.number,
                            controller: _grammController,
                            style: DesignTheme.inputText,
                            cursorColor: CustomTheme.mainColor,
                            decoration: InputDecoration(
                              labelText: 'Введите вес в граммах',
                              labelStyle: DesignTheme.labelSearchTextBigger,
                              suffixIcon: Icon(FontAwesomeIcons.weightHanging),
                            ),
                            // ignore: missing_return
                            validator: (value) {
                              if (value.isEmpty) {
                                setWriteStatus(false);
                                return 'Введите вес продукта';
                              } else if (!(double.parse(value) is double)) {
                                setWriteStatus(false);
                                return 'Введите число';
                              } else {
                                setWriteStatus(true);
                              }
                            },
                          ),
                        ]),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ProductParamPanel(
                              type: TextInputType.number,
                              value: calory,
                              title: "кКал",
                              controller: caloryController,
                              onChanged: (v) {
                                if (v == '') {
                                  v = '0.0';
                                }
                                calory = double.parse(v);
                                double totalGrams = double.parse(v) / noCalory;
                                print('calory: $calory');
                                print('noCalory: $noCalory');

                                print(totalGrams);

                                // print(totalGrams);
                                caloryBaseData(totalGrams);
                              },
                            ),
                            ProductParamPanel(
                              type: TextInputType.number,
                              value: squi,
                              title: "Белки г.",
                              controller: squiController,
                              onChanged: (v) {
                                if (v == '') {
                                  v = '0.0';
                                }
                                squi = double.parse(v);
                                double totalGrams = double.parse(v) / noSqui;
                                print(totalGrams);
                                squiBaseData(totalGrams);
                              },
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            ProductParamPanel(
                              type: TextInputType.number,
                              value: fat,
                              title: "Жир г.",
                              controller: fatController,
                              onChanged: (v) {
                                if (v == '') {
                                  v = '0.0';
                                }
                                double totalGrams = double.parse(v) / noFat;
                                print(totalGrams);
                                fat = double.parse(v);
                                fatBaseData(totalGrams);
                              },
                            ),
                            ProductParamPanel(
                              type: TextInputType.number,
                              value: carboh,
                              title: "Углеводы г.",
                              controller: carbohController,
                              onChanged: (v) {
                                if (v == '') {
                                  v = '0.0';
                                }

                                double totalGrams = double.parse(v) / noCarboh;
                                print(totalGrams);
                                carboh = double.parse(v);
                                carbohBaseData(totalGrams);
                              },
                            ),
                          ],
                        )
                      ],
                    ),
                    SingleChildScrollView(
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                              'описание',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: CustomTheme.mainColor),
                            ),
                            Text(
                              category,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: wishlistButton(
          onpress: () {
            Get.back(
                result: WishlistMealProduct(
              category: widget.product.category,
              id: widget.product.id,
              calory: double.parse(caloryController.text),
              carboh: double.parse(carbohController.text),
              squi: double.parse(squiController.text),
              fat: double.parse(fatController.text),
              gram: double.parse(_grammController.text),
            ));
          },
          title: 'Update'),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  String splitText(String text) {
    if (text.length <= 20) {
      return text;
    }
    return text.substring(0, 20) + '...';
  }

  bool isStringOverSize(String text) {
    if (text.length <= 50) {
      return false;
    }
    return true;
  }
}
