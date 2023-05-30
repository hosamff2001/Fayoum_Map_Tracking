import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'openStreet maps',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(title: 'OpenStreet Maps'),
    );
  }
}

enum AppPermissions {
  granted,
  denied,
  restricted,
  permanentlyDenied,
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  PermissionStatus _locationStatus = PermissionStatus.denied;

  List<Position> mypostion = [];
  
  @override
  void initState() {
    super.initState();
    getLocationStatus();
  }

  Future<PermissionStatus> getLocationStatus() async {
    // Request for permission
    // #4
    final status = await Permission.location.request();
    // change the location status
    // #5
    _locationStatus = status;

    // notify listeners
    return status;
  }

  void getlocation() async {
    Geolocator.getCurrentPosition().then((position) {
      setState(() {
  mypostion.add(position);
  print(position.latitude);
 
});
    });
  }

  @override
  Widget build(BuildContext context) {
    sleep(Duration(seconds: 1));
    getlocation();
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: Center(
          child: SizedBox(
            width: 400,
            height: 400,
            child: FlutterMap(
              options: MapOptions(
                center: LatLng(29.307652, 30.846704),
                swPanBoundary: LatLng(29.2691, 30.8062),
                nePanBoundary: LatLng(29.3429, 30.8818),
              ),
              children: [
                TileLayer(
                  tileProvider: AssetTileProvider(),
                  urlTemplate: 'Fayom/{z}/{x}/{y}.png',
                ),
                MarkerLayer(
                  markers: mypostion.isNotEmpty
                      ? mypostion
                          .map((e) => Marker(
                                point: LatLng(e.latitude, e.longitude),
                                builder: (context) {
                                  if (mypostion[mypostion.length-1]==e)
                                  {return const Icon(
                                      Icons.location_history,
                                      color: Colors.blue,
                                      size: 35.0);}
                                      else
                                      {
                                        return const Icon(
                                      Icons.circle,
                                      color: Colors.black,
                                      size: 15.0);
                                      }
                                },
                              ))
                          .toList()
                      : [],
                ),
              ],
            ),
          ),
        ));
  }
}