// ignore_for_file: unnecessary_null_in_if_null_operators

import 'package:flutter/material.dart';
import 'package:rna_mobile_test/face_detected/pages/db/database.dart';
import 'package:rna_mobile_test/face_detected/pages/models/user.model.dart';
import 'package:rna_mobile_test/face_detected/pages/profile.dart';
import 'package:rna_mobile_test/face_detected/pages/widgets/app_button.dart';
import 'package:rna_mobile_test/face_detected/services/camera.service.dart';
import 'package:rna_mobile_test/face_detected/services/facenet.service.dart';
import '../home.dart';
import 'app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  AuthActionButton(this._initializeControllerFuture,
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      required this.reload});
  final Future _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  User? predictedUser;
  List? dataface = [];

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List? predictedData = _faceNetService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;

    /// creates a new user in the 'database'
    await _dataBaseService.saveData(user, password, predictedData!);

    /// resets the face stored in the face net sevice
    this._faceNetService.setPredictedData(null);
    Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) => MyHomePage()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;

    if (this.predictedUser!.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => Profile(
                    this.predictedUser!.user,
                    imagePath: _cameraService.imagePath,
                  )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  String? _predictUser() {
    String? userAndPass = _faceNetService.predict();
    // print('Quinzeeeeeeeeeeeeeeeeeeeeeeeee $userAndPass');
    return userAndPass ?? null;
  }

  List? _predictUser2() {
    List? data = _faceNetService.predict2();
    //print('AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA $data');
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        try {
          // Ensure that the camera is initialized.
          await widget._initializeControllerFuture;
          // onShot event (takes the image and predict output)
          bool faceDetected = await widget.onPressed();

          if (faceDetected) {
            if (widget.isLogin) {
              var userAndPass = _predictUser();
              dataface = _predictUser2();
              // print('qqqqqqqqqqqq $userAndPass');
              // print('qqqqqqqqqqqq2222222 $dataface');
              if (userAndPass != null && dataface != null) {
                this.predictedUser = User.fromDB(userAndPass, dataface);
                // print('sssssssssssssss : ${predictedUser?.predictedData}');
              }
            }

            PersistentBottomSheetController bottomSheetController =
                Scaffold.of(context)
                    .showBottomSheet((context) => signSheet(context));

            bottomSheetController.closed.whenComplete(() => widget.reload());
          }
        } catch (e) {
          // If an error occurs, log the error to the console.
          print(e);
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Color(0xFF0F0BDB),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: Colors.blue.withOpacity(0.1),
              blurRadius: 1,
              offset: Offset(0, 2),
            ),
          ],
        ),
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const Text(
              'CAPTURE',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(
              width: 10,
            ),
            const Icon(Icons.camera_alt, color: Colors.white)
          ],
        ),
      ),
    );
  }

  signSheet(context) {
    List? predictedDataDirect = _faceNetService.predictedData;
    // ignore: avoid_print
    print('hhhhhhhh : $predictedDataDirect');
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser?.predictedData != null
              // ignore: avoid_unnecessary_containers
              ? Container(
                  child: Text(
                    'Bienvenu(e),  ${(predictedUser?.user)}',
                    style: const TextStyle(fontSize: 20),
                  ),
                )
              : widget.isLogin
                  // ignore: avoid_unnecessary_containers
                  ? Container(
                      child: const Text(
                      'Vous n\etes pas inscrit',
                      style: TextStyle(fontSize: 20),
                    ))
                  : Container(),
          // ignore: avoid_unnecessary_containers
          Container(
            child: Column(
              children: [
                !widget.isLogin
                    ? AppTextField(
                        controller: _userTextEditingController,
                        labelText: "Your Name",
                      )
                    : Container(),
                const SizedBox(height: 10),
                widget.isLogin && predictedUser == null
                    ? Container()
                    : AppTextField(
                        controller: _passwordTextEditingController,
                        labelText: "Password",
                        isPassword: true,
                      ),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                widget.isLogin && predictedUser != null
                    ? AppButton(
                        text: 'LOGIN',
                        onPressed: () async {
                          _signIn(context);
                        },
                        icon: const Icon(
                          Icons.login,
                          color: Colors.white,
                        ),
                      )
                    : !widget.isLogin
                        ? AppButton(
                            text: 'SIGN UP',
                            onPressed: () async {
                              await _signUp(context);
                            },
                            icon: const Icon(
                              Icons.person_add,
                              color: Colors.white,
                            ),
                          )
                        : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
