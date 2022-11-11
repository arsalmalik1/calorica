//@dart=2.9
import 'dart:developer';

import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/extraProductModel.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/dateProvider.dart';
import 'package:calorica/providers/local_providers/extraProductProvider.dart';
import 'package:calorica/providers/local_providers/meal_product_history.dart';

import 'package:calorica/utils/dateHelpers/dateFromInt.dart';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../providers/local_providers/mealHistoryProvider.dart';
import '../stats/daydata.dart';
import 'day_meal_details.dart';

class DayMeals extends StatefulWidget {
  bool isDash;
  DayMeals({this.isDash = false});
  @override
  _DayMealsState createState() => _DayMealsState();
}

class _DayMealsState extends State<DayMeals> {
  bool isSaerching = false;
  ScrollController scrollController;
  String searchText;

  void startSearch(String text) {
    setState(() {
      isSaerching = true;
      searchText = text;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
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
            "История питания",
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
        body: Padding(
          padding: EdgeInsets.only(
            top: 15,
            left: 20,
            right: 20,
          ),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                  Widget>[
            Padding(
              padding: EdgeInsets.only(top: 15, bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                    color: DesignTheme.whiteColor,
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [DesignTheme.originalShadow]),
                child: TextFormField(
                  onChanged: (text) {
                    startSearch(text);
                  },
                  style: DesignTheme.inputText,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    icon: Padding(
                      padding: EdgeInsets.only(
                        left: 15,
                      ),
                      child: Icon(
                        Icons.search,
                        color: CustomTheme.mainColor,
                      ),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5.0, horizontal: 15.0),
                    labelText: 'Поиск по дате...',
                    border: InputBorder.none,
                    labelStyle: DesignTheme.labelSearchText,
                  ),
                  onEditingComplete: () {},
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 15,
              ),
              child: Text(
                "Итория приема пищи в днях:",
                style: DesignTheme.lilGrayText,
              ),
            ),
            Flexible(
              child: Container(
                  padding: const EdgeInsets.all(0.0),
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height),
                  child: FutureBuilder(
                      future: DBDashMealHistoryProvider.db.getDashMeals(),
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
                              return Text(
                                '${snapshot.error}',
                                style: TextStyle(color: Colors.red),
                              );
                            } else {
                              return StaggeredGridView.countBuilder(
                                  controller: scrollController,
                                  padding: const EdgeInsets.all(7.0),
                                  mainAxisSpacing: 3,
                                  crossAxisSpacing: 0,
                                  crossAxisCount: 4,
                                  itemCount: snapshot.data.length,
                                  itemBuilder: (context, i) {
                                    return InkWell(
                                      child: getCard(snapshot.data[i]),
                                      onTap: () {
                                        Get.to(() => DayMealDetails(
                                            onDelete: () {
                                              setState(() {});
                                            },
                                            date: epochFromDate(
                                                    snapshot.data[i].date)
                                                .toString(),
                                            dashMeal: snapshot.data[i]));
                                      },
                                      onLongPress: () async {
                                        DBDashMealHistoryProvider.db
                                            .deleteDashMeal(snapshot.data[i].id)
                                            .then((value) {
                                          DBMealProductHistoryProvider.db
                                              .deleteAllMealProducts(
                                                  snapshot.data[i].id);
                                          setState(() {});
                                        });
                                      },
                                    );
                                  },
                                  staggeredTileBuilder: (int i) =>
                                      StaggeredTile.count(4, 1));
                            }
                        }
                      })),
            ),
          ]),
        ),
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
                      '${data.name != null && data.name != '' ? data.name : 'Meal ${data.id}'}',
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
                  onPressed: () async {
                    int force = 0;
                    var nowDate = DateTime.now();
                    var _date =
                        DateTime(nowDate.year, nowDate.month, nowDate.day);
                    await DBDashMealProvider.db
                        .addDashMeals(DashMeal(
                            date: _date,
                            force: force,
                            mealID: data.id,
                            name: data.name != null && data.name != ''
                                ? data.name
                                : 'Meal ${data.id}',
                            ids: data.ids,
                            type: 'day'))
                        .then((meal) async {
                      await DBMealProductHistoryProvider.db
                          .getProductByMealID(data.id)
                          .then((historyProducts) async {
                        for (WishlistMealProduct product in historyProducts) {
                          product.mealID = meal.id;
                          await DBDashMealProductProvider.db
                              .addProduct(product);
                        }
                        Navigator.popAndPushNamed(context, '/navigator/1');
                      });
                    });
                  },
                  icon: Icon(
                    Icons.add,
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
