import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/QueueModel.dart';
import 'package:booking_carcare_app/pages/status.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HistoryPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _HistoryState();
  }
}

class DisplayQueue {
  const DisplayQueue(this.queueId,this.totalPrice,this.startDate,this.endDate,this.reservStatus,this.car,this.carWashName);

  final int queueId;
  final int totalPrice;
  final String startDate;
  final String endDate;
  final int reservStatus;
  final String car;
  final String carWashName;
}

class _HistoryState extends State<HistoryPage> {
  int count = 0;
  List<DisplayQueue> displayQueueList = new List<DisplayQueue>();
  Future<List<DisplayQueue>> initQueue;

  Future<List<DisplayQueue>> getQueue() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http
        .get('http://157.179.133.41:3000/app/getQueueForMemberApi/${id}', headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      'Authorization': _bearerToken
    });
    var res = json.decode(response.body);
    var data = QueueModel.fromJson(res);
    for(int i=0;i<data.data.length;i++){
      displayQueueList.add(DisplayQueue(data.data[i].queueId,data.data[i].totalPrice,data.data[i].startDate,data.data[i].endDate,data.data[i].reservStatus,data.data[i].car,data.data[i].carWashName));
    }
    return displayQueueList;
  }

  gotoStatus(reservStatus){
    print("status"+reservStatus.toString());
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => StatusPage(reservStatus : reservStatus)),
    );
//      Navigator.pushNamed(context, '/status' , arguments: ,);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initQueue = getQueue();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('History'),
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
                onTap: () =>
                    Navigator.of(context).popUntil((_) => count++ >= 3),
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
                onTap: () => Navigator.pop(context),
                child: ListTile(
                  title: Text("Booking Page"),
                  leading: Icon(
                    Icons.book,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: InkWell(
                onTap: () => debugPrint("home Page"),
                child: ListTile(
                  title: Text("History Page"),
                  leading: Icon(
                    Icons.history,
                    color: Colors.deepPurpleAccent,
                  ),
                ),
              ),
            ),
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
                      Navigator.of(context).popUntil((route) => route.isFirst);
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
              future: initQueue,
              builder: (BuildContext context,
                  AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: displayQueueList.length,
                      itemBuilder: (BuildContext context, int index) {
                        return
                          GestureDetector(
                            onTap: (){
                              setState(() {
                                gotoStatus(displayQueueList[index].reservStatus);
                              });
                            },
                            child:  Card(
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
                                          Text(displayQueueList[index].startDate)
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
                                          Text(displayQueueList[index].totalPrice.toString())
                                        ],
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text("CARWASH : "),
                                          Text(displayQueueList[index].carWashName)
                                        ],
                                      ),
                                    ],
                                  )
                              ),
                            ),
                          );
                      });
                }else{
                  return Text('No data');
                }
              }),
          ),
        ),
    );
  }
}
