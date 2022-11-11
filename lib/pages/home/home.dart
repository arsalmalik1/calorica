//@dart=2.9
import 'dart:developer';

import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/dbModels.dart';
import 'package:calorica/models/diet.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/days/day_meals.dart';
import 'package:calorica/pages/home/widgets/empty_appbar.dart';
import 'package:calorica/pages/home/widgets/widgets.dart';
import 'package:calorica/pages/product/products_list.dart';
import 'package:calorica/pages/stats/daydata.dart';
import 'package:calorica/pages/wishlist/wishlist.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/dietProvider.dart';
import 'package:calorica/providers/local_providers/mealHistoryProvider.dart';
import 'package:calorica/providers/local_providers/meal_product_history.dart';
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
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../models/extraProductModel.dart';
import '../../providers/local_providers/dateProvider.dart';
import '../../providers/local_providers/extraProductProvider.dart';
import '../../providers/local_providers/productProvider.dart';
import '../../utils/dateHelpers/dateFromInt.dart';
import '../stats/history.dart';
import 'widgets/dashMealWidget.dart';

class Data {
  int id;

  Data({this.id});
}

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
  static _HomeState of(BuildContext context) =>
      context.findAncestorStateOfType<_HomeState>();
}

class _HomeState extends State<Home> {
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
  // double countFat = 0.0;
  double countCarboh = 0.0;
  int countDateInt = null;
  var dataExist;
  @override
  void initState() {
    super.initState();
    spLogout();
    checkDailyMeal();
    getUserDetails();
    getDashMeal();
  }

  getUserDetails() {
    DBUserProvider.db.getUser().then((res) {
      name = res.name;
      surname = res.surname;
      isNameSurnameBig = !((name + " " + surname).length <= 11);
      isNameBiggerSurname = name.length > surname.length;
      setState(() {});
    });
  }

  getDashMeal() {
    calory = RangeGraphData(name: "кКалории", percent: 0.0, weigth: 0);
    fat = RangeGraphData(name: "Жиры", percent: 0.0, weigth: 0);
    squi = RangeGraphData(name: "Белки", percent: 0.0, weigth: 0);
    carboh = RangeGraphData(name: "Углеводы", percent: 0.0, weigth: 0);
    caloryNow = 0.0;
    squiNow = 0.0;
    fatNow = 0.0;
    carbohNow = 0.0;

    caloryLimit = 2900.0;
    squiLimit = 100.0;
    fatLimit = 100.0;
    carbohLimit = 400.0;

    caloryPercent = 0.0;
    squiPercent = 0.0;
    fatPercent = 0.0;
    carbohPercent = 0.0;

    DBDashMealProvider.db.getDashDateBaseMeals(echoDate(), 1).then((dashMeals) {
      for (DashMeal meal in dashMeals) {
        getMealProducts(meal.id);
      }
    });
  }

  getDietDetails() {
    Diet diet;

    DBDietProvider.db.getDietById(1).then((_diet) {
      diet = _diet;
      if (this.mounted) {
        setState(() {
          caloryLimit = diet.calory;
          squiLimit = diet.squi;
          fatLimit = diet.fat;
          carbohLimit = diet.carboh;
        });
      }
    });
  }

  getMealProducts(int mealID) {
    DBDashMealProductProvider.db.getProductByMealID(mealID).then((products) {
      paddingTop = products.length > 0 ? paddingTop : 200;
      for (WishlistMealProduct product in products) {
        caloryNow = roundDouble(caloryNow + product.calory, 2);
        squiNow = roundDouble(squiNow + product.squi, 2);
        fatNow = roundDouble(fatNow + product.fat, 2);
        carbohNow = roundDouble(carbohNow + product.carboh, 2);
      }

      calory.weigth = caloryNow;
      fat.weigth = fatNow;
      squi.weigth = squiNow;
      carboh.weigth = carbohNow;

      calory.limit = caloryLimit;
      fat.limit = fatLimit;
      squi.limit = squiLimit;
      carboh.limit = carbohLimit;

      calory.percent = (caloryNow / caloryLimit) * 100 <= 100
          ? (caloryNow / caloryLimit) * 100
          : 100;
      fat.percent =
          (fatNow / fatLimit) * 100 <= 100 ? (fatNow / fatLimit) * 100 : 100;
      squi.percent = (squiNow / squiLimit) * 100 <= 100
          ? (squiNow / squiLimit) * 100
          : 100;
      carboh.percent = (carbohNow / carbohLimit) * 100 <= 100
          ? (carbohNow / carbohLimit) * 100
          : 100;
      if (mounted) {
        setState(() {});
      }
    });
  }

  getDate(DateTime date) {
    return '${date.day} ${date.month} ${date.year}';
  }

  checkDailyMeal() async {
    await DBDashMealProvider.db.getDashMeals().then((meal) async {
      if (meal.isNotEmpty) {
        for (DashMeal m in meal) {
          String mealDate = getDate(m.date);
          String todayDate = getDate(DateTime.now());
          if (mealDate != todayDate) {
            await DBDashMealHistoryProvider.db
                .addDashMeals(m)
                .then((value) async {
              await DBDashMealProvider.db.deleteDashMeal(m.id);
              checkMealProducts(m.id, value.id);
            });
          }
        }
      }
    });
  }

  checkMealProducts(id, newID) async {
    await DBDashMealProductProvider.db
        .getProductByMealID(id)
        .then((mealProducts) async {
      for (WishlistMealProduct product in mealProducts) {
        product.mealID = newID;
        await DBMealProductHistoryProvider.db.addProduct(product);
      }
      DBDashMealProductProvider.db.deleteProductsByMeal(id);
    });
  }

  spLogout() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    sp.setBool('is_login', false);
  }

  int echoDate() {
    var nowDate = DateTime.now();
    var _date = DateTime(nowDate.year, nowDate.month, nowDate.day);

    int now = epochFromDate(_date);
    return now;
  }

  // getTotalCounts() {
  //   countCalory = 0.0;
  //   countSqui = 0.0;
  //   countFat = 0.0;
  //   countCarboh = 0.0;
  //   countDateInt = null;
  //   Future.delayed(const Duration(milliseconds: 500), () {
  //     DBDashMealProvider.db.getDashDateBaseMeals(echoDate(), 1).then((value) {
  //       for (DashMeal meal in value) {
  //         setCounters(epochFromDate(meal.date).toString());
  //       }
  //     });
  //   });
  // }

  // setCounters(date) {
  //   countDateInt = int.parse(date);
  //   DBUserProductsProvider.db.getProductsByDate(countDateInt).then((products) {
  //     for (var product in products) {
  //       setState(() {
  //         countCalory += product.calory;
  //         countSqui += product.squi;
  //         countFat += product.fat;
  //         countCarboh += product.carboh;
  //       });
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     DBDashMealProvider.db.getDashMeals().then((value) {
      //       print('Dash Meal ${value.length}');
      //       for (var p in value) {
      //         print(p.id);
      //       }
      //     });
      //     DBDashMealProductProvider.db.getProducts().then((value) {
      //       print('Dash Products ${value.length}');
      //       for (var p in value) {
      //         print(p.id);
      //         print(p.mealID);
      //         print(p.productID);
      //       }
      //     });
      //     DBWishlisthMealProvider.db.getWishlistMeals().then((value) {
      //       print('Wishlist Meal ${value.length}');
      //     });
      //     DBWishlistMealProductProvider.db.getProducts().then((value) {
      //       print('Wishlist Products ${value.length}');
      //     });
      //     DBDashMealHistoryProvider.db.getDashMeals().then((value) {
      //       print('History Meal ${value.length}');
      //     });
      //     DBMealProductHistoryProvider.db.getProducts().then((value) {
      //       print('History Products ${value.length}');
      //     });
      //   },
      //   child: Text('+'),
      // ),

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
              HomeToolBar(
                fat: fat.weigth,
                calorie: calory.weigth,
                carboh: carboh.weigth,
                squi: squi.weigth,
              ),
              EmptyAppBar(
                  name: name,
                  surname: surname,
                  calory: calory,
                  squi: squi,
                  fat: fat,
                  carboh: carboh),
              Expanded(
                  child: FutureBuilder(
                      future: DBDashMealProvider.db
                          .getDashDateBaseMeals(echoDate(), 1),
                      // ignore: missing_return
                      builder: (BuildContext context,
                          AsyncSnapshot<List<DashMeal>> snapshot) {
                        switch (snapshot.connectionState) {
                          case ConnectionState.none:
                            return Text('Input a URL to start');
                          case ConnectionState.waiting:
                            return Center(child: CircularProgressIndicator());
                          case ConnectionState.active:
                            return Text('');
                          case ConnectionState.done:
                            if (snapshot.hasError) {
                              dataExist = null;
                              return Text(
                                '${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              );
                            } else if (snapshot.data.isEmpty) {
                              dataExist = null;
                              return Container(
                                width: double.infinity,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // EmptyAppBar(
                                    //     name: name,
                                    //     surname: surname,
                                    //     calory: calory,
                                    //     squi: squi,
                                    //     fat: fat,
                                    //     carboh: carboh),
                                    SvgPicture.asset('assets/svg/noMeal.svg'),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        TextButton(
                                            onPressed: () {
                                              Get.to(() => WishList());
                                            },
                                            child: Text('Add Meal',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18))),
                                        Container(
                                            width: 1,
                                            height: 20,
                                            color: Colors.green),
                                        TextButton(
                                            onPressed: () {
                                              Get.to(() => DayMeals());
                                            },
                                            child: Text('Add Day',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 18))),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (context, i) {
                                  return DashMealWidget(
                                    diet: diet,
                                    onAddPress: () {
                                      getDashMeal();
                                      setState(() {});
                                    },
                                    onPress: () {
                                      getDashMeal();

                                      setState(() {});
                                    },
                                    callback: (val) {
                                      getDashMeal();

                                      setState(() {});
                                    },
                                    date: epochFromDate(snapshot.data[i].date)
                                        .toString(),
                                    dashMeal: snapshot.data[i],
                                  );
                                },
                              );
                            }
                        }
                      })),
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
