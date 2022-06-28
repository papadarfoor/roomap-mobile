import 'dart:convert';
import 'package:Roomap/homepage.dart';
import 'package:Roomap/main.dart';
import 'package:Roomap/roomDetails.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LocationDetails extends StatefulWidget {
  const LocationDetails({Key? key}) : super(key: key);

  @override
  State<LocationDetails> createState() => _LocationDetailsState();
}

class _LocationDetailsState extends State<LocationDetails> {
  var rooms;
    List room_name = [];
  String searchString = "";

  getBuilding() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();

    var building_id = preferences.getString('building_id');
    return building_id;
  }

  Future getRooms() async {
    var url = Uri.parse(
        baseUrl+'/functions/customer/rooms/getRooms.php?building_id=' +
            await getBuilding());
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      rooms = details;
    });



    print(rooms);
    return rooms;
  }


        Future<void> filterSearchResults(query) async {
    var url = Uri.parse(baseUrl +
        '/functions/customer/rooms/searchRooms.php?building_id='+await getBuilding()+'&search_string=' +
        query);
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      rooms = details;
    });
    print(rooms);
    return rooms;
  }

  @override
  void initState() {
    super.initState();
    getRooms();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: rooms == null
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
                            Padding(
                              padding: const EdgeInsets.only(right:20.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  HomePage()));
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
                            child: Text('Building Rooms',
                                style: TextStyle(
                                  fontSize: 18,
                                )),
                          ),
                        ),
                        SizedBox(
                          height: 30,
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
                              () =>        filterSearchResults(searchString)
                              );
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search for a room',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                        SizedBox(
                            child: ListView.builder(
                                //  physics: NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: rooms.length,
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () async {
                                      SharedPreferences preferences =
                                          await SharedPreferences.getInstance();

                                      preferences.setString(
                                          'room_id', rooms[index]['id']);

                                       preferences.setString(
                                          'room_name', rooms[index]['room_name']);

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  RoomDetails()));
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
                                                        rooms[index]
                                                            ['room_name'],
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
