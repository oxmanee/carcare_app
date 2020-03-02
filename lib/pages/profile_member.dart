import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/CarModel.dart';
import 'package:booking_carcare_app/models/MemberDetailModel.dart';
import 'package:booking_carcare_app/models/provinceModel.dart';
import 'package:booking_carcare_app/pages/regis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _ProfileState();
  }
}

class MemberDetailForm{

  MemberDetailForm({ this.memberDetailId , this.memberLicense , this.memberProvince , this.memberCar });
  int memberDetailId;
  String memberLicense;
  DropdownProvince memberProvince;
  CarDropdown memberCar;
}

class DisplayMemberDetail{
  DisplayMemberDetail({this.car , this.license , this.province});
  String car;
  String license;
  String province;
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

  List<MemberDetailForm> formMemberDetail = new List<MemberDetailForm>();
  Widget _addList;
  Future<List<CarDropdown>> _carList;
  Future<List<DropdownProvince>> _drp;
  List<DisplayMemberDetail> displayCar = new List<DisplayMemberDetail>();
  Future<List<MemberDetailForm>> formCar;
  var value;
  @override
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
    _drp = _getProvince();
    _carList = _getCar();
    formCar = getMemberDetail();
  }


  Future<List<MemberDetailForm>> getMemberDetail() async {

    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    final response = await http
        .get("http://192.168.1.139:3000/app/getMemberDetailForEditApi/${id}",
        headers: {'Authorization': _bearerToken , 'Content-type': 'application/x-www-form-urlencoded'});
    var res = json.decode(response.body);
    var data = MemberDetailModel.fromJson(res);


    for (int i = 0; i < data.data.length; i++) {
      displayCar.add(DisplayMemberDetail( car : data.data[i].car , license : data.data[i].memberLicense , province : data.data[i].provinceName ));
      formMemberDetail.add(MemberDetailForm(memberDetailId : data.data[i].memberDetailId , memberLicense : data.data[i].memberLicense , memberProvince : DropdownProvince(data.data[i].memberProvince , data.data[i].provinceName) , memberCar: CarDropdown(data.data[i].memberCarDetailId , data.data[i].car)));
    }

    return formMemberDetail;
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

  void addCar(status) {
    setState(() {
//        int i = _addList.length; // start 0
      //  print(i);
      if(status == 1){
        formMemberDetail.add(MemberDetailForm(memberDetailId : 0, memberLicense : null, memberCar: null));
      }

      _addList =
          Column(
          children: <Widget>[
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
            Container(
              child : new ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: formMemberDetail.length,
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
                                        for(int i=0;i<formMemberDetail.length;i++){
                                          formMemberDetail[index].memberLicense = text;
                                        }
                                      },
                                      onSaved: (String value) {
                                        for(int i=0;i<formMemberDetail.length;i++){
                                          formMemberDetail[index].memberLicense = value;
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
                                                      formMemberDetail.removeAt(index);
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
              )
            )
          ],
        );
    });
  }

  Widget getDropdownCar(List<CarDropdown> dropdownList , index){
    var button = DropdownButton<CarDropdown>(
      hint: Text("Select item"),
      value: formMemberDetail[index].memberCar,
//      isExpanded: true,
      onChanged: (CarDropdown Value) {
        setState(() {
          for (int i = 0; i < formMemberDetail.length; i++) {
            formMemberDetail[index].memberCar = Value;
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
      value: formMemberDetail.isEmpty ? null : formMemberDetail[index].memberProvince,
      isDense: true,
      onChanged: (DropdownProvince Value) {
        setState(() {
          for(int i=0;i<formMemberDetail.length;i++){
            formMemberDetail[index].memberProvince = Value;
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

    Widget displayCarWidget = new FutureBuilder(
        future: formCar,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return new ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: displayCar.length,
                itemBuilder: (BuildContext ctxt, int index){
                  return Card(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text("ประเภทรถ :"),
                            Text(displayCar[index].car)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("เลขทะเบียน :"),
                            Text(displayCar[index].license)
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text("จังหวัด :"),
                            Text(displayCar[index].province)
                          ],
                        )
                      ],
                    ),
                  );
                }
            );
          }else{
            return Container();
          }
        }
    );

    Widget editCarWidget = _addList;

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
          addCar(0);
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
                  Container(

                  ),
                  chk == 1 ? Container(
                    margin: EdgeInsets.only(
                        left: MediaQuery.of(context).size.width / 5, top: 30),
                    child: Text(
                      'Car',
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
                      child: chk == 1 ? displayCarWidget : editCarWidget),
                  Container(

                  ),
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
