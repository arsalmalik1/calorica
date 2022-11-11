import 'package:calorica/blocs/auth/bloc.dart';
import 'package:calorica/pages/auth/auth.dart';
import 'package:calorica/widgets/auth/is_disable.dart';
import 'package:calorica/widgets/auth/login.dart';
import 'package:calorica/widgets/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LaunchNavigator extends StatefulWidget {
  const LaunchNavigator({Key? key}) : super(key: key);

  @override
  State<LaunchNavigator> createState() => _LaunchNavigatorState();
}

class _LaunchNavigatorState extends State<LaunchNavigator> {
  String? authToken;
  bool? isLogin, isRemember;
  bool? isLoading = true;
  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((sp) {
      authToken = sp.getString('auth_token');
      isLogin = sp.getBool('is_login');
      isRemember = sp.getBool('is_remember');
      // isLogin = false;
      isDisable();
      isLoading = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        print("******************");

        if (!isLoading!) {
          if (isLogin == true) {
            if (state is Authorized) {
              return NavigatorPage(index: 1);
            } else if (state is Unauthorized) {
              return AuthPage();
            }
          } else {
            return LoginScreen();
          }
        }
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }
}
