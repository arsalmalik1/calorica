//@dart=2.9
import 'package:calorica/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class HomeToolBar extends StatelessWidget {
  HomeToolBar({Key key, this.calorie, this.carboh, this.squi, this.fat})
      : super(key: key);
  double calorie, carboh, squi, fat;

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
              FontAwesomeIcons.userCircle,
              color: theme.accentColor,
            ),
            onTap: () {
              Navigator.pushNamed(context, '/editUser');
            },
          ),
          // ToolBarIconButton(
          //   icon: Row(
          //     children: [
          //       Column(
          //         children: [
          //           Text(
          //             '${calorie.round()}',
          //             style:
          //                 TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          //           ),
          //           Text(
          //             'кКалории',
          //             style: TextStyle(fontSize: 8),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         width: 8,
          //       ),
          //       Column(
          //         children: [
          //           Text(
          //             '${fat.round()}',
          //             style:
          //                 TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          //           ),
          //           Text(
          //             'Жиры',
          //             style: TextStyle(fontSize: 8),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         width: 8,
          //       ),
          //       Column(
          //         children: [
          //           Text(
          //             '${squi.round()}',
          //             style:
          //                 TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          //           ),
          //           Text(
          //             'Белки',
          //             style: TextStyle(fontSize: 8),
          //           ),
          //         ],
          //       ),
          //       SizedBox(
          //         width: 8,
          //       ),
          //       Column(
          //         children: [
          //           Text(
          //             '${carboh.round()}',
          //             style:
          //                 TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
          //           ),
          //           Text(
          //             'Углеводы',
          //             style: TextStyle(fontSize: 8),
          //           ),
          //         ],
          //       )
          //     ],
          //   ),
          //   onTap: () {},
          // ),

          ToolBarIconButton(
            icon: Icon(
              FontAwesomeIcons.powerOff,
              color: theme.accentColor,
            ),
            onTap: () async {
              SharedPreferences sp = await SharedPreferences.getInstance();
              sp.setBool('is_login', false);
              // sp.setBool('is_remember', false);

              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/login', (Route<dynamic> route) => false);
              // Navigator.pushNamed(context, '/editUser');
            },
          ),
        ],
      ),
    );
  }
}
