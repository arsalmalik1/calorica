//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/food_item.dart';

import 'package:flutter/material.dart';

class FoodItemCard extends StatelessWidget {
  const FoodItemCard({
    Key key,
    @required this.foodItem,
  }) : super(key: key);

  final FoodItem foodItem;

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
                width: size.width * 0.7,
                child: Text(
                  foodItem.name,
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
                foodItem.calories.toString() +
                    " кКал     " +
                    foodItem.protiens.toString() +
                    " Б     " +
                    foodItem.fats.toString() +
                    " Ж     " +
                    foodItem.carbohydrate.toString() +
                    " У",
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
              onPressed: () => _openFoodItemPage(foodItem, context),
              icon: Icon(
                Icons.add,
                color: CustomTheme.mainColor,
                size: 28,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _openFoodItemPage(FoodItem foodItem, BuildContext context) {
    // Navigator.pushNamed(
    //   context,
    //   '/product/' + product.id.toString(),
    // );
  }
}
