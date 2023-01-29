import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:try_your_luck/wallet/payment_options.dart';

class AddMoney extends StatefulWidget {
  final String balance;
  AddMoney(this.balance);

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
    amount="100";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: (){
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,color: Colors.black,),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(25, 20, 25, 20),
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
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Divider(
                    height: 5,
                    thickness: .5,
                    color: Colors.grey[700],
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
                  Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width: 1,style: BorderStyle.solid)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                            children: [
                              Icon(Icons.account_balance_wallet_outlined),
                              SizedBox(width: 5,),
                              Text('Current Balance',style: TextStyle(fontSize: 20),),
                            ]
                        ),
                        Row(
                          children: [
                            Icon(Icons.currency_rupee,size: 19,),
                            Text(widget.balance,style: TextStyle(fontSize: 20),),
                            SizedBox(width: 5,)
                          ],
                        )
                      ],
                    ),
                  ),
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
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => PaymentOptions(amount: amount,balance: widget.balance,)));
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
