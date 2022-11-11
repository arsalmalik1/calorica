import 'package:calorica/blocs/auth/bloc.dart';
import 'package:calorica/common/theme/theme.dart';
import 'package:calorica/pages/addedProduct.dart';
import 'package:calorica/pages/edit/choiceDiet.dart';
import 'package:calorica/pages/edit/editUser.dart';
import 'package:calorica/pages/edit/editUserDietParams.dart';
import 'package:calorica/pages/edit/editUserParams.dart';
import 'package:calorica/pages/product/food_item_details.dart';
import 'package:calorica/pages/wishlist/wishlist_meal_product_details.dart';
import 'package:calorica/widgets/auth/login.dart';
import 'package:calorica/widgets/navigation/navigator.dart';
import 'package:flutter/material.dart';

import 'package:calorica/pages/product/products_list.dart';
import 'package:calorica/pages/product/product.dart';
import 'package:calorica/pages/stats/daydata.dart';
import 'package:calorica/pages/stats/history.dart';
import 'package:calorica/pages/stats/main_stats.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';

import 'common/constants/constants.dart';
import 'pages/launch_navigator.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'widgets/lifie_cycle/life_cycle_watcher.dart';

class CaloricaApp extends StatefulWidget {
  @override
  _CaloricaAppState createState() => _CaloricaAppState();
}

class _CaloricaAppState extends State<CaloricaApp> {
  @override
  Widget build(BuildContext context) {
    return LifecycleWatcher(child: _App());
  }
}

class _App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) {
            return AuthBloc()..add(LoadAuthorization());
          },
        ),
      ],
      child: GetMaterialApp(
        title: Constants.appName,
        theme: lightTheme,
        debugShowCheckedModeBanner: false,
        initialRoute: '/launch',
        routes: {
          '/homePage': (BuildContext context) => NavigatorPage(index: 1),
          '/launch': (BuildContext context) => LaunchNavigator(),
          '/login': (BuildContext context) => LoginScreen(),
          '/add': (BuildContext context) => AddPage(),
          '/stats': (BuildContext context) => MainStats(),
          '/history': (BuildContext context) => HistoryPage(),
          '/editUser': (BuildContext context) => EditUserPage(),
          '/editUserParams': (BuildContext context) => EditUserParamsPage(),
          '/editUserDietParams': (BuildContext context) => EditDietParamsPage(),
          '/choiseDiet': (BuildContext context) => ChoiseDietPage(),
        },
        onGenerateRoute: (RouteSettings) {
          var path = RouteSettings.name!.split('/');

          if (path[1] == 'product') {
            return MaterialPageRoute(
              builder: (context) => ProductPage(id: path[2]),
              settings: RouteSettings,
            );
          }
          // if (path[1] == 'fooditemdetails') {
          //   return MaterialPageRoute(
          //     builder: (context) => FoodItemDetails(id: path[2]),
          //     settings: RouteSettings,
          //   );
          // }

          if (path[1] == 'navigator') {
            return MaterialPageRoute(
              builder: (context) => NavigatorPage(index: int.parse(path[2])),
              settings: RouteSettings,
            );
          }

          if (path[1] == 'daydata') {
            return MaterialPageRoute(
              builder: (context) => DayDatePage(date: path[2]),
              settings: RouteSettings,
            );
          }

          if (path[1] == 'addedProduct') {
            return MaterialPageRoute(
              builder: (context) =>
                  AddedProductPage(id: path[2], from: path[3]),
              settings: RouteSettings,
            );
          }
          return null;
        },
      ),
    );
  }
}
