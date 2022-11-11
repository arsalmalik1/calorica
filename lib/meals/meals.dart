//@dart=2.9
import 'package:calorica/models/meal.dart';
import 'package:calorica/providers/local_providers/userMealsProvider.dart';
import 'package:calorica/widgets/crads/info_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../pages/product/widgets/fooditem_appbar.dart';
import '../pages/product/widgets/meal_card.dart';
import '../pages/product/widgets/search_meal.dart';
import '../providers/local_providers/mealsProvider.dart';
import 'addmeal.dart';

class Meals extends StatefulWidget {
  @override
  _MealsState createState() => _MealsState();
}

class _MealsState extends State<Meals> {
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FooditemsListAppBar(
                title: 'Meals',
                onPress: () async {
                  String result = await Get.to(() => AddMeal());
                  if (result == 'refresh') {
                    setState(() {});
                  }
                },
              ),
              MealSearchBar(
                onChanged: (String text) {
                  startSearch(text);
                },
              ),
              InfoCard(title: "Meals"),
              Flexible(
                child: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height),
                  child: FutureBuilder(
                    future: isSaerching
                        ? DBMealProvider.db.getAllMealsSearch(searchText)
                        : DBMealProvider.db.getAllMeals(),
                    // ignore: missing_return
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Meal>> snapshot) {
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
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                  child: MealCard(
                                    meal: snapshot.data[i],
                                  ),
                                  onTap: () => _openMealPage(snapshot.data[i]),
                                );
                              },
                            );
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openMealPage(Meal meal) async {}
}
