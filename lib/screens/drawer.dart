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
    return Column(
        children: [
          loaded(),
          Padding(
            padding: const EdgeInsets.only(top: 20,left: 20,right: 20),
            child: Column(
              children: [
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
          ),
          SizedBox(height: 400,),
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
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Log out',
                      style: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 15,
                        fontWeight: FontWeight.w500
                      ),
                    ),
                    Icon(Icons.arrow_right,size: 22,color: Colors.blueAccent,weight: 10,)
                  ],
                ),
              )
            ],
          )
        ],
      );
    // );
  }
  Widget loaded(){
      return Container(
        color: Colors.green.shade600,
        padding: const EdgeInsets.fromLTRB(20, 70, 20, 15),
        child: InkWell(
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.name,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        // fontWeight: FontWeight.bold
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios,color: Colors.white,size: 25,)
                  ]
              ),
            ],
          ),
        ),
      );
  }
}
