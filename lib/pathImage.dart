import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PathImage extends StatefulWidget {
  const PathImage({Key? key}) : super(key: key);

  @override
  State<PathImage> createState() => _PathImageState();
}

class _PathImageState extends State<PathImage> {
  var path;

  getPath() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
          path = preferences.getString('path');
    });

    print(path);
    return path;
  }

  @override
  void initState() {
    super.initState();
    getPath();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 46, 0),
        title: Text(path),
      ),
      body: Center(
        child: FullScreenWidget(
            child: Image.network(
                'https://pixabay.com/get/g434c4f304bf79db1f9081f658594f38e6ce771862adcc19b9ac8a22941b370268fda741946c1f8e7cab17b1e876357c9c42779ff9253db7bdc355ee1f8c385169b23c65826ab8b839a61a83de76f985a_1920.jpg')),
      ),
    );
  }
}
