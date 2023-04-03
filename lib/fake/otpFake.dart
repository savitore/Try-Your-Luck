import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/screens/home.dart';


class otpFake extends StatefulWidget {
  final String phone;
  otpFake(this.phone);

  @override
  State<otpFake> createState() => _otpFakeState();
}

class _otpFakeState extends State<otpFake> {

  @override
  void initState() {
    super.initState();
  }

  final GlobalKey<FormState> scaffoldkey = GlobalKey<FormState>();
  String? OTP="";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: scaffoldkey,
      extendBodyBehindAppBar: true,
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
      body: Container(
        margin: EdgeInsets.fromLTRB(20, 110, 20, 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Enter OTP sent to',
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: Colors.grey[700]),
                ),
                Text(
                  widget.phone,
                  style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 1,),
                InkWell(
                  onTap: (){
                    Navigator.pop(context);
                  },
                  child: Text('Edit Phone Number?',style: TextStyle(color: Colors.black),),
                ),
                SizedBox(height: 20),
                Pinput(
                  length: 6,
                  showCursor: true,
                  onCompleted: (value){
                    setState(() {
                      OTP=value;
                    });
                  },
                ),
                SizedBox(height: 5,),
              ],
            ),
            SizedBox(
              height: 45,
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  if(OTP=='290603'){
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString("where", "home");
                    prefs.setString("name", "Test");
                    prefs.setString("phone", widget.phone);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                            (route) => false);
                  }
                  else if(OTP!.isEmpty){
                    showToastOTP();
                  }
                  else if(OTP!='290603'){
                    showToastIncorrect();
                  }
                },
                child: Text('Verify Phone Number'),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void showToastIncorrect() =>
      Fluttertoast.showToast(
          msg: "Entered OTP is incorrect.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
  void showToastOTP() =>
      Fluttertoast.showToast(
          msg: "Please enter OTP.",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.white,
          textColor: Colors.black,
          fontSize: 16.0
      );
}
