//@dart=2.9
import 'dart:convert';
import 'dart:developer';

import 'package:calorica/models/diet.dart';
import 'package:calorica/models/range.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/home/home.dart';
import 'package:calorica/pages/product/widgets/dash_meal_product_card.dart';
import 'package:calorica/pages/product/widgets/widgets.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/dateProvider.dart';
import 'package:calorica/providers/local_providers/meal_product_history.dart';
import 'package:calorica/providers/local_providers/userProductsProvider.dart';
import 'package:calorica/providers/local_providers/wishlist_meal_product_provider.dart';
import 'package:calorica/utils/doubleRounder.dart';
import 'package:calorica/utils/method.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/dbModels.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../models/extraProductModel.dart';
import '../../../providers/local_providers/extraProductProvider.dart';
import '../../../providers/local_providers/productProvider.dart';
import '../../product/dashProduct.dart';
import '../../product/product.dart';
import '../../product/products_list.dart';
import '../../product/widgets/product_param_panel.dart';
import '../../wishlist/wishlist_meal_product_details.dart';
import 'app_bar.dart';
import 'half_app_bar.dart';

typedef void StringCallback(String val);

class DashMealWidget extends StatefulWidget {
  String _date;
  final StringCallback callback;
  Diet diet;
  DashMealWidget(
      {String date,
      this.data,
      this.dashMeal,
      this.callback,
      this.diet,
      this.onAddPress,
      this.onPress})
      : _date = date;
  DateProducts data;
  DashMeal dashMeal;
  Function onPress, onAddPress;
  @override
  _DashMealWidgetState createState() => _DashMealWidgetState(_date);
}

class _DashMealWidgetState extends State<DashMealWidget> {
  String date;
  _DashMealWidgetState(this.date);
  var intDate;

  ScrollController scrollController;
  double calory = 0.0;
  double squi = 0.0;
  double fat = 0.0;
  double carboh = 0.0;
  int dateInt;
  bool isEdit = false;
  TextEditingController nameController = TextEditingController();
  List<WishlistMealProduct> foodItems = [];

  RangeGraphData rCalory =
      RangeGraphData(name: "кКалории", percent: 0.0, weigth: 0);
  RangeGraphData rFat = RangeGraphData(name: "Жиры", percent: 0.0, weigth: 0);
  RangeGraphData rSqui = RangeGraphData(name: "Белки", percent: 0.0, weigth: 0);
  RangeGraphData rCarboh =
      RangeGraphData(name: "Углеводы", percent: 0.0, weigth: 0);
  @override
  void initState() {
    super.initState();

    setCounters();
  }

  setCounters() {
    calory = 0.0;
    squi = 0.0;
    fat = 0.0;
    carboh = 0.0;
    dateInt = null;
    intDate = null;
    intDate = int.parse(date);

    dateInt = int.parse(date);

    DBDashMealProductProvider.db
        .getProductByMealID(widget.dashMeal.id)
        .then((products) {
      foodItems = products;
      for (WishlistMealProduct product in foodItems) {
        calory += product.calory;
        squi += product.squi;
        fat += product.fat;
        carboh += product.carboh;
        rFat.weigth = checkDouble(fat);
        rCarboh.weigth = checkDouble(carboh);
        rSqui.weigth = checkDouble(squi);
        rCalory.weigth = checkDouble(calory);
        rFat.limit = checkDouble(widget.diet != null ? widget.diet.fat : 0.0);
        rSqui.limit = checkDouble(widget.diet != null ? widget.diet.squi : 0.0);
        rCalory.limit =
            checkDouble(widget.diet != null ? widget.diet.calory : 0.0);
        rCarboh.limit =
            checkDouble(widget.diet != null ? widget.diet.carboh : 0.0);
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 0,
      ),
      child: Container(
        padding: const EdgeInsets.all(0.0),
        // constraints:
        //     BoxConstraints.expand(height: MediaQuery.of(context).size.height),
        child: Padding(
          padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Column(
                children: [
                  HalfAppBar(
                      onPress: () {
                        widget.onPress();
                      },
                      id: widget.dashMeal.id,
                      name: widget.dashMeal.name,
                      surname: ''),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 0.0, bottom: 20.0, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "В этот день вы съели:",
                      style: DesignTheme.lilGrayText,
                    ),
                  ],
                ),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: foodItems.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      child: DashMealProductCard(
                        isLastItem: (foodItems.length - 1) == index,
                        product: foodItems[index],
                        onAddFoodPress: () async {
                          Product product = await Get.to(() => AddPage(
                                isExtraFood: true,
                                isWishList: true,
                              ));
                          if (product != null) {
                            await DBDashMealProductProvider.db
                                .checkProductExist(
                                    widget.dashMeal.id, product.id)
                                .then((value) async {
                              if (value.isNotEmpty) {
                                Fluttertoast.showToast(msg: 'Already added!');
                              } else {
                                WishlistMealProduct wp =
                                    WishlistMealProduct.castWishlistMealProduct(
                                        product, 100);
                                wp.mealID = widget.dashMeal.id;
                                await DBDashMealProductProvider.db
                                    .addProduct(wp)
                                    .then((value) {
                                  widget.onAddPress();
                                });
                              }
                            });
                          }
                        },
                        onPress: null,
                      ),
                      onTap: () async {
                        WishlistMealProduct product =
                            await Get.to(() => WishlistMealProductDetails(
                                  product: foodItems[index],
                                ));

                        if (product != null) {
                          foodItems[index].gram = product.gram;
                          foodItems[index].calory = product.calory;
                          foodItems[index].carboh = product.carboh;
                          foodItems[index].squi = product.squi;
                          foodItems[index].fat = product.fat;

                          DBDashMealProductProvider.db
                              .updateProduct(foodItems[index]);
                          widget.onAddPress();
                        }
                      },
                    );
                  })
            ],
          ),
        ),
      ),
    );
  }

  getDayCard() {
    return Container(
      decoration: BoxDecoration(
        color: DesignTheme.whiteColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: [DesignTheme.originalShadow],
      ),
      child: Padding(
        padding: EdgeInsets.only(left: 15, right: 15, bottom: 20, top: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (!isEdit)
                    Text(
                      widget.dashMeal != null
                          ? widget.dashMeal.name
                          : '${widget.data.name != null && widget.data.name != '' ? widget.data.name : 'Meal ${widget.data.id}'}',
                      style: isStringOverSize(date)
                          ? DesignTheme.bigText3
                          : DesignTheme.bigText3,
                      textAlign: TextAlign.start,
                    ),
                  if (isEdit)
                    ProductParamPanel(
                      type: TextInputType.text,
                      value: squi,
                      title: "Meal Name",
                      controller: nameController,
                    ),
                  if (!isEdit)
                    IconButton(
                        onPressed: () {
                          setState(() {
                            isEdit = true;
                          });
                        },
                        icon: Icon(Icons.edit)),
                  if (isEdit)
                    IconButton(
                        onPressed: () {
                          if (widget.dashMeal != null) {
                            DBDashMealProvider.db.updateNameMeals(
                                widget.dashMeal.id, nameController.text);
                          } else {
                            DBDateProductsProvider.db.updateNameProducts(
                                widget.data.id, nameController.text);
                          }
                          setState(() {
                            isEdit = false;
                          });
                          Home.of(context).string = "refresh";

                          // Get.back(result: 'refresh');
                        },
                        icon: Icon(Icons.save))
                ],
              ),
              Text(
                DateFormat('yyyy-MM-dd')
                    .format(DateTime.fromMillisecondsSinceEpoch(dateInt)),
                style: isStringOverSize(date)
                    ? DesignTheme.primeText16
                    : DesignTheme.primeText16,
                textAlign: TextAlign.start,
              ),
              SizedBox(height: 30),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          getParamText(roundDouble(calory, 2), " кКал"),
                          getParamText(roundDouble(squi, 2), " Белки г."),
                        ]),
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          getParamText(roundDouble(fat, 2), " Жир г."),
                          getParamText(roundDouble(carboh, 2), " Углеводы г."),
                        ])
                  ]),
            ]),
      ),
    );
  }

  getParamText(double value, String name) {
    return Padding(
        padding: EdgeInsets.only(left: 5, bottom: 5, top: 5),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                value.toString(),
                style: DesignTheme.midleMainText,
              ),
              Text(
                name,
                style: DesignTheme.labelSearchText,
              ),
            ]));
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

getKBGUText(data) {
  return data.calory.toString() +
      " кКал     " +
      data.squi.toString() +
      " Б     " +
      data.fat.toString() +
      " Ж     " +
      data.carboh.toString() +
      " У";
}
