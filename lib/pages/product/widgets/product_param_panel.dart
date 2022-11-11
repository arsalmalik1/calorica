//@dart=2.9
import 'package:calorica/design/theme.dart';
import 'package:flutter/material.dart';

class ProductParamPanel extends StatelessWidget {
  const ProductParamPanel({
    Key key,
    @required this.title,
    @required this.value,
    this.type = TextInputType.number,
    this.onChanged,
    this.controller,
  }) : super(key: key);

  final String title;
  final double value;
  final TextEditingController controller;
  final Function onChanged;
  final TextInputType type;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width * 0.44,
      margin: EdgeInsets.symmetric(vertical: 8.0),
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(15)),
        boxShadow: DesignTheme.shadowByOpacity(0.03),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // Text(
          //   value.toString(),
          //   style: DesignTheme.bigMainText,
          // ),
          TextField(
            controller: controller,
            style: DesignTheme.bigMainText,
            onChanged: onChanged,
            keyboardType: type,
          ),
          Text(
            title,
            style: DesignTheme.labelSearchText,
          ),
        ],
      ),
    );
  }
}
