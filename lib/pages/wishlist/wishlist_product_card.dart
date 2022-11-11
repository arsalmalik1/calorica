//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/wishlist_meal_product_model.dart';

import 'package:flutter/material.dart';

import 'package:calorica/models/dbModels.dart';

class WishlistProductCard extends StatelessWidget {
  const WishlistProductCard(
      {Key key,
      @required this.product,
      @required this.check,
      @required this.onPress})
      : super(key: key);
  final String check;
  final Function onPress;
  final Product product;

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
          if (check != 'hide')
            Align(
              alignment: Alignment.centerRight,
              child: IconButton(
                splashColor: CustomTheme.mainColor,
                hoverColor: CustomTheme.mainColor,
                onPressed: () {
                  onPress();
                },
                icon: Icon(
                  check == 'remove' ? Icons.remove : Icons.add,
                  color: check == 'remove' ? Colors.red : CustomTheme.mainColor,
                  size: 28,
                ),
              ),
            )
        ],
      ),
    );
  }
}
