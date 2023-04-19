import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  final String name, phno;
  Profile(this.name, this.phno);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  String avatar='';
  @override
  void initState() {
    super.initState();
    getImage();
  }

  void getImage() async{
    var prefs = await SharedPreferences.getInstance();
    avatar = prefs.getString("image")!;
  }
  @override
  Widget build(BuildContext context) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.green.shade600,
          title: Text('Profile'),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(15, 15, 8, 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: AssetImage(avatar),
                    // backgroundImage: NetworkImage('url'),
                    radius: 50,
                    child: Stack(
                      children: [
                        Align(
                          alignment: Alignment.bottomRight,
                          child: Icon(Icons.edit),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20,),
                  Text('Name',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(widget.name,
                      style: TextStyle(color: Colors.black,fontSize: 20)),
                  SizedBox(height: 10,),
                  Text('Phone number',style: TextStyle(color: Colors.grey[700],fontSize: 20),),
                  SizedBox(height: 5,),
                  Text(widget.phno,style: TextStyle(color: Colors.black,fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      );
  }
}
