import 'package:RooMap/scan.dart';
import 'package:flutter/material.dart';
import 'package:RooMap/homepage.dart';

void main() {
  runApp(const MyApp());
}

var baseUrl = 'https://final-project-RooMap.herokuapp.com';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RooMap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
