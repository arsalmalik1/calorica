import 'package:flutter/material.dart';

Widget wishlistButton({Function? onpress, String? title}) {
  return Container(
    width: double.infinity,
    padding: EdgeInsets.all(20),
    child: Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.greenAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          onPressed: () async {
            onpress!();
          },
          child: Text(
            title!,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    ),
  );
}
