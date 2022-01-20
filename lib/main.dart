import 'dart:async';
import 'package:flutter/services.dart';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
// ignore: import_of_legacy_library_into_null_safe
import 'package:screen/screen.dart';

void main() => runApp(const MyApp());

// ignore: constant_identifier_names
const TIME_FORMAT_STRING = 'hh:mm';
// ignore: constant_identifier_names
const AM_PM_FORMAT_STRING = 'a';
// ignore: constant_identifier_names
const DATE_FORMAT_STRING = 'EEEE, MMMM d, yyyy';

final DateFormat timeFormatter =  DateFormat(TIME_FORMAT_STRING);
final DateFormat ampmFormatter =  DateFormat(AM_PM_FORMAT_STRING);
final DateFormat dateFormatter =  DateFormat(DATE_FORMAT_STRING);

// ignore: constant_identifier_names
const DAY_TIME = [9, 21];
// ignore: constant_identifier_names
const DAY_BRIGHTNESS = 1.0;
// ignore: constant_identifier_names
const NIGHT_BRIGHTNESS = 0.0;

// https://proandroiddev.com/how-to-dynamically-change-the-theme-in-flutter-698bd022d0f0
final nightTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    canvasColor: Colors.black,
    textTheme: const TextTheme(
        headline1:  TextStyle(color: Colors.white, fontSize: 92),
        subtitle1:  TextStyle(color: Colors.white, fontSize: 20),
        subtitle2:  TextStyle(color: Colors.white, fontSize: 38)
    )
);

final dayTheme = ThemeData(
    primarySwatch: Colors.blueGrey,
    canvasColor: const Color.fromRGBO(193, 246, 244, 1),
    textTheme: const TextTheme(
        headline1: TextStyle(color: Colors.black, fontSize: 92),
        subtitle1: TextStyle(color: Colors.black, fontSize: 20),
        subtitle2: TextStyle(color: Colors.black, fontSize: 38)
    )
);

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  bool nightMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner:false,
        title: 'Dock Clock',
        theme: nightMode ? nightTheme : dayTheme,
        home: MyHomePage(title: 'Dock Clock', setNightMode: (nightModeValue) {
          setState(() {
            nightMode = nightModeValue;
          });
        })
    );
  }
}
 // https://flutter.dev/docs/development/ui/animations/tutorial

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title, required this.setNightMode}) : super(key: key);

  final String title;
  final Function(bool) setNightMode;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

enum DisplayState {
  // ignore: constant_identifier_names
  AUTO,
  // ignore: constant_identifier_names
  NIGHT_MODE,
  // ignore: constant_identifier_names
  DAY_MODE
}

class _MyHomePageState extends State<MyHomePage> {
  DateTime _time =  DateTime.now();
  late Timer timer;
  DisplayState displayState = DisplayState.AUTO;

  void _updateTime() {
    setState(() {
      _time =  DateTime.now();
    });
  }

  void dayModeHandler() {
    widget.setNightMode(false);
    Screen.setBrightness(DAY_BRIGHTNESS);
  }

  void nightModeHandler() {
    widget.setNightMode(true);
    Screen.setBrightness(NIGHT_BRIGHTNESS);
  }

  void _handleTick(Timer t) {
    _updateTime();
    if (displayState == DisplayState.AUTO) {
      if (_time.hour < DAY_TIME[0] || _time.hour > DAY_TIME[1]) {
        nightModeHandler();
      } else {
        dayModeHandler();
      }
    } else if (displayState == DisplayState.NIGHT_MODE) {
      nightModeHandler();
    } else if (displayState == DisplayState.DAY_MODE) {
      dayModeHandler();
    }
  }

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    Screen.keepOn(true);

    timer = Timer.periodic(const Duration(seconds: 1), _handleTick);
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return SafeArea(
        child: GestureDetector(
          onDoubleTap: () {
            int index = (DisplayState.values.indexOf(displayState) + 1) % DisplayState.values.length;
            setState(() {
              displayState = DisplayState.values[index];
            });
          },
          child: Scaffold(
            body: Center(
            // Center is a layout widget. It takes a single child and positions it
            // in the middle of the parent.
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                            timeFormatter.format(_time),
                            style: Theme.of(context).textTheme.headline1
                        ),
                        Padding(
                            padding: const EdgeInsets.fromLTRB(0.0, 13.0, 0.0, 2.0),
                            child: Text(
                                ampmFormatter.format(_time),
                                style: Theme.of(context).textTheme.subtitle1
                            )
                        )
                      ]
                  ),
                  Text(
                      dateFormatter.format(_time),
                      style: Theme.of(context).textTheme.subtitle1
                  )
                ],
              )
            )
          ),
        )
    );
  }
}