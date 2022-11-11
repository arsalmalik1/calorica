//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';
import 'package:calorica/pages/days/day_meals.dart';
import 'package:calorica/pages/wishlist/wishlist.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

class DashMealProductCard extends StatelessWidget {
  const DashMealProductCard(
      {Key key,
      @required this.product,
      this.isLastItem = false,
      this.onAddFoodPress,
      @required this.onPress})
      : super(key: key);
  final Function onPress, onAddFoodPress;
  final WishlistMealProduct product;
  final bool isLastItem;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Column(
      children: [
        Container(
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
                      product.name,
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
                    product.calory.toString() +
                        " кКал     " +
                        product.squi.toString() +
                        " Б     " +
                        product.fat.toString() +
                        " Ж     " +
                        product.carboh.toString() +
                        " У",
                    style: DesignTheme.secondaryText.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (isLastItem) buttonList()
      ],
    );
  }

  buttonList() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
            onPressed: () async {
              onAddFoodPress();
            },
            child: Text(
              'Add Food',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
        Container(width: 1, height: 20, color: Colors.green),
        TextButton(
            onPressed: () async {
              Get.to(() => WishList());
            },
            child: Text(
              'Add Meal',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
        Container(width: 1, height: 20, color: Colors.green),
        TextButton(
            onPressed: () async {
              Get.to(() => DayMeals());
            },
            child: Text(
              'Add Day',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            )),
      ],
    );
  }
}
