import 'package:booking_carcare_app/pages/reservation/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckBoxCleanService extends StatefulWidget{
  CleanService checkbox;
  CheckBoxCleanService({Key key, this.checkbox}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    print(this.checkbox);
    return _CheckBoxCleanService(checkbox : this.checkbox);
  }

}

class _CheckBoxCleanService extends State<CheckBoxCleanService>{

  CleanService checkbox;
  _CheckBoxCleanService({Key key, this.checkbox});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Row(
          children: <Widget>[
            new Expanded(child: new Text(checkbox.name)),
            new Checkbox(
                value: checkbox.isCheck,
                onChanged: (bool value) {
                  setState(() {
                    checkbox.isCheck = value;
                  });
                })
          ],
        ));
  }
}
