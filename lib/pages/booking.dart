import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CarModel.dart';
import 'package:booking_carcare_app/models/CarWashModel.dart';
import 'package:booking_carcare_app/models/CleanServiceCheckBox.dart';
import 'package:booking_carcare_app/models/CleanServiceModel.dart';
import 'package:booking_carcare_app/models/bookingModel.dart';
import 'package:booking_carcare_app/models/resultModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

// ================ Dropdown of your car ==============
class Item {
  const Item(this.value, this.name, this.typeCar);

  final int value;
  final String name;
  final int typeCar;

  getValue() {
    return this.value;
  }
}
// ===================================================

// ================ Dropdown of car wash ==============
class CarWashDropdown {
  const CarWashDropdown(this.value, this.name);

  final int value;
  final String name;

  getValue() {
    return this.value;
  }
}
// ===================================================

class BookingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _BookingState();
  }
}

class _BookingState extends State<BookingPage> {
  int count = 0;
  final _token = manageToken();
  String _time;

  // ========= use for dropdown car ===========
  Future<List<Item>> _drpCar;

  TextEditingController _controllerTime;

  void initState() {
    super.initState();
    _drpCar = _getCar();
    _drpCarWash = _getWashCar();
  }

  Future<List<Item>> _getCar() async {
    final _bearerToken = await _token.readToken();
    final id = await _token.readId();
    final response = await http.get(
        'http://10.13.2.115:3000/app/getDetailCarByMember/${id}',
        headers: {'Authorization': _bearerToken});
    var res = json.decode(response.body);
    var data = CarModel.fromJson(res);

    List<Item> _carList = List<Item>();

    for (int i = 0; i < data.data.length; i++) {
      _carList.add(Item(
          data.data[i].carDetailId,
          data.data[i].modelName +
              " " +
              data.data[i].brand +
              " " +
              data.data[i].size,
          data.data[i].typeCarId));
    }
    return _carList;
  }

  List<Item> toItem(List<dynamic> data) => data.cast<Item>();

  Item selectedCar;

  // ===============================================

  // ================= Check box for select clean service ================
  List<CleanServiceCheckBox> checkBoxList = List<CleanServiceCheckBox>();

  Future<List<CleanServiceCheckBox>> _getCleanService() async {
    var _bearerToken = await _token.readToken();
    var typeCar = selectedCar.getValue();
    final response = await http.get(
        'http://10.13.2.115:3000/app/getCleanServiceByTypeCar/${typeCar}',
        headers: {'Authorization': _bearerToken});

    final res = json.decode(response.body);

    final data = CleanServiceModel.fromJson(res);
    checkBoxList = List<CleanServiceCheckBox>();

    for (int i = 0; i < data.data.length; i++) {
      checkBoxList.add(CleanServiceCheckBox(
          data.data[i].cleanServiceDetailId, data.data[i].serviceName, false));
    }

    // use for setState after add
    setState(() {
//      data.data.map((data) {
//        checkBoxList.add(CleanServiceCheckBox(
//            data.cleanServiceDetailId, data.serviceName, false));
//      });
    });

    return checkBoxList;
  }

  // ===================================================================

  // ========================= Use for car wash ========================
  Future<List<CarWashDropdown>> _drpCarWash;
  CarWashDropdown selectedCarWash;

  List<CarWashDropdown> toCarWash(List<dynamic> data) =>
      data.cast<CarWashDropdown>();

  Future<List<CarWashDropdown>> _getWashCar() async {
    final _bearerToken = await _token.readToken();
    final response = await http.get(
        'http://10.13.2.115:3000/app/getAllCar_wash',
        headers: {'Authorization': _bearerToken});
    final res = json.decode(response.body);
    final data = CarWashModel.fromJson(res);

    List<CarWashDropdown> _carWashList = List<CarWashDropdown>();
    for (int i = 0; i < data.data.length; i++) {
      _carWashList.add(
          CarWashDropdown(data.data[i].carWashId, data.data[i].carWashName));
    }
    return _carWashList;
  }

  // ==================================================================

  // ============================ Booking =============================
  Future addBooking() async {
    final _bearerToken = await _token.readToken();
    var id = await _token.readId();
    var booking = BookingModel();
    booking.memberId = int.parse(id);
    booking.carDetailId = selectedCar.value;
    booking.carWashId = selectedCarWash.value;
    var time_use = _time.split(' ')[0] + ":" + _time.split(' ')[2];
    booking.startTime = time_use;
    List<int> cleanServiceDetailId = List<int>();
    for (int i = 0; i < checkBoxList.length; i++) {
      if (checkBoxList[i].isCheck == true) {
        cleanServiceDetailId.add(checkBoxList[i].value);
      }
    }
    setState(() {});
    booking.cleanServiceDetailId = cleanServiceDetailId;
    var jsonRequest = bookingModelToJson(booking);
    final response = await http.post(
        "http://10.13.2.115:3000/app/insertBooking",
        body: jsonRequest,
        headers: {
          "Content-type": "application/json",
          'Authorization': _bearerToken,
        });
    final resData = json.decode(response.body);
    var res = ResultModel.fromJson(resData);

    return res;
  }

  // ==================================================================

  @override
  Widget build(BuildContext context) {
    void _showDialog(title, valid) {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: Text(title),
            content: Text(valid),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              FlatButton(
                child: Text("Close"),
                onPressed: () {
                  valid == "Booking success"
                      ? Navigator.of(context).popUntil((_) => count++ >= 3)
                      : Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: Text('Booking'),
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
                        Navigator.of(context)
                            .popUntil((route) => route.isFirst);
                      }),
                ),
              ),
            ],
          ),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2.8,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: EdgeInsets.only(top: 8, left: 20, right: 20),
                child: Column(
                  children: <Widget>[
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 20),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          icon: Icon(
                            Icons.directions_car,
                            size: 40.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          labelText:
                              selectedCar == null ? 'Select Car' : 'Car Name',
                        ),
                        child: FutureBuilder(
                            future: _drpCar,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<Item>(
                                  isExpanded: true,
                                  isDense: true,
                                  hint: Text("Please select car",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.purple)),
                                  value: selectedCar,
                                  onChanged: (Item Value) {
                                    setState(() {
                                      selectedCar = Value;
                                      _getCleanService();
                                    });
                                  },
                                  items:
                                      (toItem(snapshot.data)).map((Item val) {
                                    return DropdownMenuItem<Item>(
                                        value: val,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              val.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 25),
                      child: InputDecorator(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          icon: Icon(
                            Icons.home,
                            size: 40.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          labelText: selectedCarWash == null
                              ? 'Select channel no.'
                              : 'Channel No.',
                        ),
                        child: FutureBuilder(
                            future: _drpCarWash,
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.hasData) {
                                return DropdownButton<CarWashDropdown>(
                                  isDense: true,
                                  isExpanded: true,
                                  hint: Text("Select channel",
                                      style: TextStyle(
                                          fontSize: 18, color: Colors.purple)),
                                  value: selectedCarWash,
                                  onChanged: (CarWashDropdown Value) {
                                    setState(() {
                                      selectedCarWash = Value;
                                    });
                                  },
                                  items: (toCarWash(snapshot.data))
                                      .map((CarWashDropdown val) {
                                    return DropdownMenuItem<CarWashDropdown>(
                                        value: val,
                                        child: Row(
                                          children: <Widget>[
                                            Text(
                                              val.name,
                                              style: TextStyle(fontSize: 16),
                                            ),
                                          ],
                                        ));
                                  }).toList(),
                                );
                              } else {
                                return Container();
                              }
                            }),
                      ),
                    ),
                    Container(
                      width: 300,
                      margin: EdgeInsets.only(top: 25),
                      child: TextFormField(
                        readOnly: true,
                        controller: _controllerTime,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          filled: true,
                          icon: Icon(
                            Icons.timer,
                            size: 40.0,
                            color: Colors.deepPurpleAccent,
                          ),
                          labelText: 'Input time',
                        ),
                        onTap: () {
                          DatePicker.showTimePicker(context,
                              theme: DatePickerTheme(
                                containerHeight: 210.0,
                              ),
                              showTitleActions: true, onConfirm: (time) {
                            _time =
                                '${time.hour.toString().length == 1 ? "0" + time.hour.toString() : time.hour.toString()} : ${time.minute.toString().length == 1 ? "0" + time.minute.toString() : time.minute.toString()}';
                            _controllerTime =
                                TextEditingController(text: _time);
                            setState(() {});
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height / 2.8),
              width: MediaQuery.of(context).size.width,
              child: Stack(
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(width: 0.5, color: Colors.grey),
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          'Add service all',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      border: Border(
                          bottom: BorderSide(width: 0.5, color: Colors.grey),
                          top: BorderSide(width: 0.5, color: Colors.grey)),
                    ),
                    margin: EdgeInsets.only(top: 40),
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: checkBoxList.length != 0
                        ? ListView.builder(
                            itemCount: checkBoxList.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                        width: 0.5, color: Colors.grey),
                                  ),
                                ),
                                child: ListTile(
                                    title: Row(
                                  children: <Widget>[
                                    Expanded(
                                        child: Text(checkBoxList[index].name)),
                                    Checkbox(
                                      // color of tick Mark
                                      value: checkBoxList[index].isCheck,
                                      onChanged: (var value) {
                                        checkBoxList[index].isCheck = value;
                                        setState(() {});
//                                        print(checkBoxList[index].isCheck);
                                      },
                                    ),
                                  ],
                                )),
                              );
                            })
                        : Padding(
                            padding: EdgeInsets.only(top: 10),
                            child: Align(
                              alignment: Alignment.topCenter,
                              child: Text('Not data.'),
                            ),
                          ),
                  ),
                  Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2.3),
                      child: Padding(
                        padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ButtonTheme(
                              minWidth: 150.0,
                              height: 50.0,
                              child: OutlineButton(
                                onPressed: () {
                                  _controllerTime =
                                      TextEditingController(text: null);
                                  selectedCarWash = null;
                                  selectedCar = null;
                                  checkBoxList = [];
                                  setState(() {});
                                },
                                child: Text(
                                  'Clear',
                                  style: TextStyle(
                                      color: Colors.deepPurpleAccent,
                                      fontSize: 18),
                                ),
                                borderSide: BorderSide(
                                  color: Colors.deepPurpleAccent,
                                  //Color of the border
                                  style: BorderStyle.solid,
                                  //Style of the border
                                  width: 0.8, //width of the border
                                ),
                              ),
                            ),
                            ButtonTheme(
                              minWidth: 150.0,
                              height: 50.0,
                              child: FlatButton(
                                color: Colors.indigo,
                                onPressed: () async {
                                  if (selectedCar == null) {
                                    _showDialog("Valid", "Please select car.");
                                  } else if (selectedCarWash == null) {
                                    _showDialog(
                                        "Valid", "Please select channel.");
                                  } else if (_controllerTime == null) {
                                    _showDialog("Valid", "Please select time.");
                                  } else if (checkBoxList.length == 0 ||
                                      checkBoxList == null) {
                                    _showDialog(
                                        "Valid", "Please select service.");
                                  } else {
                                    bool chkChekbox = false;
                                    for (int i = 0;
                                        i < checkBoxList.length;
                                        i++) {
                                      if (checkBoxList[i].isCheck == true) {
                                        chkChekbox = true;
                                      }
                                    }
                                    if (chkChekbox == true) {
                                      var res = await addBooking();
                                      if (res.result == "fail") {
                                        _showDialog(res.result, res.data);
                                      } else {
                                        _showDialog(
                                            res.result, "Booking success");
                                      }
                                    } else {
                                      _showDialog(
                                          "Valid", "Please select service.");
                                    }
                                  }
                                },
                                child: Text(
                                  'Booking',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            )
          ],
        ));
  }
}
