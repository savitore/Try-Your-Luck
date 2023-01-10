import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'package:try_your_luck/home.dart';
import 'authentication/phone.dart';
import 'package:try_your_luck/db/userInfo.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // bool? isLoggedIn = (prefs.getBool('isLoggedIn')==null) ? false : prefs.getBool('isLoggedIn');
  await Firebase.initializeApp();
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  Widget first;
  if (firebaseUser != null) {
    first = Home();
  } else {
    first = Phone();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    // initialRoute: 'phone',
    // routes: {
    //   'phone':(context) => Phone(),
    //   'name':(context)=>Name()
    // },
    home: first,
  ));
}





