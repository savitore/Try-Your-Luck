import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/models/MyContestsModel.dart';
import 'package:try_your_luck/screens/wallet.dart';
import '../widgets/custom_page_route.dart';
import 'ContestExpandable.dart';
import 'drawer.dart';

class MyContests extends StatefulWidget {
  const MyContests({Key? key}) : super(key: key);

  @override
  State<MyContests> createState() => _MyContestsState();
}

class _MyContestsState extends State<MyContests> {

  String? phno="";
  List<MyContestsModel>? list=[], won =[];
  int flag=0,flag1=0,c=0;
  String result='',balance='',userName='';
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchMyContests();
    getData();
  }

  Future<void> getData() async{
      var prefs = await SharedPreferences.getInstance();
      setState(() {
        balance =prefs.getString("balance")!;
        userName=prefs.getString("name")!;
      });
  }
  Future<void> fetchMyContests() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"users",
      "collection":phno!
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
        for(int i=0; i<data['documents'].length;i++){
          if(data['documents'][i]['result']!=null){
            result=data['documents'][i]['result'];
          }
          setState(() {
            list?.add(MyContestsModel(contest_name: data['documents'][i]['contest'], lucky_number: data['documents'][i]['lucky_no_user'], winning_amount: data['documents'][i]['winning_amount'], result: result, redeemed: data['documents'][i]['redeemed'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no'], no_of_people: data['documents'][i]['no_of_people']));
            if(result=='won'){
              won?.add(MyContestsModel(contest_name: data['documents'][i]['contest'], lucky_number: data['documents'][i]['lucky_no_user'], winning_amount: data['documents'][i]['winning_amount'], result: result, redeemed: data['documents'][i]['redeemed'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no'], no_of_people: data['documents'][i]['no_of_people']));
              c=1;
            }
          });
          result='';
        }
        flag=1;
      });
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
          title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(onTap: (){scaffoldKey.currentState?.openDrawer();}, child: Icon(Icons.menu)),
            SizedBox(width: 8,),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                GestureDetector(
                  onTap: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: CircleAvatar(
                    radius: 18,
                    backgroundImage: AssetImage('assets/empty_person.jpg'),
                  ),
                ),
                Positioned(
                    top: 12,
                    right: 10.0,
                    width: 10.0,
                    height: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle
                      ),
                    )
                )
              ],
            ),
            Expanded(child: Center(child:  Text('My Contests')))
          ],
        ),
          actions: [
            GestureDetector(
              onTap: (){
                Navigator.of(context).push(
                    CustomPageRoute(child :Wallet()));
              },
              child: Row(
                children: [
                  Icon(Icons.account_balance_wallet_outlined,),
                  Text(' ₹'+ balance,style: TextStyle(fontSize: 19),)
                ],
              ),
            ),
            SizedBox(width: 8,),
          ],
          automaticallyImplyLeading: false,
        ),
        drawer:  Drawer(
          backgroundColor: Colors.grey[100],
          child: SingleChildScrollView(
            child: MyHeaderDrawer(phno.toString(),userName),
          ),
        ),
        body: flag==1 ?
        RefreshIndicator(
          key: _refreshIndicatorKey,
          color: Colors.green.shade600,
          onRefresh: (){
            return Future.delayed(
                Duration(seconds: 1),
                    (){
                  setState(() {
                    won?.clear();
                    list?.clear();
                    fetchMyContests();
                  });
                }
            );
          },
          child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ifWon(),
                  Column(
                    children: list!.map((contests){
                      return InkWell(
                        onTap: (){
                          Navigator.of(context).push(
                              CustomPageRoute(child: ContestExpandable(name: contests.contest_name, fee: contests.fee, prize: contests.winning_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
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
                                  Text(
                                    contests.contest_name,
                                    style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 25
                                    ),
                                  ),
                                  SizedBox(height: 5,)
                                ],
                              ),
                              subtitle: Column(
                                children: [
                                  Row(
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
                                              Text('₹'+contests.winning_amount,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),
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
                                          Text('Lucky Number',style: TextStyle(color: Colors.black,fontSize: 10),),
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
                                                      MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.contest_name, fee: contests.fee, prize: contests.winning_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
                                                },
                                                child: Row(
                                                  children: [
                                                    Text(contests.lucky_number,style: TextStyle(color: Colors.white)),
                                                  ],
                                                )),
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text('Entry fee:',style: TextStyle(color: Colors.blueAccent),),
                                      SizedBox(width: 5,),
                                      Text('₹'+contests.fee,style: TextStyle(color: Colors.black),)
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
                  SizedBox(height: 10,)
                ],
              ),
            ),
          ),
        ) :
          Center(child: LoadingAnimationWidget.hexagonDots(color: Colors.grey[500]!, size: 50))

    );
  }
  Widget ifWon(){
    return c==1 ? Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 10, 0, 10),
          child: Text('Contests Won',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
        Column(
          children: won!.map((contests){
            return InkWell(
              onTap: (){
                Navigator.of(context).push(
                    CustomPageRoute(child: ContestExpandable(name: contests.contest_name, fee: contests.fee, prize: contests.winning_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
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
                        Text(
                          contests.contest_name,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                          ),
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
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
                                    Text('Amount Won',style: TextStyle(color: Colors.blueAccent,),),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('₹'+contests.winning_amount,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),
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
                                Text('Lucky Number',style: TextStyle(color: Colors.black,fontSize: 10),),
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
                                            MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.contest_name, fee: contests.fee, prize: contests.winning_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no)));
                                      },
                                      child: Row(
                                        children: [
                                          Text(contests.lucky_number,style: TextStyle(color: Colors.white)),
                                        ],
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                        Row(
                          children: [
                            Text('Entry fee:',style: TextStyle(color: Colors.blueAccent),),
                            SizedBox(width: 5,),
                            Text('₹'+contests.fee,style: TextStyle(color: Colors.black),)
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
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 15, 0, 10),
          child: Text('All Contests',style: TextStyle(fontSize: 22,fontWeight: FontWeight.w500,color: Colors.black),),
        ),
      ],
    ) : Text('',style: TextStyle(fontSize: 0),);
  }
}