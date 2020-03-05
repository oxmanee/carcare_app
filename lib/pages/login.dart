import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:booking_carcare_app/models/loginModel.dart';
import 'package:flutter/services.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _LoginState();
  }
}

class User {
  final int id;
  final String username;
  final String password;
  final String fname;
  final String lname;
  final String address;
  final String tel;
  final String status;
  final int cashier_id;
  final bool result;
  final String token;

  User(
      this.id,
      this.username,
      this.password,
      this.fname,
      this.lname,
      this.address,
      this.tel,
      this.status,
      this.cashier_id,
      this.result,
      this.token);

  User.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        username = json['username'],
        password = json['password'],
        fname = json['fname'],
        lname = json['lname'],
        address = json['address'],
        tel = json['tel'],
        status = json['status'],
        cashier_id = json['cashier_id'],
        result = json['result'],
        token =
            json['token'] == '' || json['token'] == null ? null : json['token'];
}

Future getLogin(username, password) async {
  var req = LoginModel();
  req.username = username;
  req.password = password;
  var jsonRequest = req.toJson();

  http.Response response = await http.post(
      "http://157.179.133.41:3000/app/loginMember",
      body: jsonRequest,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded'
      });
  Map userMap = json.decode(response.body);
  var user = User.fromJson(userMap);
  return user;
}

class _LoginState extends State<LoginPage> {
  @override
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  Widget build(BuildContext context) {
    void _showDialog(title, valid) async {
      // flutter defined function
      showDialog(
        context: context,
        builder: (BuildContext context) {
          // return object of type Dialog
          return AlertDialog(
            title: new Text(title),
            content: new Text(valid),
            actions: <Widget>[
              // usually buttons at the bottom of the dialog
              new FlatButton(
                child: new Text("Close"),
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.black.withOpacity(0.3), BlendMode.dstATop),
            image: AssetImage('images/template.png'),
            fit: BoxFit.fill,
          ),
          ),
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).size.width / 6,
            left: 40,
            right: 40,
            bottom: MediaQuery.of(context).size.width / 6),
        child: ListView(
          children: <Widget>[
            SizedBox(
              width: 128,
              height: 160,
              child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 40),
                      Text(
                        '47',
                        style: TextStyle(
                            fontSize: 50, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'CarCare',
                        style: TextStyle(
                            fontSize: 50,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  )),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.text,
              controller: _usernameController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Username",
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            SizedBox(
              height: 30,
            ),
            TextFormField(
              // autofocus: true,
              keyboardType: TextInputType.text,
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Password",
                labelStyle: TextStyle(
                  color: Colors.purple,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20, color: Colors.deepPurple),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: FlatButton(
                child: Text(
                  "Forgot password",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.indigo),
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [
                    Colors.deepPurple,
                    Colors.purpleAccent,
                  ],
                ),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  onPressed: () async {
                    var username = _usernameController.text;
                    var password = _passwordController.text;

                    if (username == '' || password == '') {
                      await _showDialog('Valid inpuut!',
                          'Please enter your username and password.');
                      return false;
                    }

                    var login = await getLogin(username, password);

                    if (login.token == null || login.token == '') {
                      await _showDialog(
                          'Login Fail!', 'Username or password is incorrect.');
                      return false;
                    } else {
                      var genUser = await manageToken();
                      await genUser.save(login.id, login.username, login.fname,
                          login.lname, login.address, login.tel, login.token);
                      Navigator.pushNamed(context, '/home');
                      return true;
                    }
                  },
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.indigo),
              ),
              child: SizedBox.expand(
                child: FlatButton(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "Register",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ],
                  ),
                  onPressed: () => Navigator.pushNamed(context, '/regis'),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
