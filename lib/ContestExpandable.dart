import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/wallet/add_money.dart';

class ContestExpandable extends StatefulWidget {
  final String name;
  final String fee;
  final String prize;
  ContestExpandable({required this.name,required this.fee,required this.prize});

  @override
  State<ContestExpandable> createState() => _ContestExpandableState();
}

class _ContestExpandableState extends State<ContestExpandable> {
  String? phno="";
  String balance='';
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
      print("hi");
      setState((){
        balance=data['document']['balance'].toString();
      });
      if(balance==data['document']['balance']){
        flag=1;
      }
    }catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    if(flag==1){
      return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            backgroundColor: Colors.green,
            title: Text(widget.name,style: TextStyle(color: Colors.white),),
          ),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('Prize Pool: ',style: TextStyle(color: Colors.black,fontSize: 30),),
                        Icon(Icons.currency_rupee,color: Colors.black,size: 27,),
                        Text(widget.prize,style: TextStyle(color: Colors.black,fontSize: 30)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('Entry fee: ',style: TextStyle(color: Colors.black,fontSize: 20),),
                        Icon(Icons.currency_rupee,color: Colors.black,size: 18,),
                        Text(widget.fee,style: TextStyle(color: Colors.black,fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 5,),
                    Row(
                      children: [
                        Text('People joined: ',style: TextStyle(color: Colors.black,fontSize: 20),),
                        Text('0',style: TextStyle(color: Colors.black,fontSize: 20)),
                      ],
                    ),
                    SizedBox(height: 20,),
                    SizedBox(
                      height: 45,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          if(double.parse(balance)>double.parse(widget.fee)){
                            showDialog(context: context, builder: (context){
                              return Container(
                                child: AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: Text('CONFIRMATION',style: TextStyle(fontWeight: FontWeight.bold),),
                                  content: Container(
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text('To Pay'),
                                          Row(
                                            children: [
                                              Icon(Icons.currency_rupee,color: Colors.black,),
                                              Text(widget.fee,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 22),),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: (){
                                        },
                                        style: ElevatedButton.styleFrom(
                                            elevation: 12,
                                            backgroundColor: Colors.green.shade600
                                        ),
                                        child: Text('JOIN CONTEST')
                                    )
                                  ],
                                ),
                              );
                            });
                          }else{
                            showDialog(context: context, builder: (context){
                              return Container(
                                child: AlertDialog(
                                  actionsAlignment: MainAxisAlignment.center,
                                  title: Text('Insufficient balance',style: TextStyle(fontWeight: FontWeight.normal),),
                                  actions: [
                                    ElevatedButton(
                                        onPressed: (){
                                          Navigator.of(context).push(MaterialPageRoute(
                                              builder: (context)=> AddMoney(balance)
                                          ));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          elevation: 12,
                                          backgroundColor: Colors.green.shade600
                                        ),
                                        child: Text('Add money?')
                                    )
                                  ],
                                ),
                              );
                            });
                          }
                        },
                        child: Text('JOIN CONTEST'),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10,),
              Divider(
                height: 1,
                thickness: 3,
                color: Colors.grey[400],
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Text('People joined:-',style: TextStyle(fontSize: 20),)
                  ],
                ),
              ),
              Divider(
                height: 1,
                thickness: 3,
                color: Colors.grey[400],
              ),
            ],
          )
      );
    }else{
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
  }
}
