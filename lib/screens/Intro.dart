import 'package:flutter/material.dart';
import 'package:try_your_luck/authentication/phone.dart';

class Intro extends StatelessWidget {
  const Intro({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Padding(
        padding: EdgeInsets.fromLTRB(20, 80, 20, 20),
        child: SingleChildScrollView(
          child: Container(
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                          'assets/logo.png',
                        width: 80,
                      ),
                    ],
                  ),
                  SizedBox(height: 5,),
                  Text('Try Your Luck',style: TextStyle(fontSize: 30,color: Colors.black),),
                  SizedBox(height: 10,),
                  Padding(
                    padding: EdgeInsets.all(20),
                      child: Text('This application allows people to try their luck and win money. You can call the app "Online Lottery". You need to join a contest and pay the entry fee. After which, you will be assigned a lucky number. If the random draw number matches your lucky number after the contest is complete, you win the prize money. Currently, you cannot use real money. You will be given Rs 100 on sign-up, which you can use to participate in contests. Any money, if won, cannot be withdrawn. Please use this app to only try your luck.',style: TextStyle(fontSize: 20),)
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                            onPressed: (){
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context)=> Phone()
                              ));
                            },
                            child: Row(
                              children: [
                                Text('Next'),
                                SizedBox(width: 2,),
                                Icon(Icons.arrow_forward,size: 17,)
                              ],
                            ),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600, elevation:10),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}
