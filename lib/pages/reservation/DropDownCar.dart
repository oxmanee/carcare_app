import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/pages/reservation/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownScreen extends StatefulWidget {
  List<CheckBox> checkBoxList = new List<CheckBox>();
  List<Item> carList = List<Item>();
  DropdownScreen({Key key, this.carList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _DropDownCar(carList: this.carList);
  }

}

class CheckBox {
  const CheckBox(this.value, this.name);

  final int value;
  final String name;

  getValue() {
    return this.value;
  }

  getName(){
    return this.name;
  }
}
class _DropDownCar extends State<DropdownScreen>{

  final List<CheckBox> checkBoxList = List<CheckBox>();
  bool _isChecked = true;
  Item selectedUser;
  List<Item> carList = List<Item>();
  _DropDownCar({Key key, this.carList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButton<Item>(
      hint: Text("Select item"),
      value: selectedUser,
      onChanged: (Item Value) {
        setState(() {
          selectedUser = Value;
          _getCleanService(Value);
        });
      },
      items: carList.map((Item car) {
        return DropdownMenuItem<Item>(
          value: car,
          child: Row(
            children: <Widget>[
              SizedBox(
                width: 10,
              ),
              Text(
                car.name,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

Future<List<CheckBox>> _getCleanService(Item item) async {
  var _token = manageToken();
  var _bearerToken = await _token.readToken();
  var typeCar = item == null ? 0 : item.typeCar;
  http.Response response = await http.get(
      'http://157.179.132.240:3000/app/getCleanServiceByTypeCar/${typeCar}',
      headers: {'Authorization': _bearerToken});
  var res = json.decode(response.body);
  var data = CleanServiceModel.fromJson(res);
  for (int i = 0; i < data.data.length; i++) {
    widget.checkBoxList.add(CheckBox(data.data[i].cleanServiceDetailId , data.data[i].serviceName));
  }
  return widget.checkBoxList;
}

Widget checkBox(){
    var checkbox = widget.checkBoxList;
  return ListView(
      children: <Widget>[
      Column(
          children: checkbox
              .map((t) => CheckboxListTile(
            title: Text("$t"),
            value: _isChecked,
            onChanged: (val) {
              setState(() {
                _isChecked = val;
              });
            },
          ))
              .toList()
      )
      ]
  );
}
}
