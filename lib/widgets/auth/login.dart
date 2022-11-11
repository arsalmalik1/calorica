//@dart=2.9
import 'package:calorica/providers/local_providers/extraProductProvider.dart';
import 'package:calorica/providers/local_providers/meal_product_history.dart';
import 'package:calorica/providers/local_providers/wishlist_meal_product_provider.dart';
import 'package:calorica/providers/local_providers/wishlist_meal_provider.dart';
import 'package:calorica/widgets/auth/is_disable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:platform_device_id/platform_device_id.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../pages/launch_navigator.dart';
import '../../providers/local_providers/dashMealProductProvider.dart';
import '../../providers/local_providers/dashMealProvider.dart';
import '../../providers/local_providers/mealHistoryProvider.dart';
import '../../providers/local_providers/userMealsProvider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  String _deviceId;
  String errorMessage;
  SharedPreferences sp;
  bool isRemember = false;
  Future<void> initPlatformState() async {
    sp = await SharedPreferences.getInstance();
    emailController.text = sp.getString('user_email');

    String deviceId;
    try {
      deviceId = await PlatformDeviceId.getDeviceId;
    } on PlatformException {
      deviceId = 'Failed to get deviceId.';
    }

    if (!mounted) return;

    setState(() {
      _deviceId = deviceId;
      print("deviceId->$_deviceId");
    });
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    initDB();
  }

  initDB() async {
    await DBUserMealProvider.db.firstCreateTable();
    await DBDashMealProvider.db.database;
    await DBWishlisthMealProvider.db.database;
    await DBExtraProductsProvider.db.database;
    await DBWishlistMealProductProvider.db.database;
    await DBDashMealHistoryProvider.db.database;
    await DBMealProductHistoryProvider.db.database;
    await DBDashMealProductProvider.db.database;
  }

  @override
  Widget build(BuildContext context) {
    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailController.text = value;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordController,
        obscureText: true,
        // ignore: missing_return
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value.isEmpty) {
            return ("Password is required for login");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordController.text = value;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Password",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Colors.greenAccent,
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () {
            signIn(emailController.text, passwordController.text);
          },
          child: Text(
            "Login",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(36.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                        height: 200,
                        child: SvgPicture.asset(
                          "assets/svg/dev.svg",
                          fit: BoxFit.contain,
                        )),

                    SizedBox(height: 45),
                    emailField,
                    SizedBox(height: 25),
                    passwordField,
                    SizedBox(height: 10),

                    Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                      SizedBox(
                          height: 24.0,
                          width: 24.0,
                          child: Theme(
                            data: ThemeData(
                                unselectedWidgetColor:
                                    Color(0xff00C8E8) // Your color
                                ),
                            child: Checkbox(
                                activeColor: Color(0xff00C8E8),
                                value: isRemember,
                                onChanged: (v) {
                                  setState(() {
                                    isRemember = v;
                                  });
                                }),
                          )),
                      SizedBox(width: 10.0),
                      Text("Remember Me",
                          style: TextStyle(
                              color: Color(0xff646464),
                              fontSize: 12,
                              fontFamily: 'Rubic'))
                    ]),
                    SizedBox(height: 15),
                    loginButton,
                    SizedBox(height: 15),
                    // Row(
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: <Widget>[
                    //       Text("Don't have an account? "),
                    //       // GestureDetector(
                    //       //   onTap: () {
                    //       //     Navigator.push(
                    //       //         context,
                    //       //         MaterialPageRoute(
                    //       //             builder: (context) =>
                    //       //                 RegistrationScreen()));
                    //       //   },
                    //       //   child: Text(
                    //       //     "SignUp",
                    //       //     style: TextStyle(
                    //       //         color: Colors.redAccent,
                    //       //         fontWeight: FontWeight.bold,
                    //       //         fontSize: 15),
                    //       //   ),
                    //       // )
                    //     ])
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // login function
  void signIn(String email, String password) async {
    if (isRemember) {
      sp.setString('user_email', emailController.text);
    } else {
      sp.setString('user_email', '');
    }
    if (_formKey.currentState.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) {
          print(uid);
          checkUserExist();
        });
      } on FirebaseAuthException catch (error) {
        sp.setBool('is_login', false);
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage);
        print(error.code);
      }
    }
  }

  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user = _auth.currentUser;
    var info = {
      'uid': user.uid,
      'device_id': _deviceId,
      'email': emailController.text.trim(),
      'disable': false,
    };
    await firebaseFirestore.collection("users").doc(user.uid).set(info);
    Fluttertoast.showToast(msg: "Login Successful");
    sp.setBool('is_login', true);

    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LaunchNavigator()));
  }

  checkUserExist() {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    firebaseFirestore
        .collection('users')
        .doc(_auth.currentUser.uid)
        .get()
        .then((value) {
      if (value.exists == true) {
        if (value['disable'] == true) {
          isDisable();
        } else {
          if (value.data()['device_id'] != _deviceId) {
            Fluttertoast.showToast(msg: "Login Successful");
            sp.setBool('is_login', true);

            Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => LaunchNavigator()));
          } else {
            sp.setBool('is_login', false);

            Fluttertoast.showToast(msg: "Not Authorize Device");
          }
        }
      } else {
        postDetailsToFirestore();
      }
    });
  }
}
