// ignore_for_file: avoid_print

import 'dart:async';

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';
import 'package:rna_mobile_test/face_detected/pages/home.dart';

import 'capturePhoto.dart/cameraFaceDetected.dart';
import 'capturePhoto.dart/cropImage.dart';
import 'gps_offline/GeolocatorWidget.dart';

void main() {
  // runApp(const GeolocatorWidget());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'RNA Demo',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: MyHome()
        //home: const MyHomePage(title: 'RNA GPS OFFLINE'),
        );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: const Color(0XFFC7FFBE),
        appBar: AppBar(
          leading: Container(),
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                const Image(image: AssetImage('assets/logo.png')),
                Column(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) =>
                                const MyHomePage(),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        // ignore: prefer_const_constructors
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              'AUthentification',
                              style: TextStyle(color: Color(0xFF0F0BDB)),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.login, color: Color(0xFF0F0BDB))
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => Home()),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.blueGrey,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        // ignore: prefer_const_constructors
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              'Coordo Geo',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.add_location, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.8,
                      // child: Divider(
                      //   thickness: 2,
                      // ),
                    ),

                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (BuildContext context) => const SignIn2(
                              cameraDescription: null,
                            ),
                          ),
                        );
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.grey,
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.blue.withOpacity(0.1),
                              blurRadius: 1,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        alignment: Alignment.center,
                        // ignore: prefer_const_constructors
                        padding: const EdgeInsets.symmetric(
                            vertical: 14, horizontal: 16),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // ignore: prefer_const_literals_to_create_immutables
                          children: [
                            const Text(
                              'Capture Photo',
                              style: TextStyle(color: Colors.white),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Icon(Icons.camera_alt, color: Colors.white)
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                      width: MediaQuery.of(context).size.width * 0.8,
                      // child: Divider(
                      //   thickness: 2,
                      // ),
                    ),
                    // InkWell(
                    //   onTap: _launchURL,
                    //   child: Container(
                    //     decoration: BoxDecoration(
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Colors.black,
                    //       boxShadow: <BoxShadow>[
                    //         BoxShadow(
                    //           color: Colors.blue.withOpacity(0.1),
                    //           blurRadius: 1,
                    //           offset: Offset(0, 2),
                    //         ),
                    //       ],
                    //     ),
                    //     alignment: Alignment.center,
                    //     padding: EdgeInsets.symmetric(
                    //         vertical: 14, horizontal: 16),
                    //     width: MediaQuery.of(context).size.width * 0.8,
                    //     child: Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Text(
                    //           'CONTRIBUTE',
                    //           style: TextStyle(color: Colors.white),
                    //         ),
                    //         SizedBox(
                    //           width: 10,
                    //         ),
                    //         FaIcon(
                    //           FontAwesomeIcons.github,
                    //           color: Colors.white,
                    //         )
                    //       ],
                    //     ),
                    //   ),
                    // ),
                  ],
                )
              ],
            ),
          ),
        )
        // : Center(
        //     child: CircularProgressIndicator(),
        //   ),
        );
  }
}

class Home extends StatefulWidget {
  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool servicestatus = false;
  bool haspermission = false;
  late LocationPermission permission;
  late Position position;
  String long = "", lat = "", alt = "";
  late StreamSubscription<Position> positionStream;

  @override
  void initState() {
    checkGps();
    super.initState();
  }

  checkGps() async {
    servicestatus = await Geolocator.isLocationServiceEnabled();
    if (servicestatus) {
      permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print('Location permissions are denied');
        } else if (permission == LocationPermission.deniedForever) {
          print("'Location permissions are permanently denied");
        } else {
          haspermission = true;
        }
      } else {
        haspermission = true;
      }

      if (haspermission) {
        setState(() {
          //refresh the UI
          //checkGps();
        });

        getLocation();
      }
    } else {
      print("GPS Service is not enabled, turn on GPS location");
    }

    setState(() {
      //refresh the UI
      //  checkGps();
    });
  }

  getLocation() async {
    position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    print(position.longitude); //Output: 80.24599079
    print(position.latitude); //Output: 29.6593457
    print(position.altitude); //Output: 29.6593457

    long = position.longitude.toString();
    lat = position.latitude.toString();
    alt = position.altitude.toString();

    setState(() {
      //refresh UI
      // checkGps();
    });

    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high, //accuracy of the location data
      distanceFilter: 100, //minimum distance (measured in meters) a
      //device must move horizontally before an update event is generated;
    );

    StreamSubscription<Position> positionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings)
            .listen((Position position) {
      print(position.longitude); //Output: 80.24599079
      print(position.latitude); //Output: 29.6593457
      print(position.altitude); //Output: 29.6593457

      long = position.longitude.toString();
      lat = position.latitude.toString();
      alt = position.altitude.toString();

      setState(() {
        //refresh UI on update
        //  checkGps();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text("Get GPS Location"),
            backgroundColor: Colors.redAccent),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.all(50),
            child: Column(children: [
              Text(servicestatus ? "GPS is Enabled" : "GPS is disabled."),
              Text(haspermission ? "GPS is Enabled" : "GPS is disabled."),
              Text("Longitude: $long", style: const TextStyle(fontSize: 20)),
              Text(
                "Latitude: $lat",
                style: const TextStyle(fontSize: 20),
              ),
              Text(
                "Altitude: $alt",
                style: const TextStyle(fontSize: 20),
              )
            ])));
  }
}
