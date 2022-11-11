import 'package:calorica/widgets/auth/login.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

isDisable() async {
  try {
    final auth = await FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    print(currentUser);
    if (currentUser != null) {
      final user = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .get();
      print(user['disable']);
      if (user['disable'] == true) {
        Fluttertoast.showToast(msg: 'Account is disabled');
        auth.signOut();
        SharedPreferences sp = await SharedPreferences.getInstance();
        sp.setBool('is_login', false);
        Get.offAll(() => LoginScreen());
      }
    }
  } catch (e) {
    print(e.toString());
  }
}
