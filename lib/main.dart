import 'package:Roomap/scan.dart';
import 'package:flutter/material.dart';
import 'package:Roomap/homepage.dart';

void main() {
  runApp(const MyApp());
}

  var baseUrl = 'https://final-project-roomap.herokuapp.com';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rooms',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}
