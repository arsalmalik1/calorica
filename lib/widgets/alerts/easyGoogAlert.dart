import 'package:calorica/common/theme/theme.dart';
import 'package:flutter/material.dart';

Future<void> goodAlert(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(title: Text('Данные сохранены'), actions: <Widget>[
        FlatButton(
          child: Text(
            'Отлично',
            style: TextStyle(color: CustomTheme.mainColor),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ]);
    },
  );
}
