import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:try_your_luck/profile.dart';
import 'package:try_your_luck/user_contests.dart';
import 'package:try_your_luck/wallet/wallet.dart';

import 'authentication/phone.dart';

class MyHeaderDrawer extends StatefulWidget {
  const MyHeaderDrawer({Key? key}) : super(key: key);

  @override
  State<MyHeaderDrawer> createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {
  String name="";
  String? phno="";
  int flag=0;
  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchDataDrawer();
  }
  Future<void> fetchDataDrawer() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "phone_number": phno
      }
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':'hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y'},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      print(data.toString());
      setState((){
        name=data['document']['name'].toString();
        if(name==data['document']['name'].toString()){
          flag=1;
        }
      });
      print(data['document']['name']);
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70,left: 20,right: 20),
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
                      Icon(Icons.add_business_outlined),
                      SizedBox(width: 5,),
                      Text('My Contests')
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 460,),
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
  Widget loaded(){
    if(flag==1){
      return InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context)=> Profile()
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
                  Text(name,
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
    else{
      return CircularProgressIndicator();
    }
  }
}
