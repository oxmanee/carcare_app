import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
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
    var _bearerToken = await _token.read();
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

  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(
                height: (MediaQuery.of(context).size.height / 2),
                color: Colors.white,
              ),
              Container(
                height: (MediaQuery.of(context).size.height / 2),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                      Colors.white,
                      Colors.purpleAccent[100],
                      Colors.indigo
                    ])),
                child: Center(
                  child: Column(
                    children: <Widget>[
                      Container(
                        width: 70.0,
                        height: 70.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.deepPurple,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(2),
                          child: Icon(
                            Icons.person_outline,
                            size: 50,
                            color: Colors.purple[200],
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
