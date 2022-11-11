//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/meal.dart';

import 'package:flutter/material.dart';

import '../../../providers/local_providers/userMealsProvider.dart';

class MealCard extends StatelessWidget {
  const MealCard(
      {Key key, @required this.meal, this.isDash = false, this.onPress})
      : super(key: key);
  final bool isDash;
  final Meal meal;
  final Function onPress;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 15, left: 15),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: DesignTheme.shadowByOpacity(0.05),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: size.width * 0.6,
                child: Text(
                  meal.name,
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 15,
                    letterSpacing: -0.2,
                    color: DesignTheme.blackLightTextColor,
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                '',
                style: DesignTheme.secondaryText.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              splashColor: CustomTheme.mainColor,
              hoverColor: CustomTheme.mainColor,
              onPressed: () => _openMealPage(meal, context),
              icon: Icon(
                isDash ? Icons.remove : Icons.add,
                color: CustomTheme.mainColor,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _openMealPage(Meal meal, BuildContext context) async {
    if (!isDash) {
      await DBUserMealProvider.db.addUserMeal(meal);
      Navigator.popAndPushNamed(context, '/navigator/1');
    } else {
      onPress();
    }
  }
}
