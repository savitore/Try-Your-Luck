import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:try_your_luck/screens/ContestExpandable.dart';
import 'package:try_your_luck/screens/drawer.dart';
import 'package:try_your_luck/screens/wallet.dart';

import '../api_key.dart';
import '../models/ContestModel.dart';
import '../widgets/custom_page_route.dart';
import '../widgets/shimmer.dart';

class LiveContests extends StatefulWidget {
  const LiveContests({Key? key}) : super(key: key);

  @override
  State<LiveContests> createState() => _LiveContestsState();
}

class _LiveContestsState extends State<LiveContests> {

  List<ContestModel>? list=[];
  int flag=0;
  String name='',balance='',_balance='',image='',type='';
  String? phno;
  bool prize=false, fee = false, filter = false,head=false, five=false, ten=false, mega=false, all= true,fetched=false;
  final ScrollController _scrollController = ScrollController();
  double _scrollPosition = 0;
  Timer? timer;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
  new GlobalKey<RefreshIndicatorState>();

  _scrollListener() {
    setState(() {
      _scrollPosition = _scrollController.position.pixels;
    });
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void sortByPrice(){
    setState(() {
      Comparator<ContestModel> sort = (a,b) => int.parse(b.win_amount).compareTo(int.parse(a.win_amount));
      list?.sort(sort);
    });
  }
  void sortByFee(){
    setState(() {
      Comparator<ContestModel> sort = (a,b) => int.parse(a.fee).compareTo(int.parse(b.fee));
      list?.sort(sort);
    });
  }

  List<ContestModel> filterList({required int people, bool mega = false}){
    List<ContestModel>? filteredList = list;
    if(mega==false) {
      setState(() {
        filteredList =
            filteredList!.where((data) => int.parse(data.no_of_people) == people).toList();
      });
    }
    else{
      setState(() {
        filteredList =
            list!.where((data) => int.parse(data.no_of_people) > people).toList();
      });
    }
    return filteredList!;
  }

  @override
  void initState() {
    super.initState();
    getData();
    _scrollController.addListener(_scrollListener);
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getBalance());
  }

  Future<void> fetchDataProfile() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/findOne';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"users",
      "filter":{
        "phone_number": phno
      }
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':API_KEY},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      setState((){
        balance=data['document']['balance'].toString();
        image=data['document']['image'].toString();
      });
      var prefs = await SharedPreferences.getInstance();
      prefs.setString("balance", balance);
      prefs.setString("image", image);
      getBalance();
      flag=1;
      fetched=true;
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> fetchDataContests() async{
    String baseUrl ='https://data.mongodb-api.com/app/data-slzvn/endpoint/data/v1/action/find';
    final body={
      "dataSource":"Cluster0",
      "database":"db",
      "collection":"contests",
    };
    final response;
    try{
      response=await http.post(Uri.parse(baseUrl),
          headers: {'Content-Type':'application/json',
            'Accept':'application/json',
            'Access-Control-Request-Headers':'Access-Control-Allow-Origin, Accept',
            'api-key':API_KEY},
          body: jsonEncode(body)
      );
      var data = jsonDecode(response.body);
      for(int i=0; i<data['documents'].length;i++){
        setState((){
          list?.add(ContestModel(name: data['documents'][i]['name'], no_of_people: data['documents'][i]['no_of_people'], win_amount: data['documents'][i]['winning_amount'], fee: data['documents'][i]['fee'], lucky_draw_no: data['documents'][i]['lucky_draw_no'], current_people: data['documents'][i]['current_people'], type: ''));
        });
      }
      fetchDataProfile();
    }catch(e){
      print(e.toString());
    }
  }

  void getData() async{
    var prefs = await SharedPreferences.getInstance();
    name =prefs.getString("name")!;
    phno =prefs.getString("phone")!;
    image =prefs.getString("image")!;
    fetchDataContests();
  }

  Future<void> getBalance() async {
    var prefs = await SharedPreferences.getInstance();
    setState(() {
      _balance =prefs.getString("balance")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(onTap: (){scaffoldKey.currentState?.openDrawer();}, child: Icon(Icons.menu)),
            SizedBox(width: 8,),
            Stack(
              alignment: Alignment.topLeft,
              children: [
                GestureDetector(
                  onTap: (){
                    scaffoldKey.currentState?.openDrawer();
                  },
                  child: CircleAvatar(
                                radius: 18,
                                backgroundImage: AssetImage(image),
                              ),
                ),
                Positioned(
                    top: 12,
                    right: 10.0,
                    width: 10.0,
                    height: 10.0,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle
                      ),
                    )
                )
              ],
            ),
            Expanded(child: Center(child: _scrollPosition < 28 ? Text('Try Your Luck',overflow: TextOverflow.visible,): Text('Live Contests',overflow: TextOverflow.visible,),))
          ],
        ),
        centerTitle: true,
        actions: [
          GestureDetector(
            onTap: (){
              if(fetched){
                Navigator.of(context).push(
                    CustomPageRoute(child :Wallet(image)));
              }
            },
            child: Row(
              children: [
                Icon(Icons.account_balance_wallet_outlined,),
                Text(' ₹'+ _balance,style: TextStyle(fontSize: 19),)
              ],
            ),
          ),
          SizedBox(width: 8,),
        ],
        automaticallyImplyLeading: false,
      ),
      body:  flag ==1 ?
      RefreshIndicator(
        key: _refreshIndicatorKey,
        color: Colors.green.shade600,
        onRefresh: (){
          return Future.delayed(
            Duration(seconds: 1),
              (){
              setState(() {
                list?.clear();
                fetchDataContests();
              });
              }
          );
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
            child:SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment:CrossAxisAlignment.start ,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Live contests',overflow: TextOverflow.visible,style: TextStyle(fontSize: 30,fontWeight: FontWeight.w500,color: Colors.black),),
                      SizedBox(
                        height: 30,
                        width: 30,
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              filter= !filter;
                            });
                          },
                          style: filter ?
                          ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.green.shade600),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  side: BorderSide(color: Colors.white)))) :
                          ButtonStyle(
                              padding: MaterialStateProperty.all(const EdgeInsets.all(0)),
                              elevation: MaterialStateProperty.all(0),
                              backgroundColor: MaterialStateProperty.all(
                                  Colors.white),
                              shape: MaterialStateProperty.all(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(60),
                                  side: BorderSide(color: Colors.white)))
                          ) ,
                          child: Icon(Icons.filter_list_rounded,
                              color: filter ? Colors.white : Colors.green.shade600, size: 20),
                        ),
                      )
                    ],
                  ),
                  filter ? showFilter() : SizedBox(height: 10,),
                  filtered(),
                ],
              ),
            ),
          ),
        ),
      )
          : Padding(
            padding: const EdgeInsets.fromLTRB(10, 20, 10, 0),
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ShimmerEffect().shimmer(Container(
                      height: 40,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey))),
                  SizedBox(height: 10,),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                  ShimmerEffect().shimmerListTile(),
                ],
              ),
            ),
          ),
      drawer: Drawer(
        backgroundColor: Colors.grey[100],
        child: SingleChildScrollView(
          child: MyHeaderDrawer(phno.toString(),name,image),
        ),
      ),
    );
  }

  Widget showFilter(){
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      all = true;
                      head=false;
                      five=false;
                      ten=false;
                      mega=false;
                    });
                  },
                  child: Text('ALL'),
                  style: all ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      head = true;
                      five=false;
                      ten=false;
                      mega=false;
                      all=false;
                    });
                  },
                  child: Text('HEAD TO HEAD'),
                  style: head ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      five = true;
                      head=false;
                      ten=false;
                      mega=false;
                      all=false;
                    });
                  },
                  child: Text('PANCH'),
                  style: five ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      ten = true;
                      head=false;
                      five=false;
                      mega=false;
                      all=false;
                    });
                  },
                  child: Text('10 KA DUM'),
                  style: ten ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
                SizedBox(width: 5,),
                ElevatedButton(
                  onPressed: (){
                    setState(() {
                      mega = true;
                      head=false;
                      five=false;
                      ten=false;
                      all=false;
                    });
                  },
                  child: Text('MEGA'),
                  style: mega ? ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.white)),
                      backgroundColor: Colors.green.shade600,
                      foregroundColor: Colors.white,
                      elevation: 0
                  ) : ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20),side: BorderSide(width: 1,color: Colors.green.shade600)),
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.black,
                      elevation: 0
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 5,),
          Row(
            children: [
              Text('SORT BY:',style: TextStyle(color: Colors.black),),
              SizedBox(width: 10,),
              InkWell(
                  child: Text('PRIZE',style: TextStyle(color: prize ? Colors.blueAccent : Colors.black),),
                  onTap: (){
                    setState(() {
                      prize=true;
                      fee=false;
                      sortByPrice();
                    });
                  }
              ),
              SizedBox(width: 10,),
              InkWell(
                  child: Text('JOINING FEE',style: TextStyle(color: fee ? Colors.blueAccent : Colors.black),),
                  onTap: (){
                    setState(() {
                      fee=true;
                      prize=false;
                      sortByFee();
                    });
                  }
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget filtered(){
    if(head){
      return buildList(filterList(people: 2));
    } else if(five)
    {
      return buildList(filterList(people: 5));
    } else if(ten)
    {
      return buildList(filterList(people: 10));
    } else if(mega){
      return buildList(filterList(people: 10,mega: true));
    } else{
      return buildList(list!);
    }
  }

  Widget buildList(List<ContestModel> list){
    return  list.length > 0 ?
    Column(
      children: list.map((contests){
        return InkWell(
          onTap: (){
            Navigator.of(context).push(
                CustomPageRoute(child: ContestExpandable(name: contests.name, fee: contests.fee, prize: contests.win_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no, image: image,)));
          },
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),side: BorderSide(color: Colors.green.shade600)),
            color: Colors.green.shade50,
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 0, 3),
                  child: ListTile(
                    tileColor: Colors.white,
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 5,),
                        Text(
                          contests.name,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 25
                          ),
                        ),
                        SizedBox(height: 5,)
                      ],
                    ),
                    subtitle: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    SizedBox(width: 3,),
                                    Text('Prize',style: TextStyle(color: Colors.blueAccent,fontSize: 10),),
                                  ],
                                ),
                                SizedBox(height: 3,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Text('₹'+contests.win_amount,style: TextStyle(color: Colors.black,fontWeight: FontWeight.w500,fontSize: 20)),
                                  ],
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(width: 15,),
                                Image.asset('assets/money.png',height: 55,width: 55,),
                              ],
                            ),
                            Column(
                              children: [
                                Text('Joining Fee',style: TextStyle(color: Colors.black,fontSize: 10),),
                                SizedBox(height: 5,),
                                SizedBox(
                                  height: 25,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green.shade600,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20))
                                      ),
                                      onPressed: (){
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(builder: (context) => ContestExpandable(name: contests.name, fee: contests.fee, prize: contests.win_amount, no_of_people: contests.no_of_people, lucky_draw_no: contests.lucky_draw_no, image: image,)));
                                      },
                                      child: Row(
                                        children: [
                                          Icon(Icons.currency_rupee,color: Colors.white,size: 13,),
                                          Text(contests.fee,style: TextStyle(color: Colors.white)),
                                        ],
                                      )),
                                )
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 3, 10, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(checkType(int.parse(contests.no_of_people)),overflow: TextOverflow.visible,style: TextStyle(fontFamily: 'CormorantGaramond',fontWeight: FontWeight.w600)),
                      Row(
                        children: [
                          SizedBox(
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              backgroundColor: Colors.grey[100],
                              valueColor: AlwaysStoppedAnimation(Colors.green.shade600),
                              value: double.parse(contests.current_people)/double.parse(contests.no_of_people),
                            ),
                            width: 15,
                            height: 15,
                          ),
                          SizedBox(width: 10,),
                          Text(contests.current_people + '/' + contests.no_of_people+ ' spots',overflow: TextOverflow.visible,),
                        ],
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      }).toList(),
    ) :
    Center(
      child: Column(
        children: [
          Divider(
            color: Colors.grey[400],
          ),
          SizedBox(height: 10,),
          Container(
            child: Text('No Contests available!'),
          ),
        ],
      ),
    );
  }

  String checkType(int people){
    if(people==2){
      return 'HEAD 2 HEAD';
    }
    else if(people==5){
      return 'PANCH';
    }
    else if(people==10){
      return '10 KA DUM';
    }
    return 'MEGA';
  }

}
