import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'authentication/phone.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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




