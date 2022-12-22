import 'package:flutter/material.dart';
import 'authentication/LoginScreen.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/':(context) => LoginScreen(),
    },
  ));
}


