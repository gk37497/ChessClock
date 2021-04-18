import 'package:flutter/material.dart';

class SideSection extends StatelessWidget {
  final bool clicked;
  final ValueChanged<bool> onChanged;
  final Color color;
  final Color clockColor;
  final bool pauseBtnClicked;
  final Widget clock;
  final int numberOfMove;

  SideSection(
    this.clicked,
    this.onChanged,
    this.color,
    this.clockColor,
    this.pauseBtnClicked,
    this.numberOfMove,
    this.clock,
  );
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        clicked ? print(" ") : onChanged(!clicked);
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        curve: Curves.fastOutSlowIn,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * (clicked ? 0.3 : 0.6),
        child: Material(
          color: color,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              clock,
              Container(
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top * 2),
                child: Text(
                  "Move " + numberOfMove.toString(),
                  style: TextStyle(fontSize: 18, color: clockColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
