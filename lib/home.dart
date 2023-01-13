import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:try_your_luck/drawer.dart';

import 'models/UserModel.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  List<UserModel>? list=[];

  @override
  void initState() {
    super.initState();
    fetchDataContests();
  }

  Future<void> fetchDataContests() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/findOne';
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
      print(data['document'].length);
      setState((){

      });
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
        // leading: Builder(
        //   builder: (context) => GestureDetector(
        //     child:
        //     // CircleAvatar(
        //     //   backgroundImage: AssetImage('assets/empty_person.jpg'),
        //     //   // backgroundImage: NetworkImage('url'),
        //     //   radius: 5,
        //     // ),
        //     Container(
        //       decoration: BoxDecoration(
        //         borderRadius: BorderRadius.circular(100),
        //         image: DecorationImage(
        //           image: AssetImage('assets/empty_person.jpg'),
        //         )
        //       ),
        //     ),
        //     onTap: (){Scaffold.of(context).openDrawer();},
        //   ),
        // ),
        title: Text('Try Your Luck'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child:Column()
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
}