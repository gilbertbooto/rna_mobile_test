import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class CapturePhoto extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CapturePhoto();
  }
}

enum AppState {
  free,
  picked,
  cropped,
}

class _CapturePhoto extends State<CapturePhoto> {
  GlobalKey<FormState> _key = GlobalKey<FormState>();
  CameraDescription? cameraDescription;
  AppState? state, state2;
  File? imageFile, imageFile2;

  String _path = '';
  String _path2 = '';
  //String _image = '';
  String _image2 = '';

  _showPhotoLibrary() async {
    final file = await (ImagePicker().getImage(source: ImageSource.gallery));
    final bytes = File(file!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    // _image = img64;
    setState(() {
      _path = file.path;
    });

    // print('VOICI PATH $bytes');
    // print('VOICI PATH 2 $_image');
    return img64;
  }

  @override
  void initState() {
    super.initState();
    state = AppState.free;
    state2 = AppState.free;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(
            color: Colors.blue,
          ),
          backgroundColor: Colors.white,
          centerTitle: true,
          title: const Text(
            "Capture photo",
            style: TextStyle(color: Colors.blue),
          ),
        ),
        body: Center(
            child: SingleChildScrollView(
                child: Form(
          key: _key,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                // Text(
                //   "Les informations relatives à l'identité du producteur",
                //   style: TextStyle(),
                // ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Center(
                          child: imageFile != null
                              ? Image.file(
                                  imageFile!,
                                  width: 200,
                                  height: 400,
                                )
                              : Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: const Center(
                                    child: Text(
                                      'Photo du titulaire',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  ),
                                ),
                        ),
                        // Container(
                        //   child: CameraFaceDetected(
                        //     cameraDescription: cameraDescription,
                        //   ),
                        // )

                        // IconButton(
                        //     onPressed: () {

                        // if (state == AppState.free) {
                        //   SignIn(
                        //       key: _key,
                        //       cameraDescription: cameraDescription);
                        // } else if (state == AppState.picked) {
                        //   _cropImage();
                        // } else if (state == AppState.cropped) {
                        //   _clearImage();
                        // }
                        // },
                        // icon: _buildButtonIcon()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Container(
                    // width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: [
                        Center(
                          child: imageFile2 != null
                              ? Image.file(
                                  imageFile2!,
                                  width: 200,
                                  height: 400,
                                )
                              : Container(
                                  width: 80,
                                  height: 100,
                                  decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey)),
                                  child: const Center(
                                    child: Text(
                                      'Pièce identité producteur',
                                      style: TextStyle(fontSize: 10),
                                    ),
                                  )),
                        ),
                        IconButton(
                            onPressed: () {
                              if (state2 == AppState.free) {
                                _pickImage2();
                              } else if (state2 == AppState.picked) {
                                _cropImage2();
                              } else if (state2 == AppState.cropped) {
                                _clearImage2();
                              }
                            },
                            icon: _buildButtonIcon2()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {
                    if (!_key.currentState!.validate()) {
                      return;
                    } else {
                      _key.currentState!.save();
                    }

                    if (_path == '') {}

                    print('imageFile..........$_path');

                    print(_image2);
                    print('_image2..........$_path2');

                    // MyApp.storageInfoProducer.phtoHolder = _path;
                    // MyApp.storageInfoProducer.photoIdentificationDocument =
                    //     _path2;

                    // print(
                    //     "xxxxxxxxxxxxxxxxxxxxxx : ${MyApp.storageInfoProducer.photoIdentificationDocument}");

                    // Navigator.push(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (context) => producer_activities()));
                  },
                  child: const Text('Suivant'),
                  style: ButtonStyle(
                    overlayColor: MaterialStateProperty.all(Colors.red),
                    backgroundColor: MaterialStateProperty.all(Colors.blue),
                  ),
                ),
                const SizedBox(height: 20.0),
              ],
            ),
          ),
        ))));
  }

  Widget _buildButtonIcon() {
    if (state == AppState.free) {
      return const Icon(
        Icons.camera_alt,
      );
    } else if (state == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state == AppState.cropped) {
      return const Icon(Icons.clear);
    } else {
      return Container();
    }
  }

  Future<void> _pickImage2() async {
    final pickedImage2 =
        await ImagePicker().getImage(source: ImageSource.camera);
    imageFile2 = pickedImage2 != null ? File(pickedImage2.path) : null;
    if (imageFile2 != null) {
      setState(() {
        state2 = AppState.picked;
        _path2 = imageFile2!.path;
      });
    }
  }

  faceRecognizer(imageFile) async {
    final inputImage = InputImage.fromFile(imageFile);
    final faceDetector = GoogleMlKit.vision.faceDetector();
    final List<Face> faces = await faceDetector.processImage(inputImage);

    final Rect boundingBox;

    for (Face face in faces) {
      print("AAAAAAAAAAAAAAAAAAAAAAA ${face.trackingId}");
      // var checkFace = face.boundingBox;
      // if (checkFace == null) {
      //   print('Invalid');
      //   return;
      // } else {
      //   print("Valid faces $faces");
      //   return;
      // }

      //  print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa : $boundingBox");

      // final double? rotY = face.headEulerAngleY; // Head is rotated to the right rotY degrees
      // final double? rotZ = face.headEulerAngleZ; // Head is tilted sideways rotZ degrees

      // If landmark detection was enabled with FaceDetectorOptions (mouth, ears,
      // eyes, cheeks, and nose available):
      final FaceLandmark? leftEar = face.getLandmark(FaceLandmarkType.leftEar);
      if (leftEar != null) {
        // final ui.Offset leftEarPos = leftEar.position;
        print("valid leftEar $leftEar");
        return;
      }

      // If classification was enabled with FaceDetectorOptions:
      // if (face.smilingProbability != null) {
      //   final double? smileProb = face.smilingProbability;
      //   print("valid2 smileProb $smileProb");
      //   return;
      // }

      // // If face tracking was enabled with FaceDetectorOptions:
      // if (face.trackingId != null) {
      //   final int? id = face.trackingId;
      //   print("valid3 id $id");
      //   return;
      // }
    }
  }

  Future<void> _cropImage2() async {
    var croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile2!.path,
        //aspectRatioPresets: Platform.isAndroid
        // ? [
        //     CropAspectRatioPreset.square,
        //     CropAspectRatioPreset.ratio3x2,
        //     CropAspectRatioPreset.original,
        //     CropAspectRatioPreset.ratio4x3,
        //     CropAspectRatioPreset.ratio16x9
        //   ]
        // : [
        //     CropAspectRatioPreset.original,
        //     CropAspectRatioPreset.square,
        //     CropAspectRatioPreset.ratio3x2,
        //     CropAspectRatioPreset.ratio4x3,
        //     CropAspectRatioPreset.ratio5x3,
        //     CropAspectRatioPreset.ratio5x4,
        //     CropAspectRatioPreset.ratio7x5,
        //     CropAspectRatioPreset.ratio16x9
        //   ],
        androidUiSettings: const AndroidUiSettings(
            //toolbarTitle: 'Cropper',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.deepOrange,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: const IOSUiSettings(
            //title: 'Cropper',
            ));
    if (croppedFile != null) {
      imageFile2 = croppedFile;

      setState(() {
        state2 = AppState.cropped;
      });
    }
  }

  Future<void> _pickImage() async {
    // final ImagePicker _picker = ImagePicker();
    final file = await (ImagePicker().getImage(source: ImageSource.camera));
    //final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    //   final file = await (ImagePicker().getImage(source: ImageSource.camera));
    final bytes = File(file!.path).readAsBytesSync();
    String img64 = base64Encode(bytes);
    imageFile = File(file.path);
    if (imageFile != null) {
      // Face Recognizer
      // faceRecognizer(imageFile);
      setState(() {
        state = AppState.picked;
        _path = imageFile!.path;
      });
    }
  }

  void _clearImage() {
    imageFile = null;
    setState(() {
      state = AppState.free;
    });
  }

  void _clearImage2() {
    imageFile2 = null;
    setState(() {
      state2 = AppState.free;
    });
  }

  Widget _buildButtonIcon2() {
    if (state2 == AppState.free) {
      return const Icon(
        Icons.camera_alt,
      );
    } else if (state2 == AppState.picked) {
      return const Icon(Icons.crop);
    } else if (state2 == AppState.cropped) {
      return const Icon(Icons.clear);
    } else {
      return Container();
    }
  }

  Future<void> _cropImage() async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        cropStyle: CropStyle.rectangle,
        aspectRatio: const CropAspectRatio(ratioX: 3, ratioY: 4),
        // aspectRatioPresets: Platform.isAndroid
        //     ? [
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.ratio3x2,
        //         CropAspectRatioPreset.original,
        //         CropAspectRatioPreset.ratio4x3,
        //         CropAspectRatioPreset.ratio16x9
        //       ]
        //     : [
        //         CropAspectRatioPreset.original,
        //         CropAspectRatioPreset.square,
        //         CropAspectRatioPreset.ratio3x2,
        //         CropAspectRatioPreset.ratio4x3,
        //         CropAspectRatioPreset.ratio5x3,
        //         CropAspectRatioPreset.ratio5x4,
        //         CropAspectRatioPreset.ratio7x5,
        //         CropAspectRatioPreset.ratio16x9
        //       ],
        androidUiSettings: const AndroidUiSettings(
            toolbarColor: Colors.white,
            toolbarWidgetColor: Colors.deepOrange,
            // initAspectRatio: CropAspectRatio(),
            lockAspectRatio: true),
        iosUiSettings: const IOSUiSettings());
    if (croppedFile != null) {
      imageFile = croppedFile;

      setState(() {
        state = AppState.cropped;
      });
    }
  }
}
