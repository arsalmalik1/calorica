import 'package:calorica/blocs/auth/bloc.dart';
import 'package:calorica/pages/auth/auth.dart';
import 'package:calorica/widgets/navigation/navigator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaunchNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is Authorized) {
          return NavigatorPage(index: 1);
        } else if (state is Unauthorized) {
          return AuthPage();
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
