import 'dart:convert';

import 'package:Roomap/main.dart';
import 'package:Roomap/roomPaths.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'homepage.dart';

class RoomDetails extends StatefulWidget {
  const RoomDetails({Key? key}) : super(key: key);

  @override
  State<RoomDetails> createState() => _RoomDetailsState();
}

class _RoomDetailsState extends State<RoomDetails> {
  var destination;
  var room_name;
  String searchString = "";

  getRoom() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var room_id = preferences.getString('room_id');
    // print(room_id);
    return room_id;
  }

  Future getRoomDetails() async {
    var url = Uri.parse(baseUrl +
        '/functions/customer/pathways/getPathways.php?room_id=' +
        await getRoom());
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      destination = details;
    });

    print(destination);
    return destination;
  }

  getRoomName() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    room_name = preferences.getString('room_name');
    // print(room_id);
    return room_name;
  }

  Future<void> filterSearchResults(query) async {

    var url = Uri.parse(baseUrl +
        '/functions/customer/pathways/searchPathways.php?search_string=' +
        query +
        '&room_id=' +
        await getRoom());
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      destination = details;
    });
    print(destination);
    return destination;
  }

  @override
  void initState() {
    super.initState();
    getRoomDetails();
    getRoomName();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: destination == null
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
                            child: Text('Destinations',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0),
                          child: Align(
                            alignment: Alignment.topCenter,
                            child: Text('Your location is: ' + room_name,
                                style: TextStyle(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 198, 46, 0),
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 5.0, left: 20),
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Text('Where would you like to go?',
                                style: TextStyle(
                                    fontSize: 14, color: Colors.black)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: TextField(
                            onChanged: (value) {
                              setState(() {
                                searchString = value.toLowerCase();
                                EasyDebounce.debounce(
                                    'my-debouncer', // <-- An ID for this particular debouncer
                                    Duration(
                                        milliseconds:
                                            500), // <-- The debounce duration
                                    () => filterSearchResults(searchString));
                              });
                            },
                            decoration: InputDecoration(
                              labelText: 'Search for a destination',
                              suffixIcon: Icon(Icons.search),
                            ),
                          ),
                        ),
                        SizedBox(
                            child: ListView.builder(
                                //  physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: destination.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();

                                      preferences.setString('room_name',
                                          destination[index]['room']['name']);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RoomPaths()));
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 20.0,
                                          right: 20,
                                          top: 10,
                                          bottom: 10),
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width -
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Text(
                                                      'Room',
                                                      // textAlign: TextAlign.center,
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color: Color.fromARGB(
                                                              255, 0, 0, 0),
                                                          fontSize: 12),
                                                    ),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 50.0),
                                                  child: Align(
                                                    alignment:
                                                        Alignment.topLeft,
                                                    child: Padding(
                                                      padding: const EdgeInsets
                                                          .only(),
                                                      child: Text(
                                                        destination[index]
                                                            ['room']['name'],
                                                        // textAlign: TextAlign.center,
                                                        style: TextStyle(
                                                            // fontWeight: FontWeight.bold,
                                                            color:
                                                                Color.fromARGB(
                                                                    255,
                                                                    0,
                                                                    0,
                                                                    0),
                                                            fontSize: 18),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                }))
                      ]))));
  }
}
