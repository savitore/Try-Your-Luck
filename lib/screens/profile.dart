import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  final String name, phno;
  Profile(this.name, this.phno);

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  @override
  void initState() {
    super.initState();
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
            children: [
              CircleAvatar(
                backgroundImage: AssetImage('assets/empty_person.jpg'),
                // backgroundImage: NetworkImage('url'),
                radius: 50,
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
