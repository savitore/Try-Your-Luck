import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'package:http/http.dart' as http;
import 'package:try_your_luck/screens/live_contests.dart';

class IsUserAlreadyRegistered extends StatefulWidget {
  const IsUserAlreadyRegistered({Key? key}) : super(key: key);

  @override
  State<IsUserAlreadyRegistered> createState() => _IsUserAlreadyRegisteredState();
}

class _IsUserAlreadyRegisteredState extends State<IsUserAlreadyRegistered> {

  String? phno="";
  String name='';
  int flag=0;

  @override
  void initState() {
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchData();
  }

  Future<void> fetchData() async{
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
        if(response.body.length==17){
          Navigator.push(context, MaterialPageRoute(builder: (context) => Name()));
        }
        else {
          name=data['document']['name'];
          getData();
          Navigator.push(context, MaterialPageRoute(builder: (context) => LiveContests()));
        }
      });
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
      return flag ==1 ? Scaffold() : Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
  }
  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("where", "home");
    prefs.setString("phone", phno!);
    prefs.setString("name", name);
  }
}
