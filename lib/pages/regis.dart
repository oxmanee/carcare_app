import 'dart:collection';
import 'dart:io';
import 'dart:convert';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CarModel.dart';
import 'package:booking_carcare_app/models/ProvinceModel.dart';
import 'package:booking_carcare_app/models/carRequest.dart';
import 'package:booking_carcare_app/models/regisModel.dart';
import 'package:dropdown_formfield/dropdown_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:validators/validators.dart';

class RegisPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _RegigState();
  }
}

class Success {
  final String result;

  Success(this.result);

  Success.fromJson(Map<String, dynamic> json) : result = json['result'];
}

class DropdownProvince {

  DropdownProvince(
      this.provinceId,
      this.provinceName
      );
  int provinceId;
  String provinceName;
}

Future _getLogin(RegisModel payload) async {

  var jsonRequest = payload;
    print(json.encode(jsonRequest));

  http.Response response = await http.post(
      "http://192.168.1.139:3000/app/insertMemberApi",
      body: json.encode(jsonRequest),
      headers: {
        'Content-type' : 'application/json',
        'accept': 'application/json'
      });
  var responseData = json.decode(response.body);
  var res = Success.fromJson(responseData);
  return res.result;
}

class RegisMember{
  String username;
  String password;
  String fname;
  String lname;
  String address;
  String tel;
  List<Car> formCarList;
}

class Car{

  Car(this.car , this.license , this.province);
  CarDropdown car;
  String license;
  DropdownProvince province;

  @override
  String toString() {
    return 'Car{carDetailId: $car, license: $license, provinceId: $province}';
  }


}

class CarDropdown {
  CarDropdown(this.value, this.name);

  int value;
  String name;

  getValue() {
    return this.value;
  }

  @override
  String toString() {
    return 'CarDropdown{value: $value, name: $name}';
  }


}

class _RegigState extends State<RegisPage> {
  @override
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();

  ListView _addList;
  Future<List<DropdownProvince>> _drp;
  RegisMember _data = new RegisMember();
  Car _dataCar;
  Future<List<CarDropdown>> _carList;
  DropdownProvince selectedProvince;
  CarDropdown seletedCar;
  List<Car> formCarList = new List<Car>();

  @override
  void initState(){
    super.initState();
    _drp = _getProvince();
    _carList = _getCar();
  }


  Future<List<CarDropdown>> _getCar() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http.get(
        'http://192.168.1.139:3000/app/getDetailCarByMemberApi/${id}',
        headers: {
          HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
        });
    var res = json.decode(response.body);
    var data = CarModel.fromJson(res);
    List<CarDropdown> carList = List<CarDropdown>();
    for (int i = 0; i < data.data.length; i++) {
      carList.add(CarDropdown(
          data.data[i].carDetailId,
          data.data[i].modelName +
              " " +
              data.data[i].brand +
              " " +
              data.data[i].size));
    }
    return carList;
  }

  Future<List<DropdownProvince>> _getProvince() async {
    final response = await http
        .get("http://192.168.1.139:3000/app/getAllProvinceApi", headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
    });
    var res = json.decode(response.body);
    var data = ProvinceModel.fromJson(res);

    List<DropdownProvince> _drpList = List<DropdownProvince>();

    for (int i = 0; i < data.data.length; i++) {
      _drpList.add(DropdownProvince(data.data[i].provinceId, data.data[i].provinceName));
    }

    return _drpList;
  }

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
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool> submit() async {
//    for(int i=0;i<formCarList.length;i++){
//      print(formCarList[i].toString());
//    }
    // First validate form.
    if (this._formKey.currentState.validate()) {
//      _formKey.currentState.save(); // Save our form now.
//
//      print('Printing the login data.');
//      print('usernmae: ${_data.username}');
      var username = _data.username;
      var password = _data.password;
      var fname = _data.fname;
      var lname = _data.lname;
      var address = _data.address;
      var tel = _data.tel;

      List<CarRequest> formcar = new List<CarRequest>();
      for(int i=0;i<formCarList.length;i++){
        formcar.add(CarRequest(car : formCarList[i].car.value , license : formCarList[i].license , province : formCarList[i].province.provinceId));
      }
      if (username == '') {
        _showDialog('Valid form input!',
            'Please enter your username.');
        return false;
      } else if (password == '') {
        _showDialog('Valid form input!',
            'Please enter your password.');
        return false;
      } else if (fname == '') {
        _showDialog('Valid form input!',
            'Please enter your first name.');
                            return false;
      } else if (lname == '') {
        _showDialog('Valid form input!',
            'Please enter your last name.');
        return false;
      } else if (address == '') {
        _showDialog('Valid form input!',
            'Please enter your address.');
        return false;
      } else if (tel == '') {
        _showDialog('Valid form input!',
            'Please enter your tel-phone.');
        return false;
      }

      RegisModel payload = new RegisModel(username: username , password : password , fname : fname , lname : lname , address : address , tel : tel , carDetail: formcar );

      var res = await _getLogin(payload);
      print(res);
      if (res == "success") {
        Navigator.pushNamed(context, '/main');
      } else if(res == "memberFailed"){
        _showDialog('Error', 'Sorry! username already used!');
        return false;
      }else if(res == "licenseFailed"){
        _showDialog('Error', 'Sorry! license already used!');
        return false;
      }else{
      _showDialog('Error', 'Sorry! Register Failed!');
    }
      return true;
//      print('Password: ${_data.password}');
    }
  }

  void addCar(status) {
    setState(() {
//        int i = _addList.length; // start 0
      //  print(i);
      if(status == 1){
        formCarList.add(Car(null, null, null));
      }

      _addList = new ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: formCarList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Column(
              children: <Widget>[
                Form(
                  child: Card(
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: new Row(
                            children: <Widget>[
                              new Text("เลือกรถ"),
                              new Container(
                                child : new FutureBuilder(
                                    future: _carList,
                                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                                      if (snapshot.hasData) {
                                        return getDropdownCar(snapshot.data , index);
                                      } else {
                                        return Container();
                                      }
                                    }),
                              )
                            ],
                          ),
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                            child : TextFormField(
                              decoration: InputDecoration(
                                labelText: "Car code",
                              ),
                              onChanged: (text) {
                                for(int i=0;i<formCarList.length;i++){
                                  formCarList[formCarList.length-1].license = text;
                                }
                              },
                              onSaved: (String value) {
                                for(int i=0;i<formCarList.length;i++){
                                  formCarList[formCarList.length-1].license = value;
                                }
                              },
                            )
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              new Container(
                                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                                child: new Row(
                                  children: <Widget>[
                                    Text("เลือกจังหวัด"),
                                    new Container(
                                      child: FutureBuilder(
                                          future: _drp,
                                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                                            if (snapshot.hasData) {
                                              return getDropdownProvince(snapshot.data , index);
                                            } else {
                                              return Container();
                                            }
                                          }),
                                    ),
                                    Container(
                                      child: InkWell(
                                          onTap: () {
                                            setState(() {
                                              formCarList.removeAt(index);
                                              addCar(0);
                                            });
                                          },
                                          child: Icon(Icons.remove)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            );
          }
      );
    });
  }

  Widget build(BuildContext context) {

    final Size screenSize = MediaQuery.of(context).size;



    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              colorFilter: new ColorFilter.mode(
                  Colors.black.withOpacity(0.2), BlendMode.dstATop),
              image: AssetImage('images/template.png'),
              fit: BoxFit.fill,
            ),
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: new Form(
            key: this._formKey,
            child: new ListView(
                padding: EdgeInsets.only(top: 100, left: 40, right: 40),
                children: <Widget>[
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Username",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.username = text;
                        },
                        onSaved: (String value) {
                          this._data.username = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.visiblePassword,
                        obscureText: true,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Password",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.password = text;
                        },
                        onSaved: (String value) {
                          this._data.password = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Firstname",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.fname = text;
                        },
                        onSaved: (String value) {
                          this._data.fname = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Lastname",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.lname = text;
                        },
                        onSaved: (String value) {
                          this._data.lname = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Address",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.address = text;
                        },
                        onSaved: (String value) {
                          this._data.address = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                    child: new TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: "Tel",
                          labelStyle: TextStyle(
                            color: Colors.black38,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        onChanged: (text) {
                          this._data.tel = text;
                        },
                        onSaved: (String value) {
                          this._data.tel = value;
                        },
                        style: TextStyle(fontSize: 16, color: Colors.purple)
                    ),
                  ),
                  new Container(
                      margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: OutlineButton.icon(
                          icon: Icon(
                            Icons.add,
                            color: Colors.indigo,
                          ),
                          label: Text(
                            'Add car',
                            style: TextStyle(color: Colors.purple),
                          ),
                          onPressed: (){
                            addCar(1);
                          },//callback when button is clicked
                          borderSide: BorderSide(
                            color: Colors.deepPurpleAccent, //Color of the border
                            style: BorderStyle.solid, //Style of the border
                            width: 0.8, //width of the border
                          ),
                        ),
                      )
                  ),
                  new Container (
                      child : _addList
                  ),
                  new Container(
                    margin: EdgeInsets.only(top: 40.0, bottom: 10.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ButtonTheme(
                          minWidth: 150.0,
                          height: 50.0,
                          child: OutlineButton(
                            onPressed: () => Navigator.pushNamed(context, '/main'),
                            child: Text(
                              'Back',
                              style: TextStyle(color: Colors.deepPurpleAccent),
                            ),
                            borderSide: BorderSide(
                              color: Colors.deepPurpleAccent, //Color of the border
                              style: BorderStyle.solid, //Style of the border
                              width: 0.8, //width of the border
                            ),
                          ),
                        ),
                        ButtonTheme(
                          minWidth: 150.0,
                          height: 50.0,
                          child: FlatButton(
                            onPressed: this.submit,
                            color: Colors.purple,
                            child: Text(
                              'Sign up',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )

            ]
          )
          )
        ),
      ),
    );
  }
  Widget getDropdownCar(List<CarDropdown> dropdownList , index){
      var button = DropdownButton<CarDropdown>(
        hint: Text("Select item"),
        value: formCarList[index].car,
//      isExpanded: true,
        onChanged: (CarDropdown Value) {
          setState(() {
            for (int i = 0; i < formCarList.length; i++) {
              formCarList[index].car = Value;
//              formCarList[formCarList.length - 1].car = Value.value;
            }
            addCar(0);
          });
        },
        items: dropdownList.map((CarDropdown val) {
          return DropdownMenuItem<CarDropdown>(
              value: val,
              child: Row(
                children: <Widget>[
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                      val.name
                  ),
                ],
              )
          );
        }).toList(),
      );
      return button;
    //button.createState();
  }

  Widget getDropdownProvince(List<DropdownProvince> dropdownList , index) {
    return DropdownButton<DropdownProvince>(
      hint: Text("Select item"),
      value: formCarList[index].province,
      isDense: true,
      onChanged: (DropdownProvince Value) {
        setState(() {
          for(int i=0;i<formCarList.length;i++){
            formCarList[index].province = Value;
//            formCarList[formCarList.length-1].province = Value.provinceId;
          }
          addCar(0);
        });
      },
      items: dropdownList.map((DropdownProvince val) {
        return DropdownMenuItem<DropdownProvince>(
            value: val,
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 10,
                ),
                Text(
                  val.provinceName
                ),
              ],
            )
        );
      }).toList(),
    );
  }
}
