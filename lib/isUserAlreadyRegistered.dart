import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'package:try_your_luck/screens/home.dart';

class IsUserAlreadyRegistered extends StatefulWidget {
  const IsUserAlreadyRegistered({Key? key}) : super(key: key);

  @override
  State<IsUserAlreadyRegistered> createState() => _IsUserAlreadyRegisteredState();
}

class _IsUserAlreadyRegisteredState extends State<IsUserAlreadyRegistered> {

  String? phno="";
  int flag=0;
  String phoneFetched='';
  @override
  void initState() {
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
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
      print(response.body);
      print(response.body.length);
      setState((){
        // if(data['document']['phone_number']!=null)
        //   {
        //     phoneFetched=data['document']['phone_number'];
        //   }
      });
      print("hi");
      print(phoneFetched);
      print(phno);
      print(response.body);
      print(response.body.length);
      // if(phoneFetched==phno.toString()){
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Home()));
      // }else{
      //   Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => Name()));
      // }
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold();
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
