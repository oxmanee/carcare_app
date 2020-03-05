import 'dart:convert';
import 'dart:io';

import 'package:booking_carcare_app/helpers/manageToken.dart';
import 'package:booking_carcare_app/models/ReservationModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class StatusPage extends StatefulWidget{

  int queue_id;
  StatusPage({ Key key , this.queue_id});
  @override
  State<StatefulWidget> createState() {
    return _StatusPage();
  }
}

class _StatusPage extends State<StatusPage>{
  var _currentState = 2;

  Future getStatusQueue() async {
    var _token = manageToken();
    var _bearerToken = await _token.readToken();
    var id = await _token.readId();
    http.Response response = await http
        .get('http://192.168.1.144:3000/app/getReservationByQueueApi/30', headers: {
      HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
      'Authorization': _bearerToken
    });
    var res = json.decode(response.body);
    var data = ReservationModel.fromJson(res);
    for(int i=0;i<data.data.length;i++){
      _currentState = data.data[i].reservStatus;
    }
    return data;
  }
  List<Step> step = <Step>[
    Step(
      title : Text("รอดำเนินการ"),
      content: Text("รอดำเนินการ")
    ),
    Step(
        title : Text("กำลังดำเนินการ"),
        content: Text("กำลังดำเนินการ")
    ),
    Step(
        title : Text("เสร็จสิ้นการดำเนินงาน"),
        content: Text("เสร็จสิ้นการดำเนินงาน")
    ),
    Step(
        title : Text("end"),
        content: Text("end")
    )
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title : Text("Status Car")
      ),
      body: FutureBuilder(
            future: getStatusQueue(),
            builder: (BuildContext context,
                AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  return Stepper(
                      currentStep: _currentState,
                      steps : step,
                      type: StepperType.vertical,
                  );
                }else{
                  return Container();
                }
            }
          )
    );
  }
}