import 'package:flutter/material.dart';
import 'package:try_your_luck/wallet/add_money.dart';
import 'package:try_your_luck/wallet/upi.dart';

class PaymentOptions extends StatefulWidget {
  final String amount,balance;
  PaymentOptions({required this.amount,required this.balance});

  @override
  State<PaymentOptions> createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text('PAYMENT OPTIONS'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                      Text('Paying to: Try Your Luck',style: TextStyle(fontSize: 20,fontWeight: FontWeight.normal),),
              ],
            ),
          ),
          Divider(
            thickness: 10,
            color: Colors.grey[200],
          ),
              Padding(
                padding: const EdgeInsets.fromLTRB(15, 15, 15, 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                        children: [
                          Text('Add ',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                          Icon(Icons.currency_rupee_sharp,size: 15,),
                          Text(widget.amount,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold))
                        ]
                    ),
                    Row(
                      children: [
                        InkWell(
                          onTap: (){
                            Navigator.pop(context);
                          },
                            child: Icon(Icons.edit),
                        ),
                        SizedBox(width: 5,)
                      ],
                    )
                  ],
                ),
              ),
          Divider(
            thickness: 10,
            color: Colors.grey[200],
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Text('All Options',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                  ],
                ),
                SizedBox(height: 20,),
                InkWell(
                  onTap: (){
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => UPI(widget.amount)));
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                          children: [
                            Image.asset('assets/upi.png',width: 25,height: 25,),
                            SizedBox(width: 10,),
                            Text('UPI',style: TextStyle(fontSize: 20))
                          ]
                      ),
                      Row(
                        children: [
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
            ],
      ),
    );
  }
}
