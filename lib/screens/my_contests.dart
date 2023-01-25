import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/models/MyContestsModel.dart';

class MyContests extends StatefulWidget {
  const MyContests({Key? key}) : super(key: key);

  @override
  State<MyContests> createState() => _MyContestsState();
}

class _MyContestsState extends State<MyContests> {

  String? phno="";
  List<MyContestsModel>? list=[];
  int flag=0,flag1=0;
  String result='',balance='',userName='';
  String Redeemed='no';
  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchMyContests();
    fetchDataProfile();
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
        userName=data['document']['name'].toString();
      });
    }catch(e){
      print(e.toString());
    }
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
            list?.add(MyContestsModel(contest_name: data['documents'][i]['contest'], lucky_number: data['documents'][i]['lucky_no_user'], winning_amount: data['documents'][i]['winning_amount'], result: result, redeemed: data['documents'][i]['redeemed']));
          });
          result='';
        }
        flag=1;
      });
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> fetchRedeemedOrNot(String contestName) async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"users",
      "collection":phno,
      "filter":{
        "contest": contestName
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
        Redeemed=data['document']['redeemed'].toString();
      });
      // if(balance==data['document']['balance']){
      flag=1;
      // }
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> updateBalance(String Balance) async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/updateOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "phone_number": phno
      },
      "update": {
        "name": userName,
        "phone_number": phno,
        "balance": Balance
      }
    };
    final response;
    try{
      HttpClient httpClient=new HttpClient();
      HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
      httpClientRequest.headers.set("Content-Type", "application/json");
      httpClientRequest.headers.set("api-key", "hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y");
      httpClientRequest.add(utf8.encode(jsonEncode(body)));
      HttpClientResponse response=await httpClientRequest.close();
      httpClient.close();
      final contents = StringBuffer();
      await for (var data in response.transform(utf8.decoder)) {
        contents.write(data);
      }
      var output=jsonDecode(contents.toString());
      print(output);
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.green.shade600,
            foregroundColor: Colors.white,
            title: Text('My Contests'),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: list!.map((contests){
                    return Card(
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(contests.contest_name,style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),),
                                Row(
                                  children: [
                                    Text('Total prize: '),
                                    Icon(Icons.currency_rupee,size: 15,color: Colors.black,),
                                    Text(contests.winning_amount)
                                  ],
                                ),
                                Text('Lucky number: '+contests.lucky_number)
                              ],
                            ),
                            ifWon(contests.result,contests.contest_name,contests.winning_amount,contests.lucky_number,contests.redeemed)
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
          )
      );
    }else{
      return Scaffold(
          body: Center(child: CircularProgressIndicator())
      );
    }
  }
  Widget ifWon(String Result,String contestName,String winning_amount,String lucky_no_user, String redeemed){
    if(Result!=''){
      fetchRedeemedOrNot(contestName);
      return Row(
        children: [
          Text(Result,style: TextStyle(fontSize: 20,color: Colors.green.shade600),),
          SizedBox(width: 10),
          redeemedOrNot(contestName,winning_amount,lucky_no_user, redeemed)
        ],
      );
    }else{
      return Text('');
    }
  }
  Widget redeemedOrNot(String contestName, String winning_amount, String lucky_no_user, String redeemed){
    if(redeemed=="yes"){
      return ElevatedButton(
        onPressed: null,
        child: Text('Redeemed'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade200),
      );
    }
    else if(redeemed=="no"){
      return SizedBox(
        child: ElevatedButton(
          onPressed: (){
            showDialog(context: context, builder: (context){
              return Container(
                child: AlertDialog(
                  actionsAlignment: MainAxisAlignment.center,
                  title: Text('Confirmation',style: TextStyle(fontWeight: FontWeight.normal),),
                  content: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('You will receive'),
                          Row(
                            children: [
                              Icon(Icons.currency_rupee,color: Colors.black,),
                              Text(winning_amount,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  actions: [
                    ElevatedButton(
                      onPressed: (){
                        updateBalance((int.parse(balance)+int.parse(winning_amount)).toString());
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
                        showDialog(context: context, builder: (context){
                          return Container(
                            child: AlertDialog(
                              title: Text('Redeemed!',style: TextStyle(fontWeight: FontWeight.normal),),
                              content: Container(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('Updated balance'),
                                    Row(
                                      children: [
                                        Icon(Icons.currency_rupee,color: Colors.black,),
                                        Text((int.parse(balance)+int.parse(winning_amount)).toString(),style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                      },
                      child: Text('Redeem'),
                      style: ElevatedButton.styleFrom(
                          elevation: 12,
                          backgroundColor: Colors.green.shade600
                      ),
                    )
                  ],
                ),
              );
            });
          },
          child: Text('Redeem?'),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,textStyle: TextStyle(color: Colors.white)),
        ),
      );
    } else{
      return Text('');
    }
  }
}
