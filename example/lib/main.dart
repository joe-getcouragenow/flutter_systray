import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_systray/flutter_systray.dart';
import 'package:path/path.dart' as p;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Windows need .ico file
  String path;
  if (Platform.isWindows) {
    path = p.absolute('go\\assets', 'icon.ico');
  } else {
    path = p.absolute('go/assets', 'icon.png');
  }

  // root Systray entry
  MainEntry main = MainEntry(
    title: "title",
    iconPath: path,
  );

  // We first init the systray menu and then add the menu entries
  await FlutterSystray.initSystray(main);
  await FlutterSystray.updateMenu([
    SystrayAction(
        name: "focus",
        label: "Focus",
        actionType: ActionType.Focus),
    SystrayAction(
        name: "counterEvent",
        label: "Counter event",
        actionType: ActionType.SystrayEvent),
    SystrayAction(
        name: "systrayEvent2",
        label: "Event 2",
        actionType: ActionType.SystrayEvent),
    SystrayAction(
        name: "quit", label: "Quit", actionType: ActionType.Quit)
  ]);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // Register an event handler
  final FlutterSystray systemTray = FlutterSystray.init();

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _counter = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Flutter systray example app'),
        ),
        body: Center(
          child: Text(
              'There should be a menu with a Hover icon in the systray.\n\n Number of times that the counter was triggered: $_counter '),
        ),
      ),
    );
  }

  @override
  void initState() {

    // Setup a callback for systray triggered event
    widget.systemTray.registerEventHandler("counterEvent", () {
      setState(() {
        _counter += 1;
      });
    });

    super.initState();
  }
}
