import 'package:numberpicker/numberpicker.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  final pressed;
  final List<int> clock;
  final handleReseter;
  SettingsPage({this.pressed, this.clock, this.handleReseter});

  _SettingsPage createState() => _SettingsPage(this.clock);
}

class _SettingsPage extends State<SettingsPage> {
  List<int> arr = [10, 15, 5, 3, 1];
  List<int> time;
  List<int> resetArr = [0, 4, 0, 4];

  _SettingsPage(this.time);

  final Color color1 = Colors.white;
  final Color color2 = Colors.black;
  final Color color3 = Colors.grey[50];

  handleSec(newValue, type, title) {
    if (newValue != null) {
      if (title == "White") {
        setState(() {
          type == "min" ? time[1] = newValue : time[0] = newValue;
        });
      } else {
        setState(() {
          type == "min" ? time[3] = newValue : time[2] = newValue;
        });
      }
    }
  }

  handlerDefault(a) {
    setState(() {
      time[3] = arr[a];
      time[1] = arr[a];
      time[2] = 0;
      time[0] = 0;
      resetArr[3] = arr[a];
      resetArr[1] = arr[a];
      resetArr[2] = 0;
      resetArr[0] = 0;
    });
    widget.handleReseter(resetArr);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings", style: TextStyle(color: color1)),
        actions: [
          TextButton(
            onPressed: () => widget.pressed(time),
            child:
                Text("Done", style: TextStyle(color: color1, fontSize: 15.0)),
          ),
        ],
        backgroundColor: color2,
      ),
      body: Container(
        alignment: Alignment.center,
        color: color3,
        child: ListView(
          children: [
            Container(
              child: Text("Time controls",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            _buildRow("Black", color2),
            _buildRow("White", color2),
            Container(
              child: Text("Speed",
                  style:
                      TextStyle(fontSize: 20.0, fontWeight: FontWeight.w600)),
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            _buildSimpleRow("Active", 0),
            _buildSimpleRow("Rapid", 1),
            _buildSimpleRow("Blitz", 2),
            _buildSimpleRow("Bullet", 3),
            _buildSimpleRow("Lightning", 4),
            Container(
                height: MediaQuery.of(context).size.height * 0.2,
                color: color3),
          ],
        ),
      ),
    );
  }

  Container _buildSimpleRow(String title, int a) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 5),
        color: Colors.white,
        child: Column(children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(title,
                      style: TextStyle(
                          fontSize: 18.0, fontWeight: FontWeight.w600)),
                  Text(arr[a].toString() + " min"),
                ],
              ),
              TextButton(
                onPressed: () => handlerDefault(a),
                child: Text("Select"),
              ),
            ],
          ),
          Divider(indent: 2.0),
        ]));
  }

  Container _buildRow(String title, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5.0),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: MediaQuery.of(context).size.width * 0.4,
                child: Text(
                  title,
                  style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.w600),
                ),
              ),
              title == "White"
                  ? Text(time[1].toString() +
                      "min" +
                      (time[0] == 0 ? " " : " " + time[0].toString() + "sec"))
                  : Text(time[3].toString() +
                      "min" +
                      (time[2] == 0 ? " " : " " + time[2].toString() + "sec")),
            ],
          ),
          _buildButton("min", showNumberDialog, color, title),
          _buildButton("sec", showNumberDialog, color, title),
        ],
      ),
    );
  }

  //build buttons
  TextButton _buildButton(
      String type, void a(String b, String c), Color color, String title) {
    return TextButton(
      onPressed: () => {a(type, title)},
      child: Text(type, style: TextStyle(fontSize: 13.0, color: Colors.white)),
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(color),
      ),
    );
  }

  //Number picker dialog
  showNumberDialog(String type, String title) {
    return showDialog<int>(
      context: context,
      builder: (context) => NumberPickerDialog.integer(
        minValue: 0,
        maxValue: 59,
        initialIntegerValue: type == "min" && title == "White"
            ? time[1]
            : (type == "sec" && title == "White"
                ? time[0]
                : (type == "min" && title == "Black" ? time[3] : time[2])),
        title: Text("$type Chooser"),
      ),
    ).then(
      (value) => {handleSec(value, type, title)},
    );
  }
}
