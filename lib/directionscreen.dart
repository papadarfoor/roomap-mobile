import 'package:flutter/material.dart';

class DirectionScreen extends StatefulWidget {
  const DirectionScreen({Key? key}) : super(key: key);

  @override
  State<DirectionScreen> createState() => _DirectionScreenState();
}

class _DirectionScreenState extends State<DirectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
          child: SafeArea(
        child: Column(
          children: [
            InkWell(
              onTap: () {
                FocusScope.of(context).unfocus();
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Image.asset(
                    'images/arrow-small-left.png',
                    height: 12,
                  ),
                ),
              ),
            ),
            Center(
              child: InteractiveViewer(
                panEnabled: false, // Set it to false
                // boundaryMargin: EdgeInsets.all(100),
                minScale: 0.5,
                maxScale: 5,
                child: Image.asset(
                  'images/direction.gif',
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  fit: BoxFit.contain,
                ),
              ),
            )
          ],
        ),
      )),
    );
  }
}
