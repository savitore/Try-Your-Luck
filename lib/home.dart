import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/authentication/phone.dart';
import 'package:try_your_luck/drawer.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        // leading: Builder(
        //   builder: (context) => GestureDetector(
        //     child:
        //     // CircleAvatar(
        //     //   backgroundImage: AssetImage('assets/empty_person.jpg'),
        //     //   // backgroundImage: NetworkImage('url'),
        //     //   radius: 5,
        //     // ),
        //     Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(100),
        //         image: DecorationImage(
        //           image: AssetImage('assets/empty_person.jpg'),
        //         )
        //       ),
        //     ),
        //     onTap: (){Scaffold.of(context).openDrawer();},
        //   ),
        // ),
        title: Text('Try Your Luck'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          children: [
          ],
        ),
      ),
      drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer()
              ],
            ),
          ),
      ),
    );
  }
}