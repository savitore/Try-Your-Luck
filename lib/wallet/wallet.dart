import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/services/data_services.dart';
import '../models/TranscationsModel.dart';

class Wallet extends StatefulWidget {
  const Wallet({Key? key}) : super(key: key);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  String? phno="";
  String balance='',result='', name='';
  var amount="";
  TextEditingController amount_100 = TextEditingController();
  int flag=0,flag1=0;
  List<TranscationsModel>? list=[];
  late Text entry_paid=Text('Entry Paid',style: TextStyle(color: Colors.black,fontSize: 20),);
  late Text winnings=Text('Winnings',style: TextStyle(fontSize: 20,color: Colors.green.shade600),);
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  Razorpay _razorpay = Razorpay();
  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }
  DataService dataService = DataService();

  @override
  void initState(){
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    fetchBalance();
    fetchMyContests();
    amount_100.text="100";
    amount="100";
    getData();
    _scrollController.addListener(_scrollListener);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    updateBalance((int.parse(balance) + int.parse(amount)).toString());
    dataService.AmountAdded(phno!, amount, response.paymentId!, context);
    Navigator.pop(context);
    Navigator.pop(context);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
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
        balance=data['document']['balance'].toString();
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
          if(data['documents'][i]['result'].toString()!=''){
            result=data['documents'][i]['result'].toString();
            list?.add(TranscationsModel(contest_name: data['documents'][i]['contest'].toString(), winning_amount: data['documents'][i]['winning_amount'].toString(), result: '', date: data['documents'][i]['date'].toString(), time: data['documents'][i]['time'].toString(), fee: data['documents'][i]['fee'].toString()));
          }
          setState(() {
            list?.add(TranscationsModel(contest_name: data['documents'][i]['contest'].toString(), winning_amount: data['documents'][i]['winning_amount'].toString(), result: result, date: data['documents'][i]['date'].toString(), time: data['documents'][i]['time'].toString(), fee: data['documents'][i]['fee'].toString()));
          });
          result='';
        }
        flag1=1;
      });
    }catch(e){
      print(e.toString());
    }
  }
  Future<void> updateBalance(String Balance) async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/updateOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "phone_number": phno
      },
      "update": {
        "name": name,
        "phone_number": phno,
        "balance": Balance
      }
    };
    try{
      HttpClient httpClient=new HttpClient();
      HttpClientRequest httpClientRequest=await httpClient.postUrl(Uri.parse(baseUrl));
      httpClientRequest.headers.set("Content-Type", "application/json");
      httpClientRequest.headers.set("api-key", "hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y");
      httpClientRequest.add(utf8.encode(jsonEncode(body)));
      HttpClientResponse response=await httpClientRequest.close();
      httpClient.close();
      final contents = StringBuffer();
      await for (var data in response.transform(utf8.decoder)) {
        contents.write(data);
      }
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
        title: _scrollPosition < 145 ? Text('My Wallet') : Text('Transactions'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
          child: SingleChildScrollView(
            controller: _scrollController,
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
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => buildSheet(),
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(20)
                                )
                            )
                        );
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(builder: (context) => AddMoney(balance.toString())));
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
                          loading()
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
                    child: Text('WITHDRAW',style: TextStyle(fontSize: 18),),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),),
                  ),
                ),
              ],
            ),
          ),

        ),
      ),
    );
  }
  Widget loading_balance(){
    return flag==1 ? Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.currency_rupee,color: Colors.black,size: 20,),
        Text(balance,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)
      ],
    ) : Center(child: CircularProgressIndicator(
      color: Colors.green.shade600,
    ));
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
  Widget loading(){
    return flag1==1 ? Column(
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
    ) : Column(
      children: [
        CircularProgressIndicator(color: Colors.green.shade600,),
        SizedBox(height: 25,)
      ],
    );
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
  void showToastEmpty() =>
      Fluttertoast.showToast(
          msg: "Please enter amount",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  void showToastIncomplete() =>
      Fluttertoast.showToast(
          msg: "Amount must be Rs 1.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );

  Widget buildSheet() => Padding(
    padding: const EdgeInsets.fromLTRB(25, 5, 25, 20),
    child: Container(
      height: 400,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
              children:[
                Container(
                  height: 5,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20)
                  ),
                ),
                SizedBox(height: 15,),
                TextField(
                  showCursor: true,
                  controller: amount_100,
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    amount = value;
                  },
                  decoration: InputDecoration(
                      prefix: Text('₹',style: TextStyle(color: Colors.black),),
                      hintText: "Enter amount"
                  ),
                  style: TextStyle(fontSize: 26),
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: (){
                          amount_100.text="100";
                          amount="100";
                        },
                        child: Row(
                          children: [
                            Icon(Icons.currency_rupee,color: Colors.white,),
                            Text('100',style: TextStyle(color: Colors.white),)
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: (){
                          amount_100.text="500";
                          amount="500";
                        },
                        child: Row(
                          children: [
                            Icon(Icons.currency_rupee,color: Colors.white,),
                            Text('500',style: TextStyle(color: Colors.white),)
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                        onPressed: (){
                          amount_100.text="1000";
                          amount="1000";
                        },
                        child: Row(
                          children: [
                            Icon(Icons.currency_rupee,color: Colors.white,),
                            Text('1000',style: TextStyle(color: Colors.white),)
                          ],
                        )
                    )
                  ],
                ),
                SizedBox(height: 20,),
              ]
          ),
          SizedBox(
            height: 45,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                if(amount.toString()==null)
                {
                  showToastEmpty();
                }
                else{
                  var options = {
                    'key': 'rzp_live_xUZZSGR8ZMnBZj',
                    'amount': (int.parse(amount)*100).toString(), //in the smallest currency sub-unit.
                    'name': 'Try Your Luck',
                    // 'order_id': 'order_EMBFqjDHEEn80l', // Generate order_id using Orders API
                    'description': 'Add Amount',
                    'timeout': 300, // in seconds
                    'prefill': {
                      'name': name,
                      'contact': phno,
                    }
                  };
                  _razorpay.open(options);
                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(builder: (context) => PaymentOptions(amount: amount,balance: balance,)));
                }
              },
              child: Text('Next'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    ),
  );
}