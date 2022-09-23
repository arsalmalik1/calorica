import 'package:calorica/common/theme/theme.dart';
import 'package:flutter/material.dart';

badEditAlert(context) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text('Произошла ошибка при сохранении данных'),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'Ок',
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
