import 'dart:math';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfilePage> {
  var user;
  var fname;
  var lname;
  var address;
  var tel;

  var chk = 1;

  TextEditingController _usernameController = TextEditingController();
  TextEditingController _fnameController = TextEditingController();
  TextEditingController _lnameController = TextEditingController();
  TextEditingController _telController = TextEditingController();
  TextEditingController _addressController = TextEditingController();

  void initState() {
    super.initState();
    var _userData = manageToken();
    _userData.readUser().then((s) {
      setState(() {
        user = s;
        _usernameController.text = s;
      });
    });
    _userData.readFname().then((s) {
      setState(() {
        fname = s;
        _fnameController.text = s;
      });
    });
    _userData.readLname().then((s) {
      setState(() {
        lname = s;
        _lnameController.text = s;
      });
    });
    _userData.readAddress().then((s) {
      setState(() {
        address = s;
        _addressController.text = s;
      });
    });
    _userData.readTel().then((s) {
      setState(() {
        tel = s;
        _telController.text = s;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget userText = Text(
      user != null && user != '' ? user : '',
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

    Widget fnameText = Text(
      fname != null && fname != '' ? fname : '',
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

    Widget lnameText = Text(
      lname != null && lname != '' ? lname : '',
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

    Widget telText = Text(
      tel != null && tel != '' ? tel : '',
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

    Widget addressText = Text(
      address != null && address != '' ? address : '',
      style: TextStyle(fontSize: 18, color: Colors.black),
    );

    Widget editUser = TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Username",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _usernameController,
      style: TextStyle(fontSize: 18, color: Colors.purple),
    );

    Widget editFname = TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Name",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _fnameController,
      style: TextStyle(fontSize: 18, color: Colors.purple),
    );

    Widget editLname = TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Surname",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _lnameController,
      style: TextStyle(fontSize: 18, color: Colors.purple),
    );

    Widget editTel = TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Telphone",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _telController,
      style: TextStyle(fontSize: 18, color: Colors.purple),
    );

    Widget editAddress = TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        labelText: "Address",
        labelStyle: TextStyle(
          color: Colors.black38,
          fontWeight: FontWeight.w400,
          fontSize: 20,
        ),
      ),
      keyboardType: TextInputType.text,
      controller: _addressController,
      style: TextStyle(fontSize: 18, color: Colors.purple),
    );

    Widget editBtn = FlatButton(
      onPressed: () {
        setState(() {
          chk = 2;
        });
      },
      child: Text(
        'Edit',
        style: TextStyle(fontSize: 20, color: Colors.white),
      ),
      color: Color.fromRGBO(114, 114, 114, 1),
    );

    Widget saveBtn = FlatButton(
        onPressed: () {
          setState(() {
            chk = 1;
          });
        },
        child: Text(
          'Save',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
        color: Colors.indigo);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 3,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.indigo, Color.fromRGBO(206, 118, 160, 1)]),
                borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(
                        MediaQuery.of(context).size.width, 100.0)),
              ),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.topLeft,
                    child: GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        margin: EdgeInsets.only(left: 8, top: 25),
                        child: Icon(
                          Icons.arrow_back,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Center(
                      child: Stack(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.grey,
                        ),
                        child: Padding(
                            padding: EdgeInsets.all(2),
                            child: SizedBox(
                                width: 15,
                                height: 15,
                                child: Icon(
                                  Icons.person,
                                  size: 70,
                                  color: Colors.white,
                                ))),
                      ),
                      Positioned(
                        top: 88,
                        left: 66,
                        child: Icon(Icons.camera_alt,
                            size: 30.0, color: Colors.black),
                      ),
                    ],
                  )),
                  Container(
                    margin: EdgeInsets.only(top: 20),
                    child: Text(
                      user != null && user != '' ? user : '',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topLeft,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  chk == 1
                      ? Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              top: 30),
                          child: Text(
                            'Username',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(133, 133, 133, 1)),
                          ),
                        )
                      : Container(),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5,
                          top: chk == 1 ? 5 : 35,
                          right: MediaQuery.of(context).size.width / 5),
                      child: chk == 1 ? userText : editUser),
                  chk == 1
                      ? Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              top: 30),
                          child: Text(
                            'Name',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(133, 133, 133, 1)),
                          ),
                        )
                      : Container(),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5,
                          top: chk == 1 ? 5 : 35,
                          right: MediaQuery.of(context).size.width / 5),
                      child: chk == 1 ? fnameText : editFname),
                  chk == 1
                      ? Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              top: 30,
                              right: MediaQuery.of(context).size.width / 5),
                          child: Text(
                            'Surname',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(133, 133, 133, 1)),
                          ),
                        )
                      : Container(),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5,
                          top: chk == 1 ? 5 : 35,
                          right: MediaQuery.of(context).size.width / 5),
                      child: chk == 1 ? lnameText : editLname),
                  chk == 1
                      ? Container(
                          margin: EdgeInsets.only(
                              left: MediaQuery.of(context).size.width / 5,
                              top: 30),
                          child: Text(
                            'Telphone',
                            style: TextStyle(
                                fontSize: 22,
                                color: Color.fromRGBO(133, 133, 133, 1)),
                          ),
                        )
                      : Container(),
                  Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 5,
                        top: chk == 1 ? 5 : 35,
                        right: MediaQuery.of(context).size.width / 5),
                    child: chk == 1 ? telText : editTel,
                  ),
                  chk == 1 ? Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 5, top: 30),
                    child: Text(
                      'Address',
                      style: TextStyle(
                          fontSize: 22,
                          color: Color.fromRGBO(133, 133, 133, 1)),
                    ),
                  ) : Container(),
                  Container(
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width / 5,
                          top: chk == 1 ? 5 : 35,
                          right: MediaQuery.of(context).size.width / 5),
                      child: chk == 1 ? addressText : editAddress),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 8, top: 10),
                  child: chk == 1 ? editBtn : saveBtn),
            )
          ],
        ),
      ),
    );
  }
}
