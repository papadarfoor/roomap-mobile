import 'dart:convert';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:Roomap/locationDetails.dart';
import 'package:Roomap/main.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Locations extends StatefulWidget {
  const Locations({Key? key}) : super(key: key);

  @override
  State<Locations> createState() => _LocationsState();
}

class _LocationsState extends State<Locations> {
  var buildings;
  List building_name = [];
  String searchString = "";
  var items = [];

  Future getBuildings() async {
    var url =
        Uri.parse(baseUrl + '/functions/customer/buildings/getBuildings.php');
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      buildings = details;
    });

    return buildings;
  }

  Future<void> filterSearchResults(query) async {
    var url = Uri.parse(baseUrl +
        '/functions/customer/buildings/searchBuildings.php?search_string=' +
        query);
    var response = await http.get(url);
    final details = json.decode(response.body);
    setState(() {
      buildings = details;
    });
    print(buildings);
    return buildings;
  }

  @override
  void initState() {
    super.initState();
    getBuildings();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: buildings == null
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
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
                              () => filterSearchResults(
                                  searchString) // <-- The target method
                              );
                        });
                      },
                      decoration: InputDecoration(
                        labelText: 'Search for a building',
                        suffixIcon: Icon(Icons.search),
                      ),
                    ),
                  ),
                  Expanded(
                      child: GridView.count(
                          crossAxisCount: 2,
                          children: List.generate(buildings.length, (index) {
                            return InkWell(
                                onTap: () async {
                                  SharedPreferences preferences =
                                      await SharedPreferences.getInstance();

                                  preferences.setString(
                                      'building_id', buildings[index]['id']);
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              LocationDetails()));
                                },
                                child: Container(
                                  child: Card(
                                    color: Color.fromARGB(255, 198, 46, 0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Image.asset('images/building.png',height: 40,),
                                        Text(
                                          buildings[index]['building_name'],
                                          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
                                          
                                        )
                                      ],
                                    ),
                                  ),
                                ));
                          })))
                ],
              ),
      ),
    );
  }
}
