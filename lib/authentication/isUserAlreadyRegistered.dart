import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'package:try_your_luck/screens/home.dart';

class IsUserAlreadyRegistered extends StatefulWidget {
  const IsUserAlreadyRegistered({Key? key}) : super(key: key);

  @override
  State<IsUserAlreadyRegistered> createState() => _IsUserAlreadyRegisteredState();
}

class _IsUserAlreadyRegisteredState extends State<IsUserAlreadyRegistered> {

  String? phno="";
  String name='';
  int flag=0;
  String phoneFetched='';
  @override
  void initState() {
    getData();
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
  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    phno =prefs.getString("phone").toString();
    if(phno!='null'){
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context) => Name()));
    }
    flag=1;
  }
}
