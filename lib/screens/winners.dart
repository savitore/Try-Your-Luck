import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/models/WinnersModel.dart';
import 'package:try_your_luck/screens/wallet.dart';

import 'ContestExpandable.dart';
import 'drawer.dart';

class Winners extends StatefulWidget {
  const Winners({Key? key}) : super(key: key);

  @override
  State<Winners> createState() => _WinnersState();
}

class _WinnersState extends State<Winners> {

  String name='',balance='';
  String? phno;
  Timer? timer;
  int flag=0;
  List<WinnersModel> list = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  Future<void> getBalance() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      balance =prefs.getString("balance")!;
    });
  }

  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
    phno =prefs.getString("phone")!;
  }

  @override
  void initState() {
    super.initState();
    getData();
    fetchWinners();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getBalance());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> fetchWinners() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"winners",
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
          list?.add(WinnersModel(name: data['documents'][i]['name'], contest_name: data['documents'][i]['contest_name'], prize: data['documents'][i]['prize'], lucky_no: data['documents'][i]['lucky_no'], date: data['documents'][i]['date'], fee: data['documents'][i]['fee'], no_of_people: data['documents'][i]['no_of_people']));
        });
      }
      flag=1;
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
            Expanded(child: Center(child:  Text('Winners')))
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        automaticallyImplyLeading: false,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Wallet()));
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
      ),
      body: flag==1?
      RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.green.shade600,
        onRefresh: (){
          return Future.delayed(
              Duration(seconds: 1),
                  (){
                setState(() {
                  list?.clear();
                  fetchWinners();
                });
              }
          );
        },
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: list!.map((winners){
                    return InkWell(
                      onTap: (){
                        Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ContestExpandable(name: winners.contest_name, fee: winners.fee, prize: winners.prize, no_of_people: winners.no_of_people, lucky_draw_no: winners.lucky_no)));
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black26,width: .5)),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          tileColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(winners.contest_name,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                    Text(winners.date,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18))
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: .5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                child: Row(
                                  children: [
                                    Text(winners.name,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 13, 10, 3),
                                child: Row(
                                  children: [
                                    Image.asset('assets/trophy.png',width: 50,height: 50,),
                                    SizedBox(width: 10,),
                                    Text('Won',style: TextStyle(fontFamily: 'Raleway',color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 22),),
                                    SizedBox(width: 5,),
                                    Text('₹'+winners.prize,style: TextStyle(fontFamily: 'Raleway',color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 22),),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: .5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                                child: Row(
                                  children: [
                                    Text('Lucky Number: ',style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),),
                                    Text(winners.lucky_no,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
      ): Center(
        child: LoadingAnimationWidget.hexagonDots(color: Colors.grey[500]!, size: 50),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child: SingleChildScrollView(
          child: MyHeaderDrawer(phno.toString(),name),
        ),
      ),
    );
  }
}
