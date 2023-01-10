import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/profile.dart';
import 'package:try_your_luck/wallet.dart';

import 'authentication/phone.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70,left: 20,right: 20),
      child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: [CircleAvatar(
                    backgroundImage: AssetImage('assets/empty_person.jpg'),
                    // backgroundImage: NetworkImage('url'),
                    radius: 30,
                  )
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                    children: [
                      Text('Krishna Agrawal',
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
                    InkWell(
                      child: Text(
                        'View profile',
                        style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14),
                      ),
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> Profile()
                        ));
                      },
                    )
                  ],
                ),
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
              ],
            ),
            SizedBox(height: 500,),
            Divider(height: 1,thickness: 0.5,color: Colors.grey[500]),
            SizedBox(height: 10,),
            Column(
              children: [
                GestureDetector(
                  onTap: () async {
                    await FirebaseAuth.instance.signOut();
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Phone()),
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
    );
    // );
  }
}
