import 'dart:async';
import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CarModel.dart';
import 'package:booking_carcare_app/models/CarWashModel.dart';
import 'package:booking_carcare_app/models/CleanServiceCheckBox.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/pages/reservation/CheckBoxCleanService.dart';
import 'package:booking_carcare_app/pages/reservation/DropDownCar.dart';
import 'package:booking_carcare_app/pages/reservation/DropdownWashCar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ReservePage extends StatefulWidget {
  final List<CleanServiceCheckBox> checkBoxList =
      new List<CleanServiceCheckBox>();
  Item data;

  ReservePage({Key key, this.data});

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

class CarWashDropdown {
  const CarWashDropdown(this.value, this.name);

  final int value;
  final String name;

  getValue() {
    return this.value;
  }
}

class _ReserveState extends State<ReservePage> {
  List<Item> carList = List<Item>();
  List<CarWashDropdown> carWashList = List<CarWashDropdown>();
  var seleteItem;

  Future<List<Item>> _getCar() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http.get(
        'http://192.168.1.134:3000/app/getDetailCarByMember/${id}',
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

  Future<List<CleanServiceCheckBox>> _getCleanService() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var typeCar = widget.data.typeCar;
    http.Response response = await http.get(
        'http://192.168.1.134:3000/app/getCleanServiceByTypeCar/${typeCar}',
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = CleanServiceModel.fromJson(res);
    for (int i = 0; i < data.data.length; i++) {
      widget.checkBoxList.add(CleanServiceCheckBox(
          data.data[i].cleanServiceDetailId, data.data[i].serviceName, false));
    }
    return widget.checkBoxList;
  }

  Future<List<CarWashDropdown>> _getWashCar() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    http.Response response = await http.get(
        'http://192.168.1.134:3000/app/getAllCar_wash',
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = CarWashModel.fromJson(res);
    for (int i = 0; i < data.data.length; i++) {
      carWashList.add(
          CarWashDropdown(data.data[i].carWashId, data.data[i].carWashName));
    }
    return carWashList;
  }
  var now = new DateTime.now();
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: new AppBar(title: new Text('จองคิวล้างรถ')),
      body: new Center(
        child: new Column(
          children: <Widget>[
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("เลือกรถที่ต้องกาาร"),
                  new Container(
                      child: new FutureBuilder(
                          future: _getCar(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return DropdownScreen(carList: snapshot.data);
                            } else {
                              return Container();
                            }
                          })),
                ],
              ),
            ),
            widget.data != null
                ? new Container(
                    child: new FutureBuilder(
                        future: _getCleanService(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          if (snapshot.hasData) {
                            return new Container(
                                 height: 200,
                                child: new ListView(
                              padding: new EdgeInsets.symmetric(vertical: 2.0),
                              children: widget.checkBoxList.map((checkbox) {
                                return CheckBoxCleanService(checkbox: checkbox);
                              }).toList(),
                            ));
                          } else {
                            return Container();
                          }
                        }))
                : Container(),
            new Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text("เลือกช่องล้างรถ"),
                  new Container(
                      child: new FutureBuilder(
                          future: _getWashCar(),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              return DropdownWashCar(
                                  carWashList: snapshot.data);
                            } else {
                              return Container();
                            }
                          })),
                ],
              ),
            ),
            new Container(
                    child: TextFormField(
                      // autofocus: true,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: now.toString(),
                        labelStyle: TextStyle(
                          color: Colors.purple,
                          fontWeight: FontWeight.w400,
                          fontSize: 20,
                        ),
                      ),
                      style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                    ),
            ),
            new Container(
              child : Column(
                children: <Widget>[
                  //_queue()
                ],
              )
            )
          ],
        ),
      ),
    );
  }
//  Widget _queue(){
//    return ListView.builder(
//      itemCount: _timeList.length,
//      itemBuilder: (context, index) {
//        return Card( //                           <-- Card widget
//          child: ListTile(
//              title: Text(_timeList[index])
//          ),
//        );
//      },
//    );
//  }
}
