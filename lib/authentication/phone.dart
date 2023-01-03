import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      body: Container(
        margin: EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.centerLeft,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Image.asset('assets/bg.png', width: 150, height: 150,),
              SizedBox(height: 25,),
              Text(
                'Enter Your Phone Number',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
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
              SizedBox(height: 25,),
              SizedBox(
                height: 45,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if(countrycode.text=="+91" && phone.length!=10)
                    {
                      showToastIncorrect();
                    }
                    else if (countrycode.text.isNotEmpty && phone.isNotEmpty) {
                      // await FirebaseAuth.instance.verifyPhoneNumber(
                      //   phoneNumber: '${countrycode.text + phone}',
                      //   verificationCompleted: (
                      //       PhoneAuthCredential credential) {},
                      //   verificationFailed: (FirebaseAuthException e) {},
                      //   codeSent: (String verificationId, int? resendToken) {},
                      //   codeAutoRetrievalTimeout: (String verificationId) {},
                      // );
                      String phoneno=countrycode.text + phone.toString();
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context)=> Otp(phoneno)
                      ));
                    }
                    else if (phone.isEmpty) {
                      print("hi");
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
