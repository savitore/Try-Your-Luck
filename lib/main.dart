import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/screens/live_contests.dart';
import 'screens/Intro.dart';
import 'authentication/name.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  User? firebaseUser = FirebaseAuth.instance.currentUser;
  var prefs= await SharedPreferences.getInstance();
  String where =prefs.getString("where").toString();
  Widget first;
  if (firebaseUser != null) {
    if(where=="name"){
      first=Name();
    } else{
      first = LiveContests();
    }
  } else {
    first = Intro();
  }
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: first,
  ));
}





