import 'dart:async';
import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CarModel.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/pages/reservation/CheckBoxCleanService.dart';
import 'package:booking_carcare_app/pages/reservation/DropDownCar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservePage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ReserveState();
  }
}

class Item {
  const Item(this.value, this.name, this.typeCar);

  final int value;
  final String name;
  final int typeCar;

  getValue() {
    return this.value;
  }
}

class CleanService {
  CleanService(this.value, this.name, this.isCheck);

  int value;
  String name;
  bool isCheck;

  getValue() {
    return this.value;
  }
}

class _ReserveState extends State<ReservePage> {

  List<Item> carList = List<Item>();
  List<CleanService> checkBoxList = new List<CleanService>();
  var seleteItem;

  Future<List<Item>> _getCar() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http.get(
        'http://157.179.133.86:3000/app/getDetailCarByMember/${id}',
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = CarModel.fromJson(res);
    for (int i = 0; i < data.data.length; i++) {
      carList.add(Item(
          data.data[i].carDetailId,
          data.data[i].modelName +
              " " +
              data.data[i].brand +
              " " +
              data.data[i].size,
          data.data[i].typeCarId));
    }
    return carList;
  }

  Future<List<CleanService>> _getCleanService() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    http.Response response = await http.get(
        'http://157.179.133.86:3000/app/getCleanServiceByTypeCar/1',
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = CleanServiceModel.fromJson(res);
    for (int i = 0; i < data.data.length; i++) {
      checkBoxList.add(CleanService(data.data[i].cleanServiceDetailId , data.data[i].serviceName , true));
    }
    return checkBoxList;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('จองคิวล้างรถ')
      ),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
                child : new FutureBuilder(
                    future: _getCar(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return DropdownScreen(carList: snapshot.data);
                      } else {
                        return Container();
                      }
                    }
                )
            ),
            new Container(
                child : new FutureBuilder(
                    future: _getCleanService(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        return new Expanded(
                            child: new ListView(
                              padding: new EdgeInsets.symmetric(vertical: 8.0),
                              children: snapshot.data.map((checkbox) {
                                return new CheckBoxCleanService(checkbox: checkbox);
                              }).toList(),
                            ));
                      } else {
                        return Container();
                      }
                    }
                )
            )
          ],
        ),
      ),
    );
  }
}
