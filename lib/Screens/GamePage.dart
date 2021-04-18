import 'dart:async';
import 'dart:ffi';

import 'package:Chess/Screens/SettingsPage.dart';
import 'package:Chess/widgets/clock.dart';
import 'package:flutter/material.dart';
import 'package:Chess/widgets/SideSection.dart';
import 'package:flutter/services.dart';

class GamePage extends StatefulWidget {
  @override
  _GamePage createState() => _GamePage();
}

class _GamePage extends State<GamePage> {
  final Color color1 = Colors.black;
  final Color color2 = Colors.white;

  List<int> arr = [0, 5, 0, 5];

  List<int> resetArr = [0, 5, 0, 5];

  bool isClicked = true;
  bool isPaused = true;
  bool isReseted = false;
  bool isFinished = false;

  List numberOfMoveArr = [0, 0];

  static const duration = const Duration(milliseconds: 1000);
  Timer timer;

  void handleChangerBlack(bool isTaped) {
    print(resetArr.toString());
    setState(() {
      isPaused ? isPaused = false : isClicked = isTaped;
      if (!isPaused && isClicked) numberOfMoveArr[0]++;
    });
  }

  void handleChangerWhite(bool isTaped) {
    setState(() {
      isPaused ? isPaused = false : isClicked = !isTaped;
      if (!isPaused && !isClicked) numberOfMoveArr[1]++;
    });
  }

  void handlePauseBtn() {
    setState(() {
      isPaused = !isPaused;
    });
  }

  void routeSecondPage() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SettingsPage(
            clock: arr,
            pressed: (data) {
              setState(() {
                arr = data;
              });
              Navigator.pop(context);
            },
            handleReseter: (res) {
              setState(() {
                resetArr = res;
              });
            }),
      ),
    );
  }

  void reset() {
    setState(() {
      arr = resetArr;
      isFinished = false;
      numberOfMoveArr[0] = 0;
      numberOfMoveArr[1] = 0;
    });
    Navigator.pop(context);
  }

  void setTimer(a) {
    if (arr[a] == 0 && arr[a + 1] == 0) {
      setState(() {
        isFinished = true;
        isPaused = true;
      });
    } else {
      setState(() {
        isFinished = false;
        if (arr[a] > 0)
          arr[a]--;
        else if (arr[a] == 0) {
          arr[a + 1]--;
          arr[a] = 59;
        }
      });
    }
  }

  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    if (timer == null) {
      timer = Timer.periodic(duration, (timer) {
        if (!isPaused) {
          if (!isClicked) {
            setTimer(0);
          } else {
            setTimer(2);
          }
        }
      });
    }

    return Scaffold(
        body: Center(
      child: Column(
        children: [
          RotatedBox(
            quarterTurns: 2,
            child: SideSection(
              isClicked,
              handleChangerBlack,
              color1,
              color2,
              isPaused,
              numberOfMoveArr[0],
              Clock(isClicked, color2, isPaused, arr[0], arr[1], isFinished),
            ),
          ),
          RotatedBox(
            quarterTurns: isClicked ? 0 : 2,
            child: Visibility(
              visible: !isPaused,
              child: _buildButton("Pause", handlePauseBtn, color1, color2),
              replacement: Row(
                children: [
                  _buildButton("Settings", routeSecondPage, color2, color1),
                  _buildButton("Reset", showResetDialog, color1, color2),
                ],
              ),
            ),
          ),
          SideSection(
            !isClicked,
            handleChangerWhite,
            color2,
            color1,
            isPaused,
            numberOfMoveArr[1],
            Clock(!isClicked, color1, isPaused, arr[2], arr[3], isFinished),
          ),
        ],
      ),
    ));
  }

  //build buttons
  FlatButton _buildButton(String title, void a(), Color c1, Color c2) {
    return FlatButton(
      onPressed: () => {a()},
      child: Text(
        title,
        style: TextStyle(
          color: isClicked ? c1 : c2,
          fontSize: 18.0,
        ),
      ),
      color: isClicked ? c2 : c1,
      height: MediaQuery.of(context).size.height * 0.1,
      minWidth: MediaQuery.of(context).size.width * (isPaused ? 0.5 : 1),
    );
  }

  //showResetDialog
  showResetDialog() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm Reset?"),
        actions: [
          TextButton(onPressed: () => {reset()}, child: Text("Reset")),
          TextButton(
              onPressed: () => {Navigator.pop(context)}, child: Text("Close")),
        ],
      ),
    );
  }
}
