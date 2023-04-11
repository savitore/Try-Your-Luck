import 'dart:convert';
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

  List<ContestModel>? list=[], _head=[], _teen=[], _ten=[], _mega=[];
  int flag=0;
  String name='',balance='';
  String? phno;
  bool prize=false, fee = false, filter = false,head=false, teen=false, ten=false, mega=false, all= true;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }

  void sortByPrice(){
    setState(() {
      Comparator<ContestModel> sort = (a,b) => int.parse(b.win_amount).compareTo(int.parse(a.win_amount));
      list?.sort(sort);
      _head?.sort(sort);
      _teen?.sort(sort);
      _ten?.sort(sort);
      _mega?.sort(sort);
    });
  }
  void sortByFee(){
    setState(() {
      Comparator<ContestModel> sort = (a,b) => int.parse(a.fee).compareTo(int.parse(b.fee));
      list?.sort(sort);
      _head?.sort(sort);
      _teen?.sort(sort);
      _ten?.sort(sort);
      _mega?.sort(sort);
    });
  }
  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(_scrollListener);
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
      flag=1;
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
          if(int.parse(data['documents'][i]['no_of_people']) == 2){
            _head?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
          } else if(int.parse(data['documents'][i]['no_of_people']) == 3){
            _teen?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
          } else if(int.parse(data['documents'][i]['no_of_people']) == 10){
            _ten?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
          } else{
            _mega?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
          }
        });
      }
      fetchDataProfile();
    }catch(e){
      print(e.toString());
    }
  }
  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
    phno =prefs.getString("phone")!;
    fetchDataContests();
  }
  @override
  Widget build(BuildContext context) {
    return flag==1 ? Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: _scrollPosition < 20 ? Text('Try Your Luck'): Text('Live Contests'),
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
                Icon(Icons.account_balance_wallet_outlined,),
                Text(' ₹'+ balance,style: TextStyle(fontSize: 19),)
              ],
            ),
          ),
          SizedBox(width: 8,),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
          child:SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment:CrossAxisAlignment.start ,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Live contests',style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.black),),
                    SizedBox(
                      height: 30,
                      width: 30,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            filter= !filter;
                          });
                        },
                        style: filter ? ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.green.shade600),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                                side: BorderSide(color: Colors.white)))) : ButtonStyle(
                            padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all(
                                Colors.white),
                            shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(60),
                                side: BorderSide(color: Colors.white)))
                        ) ,
                        child: Icon(Icons.filter_list_rounded,
                            color: filter ? Colors.white : Colors.green.shade600, size: 20),
                      ),
                    )
                  ],
                ),
                filter ? showFilter() : SizedBox(height: 10,),
                filtered(),
              ],
            ),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child: SingleChildScrollView(
          child: Container(
            // color: Colors.white,
            child: MyHeaderDrawer(phno.toString(),name),
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

  Widget showFilter(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      all = true;
                      head=false;
                      teen=false;
                      ten=false;
                      mega=false;
                    });
                  },
                  child: Text('ALL'),
                  style: all ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                    onPressed: (){
                      setState(() {
                        head = true;
                        teen=false;
                        ten=false;
                        mega=false;
                        all=false;
                      });
                      },
                    child: Text('HEAD TO HEAD'),
                  style: head ? ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      teen = true;
                      head=false;
                      ten=false;
                      mega=false;
                      all=false;
                    });
                  },
                  child: Text('TEEN'),
                  style: teen ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      ten = true;
                      head=false;
                      teen=false;
                      mega=false;
                      all=false;
                    });
                  },
                  child: Text('10 KA DUM'),
                  style: ten ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      mega = true;
                      head=false;
                      teen=false;
                      ten=false;
                      all=false;
                    });
                  },
                  child: Text('MEGA'),
                  style: mega ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text('SORT BY:',style: TextStyle(color: Colors.black),),
              SizedBox(width: 10,),
              InkWell(
                child: Text('PRIZE',style: TextStyle(color: prize ? Colors.blueAccent : Colors.black),),
                onTap: (){
                  setState(() {
                    prize=true;
                    fee=false;
                    sortByPrice();
                  });
                }
                ),
              SizedBox(width: 10,),
              InkWell(
                  child: Text('JOINING FEE',style: TextStyle(color: fee ? Colors.blueAccent : Colors.black),),
                  onTap: (){
                    setState(() {
                      fee=true;
                      prize=false;
                      sortByFee();
                    });
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }

   Widget filtered(){
    if(head){
      return Column(
        children: _head!.map((contests){
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if(teen){
      return Column(
        children: _teen!.map((contests){
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if(ten){
      return Column(
        children: _ten!.map((contests){
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else if(mega){
      return Column(
        children: _mega!.map((contests){
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    } else{
      return Column(
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
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      );
    }
   }
}