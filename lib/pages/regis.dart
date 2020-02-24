import 'dart:io';
import 'dart:convert';

import 'package:booking_carcare_app/models/regisModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

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

Future _getLogin(
    username, password, fname, lname, address, tel, cashierId) async {
  var req = RegisModel();
  req.username = username;
  req.password = password;
  req.fname = fname;
  req.lname = lname;
  req.address = address;
  req.tel = tel;
  req.cashierId = cashierId;

  var jsonRequest = req.toJson();

  http.Response response = await http.post(
      "http://192.168.163.2:3000/app/insertMember",
      body: jsonRequest,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
      });

  var responseData = json.decode(response.body);
  var res = Success.fromJson(responseData);
  return res.result;
}

class _RegigState extends State<RegisPage> {
  @override
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fameController = TextEditingController();
  TextEditingController _lameController = TextEditingController();
  TextEditingController _addressController = TextEditingController();
  TextEditingController _telController = TextEditingController();

  var _add = 0;

  Widget build(BuildContext context) {
    List<Widget> _addList = List<Widget>();

    for (var i = 0; i < _add; i++) {
      _addList.add(Row(
        key: Key("index_$i"),
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width / 5,
            child: TextFormField(
                decoration: InputDecoration(
              labelText: "Car",
            )),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width / 5,
            child: TextFormField(
                decoration: InputDecoration(
              labelText: "Car code",
            )),
          ),
          Container(
            margin: EdgeInsets.only(right: 15),
            width: MediaQuery.of(context).size.width / 5,
            child: TextFormField(
                decoration: InputDecoration(
              labelText: "Province",
            )),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _add -= 1;
              });
            },
            child: Container(
              child: Icon(Icons.remove),
            ),
          ),
        ],
      ));
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

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: ListView(
            padding: EdgeInsets.only(top: 100, left: 40, right: 40),
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(top: 5.0, bottom: 10.0),
                child: TextFormField(
                  controller: _usernameController,
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
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: TextFormField(
                  controller: _passwordController,
                  keyboardType: TextInputType.text,
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
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: TextFormField(
                  controller: _fameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "First name",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: TextFormField(
                  controller: _lameController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Last name",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: TextFormField(
                  maxLines: null,
                  controller: _addressController,
                  keyboardType: TextInputType.multiline,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Adress",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 15.0, bottom: 10.0),
                child: TextFormField(
                  inputFormatters: [
                    LengthLimitingTextInputFormatter(10),
                  ],
                  maxLines: null,
                  controller: _telController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Tel",
                    labelStyle: TextStyle(
                      color: Colors.black38,
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
                  ),
                  style: TextStyle(fontSize: 16, color: Colors.purple),
                ),
              ),
              Container(
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
                      onPressed: () {
                        setState(() {
                          _add += 1;
                        });
                      }, //callback when button is clicked
                      borderSide: BorderSide(
                        color: Colors.deepPurpleAccent, //Color of the border
                        style: BorderStyle.solid, //Style of the border
                        width: 0.8, //width of the border
                      ),
                    ),
                  )),
              Column(
                children: _addList,
              ),
              Container(
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
                        onPressed: () async {
                          var username = _usernameController.text;
                          var password = _passwordController.text;
                          var fname = _fameController.text;
                          var lname = _lameController.text;
                          var address = _addressController.text;
                          var tel = _telController.text;

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

                          var res = await _getLogin(username, password, fname,
                              lname, address, tel, '1');
                          print(res);
                          if (res == "success") {
                            Navigator.pushNamed(context, '/main');
                          } else {
                            _showDialog('Error', 'Sorry! register fail');
                          }
                          return true;
                        },
                        color: Colors.purple,
                        child: Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
