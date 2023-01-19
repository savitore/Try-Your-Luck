import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/screens/home.dart';
import 'authentication/phone.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
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
    home: first,
  ));
}





