// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import 'package:rna_mobile_test/face_detected/pages/home.dart';

import 'capturePhoto.dart/cameraFaceDetected.dart';
import 'gps_offline/pagegps.dart';

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
                              builder: (BuildContext context) => GPS()),
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
