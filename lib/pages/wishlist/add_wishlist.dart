//@dart=2.9
import 'dart:developer';

import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/dbModels.dart';
import 'package:calorica/models/diet.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/home/widgets/widgets.dart';
import 'package:calorica/pages/product/products_list.dart';
import 'package:calorica/pages/stats/daydata.dart';
import 'package:calorica/pages/wishlist/wishlist_appbar.dart';
import 'package:calorica/pages/wishlist/wishlist_meal_product_details.dart';
import 'package:calorica/pages/wishlist/wishlist_meal_widget.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/dietProvider.dart';
import 'package:calorica/providers/local_providers/userProductsProvider.dart';
import 'package:calorica/providers/local_providers/wishlist_meal_product_provider.dart';
import 'package:calorica/providers/local_providers/wishlist_meal_provider.dart';
import 'package:calorica/utils/doubleRounder.dart';
import 'package:calorica/utils/method.dart';
import 'package:calorica/models/range.dart';

import 'package:flutter/material.dart';
import 'package:calorica/providers/local_providers/userProvider.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../providers/local_providers/dateProvider.dart';
import '../../utils/dateHelpers/dateFromInt.dart';
import '../../widgets/buttons/tool_bar_button.dart';
import '../home/widgets/dashMealWidget.dart';
import '../stats/history.dart';
import 'wishlist_meal_product_card.dart';
import 'wishlist_product_card.dart';

class Data {
  int id;

  Data({this.id});
}

class AddWishList extends StatefulWidget {
  @override
  _AddWishListState createState() => _AddWishListState();
  static _AddWishListState of(BuildContext context) =>
      context.findAncestorStateOfType<_AddWishListState>();
}

class _AddWishListState extends State<AddWishList> {
  ScrollController scrollController;
  List<UserProduct> userProducts;
  double caloryNow = 0.0;
  double squiNow = 0.0;
  double fatNow = 0.0;
  double carbohNow = 0.0;

  double caloryLimit = 2900.0;
  double squiLimit = 100.0;
  double fatLimit = 100.0;
  double carbohLimit = 400.0;

  double caloryPercent = 0.0;
  double squiPercent = 0.0;
  double fatPercent = 0.0;
  double carbohPercent = 0.0;

  bool isNameSurnameBig = false;
  bool isNameBiggerSurname = false;

  String name = "";
  String surname = "";
  List<Data> data = [];
  List<DateProducts> emptyProduct = [];
  List<WishlistMealProduct> products = [];
  double paddingTop = 280;

  RangeGraphData calory =
      RangeGraphData(name: "кКалории", percent: 0.0, weigth: 0);
  RangeGraphData fat = RangeGraphData(name: "Жиры", percent: 0.0, weigth: 0);
  RangeGraphData squi = RangeGraphData(name: "Белки", percent: 0.0, weigth: 0);
  RangeGraphData carboh =
      RangeGraphData(name: "Углеводы", percent: 0.0, weigth: 0);

  String _string = "";

  set string(String value) => setState(() => _string = value);
  Diet diet;
  double countCalory = 0.0;
  double countSqui = 0.0;
  double countFat = 0.0;
  double countCarboh = 0.0;
  int countDateInt = null;

  @override
  void initState() {
    super.initState();

    DBUserProvider.db.getUser().then((res) {
      DBUserProductsProvider.db.getAllProducts().then((products) {
        paddingTop = products.length > 0 ? paddingTop : 200;

        DBDietProvider.db.getDietById(1).then((_diet) {
          diet = _diet;

          if (this.mounted) {
            setState(() {
              name = res.name;

              surname = res.surname;
              caloryLimit = checkDouble(diet?.calory);
              squiLimit = diet?.squi ?? 0.0;
              fatLimit = diet?.fat ?? 0.0;
              carbohLimit = diet?.carboh ?? 0.0;

              isNameSurnameBig = !((name + " " + surname).length <= 11);
              isNameBiggerSurname = name.length > surname.length;
            });
          }

          for (var i = 0; i < products.length; i++) {
            caloryNow = roundDouble(caloryNow + products[i].calory, 2);
            squiNow = roundDouble(squiNow + products[i].squi, 2);
            fatNow = roundDouble(fatNow + products[i].fat, 2);
            carbohNow = roundDouble(carbohNow + products[i].carboh, 2);
          }

          if (this.mounted) {
            setState(() {
              calory.weigth = caloryNow;
              fat.weigth = fatNow;
              squi.weigth = squiNow;
              carboh.weigth = carbohNow;

              caloryLimit = checkDouble(caloryLimit);
              fatLimit = checkDouble(fatLimit);
              squiLimit = checkDouble(squiLimit);
              carbohLimit = checkDouble(carbohLimit);

              calory.limit = caloryLimit;
              fat.limit = fatLimit;
              squi.limit = squiLimit;
              carboh.limit = carbohLimit;

              calory.percent = (caloryNow / caloryLimit) * 100 <= 100
                  ? (caloryNow / caloryLimit) * 100
                  : 100;
              fat.percent = (fatNow / fatLimit) * 100 <= 100
                  ? (fatNow / fatLimit) * 100
                  : 100;
              squi.percent = (squiNow / squiLimit) * 100 <= 100
                  ? (squiNow / squiLimit) * 100
                  : 100;
              carboh.percent = (carbohNow / carbohLimit) * 100 <= 100
                  ? (carbohNow / carbohLimit) * 100
                  : 100;
            });
          }
        });
      });
    });
    for (var i = 0; i < 6; i++) {
      data.add(Data(id: i));
    }

    spLogout();
    // getTotalCounts();
  }

  spLogout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('is_login', false);

    // bool isRemember = sp.getBool('is_remember');
    // if (!isRemember) {
    //   sp.setBool('is_remember', false);

    //   print('logout');
    // }
  }

  int echoDate() {
    var nowDate = DateTime.now();
    var _date = DateTime(nowDate.year, nowDate.month, nowDate.day);

    int now = epochFromDate(_date);
    return now;
  }

  setCounters() {
    countCalory = 0.0;
    countSqui = 0.0;
    countCarboh = 0.0;
    countFat = 0.0;
    if (products.isNotEmpty) {
      for (WishlistMealProduct product in products) {
        print(product.calory);
        setState(() {
          countCalory += product.calory;
          countSqui += product.squi;
          countFat += product.fat;
          countCarboh += product.carboh;
        });
      }
    } else {
      setState(() {});
    }
  }

  TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: IconButton(
      //   icon: Icon(Icons.remove),
      //   onPressed: () {
      //     DBWishlistMealProductProvider.db.deleteAllWishlistMealProducts();
      //   },
      // ),
      resizeToAvoidBottomInset: false,
      backgroundColor: DesignTheme.backgroundColor,
      body: Stack(
        children: [
          Container(
            constraints: BoxConstraints.expand(height: 190),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                CustomTheme.mainColor[600],
                CustomTheme.mainColor[900],
              ]),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              WishListBar(
                fat: countFat,
                calorie: countCalory,
                carboh: countCarboh,
                squi: countSqui,
                controller: controller,
                onRightPress: () async {
                  Product result = await Get.to(() => AddPage(
                        isWishList: true,
                      ));
                  if (result != null) {
                    bool isExist = false;
                    for (WishlistMealProduct p in products) {
                      if (p.productID == result.id) {
                        isExist = true;
                        Fluttertoast.showToast(msg: 'Already added!');
                        break;
                      }
                    }
                    if (!isExist) {
                      products.add(WishlistMealProduct.castWishlistMealProduct(
                          result, 100.0));
                      setState(() {});
                    } else {}
                    setCounters();
                  }
                },
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  width: Get.size.width * 0.5,
                  child: ToolBarIconButton(
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              '${countCalory.round()}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'кКалории',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              '${countFat.round()}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Жиры',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              '${countSqui.round()}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Белки',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Column(
                          children: [
                            Text(
                              '${countCarboh.round()}',
                              style: TextStyle(
                                  fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            Text(
                              'Углеводы',
                              style: TextStyle(fontSize: 8),
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: () {},
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                  child: products.isEmpty
                      ? emptyData()
                      : ListView.builder(
                          itemCount: products.length,
                          itemBuilder: (c, i) {
                            return GestureDetector(
                              onTap: () async {
                                WishlistMealProduct product = await Get.to(
                                    () => WishlistMealProductDetails(
                                          product: products[i],
                                        ));
                                if (product != null) {
                                  products[i].gram = product.gram;
                                  products[i].fat = product.fat;
                                  products[i].squi = product.squi;
                                  products[i].calory = product.calory;
                                  products[i].carboh = product.carboh;
                                  setCounters();
                                }
                              },
                              child: WishlistMealProductCard(
                                check: 'remove',
                                product: products[i],
                                onPress: () {
                                  products.removeAt(i);
                                  setCounters();
                                },
                              ),
                            );
                          },
                        )),
              Container(
                padding: EdgeInsets.all(20),
                child: Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.greenAccent,
                  child: MaterialButton(
                      padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                      minWidth: MediaQuery.of(context).size.width,
                      onPressed: () async {
                        if (controller.text.isEmpty || products.isEmpty) {
                          Fluttertoast.showToast(
                              msg: 'Meal Name & Food items required!');
                        } else {
                          List ids = [];
                          for (WishlistMealProduct p in products) {
                            ids.add(p.productID);
                          }

                          DashMeal meal = DashMeal(
                              date: DateTime.now(),
                              ids: '$ids',
                              name: controller.text);
                          await DBWishlisthMealProvider.db
                              .addWishlistMeals(meal)
                              .then((value) async {
                            for (WishlistMealProduct p in products) {
                              p.mealID = value.id;
                              await DBWishlistMealProductProvider.db
                                  .addProduct(p);
                            }
                            Get.back(result: 'refresh');
                          });
                        }
                      },
                      child: Text(
                        "Create Meal",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget emptyData() {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/svg/noMeal.svg'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () async {
                    Product result = await Get.to(() => AddPage(
                          isWishList: true,
                        ));
                    if (result != null) {
                      products.add(WishlistMealProduct.castWishlistMealProduct(
                          result, 100.0));
                      setState(() {});
                    }
                  },
                  child: Text(
                    'Add Food',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  )),
            ],
          ),
        ],
      ),
    );
  }

  getCard(DashMeal data) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      elevation: 1.0,
      child: Padding(
        padding: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5, left: 15),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    //TYT
                    Text(
                      data.name,
                      style: DesignTheme.primeTextBold,
                    ),
                    Text(
                      splitText(DateFormat('yyyy-MM-dd').format(data.date)),
                      style: DesignTheme.primeText16,
                    ),
                  ]),
              Align(
                alignment: Alignment.centerRight,
                child: IconButton(
                  splashColor: CustomTheme.mainColor,
                  hoverColor: CustomTheme.mainColor,
                  onPressed: () {
                    DBDashMealProvider.db.deleteDashMeal(data.id);
                    setState(() {});
                  },
                  icon: Icon(
                    Icons.remove,
                    color: CustomTheme.mainColor,
                    size: 28,
                  ),
                ),
              )
            ]),
      ),
    );
  }

  String splitText(String text) {
    if (text.length <= 22) {
      return text;
    }
    return text.substring(0, 22) + '...';
  }
}
