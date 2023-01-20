import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/wallet/add_money.dart';

import '../services/data_services.dart';
import '../models/ContestUsersModel.dart';

class ContestExpandable extends StatefulWidget {
  final String name;
  final String fee;
  final String prize;
  final String no_of_people;
  final String lucky_draw_no;
  ContestExpandable({required this.name,required this.fee,required this.prize, required this.no_of_people, required this.lucky_draw_no});

  @override
  State<ContestExpandable> createState() => _ContestExpandableState();
}

class _ContestExpandableState extends State<ContestExpandable> {
  String? phno="";
  String balance='',userName='',luckyUserIfString='';
  int flag=0,luckyUserIf=0;
  var people_joined=0;
  var lucky=0;
  String lucky_no_user='',luckyUser='';
  bool alreadyJoined=false;
  String contestJoined='JOIN CONTEST';
  Color? button = Colors.green.shade600;
  List<ContestUsersModel>? contestUsers=[];

  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchDataProfile();
    fetchContestUsers();
    fetchCurrentUserForAlreadyJoined();
  }
  DataService dataService=DataService();

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
        userName=data['document']['name'].toString();
      });
      // if(balance==data['document']['balance']){
        flag=1;
      // }
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> updateBalance() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/updateOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "phone_number": phno
      },
      // "update": {  "$set":{ "balance": (double.parse(balance)-double.parse(widget.fee)).toString() }}
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
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> fetchContestUsers() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"contests",
      "collection":widget.name,
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
        lucky=i+1;
        setState((){
          contestUsers?.add(ContestUsersModel(name: data['documents'][i]['name'], lucky_number: lucky.toString()));
        });
      }
      people_joined=data['documents'].length;
      print(luckyUserIfString);
      if(data['documents'].length>=int.parse(widget.lucky_draw_no)){
      luckyUserIf=int.parse(widget.lucky_draw_no);
      luckyUserIfString=(luckyUserIf-1).toString();
        luckyUser=data['documents'][int.parse(luckyUserIfString)]['name'];
      }
      lucky_no_user=(people_joined+1).toString();
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> fetchCurrentUserForAlreadyJoined() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"contests",
      "collection":widget.name,
      "filter":{
        "phone_number": phno
      },
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
          alreadyJoined=data['document']['already_joined'];
          if(alreadyJoined==true){
            contestJoined='ALREADY JOINED';
            button=Colors.green.shade100;
          }
        });
    }catch(e){
      print("this"+e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text(widget.name,style: TextStyle(color: Colors.white),),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Text('Prize Pool: ',style: TextStyle(color: Colors.black,fontSize: 30),),
                        Icon(Icons.currency_rupee,color: Colors.black,size: 27,),
                        Text(widget.prize,style: TextStyle(color: Colors.black,fontSize: 30)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Entry fee: ',style: TextStyle(color: Colors.black,fontSize: 20),),
                        Icon(Icons.currency_rupee,color: Colors.black,size: 18,),
                        Text(widget.fee,style: TextStyle(color: Colors.black,fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('People joined: ',style: TextStyle(color: Colors.black,fontSize: 20),),
                        Text(people_joined.toString(),style: TextStyle(color: Colors.black,fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    contestIsFullOrElse()
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[600],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('People joined:-',style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 1,
                color: Colors.grey[600],
              ),
              SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child:loaded(),
                  ),
                ),
              ),
            ],
          )
      );
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
  Widget loaded(){
    return Column(
      children: contestUsers!.map((contestUsers){
        return Card(
          child: ListTile(
            tileColor: Colors.white,
            title: Row(
              children: [
                Text(
                  contestUsers.lucky_number+'.',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
                SizedBox(width: 10,),
                Text(
                  contestUsers.name,
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget contestIsFullOrElse(){
    if(people_joined<double.parse(widget.no_of_people)){
      return SizedBox(
        height: 45,
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            if(alreadyJoined==false){
              if(people_joined<double.parse(widget.no_of_people)){
                if(double.parse(balance)>double.parse(widget.fee)){
                  showDialog(context: context, builder: (context){
                    return Container(
                      child: AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        title: Text('CONFIRMATION',style: TextStyle(fontWeight: FontWeight.bold),),
                        content: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('To Pay'),
                                Row(
                                  children: [
                                    Icon(Icons.currency_rupee,color: Colors.black,),
                                    Text(widget.fee,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        actions: [
                          ElevatedButton(
                              onPressed: (){
                                alreadyJoined=true;
                                updateBalance();
                                dataService.DataInsertContestUsers(userName, phno!, widget.name,alreadyJoined, context);
                                dataService.DataInsertUserMultipleContests(widget.name, phno!, widget.prize,lucky_no_user, context);
                                Navigator.pop(context);
                                Navigator.pop(context);
                                showDialog(context: context, builder: (context){
                                  return Container(
                                    child: AlertDialog(
                                      title: Text('Congratulations!',style: TextStyle(fontWeight: FontWeight.normal,fontSize: 22),),
                                      actions: [
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Contest joined',style: TextStyle(fontSize: 20),),
                                          ],
                                        ),
                                        SizedBox(height: 10,),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text('Your Lucky Number is',style: TextStyle(fontSize: 22)),
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(lucky_no_user,style: TextStyle(fontSize: 60,color: Colors.green.shade600),),
                                          ],
                                        )
                                      ],
                                    ),
                                  );
                                });
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 12,
                                  backgroundColor: Colors.green.shade600
                              ),
                              child: Text('JOIN CONTEST')
                          )
                        ],
                      ),
                    );
                  });
                }else{
                  showDialog(context: context, builder: (context){
                    return Container(
                      child: AlertDialog(
                        actionsAlignment: MainAxisAlignment.center,
                        title: Text('Insufficient balance',style: TextStyle(fontWeight: FontWeight.normal),),
                        actions: [
                          ElevatedButton(
                              onPressed: (){
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context)=> AddMoney(balance)
                                ));
                              },
                              style: ElevatedButton.styleFrom(
                                  elevation: 12,
                                  backgroundColor: Colors.green.shade600
                              ),
                              child: Text('Add money?')
                          )
                        ],
                      ),
                    );
                  });
                }
              }
              else{
                showDialog(context: context, builder: (context){
                  return Container(
                    child: AlertDialog(
                      title: Text('Contest full!',style: TextStyle(fontWeight: FontWeight.normal),),
                    ),
                  );
                });
              }
            }
            else{
              showDialog(context: context, builder: (context){
                return Container(
                  child: AlertDialog(
                    title: Text('Already joined',style: TextStyle(fontWeight: FontWeight.normal),),
                  ),
                );
              });
            }
          },
          child: Text(contestJoined),
          style: ElevatedButton.styleFrom(backgroundColor: button,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
        ),
      );
    }else{
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(
            height: 5,
            thickness: 2,
          ),
          SizedBox(height: 10,),
          Text('Lucky draw number',style: TextStyle(fontSize: 20)),
          Text(widget.lucky_draw_no.toString(),style: TextStyle(fontSize: 60,color: Colors.green.shade600),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Winner is ',style: TextStyle(fontSize: 20),),
              Text(luckyUser.toString(),style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),)
            ],
          ),
        ],
      );
    }
  }
}
