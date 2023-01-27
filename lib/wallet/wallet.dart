import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:try_your_luck/wallet/add_money.dart';
import 'package:http/http.dart' as http;

class Wallet extends StatefulWidget {
  late final String balance;
  Wallet(this.balance);

  @override
  State<Wallet> createState() => _WalletState();
}

class _WalletState extends State<Wallet> {

  String? phno="";

  @override
  void initState() {
    super.initState();
    phno=FirebaseAuth.instance.currentUser?.phoneNumber;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        foregroundColor: Colors.white,
        backgroundColor: Colors.green.shade600,
        title: Text('My Wallet'),
        // title: Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(8, 8, 8, 15),
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
                        MaterialPageRoute(builder: (context) => AddMoney(widget.balance.toString())));
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
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Row(
                          children: [
                            Text('Transactions',style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
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
    );
  }
  Widget loading_balance(){
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.currency_rupee,color: Colors.black,size: 20,),
          Text(widget.balance,style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),)
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
