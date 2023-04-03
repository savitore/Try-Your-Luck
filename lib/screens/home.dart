import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/screens/ContestExpandable.dart';
import 'package:try_your_luck/screens/drawer.dart';
import 'package:try_your_luck/wallet/wallet.dart';

import '../models/ContestModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<ContestModel>? list=[];
  int flag=0,flag1=0;
  String name='',balance='';
  String? phno;
  @override
  void initState() {
    super.initState();
    getData();
    fetchDataContests();
  }
  Future<void> fetchDataProfile() async{
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
      setState((){
        balance=data['document']['balance'].toString();
      });
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> fetchDataContests() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"contests",
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
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          list?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
        });
      }
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return loaded();
  }
  Widget loaded(){
      return flag==1 ? Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          title: Text('Try Your Luck'),
          centerTitle: true,
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Wallet()));
              },
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,color: Colors.white,),
                  Text(' ₹'+ balance,style: TextStyle(fontSize: 20),)
                ],
              ),
            ),
            SizedBox(width: 8,),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child:SingleChildScrollView(
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Text('Live contests',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
                  SizedBox(height: 10,),
                  Column(
                    children: list!.map((contests){
                      return InkWell(
                        onTap: (){
                          Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.name, fee: contests.fee, prize: contests.win_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
                        },
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: Colors.green.shade600)),
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                            child: ListTile(
                              tileColor: Colors.white,
                              title: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 5,),
                                  Text(
                                    contests.name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                              subtitle: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          SizedBox(width: 3,),
                                          Text('Prize',style: TextStyle(color: Colors.blueAccent,fontSize: 10),),
                                        ],
                                      ),
                                      SizedBox(height: 3,),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        children: [
                                          Text('₹'+contests.win_amount,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(width: 15,),
                                      Image.asset('assets/money.png',height: 55,width: 55,),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text('Joining Fee',style: TextStyle(color: Colors.black,fontSize: 10),),
                                      SizedBox(height: 5,),
                                      SizedBox(
                                        height: 25,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green.shade600,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                          ),
                                            onPressed: (){
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.name, fee: contests.fee, prize: contests.win_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
                                            },
                                            child: Row(
                                            children: [
                                            Icon(Icons.currency_rupee,color: Colors.white,size: 13,),
                                            Text(contests.fee,style: TextStyle(color: Colors.white)),
                                          ],
                                        )),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: Column(
              children: [
                MyHeaderDrawer(phno.toString(),name)
              ],
            ),
          ),
        ),
      ) : Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
          child: Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/logo.png',
                      width: 120,
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Text('Try Your Luck',style: TextStyle(fontSize: 30,color: Colors.black),),
                SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      );
  }

  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
    phno =prefs.getString("phone")!;
    fetchDataProfile();
  }
}