import 'package:Roomap/locations.dart';
import 'package:Roomap/scan.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentIndex = 0;
  final tabs = [QRViewExample(), Locations()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: new Icon(
              Icons.qr_code_scanner_outlined,
            ),
            label: 'Scan',
          ),
          BottomNavigationBarItem(
              icon: new Icon(
                Icons.room_outlined,
              ),
              label: 'Locations'),
        ],
        selectedItemColor: Colors.black,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
      body: tabs[currentIndex],
    );
  }
}
