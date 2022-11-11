//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/models/extraProductModel.dart';
import 'package:calorica/providers/local_providers/extraProductProvider.dart';

import 'package:flutter/material.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:get/get.dart';

class FoodItemCard extends StatelessWidget {
  const FoodItemCard(
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
      ],
    );
  }

  void _openProductPage(Product product, BuildContext context) {
    Navigator.pushNamed(
      context,
      '/product/' + product.id.toString(),
    );
  }
}
