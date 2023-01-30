import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/wallet/add_money.dart';
import 'package:http/http.dart' as http;
import '../models/TranscationsModel.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  String? phno="";
  String balance='',result='';
  int flag=0;
  List<TranscationsModel>? list=[];
  late Text entry_paid=Text('Entry Paid',style: TextStyle(color: Colors.black,fontSize: 20),);
  late Text winnings=Text('Winnings',style: TextStyle(fontSize: 20,color: Colors.green.shade600),);

  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchBalance();
    fetchMyContests();
  }
  Future<void> fetchBalance() async{
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
        balance=data['document']['balance'];
      });
      flag=1;
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
          print("1");
          if(data['documents'][i]['result']!=''){
            result=data['documents'][i]['result'].toString();
            list?.add(TranscationsModel(contest_name: data['documents'][i]['contest'], winning_amount: data['documents'][i]['winning_amount'], result: '', date: data['documents'][i]['date'], time: data['documents'][i]['time'], fee: data['documents'][i]['fee']));
            print(i.toString()+" "+result);
          }
          setState(() {
            print("hi");
            print(i.toString()+data['documents'][i]['fee']);
            list?.add(TranscationsModel(contest_name: data['documents'][i]['contest'], winning_amount: data['documents'][i]['winning_amount'], result: result, date: data['documents'][i]['date'], time: data['documents'][i]['time'], fee: data['documents'][i]['fee']));
          });
          result='';
        }
        flag=1;
      });
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade600,
        title: Text('My Wallet'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  SizedBox(height: 15,),
                  Text('Total Balance',style: TextStyle(color: Colors.grey[600],fontSize: 15),),
                  SizedBox(height: 5,),
                  loading_balance(),
                  SizedBox(height: 5,),
                  ElevatedButton(
                    onPressed: (){
                      Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddMoney(balance.toString())));
                    },
                    child:Text('ADD MONEY'),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                  ),
                  SizedBox(height: 10,),
                  Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6.0),
                          child: Row(
                            children: [
                              Text('Transactions',style: TextStyle(fontSize: 23,fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                        Column(
                          children: list!.map((contests){
                            return Card(
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Column(
                                  children: [
                                    transcation(contests.contest_name,contests.winning_amount,contests.date,contests.time,contests.result,contests.fee),
                                  ],
                                )
                              ),
                            );
                          }).toList(),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    showToast();
                  },
                  child: Text('Withdraw'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                ),
              ),
            ],
          ),
        ),

      ),
    );
  }
  Widget loading_balance(){
    if(flag==1){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.currency_rupee,color: Colors.black,size: 20,),
          Text(balance,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)
        ],
      );
    }else{
      return Center(child: CircularProgressIndicator(
        color: Colors.green.shade600,
      ));
    }
  }
  Widget transcation(String contest_name, String winning_amount, String date, String time, String Result, String fee){
    if(Result=="won"){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              winnings,
              Text(contest_name,style: TextStyle(color: Colors.black,fontSize: 17)),
            ],
          ),
          winning(winning_amount),
        ],
      );
    }
    else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              entry_paid,
              Text(contest_name,style: TextStyle(color: Colors.black,fontSize: 17)),
              Row(
                children: [
                  Text(date+" | "),
                  Text(time)
                ],
              ),
            ],
          ),
          entry(fee),
        ],
      );
    }
  }
  Widget entry(String fee){
     return Row(
      children: [
        Text("-",style: TextStyle(fontSize: 18),),
        Icon(Icons.currency_rupee_outlined,color: Colors.black,size: 18,),
        Text(fee,style: TextStyle(fontSize: 18),),
      ],
    );
  }
  Widget winning(String winning_amount){
    return Row(
      children: [
        Text("+",style: TextStyle(fontSize: 18,color: Colors.green.shade600),),
        Icon(Icons.currency_rupee_outlined,color: Colors.green.shade600,size: 18),
        Text(winning_amount,style: TextStyle(fontSize: 18,color: Colors.green.shade600),),
      ],
    );
  }
  showToast() =>
      Fluttertoast.showToast(
          msg: "Withdraw option will come soon.",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 20.0
      );
}
