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
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  bool? isLoggedIn = false;
  isLoggedIn = (prefs.getBool('isLoggedIn')==null) ? false : prefs.getBool('isLoggedIn');
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: 'phone',
    routes: {
      'phone':(context) => Phone(),
      'name':(context)=>Name()
    },
  ));
}





