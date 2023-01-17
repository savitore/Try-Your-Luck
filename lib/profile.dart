import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String? phno="";
  String name="",phone="";
  int flag=0;
  @override
  void initState() {
    super.initState();
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
      print(data.toString());
      setState((){
        name=data['document']['name'].toString();
        if(name==data['document']['name'].toString()){
          flag=1;
        }
        phone=data['document']['phone_number'].toString();
      });
      print(data['document']['name']);
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade600,
          title: Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 8, 10),
          child: Column(
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/empty_person.jpg'),
                // backgroundImage: NetworkImage('url'),
                radius: 50,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text('Name',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(name,
                      style: TextStyle(color: Colors.black,fontSize: 20)),
                  SizedBox(height: 10,),
                  Text('Phone number',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(phone.toString(),style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      );
    }
    else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
