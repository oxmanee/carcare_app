import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/pages/reservation/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DropdownWashCar extends StatefulWidget {
  List<CarWashDropdown> carWashList = List<CarWashDropdown>();
  DropdownWashCar({Key key, this.carWashList}) : super(key: key);

  @override
  State<StatefulWidget> createState() {

    return _DropDownWashCar(carWashList: this.carWashList);
  }

}

class _DropDownWashCar extends State<DropdownWashCar>{

  CarWashDropdown selectedCarWash;
  List<CarWashDropdown> carWashList = List<CarWashDropdown>();
  _DropDownWashCar({Key key, this.carWashList});
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return DropdownButton<CarWashDropdown>(
      hint: Text("Select item"),
      value: selectedCarWash,
      onChanged: (CarWashDropdown Value) {
        setState(() {
          selectedCarWash = Value;
//          Navigator.push(
//            context,
//            MaterialPageRoute(
//                builder: (context) => ReservePage(
//                  data: selectedCarWash,
//                )),
//          );
        });
      },
      items: carWashList.map((CarWashDropdown car) {
        return DropdownMenuItem<CarWashDropdown>(
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
