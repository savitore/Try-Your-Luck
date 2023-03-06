import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/screens/Intro.dart';
import 'package:try_your_luck/screens/profile.dart';
import 'package:try_your_luck/screens/my_contests.dart';
import 'package:try_your_luck/wallet/wallet.dart';

class MyHeaderDrawer extends StatefulWidget {
  late final String phno,name;
  MyHeaderDrawer(this.phno,this.name);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70,left: 20,right: 20),
      child: SingleChildScrollView(
        child: Column(
            children: [
              Column(
                children: [
                  loaded(),
                  SizedBox(height: 10,),
                  Divider(height: 1,thickness: 0.5,color: Colors.grey[500],),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=> Wallet()
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.account_balance_wallet_outlined),
                        SizedBox(width: 5,),
                        Text('My Wallet')
                      ],
                    ),
                  ),
                  SizedBox(height: 15,),
                  InkWell(
                    onTap: (){
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=> MyContests()
                      ));
                    },
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today),
                        SizedBox(width: 5,),
                        Text('My Contests')
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 400,),
              Divider(height: 1,thickness: 0.5,color: Colors.grey[500]),
              SizedBox(height: 10,),
              Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => Intro()),
                              (route) => false);
                    },
                    child: Row(
                      children: [
                        Text('Log out',
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 15
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
      ),
    );
    // );
  }
  Widget loaded(){
      return InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> Profile(widget.name,widget.phno)
          ));
        },
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/empty_person.jpg'),
                  // backgroundImage: NetworkImage('url'),
                  radius: 30,
                )
              ],
            ),
            SizedBox(height: 10,),
            Row(
                children: [
                  Text(widget.name,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      // fontWeight: FontWeight.bold
                    ),
                  )
                ]
            ),
            Row(
              children: [
                Text(
                  'View profile',
                  style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 14),
                )
              ],
            ),
          ],
        ),
      );
  }
}
