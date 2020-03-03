import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/pages/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:booking_carcare_app/models/promotionModel.dart';

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
        "http://192.168.163.2:3000/app/getAllPromotion",
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
              Padding(
                padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child: InkWell(
                  onTap: () => Navigator.pushNamed(context, '/history'),
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
            child: litems.length > 0
                ? ListView.builder(
                    itemCount: litems.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: Padding(
                          padding: EdgeInsets.all(16.00),
                          child: Text(litems[index].toString()),
                        ),
                      );
                    })
                : Center(
                    child: Text('No data'),
                  ),
          ),
        ));
  }
}
