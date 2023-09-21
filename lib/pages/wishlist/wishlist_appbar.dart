//@dart=2.9
import 'package:calorica/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common/theme/custom_theme/custom_theme.dart';
import '../../design/theme.dart';

// ignore: must_be_immutable
class WishListBar extends StatelessWidget {
  WishListBar(
      {Key key,
      this.calorie,
      this.carboh,
      this.squi,
      this.fat,
      this.controller,
      this.onRightPress})
      : super(key: key);
  double calorie, carboh, squi, fat;
  Function onRightPress;
  TextEditingController controller;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(top: 40.0, left: 25, right: 25),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ToolBarIconButton(
            icon: Icon(
              FontAwesomeIcons.arrowAltCircleLeft,
              color: theme.accentColor,
            ),
            onTap: () {
              Get.back();
            },
          ),
          SizedBox(
            width: 10,
          ),
          Expanded(
            child: TextFormField(
              onChanged: (text) {},
              controller: controller,
              style: DesignTheme.inputTextLight,
              cursorColor: CustomTheme.mainColorLight,

              decoration: InputDecoration(
                labelText: 'Meal Name',
                labelStyle: DesignTheme.labelSearchTextBiggerLight,
              ),
              // ignore: missing_return
            ),
          ),
          SizedBox(
            width: 10,
          ),
          ToolBarIconButton(
            icon: Icon(
              FontAwesomeIcons.plus,
              color: theme.accentColor,
            ),
            onTap: () async {
              onRightPress();
            },
          ),
        ],
      ),
    );
  }
}
