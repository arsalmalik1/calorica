import 'package:calorica/design/theme.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:flutter/material.dart';

getFlatNavigationButton(title, route, context) {
  return InkWell(
    splashColor: CustomTheme.mainColor,
    child: Row(children: <Widget>[
      Padding(
        padding: EdgeInsets.only(
          right: 5,
        ),
        child: Text(
          title,
          style: DesignTheme.labelTextBiggerBlack,
        ),
      ),
      Icon(Icons.chevron_right, color: CustomTheme.mainColor),
    ]),
    onTap: () {
      Navigator.pushNamed(context, route);
    },
  );
}
