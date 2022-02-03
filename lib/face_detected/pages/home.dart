// ignore_for_file: prefer_collection_literals

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:rna_mobile_test/face_detected/pages/db/database.dart';
import 'package:rna_mobile_test/face_detected/pages/sign-in.dart';
import 'package:rna_mobile_test/face_detected/pages/sign-up.dart';
import 'package:rna_mobile_test/face_detected/services/facenet.service.dart';
import 'package:rna_mobile_test/face_detected/services/ml_kit_service.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Services injection
  final FaceNetService _faceNetService = FaceNetService();
  final MLKitService _mlKitService = MLKitService();
  final DataBaseService _dataBaseService = DataBaseService();

  Map? appData = Map<String, dynamic>();

  CameraDescription? cameraDescription;
  bool loading = false;

  // String githubURL =
  //     "https://github.com/MCarlomagno/FaceRecognitionAuth/tree/master";

  @override
  void initState() {
    super.initState();
    _startUp();
    // getfacedata();
  }

  /// 1 Obtain a list of the available cameras on the device.
  /// 2 loads the face net model
  _startUp() async {
    _setLoading(true);

    List<CameraDescription> cameras = await availableCameras();

    /// takes the front camera
    cameraDescription = cameras.firstWhere(
      (CameraDescription camera) =>
          camera.lensDirection ==
          CameraLensDirection
              .front, // la vue du camera (arriere ou avant : front or back)
    );

    // start the services
    await _faceNetService.loadModel();
    await _dataBaseService.db;
    _mlKitService.initialize();

    _setLoading(false);
  }

  // shows or hides the circular progress indicator
  _setLoading(bool value) {
    setState(() {
      loading = value;
    });
  }

  // void _launchURL() async => await canLaunch(githubURL)
  //     ? await launch(githubURL)
  //     : throw 'Could not launch $githubURL';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0XFFC7FFBE),
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        backgroundColor: Colors.transparent,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              // ignore: prefer_const_constructors
              child: Icon(
                Icons.more_vert,
                color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    _dataBaseService.cleanDB();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      body: !loading
          ? SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    const Image(image: AssetImage('assets/logo.png')),
                    // Container(
                    //   width: MediaQuery.of(context).size.width * 0.8,
                    //   child: Column(
                    //     children: [
                    //       Text(
                    //         "FACE RECOGNITION AUTHENTICATION",
                    //         style: TextStyle(
                    //             fontSize: 25, fontWeight: FontWeight.bold),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //       SizedBox(
                    //         height: 20,
                    //       ),
                    //       Text(
                    //         "Demo application that uses Flutter and tensorflow to implement authentication with facial recognition",
                    //         style: TextStyle(
                    //           fontSize: 16,
                    //         ),
                    //         textAlign: TextAlign.center,
                    //       ),
                    //     ],
                    //   ),
                    // ),
                    Column(
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (BuildContext context) => SignIn(
                                  cameraDescription: cameraDescription,
                                ),
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
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            // ignore: prefer_const_constructors
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'LOGIN',
                                  style: TextStyle(color: Color(0xFF0F0BDB)),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.login,
                                    color: Color(0xFF0F0BDB))
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
                                builder: (BuildContext context) => SignUp(
                                  cameraDescription: cameraDescription,
                                ),
                              ),
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
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            // ignore: prefer_const_constructors
                            padding: EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              // ignore: prefer_const_literals_to_create_immutables
                              children: [
                                const Text(
                                  'SIGN UP',
                                  style: TextStyle(color: Colors.white),
                                ),
                                const SizedBox(
                                  width: 10,
                                ),
                                const Icon(Icons.person_add,
                                    color: Colors.white)
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
          : Center(
              child: CircularProgressIndicator(),
            ),
    );
  }

  // Future getfacedata() async {
  //   DataBaseService _dataBaseService = DataBaseService.instance;
  //   var b;

  //   Database base =
  //       await (_dataBaseService.getDatabase() as FutureOr<Database>);
  //   List<Map<String, dynamic>> liste =
  //       await base.rawQuery("select * from table_face");

  //   if (liste.isNotEmpty) {
  //     var f = (liste[0]['user']);
  //     b = json.decode(f);
  //   }

  //   appData = b;

  //   // print(
  //   //     " wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww 2 : $dataface");
  //   print(
  //       " wwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwwww : $appData");
  //   return appData;
  // }
}
