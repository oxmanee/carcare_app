import 'package:booking_carcare_app/models/CleanServiceCheckBox.dart';
import 'package:booking_carcare_app/pages/reservation/reservation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class CheckBoxCleanService extends StatefulWidget{
  CleanServiceCheckBox checkbox;
  CheckBoxCleanService({Key key, this.checkbox}) : super(key: key);
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _CheckBoxCleanService(checkbox : this.checkbox);
  }
}

class _CheckBoxCleanService extends State<CheckBoxCleanService>{

  CleanServiceCheckBox checkbox;
  _CheckBoxCleanService({Key key, this.checkbox});

  @override
  Widget build(BuildContext context) {
    return new ListTile(
        title: new Row(
          children: <Widget>[
            new Expanded(child: new Text(checkbox.name)),
            new Checkbox(
                value: checkbox.isCheck,
                onChanged: (var value) {
                  setState(() {
                    checkbox.isCheck = value;
                  });
                })
          ],
        ));
  }
}
