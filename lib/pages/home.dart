import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/QueueModel.dart';
import 'package:booking_carcare_app/pages/login.dart';
import 'package:booking_carcare_app/pages/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:booking_carcare_app/models/promotionModel.dart';

import 'history.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HomeState();
  }
}

class _HomeState extends State<HomePage> {
  Future<List> _getPromotion() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
//  print(_bearerToken);
    http.Response response = await http.get(
        "http://10.13.3.39:3000/app/getAllPromotion",
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = PromotionModel.fromJson(res);
    List arr = [];
    for (int i = 0; i < data.data.length; i++) {
      data.data[i].promoImg != null && data.data[i].promoImg != ''
          ? arr.add(data.data[i].promoImg.split(",")[1])
          : '';
    }
    return arr;
  }

  Future<List<DisplayQueue>> initQueue;
  List<DisplayQueue> displayQueueList = new List<DisplayQueue>();

  Future<List<DisplayQueue>> getQueue() async {
    displayQueueList = new List<DisplayQueue>();
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http.get(
        'http://10.13.3.39:3000/app/getQueueForMemberApi/${id}',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
          'Authorization': _bearerToken
        });
    var res = json.decode(response.body);
    var data = QueueModel.fromJson(res);
    for (int i = 0; i < data.data.length; i++) {
      displayQueueList.add(DisplayQueue(
          data.data[i].queueId,
          data.data[i].totalPrice,
          data.data[i].startDate,
          data.data[i].endDate,
          data.data[i].reservStatus,
          data.data[i].car,
          data.data[i].carWashName));
    }
    return displayQueueList;
  }

  gotoStatus(reservStatus) {
    print("status" + reservStatus.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StatusPage(reservStatus: reservStatus)),
    );
//      Navigator.pushNamed(context, '/status' , arguments: ,);
  }

  @override
  void initState() {
    super.initState();
    Future<List> future = _getPromotion();
    future.then((List data) {
      if (data.length != 0) {
        WidgetsBinding.instance.addPostFrameCallback((_) async {
          await showDialog<String>(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: Center(
                  child:
                      Text('Promotion', style: TextStyle(color: Colors.blue))),
              content: Container(
                height: 250,
                width: 100,
                child: CarouselSlider(
                  height: 250.0,
                  autoPlay: true,
                  aspectRatio: 2.0,
                  items: data.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
//                          decoration: BoxDecoration(color: Colors.amber),
                            child: Image.memory(base64.decode(i)));
                      },
                    );
                  }).toList(),
                ),
              ),
              actions: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 10),
                      child: OutlineButton(
                        child: Text("Later"),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        onPressed: () => Navigator.of(context).pop(),
                        borderSide: BorderSide(
                          color: Colors.blue, //Color of the border
                          style: BorderStyle.solid, //Style of the border
                          width: 1.5, //width of the border
                        ),
                      ),
                    ),
                    FlatButton(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)),
                      child: Text("Order Now"),
                      onPressed: () {},
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      }
    });
  }

  List<String> litems = ["1", "2", "Third", "4", "5", "asdlkas", "asdpoaskjd"];

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Home'),
          backgroundColor: Colors.deepPurple,
        ),
        drawer: Drawer(
          child: ExpansionTile(
            initiallyExpanded: true,
            title: UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              accountName: Text("Mohamed Ali"),
              accountEmail: Text("mohamed.ali6996@hotmail.com"),
              currentAccountPicture: CircleAvatar(
                child: Text("M"),
                backgroundColor: Colors.white,
              ),
            ),
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: ListTile(
                    title: Text("Home Page"),
                    leading: Icon(
                      Icons.home,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/profile'),
                  child: ListTile(
                    title: Text("Profile Page"),
                    leading: Icon(
                      Icons.person_outline,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/booking'),
                  child: ListTile(
                    title: Text("Booking Page"),
                    leading: Icon(
                      Icons.book,
                      color: Colors.deepPurpleAccent,
                    ),
                  ),
                ),
              ),
//              Padding(
//                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
//                child: InkWell(
//                  onTap: () => Navigator.pushNamed(context, '/history'),
//                  child: ListTile(
//                    title: Text("History Page"),
//                    leading: Icon(
//                      Icons.history,
//                      color: Colors.deepPurpleAccent,
//                    ),
//                  ),
//                ),
//              ),
              Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
                height: 0.3,
              ),
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                child: InkWell(
                  child: ListTile(
                      title: Text("Log out"),
                      leading: Icon(
                        Icons.assignment_return,
                        color: Colors.deepPurpleAccent,
                      ),
                      onTap: () async {
                        var manageData = manageToken();
                        await manageData.clearData();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            '/main', (Route<dynamic> route) => false);
                      }),
                ),
              ),
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            color: Color.fromRGBO(251, 245, 255, 1),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: FutureBuilder(
                future: getQueue(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: displayQueueList.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                gotoStatus(
                                    displayQueueList[index].reservStatus);
                              });
                            },
                            child: Card(
                              child: Padding(
                                  padding: EdgeInsets.all(16.00),
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        children: <Widget>[
                                          Text("CAR : "),
                                          Text(displayQueueList[index].car)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("START : "),
                                          Text(
                                              displayQueueList[index].startDate)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("END : "),
                                          Text(displayQueueList[index].endDate)
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("TOTAL : "),
                                          Text(displayQueueList[index]
                                              .totalPrice
                                              .toString())
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("CARWASH : "),
                                          Text(displayQueueList[index]
                                              .carWashName)
                                        ],
                                      ),
                                    ],
                                  )),
                            ),
                          );
                        });
                  } else {
                    return Align(
                      alignment: Alignment.topCenter,
                      child: Text('No data'),
                    );
                  }
                }),
          ),
        ));
  }
}
