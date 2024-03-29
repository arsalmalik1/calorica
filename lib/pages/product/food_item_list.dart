//@dart=2.9
import 'package:calorica/pages/product/widgets/widgets.dart';
import 'package:calorica/providers/local_providers/productProvider.dart';
import 'package:calorica/widgets/crads/info_card.dart';

import 'package:flutter/material.dart';

import 'package:calorica/models/dbModels.dart';
import 'package:get/get.dart';

import '../../utils/dataLoader.dart';
import '../forms/fooditem_form.dart';
import '../wishlist/wishlist_product_card.dart';
import 'food_item_card.dart';
import 'food_item_details.dart';
import 'widgets/fooditem_appbar.dart';

class FoodItemList extends StatefulWidget {
  FoodItemList(
      {this.isMeal = false,
      this.isWishList = false,
      this.isDash = false,
      this.isExtraFood = false});

  bool isMeal, isWishList, isDash, isExtraFood;

  @override
  _FoodItemListState createState() => _FoodItemListState();
}

class _FoodItemListState extends State<FoodItemList> {
  bool isSaerching = false;
  ScrollController scrollController;
  String searchText;

  void startSearch(String text) {
    setState(() {
      isSaerching = true;
      searchText = text;
    });
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.only(top: 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              FooditemsListAppBar(
                isMeal: widget.isMeal || widget.isWishList ? true : false,
                onPress: () async {
                  String refresh = await Get.to(() => const FooditemForm());
                  setState(() {});
                },
              ),
              ProductSearchBar(
                onChanged: (String text) {
                  startSearch(text);
                },
              ),
              InfoCard(title: "Результаты поиска"),
              Flexible(
                child: Container(
                  constraints: BoxConstraints.expand(
                      height: MediaQuery.of(context).size.height),
                  child: FutureBuilder(
                    future: isSaerching
                        ? DBProductProvider.db.getAllProductsSearch(searchText)
                        : DBProductProvider.db.getAllProducts(),
                    // ignore: missing_return
                    builder: (BuildContext context,
                        AsyncSnapshot<List<Product>> snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.none:
                          return Text('Input a URL to start');
                        case ConnectionState.waiting:
                          return Center(child: CircularProgressIndicator());
                        case ConnectionState.active:
                          return Text('');
                        case ConnectionState.done:
                          if (snapshot.hasError) {
                            return Text(
                              '${snapshot.error}',
                              style: TextStyle(color: Colors.red),
                            );
                          } else {
                            return ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.symmetric(
                                vertical: 10.0,
                              ),
                              physics: const BouncingScrollPhysics(),
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, i) {
                                return GestureDetector(
                                    child: FoodItemCard(
                                      check: widget.isMeal
                                          ? 'hide'
                                          : widget.isExtraFood
                                              ? 'extra'
                                              : null,
                                      product: snapshot.data[i],
                                      onPress: () {
                                        if (widget.isExtraFood) {
                                          Get.back(result: snapshot.data[i]);
                                        }
                                      },
                                    ),
                                    onTap: () {
                                      if (widget.isMeal || widget.isExtraFood) {
                                        Get.back(result: snapshot.data[i]);
                                      } else {
                                        _openProductPage(snapshot.data[i]);
                                      }
                                    });
                              },
                            );
                          }
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openProductPage(Product product) async {
    String result = await Get.to(() => FoodItemDetails(id: product.id));
    if (result != null) {
      setState(() {});
    }
    // Navigator.pushNamed(
    //   context,
    //   '/fooditemdetails/' + product.id.toString(),
    // );
  }
}
