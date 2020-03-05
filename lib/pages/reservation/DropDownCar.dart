import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/pages/reservation/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownScreen extends StatefulWidget {
  List<Item> carList = List<Item>();
  DropdownScreen({Key key, this.carList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _DropDownCar(carList: this.carList);
  }

}

class _DropDownCar extends State<DropdownScreen>{

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
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ReservePage(
                  data: selectedUser,
                )),
          );
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
}
