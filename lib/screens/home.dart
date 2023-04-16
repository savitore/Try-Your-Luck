import 'package:flutter/material.dart';
import 'package:try_your_luck/screens/live_contests.dart';
import 'package:try_your_luck/screens/my_contests.dart';
import 'package:try_your_luck/screens/winners.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedIconTheme: IconThemeData(color: Colors.green.shade600, size: 30),
        selectedItemColor: Colors.green.shade600,
        unselectedIconTheme: IconThemeData(color: Colors.grey[500], size: 30),
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
            label: 'Home'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/trophy.png')),
              label: 'My Contests'
          ),
          BottomNavigationBarItem(
              icon: ImageIcon(AssetImage('assets/winners.png')),
              label: 'Rewards'
          )
        ],
        currentIndex: _selectedIndex, //New
        onTap: _onItemTapped,
      ),
      body: Container(
          child: _pages.elementAt(_selectedIndex)
      ),
    );
  }

  static const List<Widget> _pages = <Widget>[
    LiveContests(),
    MyContests(),
    Winners()
  ];
}