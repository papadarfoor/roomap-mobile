import 'dart:convert';
import 'package:RooMap/main.dart';
import 'package:RooMap/pathImage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'homepage.dart';

class RoomPaths extends StatefulWidget {
  const RoomPaths({Key? key}) : super(key: key);

  @override
  State<RoomPaths> createState() => _RoomPathsState();
}

class _RoomPathsState extends State<RoomPaths> {
  var path_direction;

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

  Future getRoomInfo() async {
    var url = Uri.parse(baseUrl +
        '/functions/customer/pathways/getOnePathway.php?room_id=' +
        await getRoom() +
        '&room_name=' +
        await getRoomName());

    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      path_direction = details;
    });

    print(path_direction);
    return path_direction;
  }

  @override
  void initState() {
    super.initState();
    getRoomInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: path_direction == null
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Column(children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            InkWell(
                              onTap: () {
                                FocusScope.of(context).unfocus();
                                Navigator.pop(context);
                              },
                              child: Padding(
                                padding:
                                    const EdgeInsets.only(left: 20.0, top: 20),
                                child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Image.asset(
                                    'images/arrow-small-left.png',
                                    height: 12,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => HomePage()));
                                },
                                child: Icon(
                                  Icons.qr_code_scanner_outlined,
                                ),
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('Path',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                            child: ListView.builder(
                                //  physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: path_direction.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0,
                                        right: 20,
                                        top: 10,
                                        bottom: 10),
                                    child: Container(
                                      width: MediaQuery.of(context).size.width -
                                          40,
                                      height: 80,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5)),
                                          color: Colors.white,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Color.fromARGB(74, 0, 0, 0),
                                              offset: const Offset(
                                                3.0,
                                                3.0,
                                              ),
                                              blurRadius: 1.0,
                                              spreadRadius: 1.0,
                                            ),
                                          ]),
                                      child: Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 20.0),
                                            child: Text(
                                              '',
                                            ),
                                          ),
                                          Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 50.0),
                                                child: Align(
                                                  alignment: Alignment.topLeft,
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.only(),
                                                    child: SizedBox(
                                                      width: 318,
                                                      child: Row(
                                                        children: [
                                                          Expanded(
                                                            child: InkWell(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    preferences =
                                                                    await SharedPreferences
                                                                        .getInstance();

                                                                preferences.setString(
                                                                    'path',
                                                                    path_direction[
                                                                        index]);

                                                                preferences.setInt(
                                                                    'image_index',
                                                                    index);

                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                PathImage()));
                                                              },
                                                              child: Text(
                                                                path_direction[
                                                                    index],
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis, // default is .clip
                                                                maxLines: 2,
                                                              ),
                                                            ), // default is 1
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }))
                      ]))));
  }
}
