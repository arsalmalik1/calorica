//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:calorica/models/range.dart';
import 'package:calorica/providers/local_providers/dashMealProductProvider.dart';
import 'package:calorica/providers/local_providers/mealHistoryProvider.dart';
import 'package:calorica/providers/local_providers/meal_product_history.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:get/get.dart';

import '../../../providers/local_providers/dashMealProvider.dart';
import '../home/home.dart';
import '../product/widgets/product_param_panel.dart';
import 'day_meal_details.dart';

class DayAppBar extends StatefulWidget {
  DayAppBar({
    Key key,
    this.onPress,
    @required this.name,
    @required this.surname,
    @required this.calory,
    @required this.squi,
    @required this.fat,
    @required this.carboh,
    this.id,
  }) : super(key: key);
  final int id;
  String name;
  final String surname;
  final RangeGraphData calory;
  final RangeGraphData squi;
  final RangeGraphData fat;
  final RangeGraphData carboh;
  Function onPress;
  @override
  State<DayAppBar> createState() => _DayAppBarState();
}

class _DayAppBarState extends State<DayAppBar> {
  bool isEdit = false;
  TextEditingController nameController = TextEditingController();
  String name;
  @override
  void initState() {
    super.initState();
    name = widget.name;
    nameController.text = name;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {},
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
                            name == null || name == ''
                                ? 'Meal ${widget.id}'
                                : name,
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
                                DBDashMealHistoryProvider.db
                                    .updateNameMeals(
                                        widget.id, nameController.text)
                                    .then((value) {
                                  setState(() {
                                    name = nameController.text;
                                    isEdit = false;
                                  });
                                  widget.onPress();
                                });
                              },
                              icon: Icon(Icons.save))
                      ],
                    ),
                    IconButton(
                        onPressed: () async {
                          await DBDashMealHistoryProvider.db
                              .deleteDashMeal(widget.id);
                          await DBMealProductHistoryProvider.db
                              .deleteProductsByMeal(widget.id)
                              .then((value) {
                            print('val: $value');

                            widget.onPress();
                            Get.back();
                          });
                        },
                        icon: Icon(
                          Icons.delete,
                          color: Colors.redAccent,
                        ))
                  ],
                ),
              ),
              getBigRangeWidget(widget.calory, context),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  getRangeWidget(widget.squi, context),
                  getRangeWidget(widget.fat, context),
                  getRangeWidget(widget.carboh, context),
                ],
              ),
              if ((widget.calory?.weigth ?? 0.0) >
                  (widget.calory?.limit ?? 0.0))
                Text(
                  'You have exceeded your calories intake for today.',
                  style: TextStyle(fontSize: 10),
                ),
              if ((widget.squi?.weigth ?? 0.0) > (widget.squi?.limit ?? 0.0))
                Text(
                  'You have exceeded your protien intake for today.',
                  style: TextStyle(fontSize: 10),
                ),
              if ((widget.fat?.weigth ?? 0.0) > (widget.fat?.limit ?? 0.0))
                Text(
                  'You have exceeded your fat intake for today.',
                  style: TextStyle(fontSize: 10),
                ),
              if ((widget.carboh.weigth ?? 0.0) > (widget.carboh?.limit ?? 0.0))
                Text(
                  'You have exceeded your carbo intake for today.',
                  style: TextStyle(fontSize: 10),
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
