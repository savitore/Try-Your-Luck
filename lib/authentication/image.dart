import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/services/data_services.dart';

import '../screens/home.dart';

class ImageView extends StatefulWidget {
  final String name, phone;
  ImageView({required this.name, required this.phone});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

  bool avatar=false;
  String _avatar='';
  DataService dataService = DataService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 150, 10, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SingleChildScrollView(
                child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Choose a profile picture',style: TextStyle(fontSize: MediaQuery.of(context).size.width*0.07,color: Colors.black),),
                  SizedBox(height: 5,),
                  Divider(
                    height: 5,
                    thickness: 1,
                    color: Colors.grey[600],
                  ),
                  SizedBox(height: 10,),
                  pickedImage(),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user1.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user1.png'),
                            radius: 30,
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user5.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user5.png'),
                            radius: 30,
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user6.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user6.png'),
                            radius: 30,
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user3.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user3.png'),
                            radius: 30,
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user2.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user2.png'),
                            radius: 30,
                          ),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () async {
                            setState(() {

                            });
                            avatar=true;
                            _avatar = 'assets/user4.png';
                          },
                          child: CircleAvatar(
                            backgroundImage: AssetImage('assets/user4.png'),
                            radius: 30,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('or',style: TextStyle(fontSize: 20),),
                    ],
                  ),
                  SizedBox(height: 25,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.green.shade600,foregroundColor: Colors.white,elevation: 0,shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))),
                          onPressed: (){},
                          child: Text('Choose from Gallery')
                      ),
                    ],
                  )
                ],
            ),
              ),
              SizedBox(
                width: double.infinity,
                height: 45,
                child: ElevatedButton(
                  onPressed: () async {
                    if(avatar){
                      var prefs = await SharedPreferences.getInstance();
                      prefs.setString("image", _avatar );
                    }
                    var prefs = await SharedPreferences.getInstance();
                    prefs.setString("where", "home");
                    _insertData(widget.name, widget.phone, _avatar);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => Home()),
                            (route) => false);
                  },
                  child: Text('NEXT',style: TextStyle(fontSize: 20),),
                  style: ElevatedButton.styleFrom(foregroundColor: Colors.white,backgroundColor: Colors.green.shade600),
                ),
              )
          ]
          ),
        ),
      ),
    );
  }
  Widget pickedImage(){
    return avatar ? Column(
      children: [
        SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(_avatar),
              radius: 60,
            )
          ],
        ),
        SizedBox(height: 25,),
      ],
    )
        : SizedBox(height: 10,);
  }
  Future<void> _insertData(String name, String phoneno, String image) async{
    dataService.DataInsertUsers(name,phoneno,"100",image, context);
  }
}
