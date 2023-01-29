import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/authentication/name.dart';
import 'package:try_your_luck/authentication/isUserAlreadyRegistered.dart';


class Otp extends StatefulWidget {
  final String phone;
  Otp(this.phone);

  @override
  State<Otp> createState() => _OtpState();
}

class _OtpState extends State<Otp> {

  @override
  void initState() {
    super.initState();
    verifyPhone();
  }

  final GlobalKey<FormState> scaffoldkey = GlobalKey<FormState>();
  late String verificationCode,authStatus;
  String? OTP="";
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: TextStyle(fontSize: 20, color: Color.fromRGBO(30, 60, 87, 1), fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromRGBO(234, 239, 243, 1)),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Did not receive OTP?',style: TextStyle(color: Colors.grey[800]),),
                    GestureDetector(
                      onTap: (){
                        verifyPhone();
                      },
                      child: Text('Resend OTP',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
              ],
            ),
                SizedBox(
                  height: 45,
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async{
                      signIn(OTP!);
                      if(FirebaseAuth.instance.currentUser!=null){
                        var prefs = await SharedPreferences.getInstance();
                        prefs.setString("where", "name");
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => IsUserAlreadyRegistered()),
                                (route) => false);
                      }
                      else if(OTP!.isEmpty){
                        showToastOTP();
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
  Future<void> verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: widget.phone,
        verificationCompleted: (AuthCredential credential) async {
          auth.signInWithCredential(credential);
          setState(() {
            authStatus = "Your account is successfully verified";
          });
        },
        verificationFailed: (FirebaseAuthException e) {
          setState(() {
            authStatus = "Authentication failed";
          });
          if (e.code == 'invalid-phone-number') {
            print('The provided phone number is not valid.');
          }
        },
        codeSent: (String verificationID, int? resendToken) async{
          verificationCode = verificationID;
          setState(() {
            authStatus = "OTP has been successfully send";
          });
        },
        codeAutoRetrievalTimeout: (String verificationID) {
            verificationCode = verificationID;
            setState(() {
              authStatus = "TIMEOUT";
            });
        },
        timeout: Duration(seconds: 15)
    );
  }
  Future<void> signIn(String otp) async {
     await auth
        .signInWithCredential(PhoneAuthProvider.credential(
        verificationId: verificationCode,
        smsCode: OTP!
    ));
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
