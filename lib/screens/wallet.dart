import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/models/DepositsModel.dart';
import 'package:try_your_luck/services/data_services.dart';
import 'package:vibration/vibration.dart';
import '../models/TranscationsModel.dart';

class Wallet extends StatefulWidget {
  final String image;
  Wallet(this.image);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  String? phno="";
  String result='', name='',_balance='';
  var amount="";
  TextEditingController amount_100 = TextEditingController();
  int flag1=0,flag2=0, no_of_contests=0, no_of_dw=0;
  bool cont =true, dw=false;
  List<TranscationsModel>? list=[];
  List<DepositModel>? deposits=[];
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
  Timer? timer;

  @override
  void initState(){
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
    getBalance();
    fetchMyContests();
    fetchMyDeposits();
    amount_100.text="100";
    amount="100";
    getData();
    _scrollController.addListener(_scrollListener);
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getBalance());
  }
  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
    timer?.cancel();
  }
  Future<void> getBalance() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance =prefs.getString("balance")!;
    });
  }
  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
  }
  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    Vibration.vibrate(duration: 50);
    final now = new DateTime.now();
    String date = DateFormat('yMMMd').format(now);
    String time= DateFormat('jm').format(now);
    updateBalance((int.parse(_balance) + int.parse(amount)).toString());
    dataService.AmountAdded(phno!, amount, response.paymentId!, date, time, context);
    setState(() {
      _balance=(int.parse(_balance) + int.parse(amount)).toString();
      setBalance(_balance);
    });
    Navigator.pop(context);
  }
  Future<void> setBalance(String balance) async {
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("balance", balance);
  }
  void _handlePaymentError(PaymentFailureResponse response) {
    // Do something when payment fails
    print('failed');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
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
        no_of_contests=data['documents'].length;
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
  Future<void> fetchMyDeposits() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"transcations",
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
        no_of_dw=data['documents'].length;
        if(no_of_dw==0){
          setState(() {
            flag2=1;
          });
        }
        for(int i=0; i<data['documents'].length;i++){
          setState(() {
            deposits?.add(DepositModel(payment_id: data['documents'][i]['payment_id'].toString(), date: data['documents'][i]['date'].toString(), time: data['documents'][i]['time'].toString(), amount_added: data['documents'][i]['amount_added'].toString()));
          });
          flag2=1;
        }
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
        "balance": Balance,
        "image": widget.image
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
        title: _scrollPosition < 161 ? Text('My Wallet') : Text('Transactions'),
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: ElevatedButton(
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
                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/add.png',width: 20,height: 20,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text('ADD MONEY'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.green[700],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                        SizedBox(width: 10,),
                        SizedBox(
                          width: MediaQuery.of(context).size.width*0.4,
                          child: ElevatedButton(
                            onPressed: (){
                              showToast();
                            },
                            child:Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset('assets/withdraw.png',width: 20,height: 20,color: Colors.white,),
                                SizedBox(width: 10,),
                                Text('WITHDRAW'),
                              ],
                            ),
                            style: ElevatedButton.styleFrom(backgroundColor: Colors.blue[700],shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
                          ),
                        ),
                      ],
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
                          Padding(
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Row(
                              children: [
                                InkWell(
                                  onTap: (){
                                    setState(() {
                                      cont=true;
                                      dw=false;
                                    });
                                  },
                                    child: Text('Contests',style: TextStyle(fontSize: 18,color: cont ? Colors.blueAccent : Colors.black),)
                                ),
                                SizedBox(width: 20,),
                                InkWell(
                                    onTap: (){
                                      setState(() {
                                        cont=false;
                                        dw=true;
                                      });
                                    },
                                    child: Text('Deposits & Withdrawals',style: TextStyle(fontSize: 18,color: dw ? Colors.blueAccent : Colors.black),)
                                )
                              ],
                            ),
                          ),
                           cont ? Divider(
                            height: 10,
                            thickness: 2,
                            color: Colors.blueAccent,
                             indent: 10,
                             endIndent: 285,
                          ) : Divider(
                             height: 10,
                             thickness: 2,
                             color: Colors.blueAccent,
                             indent: 100,
                             endIndent: 75,
                           ),
                          cont ? contests() : Deposits()
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget loading_balance(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.currency_rupee,color: Colors.black,size: 25,),
        Text(_balance,style: TextStyle(color: Colors.black,fontSize: 25,fontWeight: FontWeight.bold),)
      ],
    );
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
                  Text(date+" | ",style: TextStyle(color: Colors.grey[600]),),
                  Text(time,style: TextStyle(color: Colors.grey[600]))
                ],
              ),
            ],
          ),
          entry(fee),
        ],
      );
    }
  }
  Widget contests(){
    return  flag1==1 ? no_of_contests ==0 ? Container(
      height: MediaQuery.of(context).size.height*0.6,
      child: Center(child: Text('No contests joined!',style: TextStyle(fontSize: 20),))
    ) : Column(
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
        LoadingAnimationWidget.hexagonDots(color: Colors.grey[500]!, size: 50),
        SizedBox(height: 25,)
      ],
    );
  }
  Widget Deposits(){
    return flag2==1 ? no_of_dw ==0 ? Container(
        height: MediaQuery.of(context).size.height*0.6,
        child: Center(child: Text('No transcations yet!',style: TextStyle(fontSize: 20),))
    ) : Column(
      children: deposits!.map((_deposits){
        return Card(
          child: ListTile(
              tileColor: Colors.white,
              title: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Amount Added',style: TextStyle(color: Colors.black,fontSize: 20),),
                          Text(_deposits.payment_id),
                          Row(
                            children: [
                              Text(_deposits.date+" | ",style: TextStyle(color: Colors.grey[600])),
                              Text(_deposits.time,style: TextStyle(color: Colors.grey[600]))
                            ],
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Text("+",style: TextStyle(fontSize: 18,color: Colors.black),),
                          Icon(Icons.currency_rupee_outlined,color: Colors.black,size: 18,),
                          Text(_deposits.amount_added,style: TextStyle(fontSize: 18,color: Colors.black),),
                        ],
                      ),
                    ],
                  )
                ],
              )
          ),
        );
      }).toList(),
    ) : Column(
      children: [
        LoadingAnimationWidget.hexagonDots(color: Colors.grey[500]!, size: 50),
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
                SizedBox(height: 25,),
                Row(
                  children: [
                    Text('Enter Amount (Min ₹1)',style: TextStyle(fontSize: 18),),
                  ],
                ),
                SizedBox(height: 5,),
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
                SizedBox(height: 20,),
                Row(
                  children: [
                    Text('Instant',style: TextStyle(fontSize: 18),),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),elevation: 0),
                        onPressed: (){
                          amount_100.text="100";
                          amount="100";
                        },
                        child: Row(
                          children: [
                            Text(' ₹100 ',style: TextStyle(color: Colors.black),)
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),elevation: 0),
                        onPressed: (){
                        amount_100.text="200";
                        amount="200";
                    },
                        child: Row(
                          children: [
                            Text(' ₹200 ',style: TextStyle(color: Colors.black),)
                          ],
                        )
                    ),
                    ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300],elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero)),
                          onPressed: (){
                          amount_100.text="500";
                          amount="500";
                        },
                        child: Row(
                          children: [
                            Text(' ₹500 ',style: TextStyle(color: Colors.black),)
                          ],
                        )
                    ),
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.grey[300],shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),elevation: 0),
                        onPressed: (){
                          amount_100.text="1000";
                          amount="1000";
                        },
                        child: Row(
                          children: [
                            Text(' ₹1000 ',style: TextStyle(color: Colors.black),)
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
                if(amount.toString().isEmpty)
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
                }
              },
              child: Text('PAY',style: TextStyle(fontSize: 20),),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
            ),
          ),
        ],
      ),
    ),
  );

}