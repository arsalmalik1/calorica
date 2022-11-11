//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/pages/forms/fooditem_form.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/theme/theme.dart';

class FooditemsListAppBar extends StatelessWidget {
  FooditemsListAppBar({Key key, this.onPress, this.isMeal = false, this.title})
      : super(key: key);
  bool isMeal;
  final Function onPress;
  String title;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title ?? "Добавление \nприема пищи",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 28,
              color: DesignTheme.blackTextColor,
            ),
          ),
          if (!isMeal)
            IconButton(
                onPressed: () {
                  onPress();
                },
                icon: Icon(
                  Icons.add,
                  size: 40,
                  color: CustomTheme.mainColor,
                ))
        ],
      ),
    );
  }
}
