import 'package:flutter/material.dart';

class Clock extends StatelessWidget {
  final bool clicked;
  final Color color;
  final bool paused;
  final int sec;
  final int min;
  final bool isFinished;

  Clock(
    this.clicked,
    this.color,
    this.paused,
    this.sec,
    this.min,
    this.isFinished,
  );
  @override
  Widget build(BuildContext context) {
    String time = (min >= 10 ? min.toString() : ("0" + min.toString())) +
        ":" +
        (sec >= 10 ? sec.toString() : "0" + sec.toString());

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          time,
          style: TextStyle(
              fontSize: 70.0, fontWeight: FontWeight.w500, color: color),
        ),
        Visibility(
          visible: paused && !clicked && !isFinished,
          child: Text(
            "Tap To Resume",
            style: TextStyle(
              fontSize: 20.0,
              color: color,
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
        Visibility(
          visible: isFinished && !clicked,
          child: Text(
            "OUT OF TIME",
            style: (TextStyle(color: Colors.red, fontSize: 18)),
          ),
        ),
      ],
    );
  }
}
