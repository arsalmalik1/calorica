//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/range.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../../../providers/local_providers/dashMealProvider.dart';
import '../../product/widgets/product_param_panel.dart';
import '../home.dart';

class HalfAppBar extends StatefulWidget {
  HalfAppBar({
    Key key,
    this.onPress,
    @required this.name,
    @required this.surname,
    this.id,
  }) : super(key: key);
  final int id;
  final String name;
  final String surname;
  Function onPress;
  @override
  State<HalfAppBar> createState() => _HlafAppBarState();
}

class _HlafAppBarState extends State<HalfAppBar> {
  bool isEdit = false;
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, '/editUser');
      },
      child: Container(
        margin: EdgeInsets.only(top: 5, left: 5, right: 5, bottom: 10),
        padding: EdgeInsets.symmetric(vertical: 15),
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: DesignTheme.shadowByOpacity(0.04),
        ),
        child: Container(
          padding: EdgeInsets.only(left: 20, right: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        if (!isEdit)
                          Text(
                            widget.name == null || widget.name == ''
                                ? 'Meal ${widget.id}'
                                : widget.name,
                            style: DesignTheme.bigText3,
                            textAlign: TextAlign.start,
                          ),
                        if (isEdit)
                          ProductParamPanel(
                            type: TextInputType.text,
                            title: "Meal Name",
                            controller: nameController,
                            value: null,
                          ),
                        if (!isEdit)
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  isEdit = true;
                                });
                              },
                              icon: Icon(Icons.edit)),
                        if (isEdit)
                          IconButton(
                              onPressed: () {
                                DBDashMealProvider.db.updateNameMeals(
                                    widget.id, nameController.text);

                                setState(() {
                                  isEdit = false;
                                });
                                Home.of(context).string = "refresh";
                              },
                              icon: Icon(Icons.save))
                      ],
                    ),
                    IconButton(
                        onPressed: () {
                          DBDashMealProvider.db.deleteDashMeal(widget.id);
                          DBDashMealProductProvider.db
                              .deleteProductsByMeal(widget.id)
                              .then((value) {
                            print('val: $value');
                          });
                          Home.of(context).string = "refresh";
                          widget.onPress();
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  splitBigTxt(String text) {
    if (text.length <= 13)
      return text;
    else
      return text.substring(0, 13);
  }

  // getIconButton(BuildContext context) {
  //   return IconButton(
  //     icon: Icon(
  //       Icons.edit,
  //       color: Theme.of(context).primaryColor,
  //       size: MediaQuery.of(context).size.width * 0.08,
  //     ),
  //     onPressed: () {
  //       Navigator.pushNamed(context, '/editUser');
  //     },
  //   );
  // }

  buildUserName(String name, String surname, BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      width: size.width * 0.7,
      child: AutoSizeText(
        '$name $surname',
        maxLines: 1,
        minFontSize: 20,
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 26,
          color: DesignTheme.blackTextColor,
        ),
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  getRangeWidget(RangeGraphData range, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            range.name,
            style: DesignTheme.lilWhiteText.copyWith(
              color: DesignTheme.blackTextColor,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 4),
            child: Container(
              height: 6,
              width: 80,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: (range.percent * 0.01) * 80,
                    height: 6,
                    decoration: BoxDecoration(
                      gradient: range.gradient,
                      borderRadius: BorderRadius.all(Radius.circular(4.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 6),
            child: RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: range.weigth != null
                    ? range.weigth.roundToDouble().toString()
                    : '0.0',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: range.color,
                ),
                children: [
                  TextSpan(
                    text:
                        ' / ${range.limit != null ? range.limit.roundToDouble() : 0.0} г',
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 9,
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  getBigRangeWidget(RangeGraphData range, BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 10, right: 0, left: 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(
                    right: 20,
                  ),
                  child: Text(
                    range.name,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      fontSize: MediaQuery.of(context).size.width * 0.051,
                      letterSpacing: -0.2,
                      color: DesignTheme.blackTextColor,
                    ),
                  ),
                ),
                Text(
                  range.weigth.toString() +
                      " / " +
                      (range.limit == null ? '0.0' : range.limit.toString()),
                  textAlign: TextAlign.end,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: MediaQuery.of(context).size.width * 0.051,
                    letterSpacing: -0.2,
                    color: DesignTheme.blackTextColor,
                  ),
                ),
              ]),
          Padding(
            padding: const EdgeInsets.only(right: 0, top: 4),
            child: Container(
              height: 10,
              width: MediaQuery.of(context).size.width - 122,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
              child: Row(
                children: <Widget>[
                  Container(
                    width: (MediaQuery.of(context).size.width - 122) *
                        range.percent *
                        0.01,
                    height: 10,
                    decoration: BoxDecoration(
                      gradient: range.gradient,
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
