import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:try_your_luck/screens/ContestExpandable.dart';
import 'package:try_your_luck/screens/drawer.dart';

import '../models/ContestModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<ContestModel>? list=[];
  int flag=0;
  @override
  void initState() {
    super.initState();
    fetchDataContests();
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
      print(data.toString());
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          list?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no']));
        });
      }
      print(data['documents'][0]['name']);
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: Text('Try Your Luck'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:loaded(),
      ),
      ),
      drawer: Drawer(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer()
              ],
            ),
          ),
      ),
    );
  }
  Widget loaded(){
    if(flag==1){
      return Column(
        crossAxisAlignment:CrossAxisAlignment.start ,
        children: [
          Text('Upcoming contests',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w500),),
          SizedBox(height: 10,),
          Column(
            children: list!.map((contests){
              return InkWell(
                onTap: (){
                  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.name, fee: contests.fee, prize: contests.win_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no,)));
                },
                child: Card(
                  color: Colors.green,
                  child: ListTile(
                    tileColor: Colors.white,
                    title: Text(
                      contests.name,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          children: [
                            Text('Entry fee: ',style: TextStyle(color: Colors.black),),
                            Icon(Icons.currency_rupee,color: Colors.black,size: 12,),
                            Text(contests.fee,style: TextStyle(color: Colors.black)),
                          ],
                        ),
                        Row(
                          children: [
                            Text('Prize Pool: ',style: TextStyle(color: Colors.black),),
                            Icon(Icons.currency_rupee,color: Colors.black,size: 12,),
                            Text(contests.win_amount,style: TextStyle(color: Colors.black)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      );
    }
    else{
      return Center(child: CircularProgressIndicator());
    }
  }
}