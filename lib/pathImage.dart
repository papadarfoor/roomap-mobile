import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:RooMap/main.dart';
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
  var path_image;
  var index;

  getPath() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      path = preferences.getString('path');
    });

    print(path);
    return path;
  }

  getRoom() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var room_id = preferences.getString('room_id');
    return room_id;
  }

  getRoomName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var room_name = preferences.getString('room_name');
    return room_name;
  }

  getPathImageIndex() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    setState(() {
      index = preferences.getInt('image_index');
    });

    return index;
  }

  Future getPathImage() async {
    var url = Uri.parse(baseUrl +
        '/functions/customer/pathways/getPathwayImages.php?room_id=' +
        await getRoom() +
        '&room_name=' +
        await getRoomName());

    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      path_image = details;
    });

    print(path_image);
    return path_image;
  }

  @override
  void initState() {
    super.initState();
    getPath();
    getPathImageIndex();
    getPathImage();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 198, 46, 0),
        title: Text(path),
      ),
      body: path == null
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: path_image == null
                  ? CircularProgressIndicator()
                  : FullScreenWidget(child: Image.network(path_image[index])),
            ),
    );
  }
}
