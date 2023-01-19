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
  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchMyContests();
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
          setState(() {
            list?.add(MyContestsModel(contest_name: data['documents'][i]['contest'], lucky_number: data['documents'][i]['lucky_no_user'], winning_amount: data['documents'][i]['winning_amount']));
          });
        }
        flag=1;
      });
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
                        title: Column(
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
}
