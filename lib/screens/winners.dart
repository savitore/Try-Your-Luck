import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:try_your_luck/models/WinnersModel.dart';

import '../widgets/custom_page_route.dart';
import 'ContestExpandable.dart';

class Winners extends StatefulWidget {
  const Winners({Key? key}) : super(key: key);

  @override
  State<Winners> createState() => _WinnersState();
}

class _WinnersState extends State<Winners> {

  String name='',balance='';
  String? phno;
  int flag=0;
  List<WinnersModel> list = [];
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    super.initState();
    fetchWinners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> fetchWinners() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"winners",
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':'hFpu17U8fUsHjNaqLQmalJKIurolrUcYON0rkHLvTM34cT3tnpTjc5ryTPKX9W9y'},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          list.add(WinnersModel(name: data['documents'][i]['name'], contest_name: data['documents'][i]['contest_name'], prize: data['documents'][i]['prize'], lucky_no: data['documents'][i]['lucky_no'], date: data['documents'][i]['date'], fee: data['documents'][i]['fee'], no_of_people: data['documents'][i]['no_of_people']));
        });
      }
      flag=1;
    }catch(e){
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Winners',overflow: TextOverflow.visible,),
        centerTitle: true,
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: flag==1?
      RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.green.shade600,
        onRefresh: (){
          return Future.delayed(
              Duration(seconds: 1),
                  (){
                setState(() {
                  list.clear();
                  fetchWinners();
                });
              }
          );
        },
        child: SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment:CrossAxisAlignment.start,
                  children: list.map((winners){
                    return InkWell(
                      onTap: (){
                        Navigator.of(context).push(
                            CustomPageRoute(child: ContestExpandable(name: winners.contest_name, fee: winners.fee, prize: winners.prize, no_of_people: winners.no_of_people, lucky_draw_no: winners.lucky_no, image: '',)));
                      },
                      child: Card(
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black26,width: .5)),
                        color: Colors.white,
                        child: ListTile(
                          contentPadding: EdgeInsets.zero,
                          tileColor: Colors.white,
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(winners.contest_name,overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18),),
                                    Text(winners.date,overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 18))
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: .5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 3, 10, 3),
                                child: Row(
                                  children: [
                                    Text(winners.name,overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 25),),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 13, 10, 3),
                                child: Row(
                                  children: [
                                    Image.asset('assets/trophy.png',width: 50,height: 50,),
                                    SizedBox(width: 10,),
                                    Text('Won',style: TextStyle(fontFamily: 'Raleway',color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 22),),
                                    SizedBox(width: 5,),
                                    Text('₹'+winners.prize,style: TextStyle(fontFamily: 'Raleway',color: Colors.blueAccent,fontWeight: FontWeight.bold,fontSize: 22),),
                                  ],
                                ),
                              ),
                              Divider(
                                thickness: .5,
                                color: Colors.black26,
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(10, 0, 10, 3),
                                child: Row(
                                  children: [
                                    Text('Lucky Number: ',overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22),),
                                    Text(winners.lucky_no,overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'Raleway',color: Colors.black,fontWeight: FontWeight.bold,fontSize: 22)),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
      ) :
      Center(
        child: LoadingAnimationWidget.hexagonDots(color: Colors.grey[500]!, size: 50),
      ),
    );
  }
}
