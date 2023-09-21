//@dart=2.9
import 'dart:developer';

import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/dbModels.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/stats/barGraph.dart';
import 'package:calorica/pages/stats/lineWeekGraph.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:calorica/providers/local_providers/dashMealProvider.dart';
import 'package:calorica/providers/local_providers/mealHistoryProvider.dart';
import 'package:calorica/providers/local_providers/userProductsProvider.dart';

import 'package:calorica/utils/dietSelector.dart';
import 'package:calorica/providers/local_providers/userProvider.dart';
import 'package:calorica/utils/stats/prepareDataByDay.dart';
import 'package:calorica/utils/stats/prepareDataByWeek.dart';
import 'package:calorica/widgets/crads/info_card.dart';
import 'package:calorica/widgets/stats/paramTextColumn.dart';
import 'package:calorica/widgets/textHelper.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../providers/local_providers/meal_product_history.dart';
import '../../utils/dateHelpers/dateFromInt.dart';
import '../../utils/doubleRounder.dart';
import '../days/day_meals.dart';
import 'widgets/widgets.dart';

class MainStats extends StatefulWidget {
  final Widget child;

  MainStats({Key key, this.child}) : super(key: key);

  _MainStatsState createState() => _MainStatsState();
}

class _MainStatsState extends State<MainStats> {
  List<charts.Series<GraphData, String>> _seriesData = [];
  List<charts.Series<GraphLinarData, String>> _chartData = [];

  List<UserProduct> userTodayProducts;
  List<UserProduct> userYesterdayProducts;

  UserProduct todayParams = null;
  UserProduct yesterdayParams = null;
  List<UserProduct> weekStats;

  var caloryLimit = 0.0;
  var caloryLimitDeltaL = 0.0;
  var caloryLimitDeltaR = 0.0;
  List<Widget> chartsWidgetList = [Center(child: CircularProgressIndicator())];
  List<Widget> lineTextList = [];

  bool isAutoPlay = true;

  @override
  void initState() {
    super.initState();
    getDetails();
  }

  getDetails() {
    getProductsCaloryByDateList().then((_weekStats) {
      setState(() {
        weekStats = _weekStats;
      });

      DBUserProvider.db.getUser().then((res) {
        var diet = selectDiet(res);
        caloryLimit = diet.calory;
        caloryLimitDeltaL = caloryLimit * 0.7;
        caloryLimitDeltaR = caloryLimit * 1.2;
      });
      getDashMealProduct();
    });
  }

  getDashMealProduct() async {
    List<UserProduct> _Todayproducts = [];
    List<UserProduct> _yesterdayProducts = [];

    await DBDashMealProvider.db
        .getDashDateBaseMeals(echoDate(DateTime.now()), 1)
        .then((meals) async {
      for (DashMeal meal in meals) {
        await DBDashMealProductProvider.db
            .getProductByMealID(meal.id)
            .then((products) {
          for (WishlistMealProduct product in products) {
            _Todayproducts.add(UserProduct(
                id: product.id,
                name: product.name,
                fat: product.fat,
                calory: product.calory,
                category: product.category,
                squi: product.squi,
                carboh: product.carboh,
                grams: product.gram,
                date: DateTime.now(),
                productId: product.productID));
          }
        });
      }
    });

    await DBDashMealHistoryProvider.db
        .getDashDateBaseMeals(
            echoDate(DateTime.now().subtract(Duration(days: 1))), 1)
        .then((meals) async {
      for (DashMeal meal in meals) {
        // await DBDashMealProductProvider.db
        //     .getProductByMealID(meal.id)
        await DBMealProductHistoryProvider.db
            .getProductByMealID(meal.id)
            .then((products) {
          for (WishlistMealProduct product in products) {
            _yesterdayProducts.add(UserProduct(
                id: product.id,
                name: product.name,
                fat: product.fat,
                calory: product.calory,
                category: product.category,
                squi: product.squi,
                carboh: product.carboh,
                grams: product.gram,
                date: DateTime.now().subtract(Duration(days: 1)),
                productId: product.productID));
          }
        });
      }
    });
    // if (_Todayproducts.isNotEmpty && _yesterdayProducts.isNotEmpty) {
    setProductsValues(_Todayproducts, _yesterdayProducts);
    // }
  }

  int echoDate(DateTime nowDate) {
    var _date = DateTime(nowDate.year, nowDate.month, nowDate.day);

    int now = epochFromDate(_date);
    return now;
  }

  setProductsValues(
      List<UserProduct> todayProd, List<UserProduct> yesterdayProd) {
    setState(() {
      todayParams = getProductsParamsSum(todayProd);
      yesterdayParams = getProductsParamsSum(yesterdayProd);
    });

    weekStats = [...yesterdayProd, ...todayProd];

    print(weekStats);
    setState(() {
      _chartData = createSampleData(weekStats);
      _seriesData = generateData(
        yesterdayParams,
        todayParams,
        caloryLimitDeltaR,
        caloryLimitDeltaL,
      );

      chartsWidgetList.removeLast();

      chartsWidgetList.add(
        getBarGraph(
          context,
          _seriesData,
          caloryLimitDeltaL,
          caloryLimitDeltaR,
          todayParams,
          yesterdayParams,
        ),
      );

      chartsWidgetList.add(
        getLineGraph(
          context,
          _chartData,
        ),
      );

      lineTextList.add(getOtherParamTextColumn(
        todayParams,
        yesterdayParams,
        ' кКалорий',
        getParamText(
            todayParams, yesterdayParams, caloryLimitDeltaR, caloryLimitDeltaL),
      ));
      lineTextList.add(
        getOtherParamTextColumn(
          todayParams.squi.roundToDouble(),
          yesterdayParams.squi.roundToDouble(),
          " г. белков",
          getOtherParamText(todayParams.squi.roundToDouble(),
              yesterdayParams.squi.roundToDouble()),
        ),
      );
      lineTextList.add(
        getOtherParamTextColumn(
          todayParams.fat.roundToDouble(),
          yesterdayParams.fat.roundToDouble(),
          " г. жиров",
          getOtherParamText(todayParams.fat.roundToDouble(),
              yesterdayParams.fat.roundToDouble()),
        ),
      );
      lineTextList.add(
        getOtherParamTextColumn(
          todayParams.carboh.roundToDouble(),
          yesterdayParams.carboh.roundToDouble(),
          " г. углеводов",
          getOtherParamText(todayParams.carboh.roundToDouble(),
              yesterdayParams.carboh.roundToDouble()),
        ),
      );
      lineTextList.add(
        getOtherParamTextColumn(
          todayParams.grams.roundToDouble(),
          yesterdayParams.grams.roundToDouble(),
          " грамм",
          getOtherParamText(todayParams.grams, yesterdayParams.grams),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 50, left: 20, right: 20),
              child: getStartText(
                todayParams,
                yesterdayParams,
                caloryLimitDeltaR,
                caloryLimitDeltaL,
              ),
            ),
            Container(
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(15.0),
                boxShadow: DesignTheme.shadowByOpacity(0.05),
              ),
              margin: EdgeInsets.all(15),
              padding: EdgeInsets.all(12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "История питания",
                          style: DesignTheme.primeTextBig,
                        ),
                        Text(
                          "Узнай как ты питаешься",
                          style: DesignTheme.secondaryTextBig,
                        ),
                      ]),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      splashColor: CustomTheme.mainColor,
                      hoverColor: CustomTheme.mainColor,
                      onPressed: () {
                        Get.to(() => DayMeals());
                        // Navigator.pushNamed(context, '/history');
                      },
                      icon: Icon(
                        Icons.arrow_forward_ios,
                        color: CustomTheme.mainColor,
                        size: 26,
                      ),
                    ),
                  )
                ],
              ),
            ),
            InfoCard(
              title:
                  "По сравнению с ${DateFormat('yyyy-MM-dd').format(DateTime.now().add(Duration(days: -1)))}",
              enableDivider: false,
            ),
            SizedBox(
              height: 10,
            ),
            StatsParamsPanel(
              items: lineTextList,
            ),
            Container(
              height: 290.0,
              child: CarouselSlider.builder(
                itemCount: chartsWidgetList.length,
                itemBuilder: (context, index, i) {
                  return chartsWidgetList[index];
                },
                options: CarouselOptions(
                    height: 290.0,
                    viewportFraction: 1,
                    autoPlay: isAutoPlay,
                    autoPlayCurve: Curves.easeInExpo,
                    autoPlayInterval: const Duration(seconds: 8),
                    onPageChanged: (index, reason) {}),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
