import 'dart:io';

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
  int flag=0;
  String result='',balance='',userName='';
  String redeemed='no';
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
            list?.add(MyContestsModel(contest_name: data['documents'][i]['contest'], lucky_number: data['documents'][i]['lucky_no_user'], winning_amount: data['documents'][i]['winning_amount'], result: result));
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
        redeemed=data['document']['redeemed'].toString();
      });
      // if(balance==data['document']['balance']){
      flag=1;
      // }
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> UpdateUserRedeemedOrNot(String contestName,String winning_amount, String lucky_no_user) async {
    String baseUrl='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/updateOne';
    final body={
      "dataSource":"Cluster0",
      "database":"users",
      "collection":phno,
      "filter":{
        "contest":contestName,
      },
      "update":{
        "contest":contestName,
        "winning_amount": winning_amount,
        "lucky_no_user": lucky_no_user,
        "result":"won",
        "redeemed":"yes"
      }
    };
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
    print(output['insertedId']);
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
                            ifWon(contests.result,contests.contest_name,contests.winning_amount,contests.lucky_number)
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
  Widget ifWon(String Result,String contestName,String winning_amount,String lucky_no_user){
    if(Result!=''){
      fetchRedeemedOrNot(contestName);
      print("1"+redeemed);
      return Row(
        children: [
          Text(Result,style: TextStyle(fontSize: 20,color: Colors.green.shade600),),
          SizedBox(width: 10),
          redeemedOrNot(contestName,winning_amount,lucky_no_user)
        ],
      );
    }else{
      print(redeemed);
      return Text('');
    }
  }
  Widget redeemedOrNot(String contestName, String winning_amount, String lucky_no_user){
    if(redeemed=="no"){
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
                        UpdateUserRedeemedOrNot(contestName, winning_amount, lucky_no_user);
                        updateBalance((int.parse(balance)+int.parse(winning_amount)).toString());
                        Navigator.pop(context);
                        Navigator.pop(context);
                        Navigator.pop(context);
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
    } else if(redeemed=="yes"){
      return ElevatedButton(
        onPressed: null,
        child: Text('Redeemed'),
        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade200),
      );
    }else{
      return Text('');
    }
  }
}
