import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../data_services.dart';
import '../home.dart';

class Name extends StatefulWidget {
  const Name({Key? key}) : super(key: key);

  @override
  State<Name> createState() => _NameState();
}

class _NameState extends State<Name> {
  String? uid,phno;
  var name="";
  @override
  void initState() {
    super.initState();
    uid = FirebaseAuth.instance.currentUser!.uid;
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
  }
  DataService dataService=DataService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.fromLTRB(25, 150, 25, 40),
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children:[
                  Row(
                  children: [
                    Text(
                      'What is your name?',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30,
                        // fontFamily:'Raleway'
                      ),

                    ),
                  ],
                ),
                  SizedBox(height: 5,),
                  Divider(
                    height: 5,
                    thickness: 1,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 10,),
                  SizedBox(
                    child: TextField(
                      showCursor: true,
                      keyboardType: TextInputType.text,
                      onChanged: (value) {
                        name = value;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter Your Name"
                      ),
                      style: TextStyle(fontSize: 26),
                    ),
                  ),
                  SizedBox(height: 20,),
                  ]
                ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if(name.isEmpty)
                        {
                          showToastEmpty();
                        }
                      else if(name.length<3)
                        {
                          showToastIncomplete();
                        }
                      else
                        {
                          print("hi");
                          _insertData(name, phno!);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => Home()),
                                  (route) => false);
                        }
                    },
                    child: Text('Next'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                  ),
                ),
              ],
            ),
        ),
      // ),
    );
  }
  void showToastEmpty() =>
      Fluttertoast.showToast(
          msg: "Please enter name",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  void showToastIncomplete() =>
      Fluttertoast.showToast(
          msg: "Name must contain atleast 3 characters.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  Future<void> _insertData(String name, String phoneno) async{
    dataService.DataInsertUsers(name,phoneno,0.toString(),context);
  }
}
