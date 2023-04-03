import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../fake/otpFake.dart';
import 'otp.dart';

class Phone extends StatefulWidget {
  const Phone({Key? key}) : super(key: key);

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {

  TextEditingController countrycode = TextEditingController();
  var phone = "";

  @override
  void initState() {
    super.initState();
    countrycode.text = "+91";
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.fromLTRB(15, 90, 15, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text(
                      'Enter your phone number to continue',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                Divider(
                  thickness: 1,
                  color: Colors.grey[600],
                ),
                SizedBox(height: 25),
                Container(
                  height: 55,
                  decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10,
                      ),
                      SizedBox(
                        width: 40,
                        child: TextField(
                          controller: countrycode,
                          decoration: InputDecoration(
                              border: InputBorder.none
                          ),
                        ),
                      ),
                      Text(
                        '|', style: TextStyle(fontSize: 33, color: Colors.grey),),
                      SizedBox(width: 10,),
                      Expanded(
                          child: TextField(
                            keyboardType: TextInputType.phone,
                            onChanged: (value) {
                              phone = value;
                            },
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Phone"
                            ),
                          )
                      )
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                Row(
                  children: [
                    Text('We will send an OTP for verification.',style: TextStyle(fontSize: 16,color: Colors.grey[700]),),
                  ],
                )
              ],
            ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      if(phone=='290603'){
                        String phoneno=countrycode.text + phone.toString();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> otpFake(phoneno)
                        ));
                      }
                      else if(countrycode.text=="+91" && phone.length!=10)
                      {
                        showToastIncorrect();
                      }
                      else if (countrycode.text.isNotEmpty && phone.isNotEmpty) {
                        String phoneno=countrycode.text + phone.toString();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=> Otp(phoneno)
                        ));
                      }
                      else if (phone.isEmpty) {
                        showToast();
                      }
                      else if(countrycode.text.isEmpty){
                        showToastCountrycode();
                      }
                    },
                    child: Text('Send OTP'),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green.shade600,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10))),
                  ),
                )
              ],
            ),
      ),
    );
  }

  void showToast() =>
      Fluttertoast.showToast(
          msg: "Please enter phone number.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  void showToastIncorrect() =>
      Fluttertoast.showToast(
          msg: "Please enter correct phone number.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  void showToastCountrycode() =>
      Fluttertoast.showToast(
          msg: "Please enter country code.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
}
