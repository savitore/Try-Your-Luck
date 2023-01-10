import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../home.dart';

class AddMoney extends StatefulWidget {
  const AddMoney({Key? key}) : super(key: key);

  @override
  State<AddMoney> createState() => _AddMoneyState();
}

class _AddMoneyState extends State<AddMoney> {
  var amount="";
  TextEditingController amount_100 = TextEditingController();
  @override
  void initState() {
    super.initState();
    amount_100.text="100";
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new_rounded,color: Colors.black,),
        ),
      ),
      // body: Container(
      //   margin: EdgeInsets.only(left: 25,right: 25,top: 100),
      //   alignment: Alignment.topLeft,
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
                children:[
                  Row(
                    children: [
                      Text(
                        'Add money',
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
                    thickness: .5,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 10,),
                  TextField(
                      showCursor: true,
                      controller: amount_100,
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        amount = value;
                      },
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter amount"
                      ),
                      style: TextStyle(fontSize: 26),
                    ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: (){amount_100.text="1000";},
                          child: Row(
                            children: [
                              Icon(Icons.currency_rupee,color: Colors.white,),
                              Text('1000',style: TextStyle(color: Colors.white),)
                            ],
                          )
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: (){amount_100.text="5000";},
                          child: Row(
                            children: [
                              Icon(Icons.currency_rupee,color: Colors.white,),
                              Text('5000',style: TextStyle(color: Colors.white),)
                            ],
                          )
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                          onPressed: (){amount_100.text="10000";},
                          child: Row(
                            children: [
                              Icon(Icons.currency_rupee,color: Colors.white,),
                              Text('10000',style: TextStyle(color: Colors.white),)
                            ],
                          )
                      )
                    ],
                  )
                ]
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if(amount==null)
                    {
                      showToastEmpty();
                    }
                  else{

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
}
